#!/usr/bin/env bb
;; Focused exit-code and summary checks. Safe to run locally: all targets
;; and cleanup directories are created under a temporary directory.
;; Usage: bb link/tests/link-results-tests.clj
(require '[babashka.fs :as fs]
         '[babashka.process :as p]
         '[clojure.string :as str]
         '[clojure.test :refer [deftest is run-tests]])

(def repo (-> *file* fs/absolutize fs/parent fs/parent fs/parent str))
(def ^:dynamic *tmp*)

(defn target [name] (str (fs/path *tmp* name)))
(defn entry [name] {:target (target name) :source "README.md"})

(clojure.test/use-fixtures
  :each
  (fn [test-fn]
    (let [dir (fs/create-temp-dir {:prefix "dotfiles-results-"})]
      (try
        (binding [*tmp* dir] (test-fn))
        (finally (fs/delete-tree dir))))))

(defn link [config & args]
  (let [config-file (target "config.edn")]
    (spit config-file (pr-str config))
    (apply p/shell {:dir repo :out :string :err :string :continue true}
           "bb" "link/link.clj" "--config" config-file args)))

(defn summary [out]
  (last (str/split out #"\nSummary: " 2)))

(deftest success-and-unchanged
  (let [config {:link [(entry "linked")]}]
    (let [{:keys [exit out]} (link config)]
      (is (= 0 exit))
      (is (fs/sym-link? (target "linked")))
      (is (not (str/includes? (summary out) "Errors in")))
      (is (str/includes? out "Summary: 0 unchanged, 1 linked, 0 relinked, 0 cleaned, 0 planned, 0 errors.")))
    (let [{:keys [exit out]} (link config)]
      (is (= 0 exit))
      (is (str/includes? out "Summary: 1 unchanged, 0 linked, 0 relinked, 0 cleaned, 0 planned, 0 errors.")))))

(deftest failures-are-counted-and-work-continues
  (spit (target "conflict") "keep me")
  (spit (target "parent-file") "not a directory")
  (fs/create-sym-link (target "dead") (fs/path repo "missing-results-test-source"))
  (let [{:keys [exit out]}
        (link {:link [{:target (target "missing") :source "missing-results-test-source"}
                         (entry "conflict")
                         (entry "parent-file/child")
                         (entry "good")]
                  :clean [(str *tmp*)]})]
    (is (= 1 exit))
    (is (= "keep me" (slurp (target "conflict"))))
    (is (fs/sym-link? (target "good")))
    (is (not (fs/sym-link? (target "dead"))))
    (let [report (summary out)]
      (is (str/includes? report (str "Errors in " (target "config.edn"))))
      (is (str/includes? report (str "[:link 0] " (pr-str {:target (target "missing") :source "missing-results-test-source"}))))
      (is (str/includes? report (str "Reason: source missing: " (fs/path repo "missing-results-test-source"))))
      (is (str/includes? report (str "[:link 1] " (pr-str (entry "conflict")))))
      (is (str/includes? report "already exists as a file/dir"))
      (is (str/includes? report (str "[:link 2] " (pr-str (entry "parent-file/child")))))
      (is (str/includes? report "Reason: FileSystemException:"))
      (is (not (str/includes? report "[:link 3]"))))
    (is (str/includes? out "Summary: 0 unchanged, 1 linked, 0 relinked, 1 cleaned, 0 planned, 3 errors."))))

(deftest dry-run-fails-without-changing-files
  (spit (target "conflict") "keep me")
  (fs/create-sym-link (target "dead") (fs/path repo "missing-results-test-source"))
  (let [{:keys [exit out]}
        (link {:link [(entry "conflict") (entry "new")]
                  :clean [(str *tmp*)]} "--dry-run")]
    (is (= 1 exit))
    (is (= "keep me" (slurp (target "conflict"))))
    (is (not (fs/exists? (target "new") {:nofollow-links true})))
    (is (fs/sym-link? (target "dead")))
    (is (str/includes? (summary out) (str "[:link 0] " (pr-str (entry "conflict")))))
    (is (str/includes? out "Summary: 0 unchanged, 0 linked, 0 relinked, 0 cleaned, 2 planned, 1 errors."))))

(deftest successful-dry-run
  (let [{:keys [exit out]} (link {:link [(entry "new")]} "--dry-run")]
    (is (= 0 exit))
    (is (not (fs/exists? (target "new") {:nofollow-links true})))
    (is (str/includes? out "Summary: 0 unchanged, 0 linked, 0 relinked, 0 cleaned, 1 planned, 0 errors."))))

(deftest creates-missing-parent-directories
  (let [nested-target (target "one/two/three/file")
        cfg {:link [{:target nested-target :source "README.md"}]}]
    (is (not (fs/exists? (target "one") {:nofollow-links true})))
    (let [{:keys [exit out]} (link cfg)]
      (is (= 0 exit) out)
      (is (fs/directory? (target "one/two/three")))
      (is (fs/sym-link? nested-target))
      (is (= (fs/real-path nested-target)
             (fs/real-path (fs/path repo "README.md"))))
      (is (str/includes? out "Summary: 0 unchanged, 1 linked, 0 relinked, 0 cleaned, 0 planned, 0 errors.")))))

(deftest cleanup-exceptions-do-not-stop-later-directories
  (fs/create-sym-link (target "dead") (fs/path repo "missing-results-test-source"))
  (let [{:keys [exit out]} (link {:clean [(str "invalid" (char 0)) (str *tmp*)]})]
    (is (= 1 exit))
    (is (not (fs/sym-link? (target "dead"))))
    (is (str/includes? (summary out) (str "[:clean 0] " (pr-str (str "invalid" (char 0))))))
    (is (str/includes? (summary out) "Reason: InvalidPathException:"))
    (is (str/includes? out "Summary: 0 unchanged, 0 linked, 0 relinked, 1 cleaned, 0 planned, 1 errors."))))

(deftest cleanup-respects-repository-boundaries
  ;; Run a copy of the linker in a temporary repo so ancestor symlinks can
  ;; be exercised without adding fixtures to the user's actual repository.
  (let [fixture-repo (fs/path *tmp* "dotfiles")
        neighbour (fs/path *tmp* "dotfiles-other")
        clean-dir (fs/path *tmp* "links")
        config-file (target "cleanup.edn")]
    (doseq [dir [(fs/path fixture-repo "link") neighbour
                 (fs/path clean-dir "nested")]]
      (fs/create-dirs dir))
    (fs/copy (fs/path repo "link/link.clj") (fs/path fixture-repo "link/link.clj"))
    (fs/create-sym-link (fs/path fixture-repo "outside") neighbour)
    (fs/create-sym-link (fs/path *tmp* "repo-alias") fixture-repo)
    (spit (str (fs/path clean-dir "regular")) "keep me")
    (let [removed {"inside" (fs/path fixture-repo "missing")
                   "normalised-inside" (fs/path fixture-repo "link/../missing")
                   "relative-inside" (fs/path "../dotfiles/missing")
                   "alias-inside" (fs/path *tmp* "repo-alias/missing")}
          preserved {"neighbour" (fs/path neighbour "missing")
                     "parent-escape" (fs/path fixture-repo "../dotfiles-other/missing")
                     "relative-neighbour" (fs/path "../dotfiles-other/missing")
                     "symlink-escape" (fs/path fixture-repo "outside/missing")
                     "live" (fs/path fixture-repo "link/link.clj")
                     "nested/dead" (fs/path fixture-repo "missing")}
          run-clean (fn [& args]
                      (apply p/shell {:dir (str fixture-repo) :out :string :err :string :continue true}
                             "bb" "link/link.clj" "--config" config-file args))]
      (doseq [[name destination] (merge removed preserved)]
        (fs/create-sym-link (fs/path clean-dir name) destination))
      (spit config-file (pr-str {:clean [(str clean-dir)]}))
      (let [{:keys [exit out]} (run-clean "--dry-run")]
        (is (= 0 exit) out)
        (is (str/includes? (summary out) "0 cleaned, 4 planned, 0 errors."))
        (doseq [name (keys (merge removed preserved))]
          (is (fs/sym-link? (fs/path clean-dir name)) (str "dry-run preserves " name))))
      (let [{:keys [exit out]} (run-clean)]
        (is (= 0 exit) out)
        (is (str/includes? (summary out) "4 cleaned, 0 planned, 0 errors."))
        (doseq [name (keys removed)]
          (is (not (fs/exists? (fs/path clean-dir name) {:nofollow-links true})) name))
        (doseq [[name destination] preserved]
          (is (fs/sym-link? (fs/path clean-dir name)) name)
          (is (= destination (fs/read-link (fs/path clean-dir name))) name))
        (is (= "keep me" (slurp (str (fs/path clean-dir "regular")))))))))

(deftest configuration-rules
  (doseq [[cfg expected]
          [[nil "[]: must be a map"]
           [[] "[]: must be a map"]
           [{:lnik []} "[:lnik]: unknown directive"]
           [{:link nil} "[:link]: must be a vector"]
           [{:link {}} "[:link]: must be a vector"]
           [{:clean "~"} "[:clean]: must be a vector"]
           [{:clean nil} "[:clean]: must be a vector"]
           [{:link ["file"]} "[:link 0]: must be a map"]
           [{:link [{:target "x" :source "README.md" :force true}]}
            "[:link 0 :force]: unknown link field"]
           [{:link [{:source "README.md"}]} "[:link 0 :target]: must be a non-blank path string"]
           [{:link [{:target "x"}]} "[:link 0 :source]: must be a non-blank path string"]
           [{:link [{:target 42 :source "README.md"}]} "[:link 0 :target]: must be a non-blank path string"]
           [{:link [{:target "x" :source "  "}]} "[:link 0 :source]: must be a non-blank path string"]
           [{:clean [""]} "[:clean 0]: must be a non-blank path string"]
           [{:clean [false]} "[:clean 0]: must be a non-blank path string"]]]
    (let [{:keys [exit err out]} (link cfg)]
      (is (= 2 exit) (pr-str cfg))
      (is (str/includes? err expected) err)
      (is (str/includes? err (target "config.edn")))
      (is (not (str/includes? out "Linking:"))))))

(deftest validation-reports-all-errors-before-any-work
  (fs/create-sym-link (target "dead") (fs/path repo "missing-results-test-source"))
  (doseq [args [[] ["--dry-run"]]]
    (let [{:keys [exit err]}
          (apply link {:link [(entry "new") {:target "" :source 12 :soruce "typo"}]
                       :clean [(str *tmp*) nil]
                       :shell []} args)]
      (is (= 2 exit))
      (doseq [location ["[:link 1 :target]" "[:link 1 :source]" "[:link 1 :soruce]"
                        "[:clean 1]" "[:shell]"]]
        (is (str/includes? err location) err))
      (is (str/includes? err "No changes made."))
      (is (not (fs/exists? (target "new") {:nofollow-links true})))
      (is (fs/sym-link? (target "dead"))))))

(deftest empty-sections-are-valid
  (doseq [cfg [{} {:link []} {:clean []} {:link [] :clean []}]]
    (let [{:keys [exit out]} (link cfg)]
      (is (= 0 exit))
      (is (str/includes? (summary out) "0 errors.")))))

(deftest unreadable-edn-is-a-configuration-error
  (doseq [contents ["" "; comments only\n" "{:link [" "{} {}" "{} garbage" "#unknown/tag {}"]]
    (let [config-file (target "invalid.edn")]
      (spit config-file contents)
      (let [{:keys [exit out err]}
            (p/shell {:dir repo :out :string :err :string :continue true}
                     "bb" "link/link.clj" "--config" config-file)]
        (is (= 2 exit) contents)
        (is (str/includes? err config-file))
        (is (str/includes? err "No changes made."))
        (is (not (str/includes? out "Linking:")))))))

(deftest equivalent-link-paths-are-left-unchanged
  (fs/create-dirs (target "subdir"))
  (let [destinations {"dot-segments" (fs/path repo "link/.././README.md")
                      "relative" (fs/relativize (fs/real-path *tmp*)
                                                (fs/real-path (fs/path repo "README.md")))
                      "source-dot-segments" (fs/path repo "README.md")}
        cfg {:link [{:target (target "subdir/../dot-segments") :source "README.md"}
                    (entry "relative")
                    {:target (target "source-dot-segments") :source "link/.././README.md"}]}]
    (doseq [[name destination] destinations]
      (fs/create-sym-link (target name) destination))
    (doseq [args [[] ["--dry-run"]]]
      (let [{:keys [exit out]} (apply link cfg args)]
        (is (= 0 exit) out)
        (is (str/includes? (summary out) "3 unchanged, 0 linked, 0 relinked, 0 cleaned, 0 planned, 0 errors."))
        (doseq [[name destination] destinations]
          (is (= destination (fs/read-link (target name))) name))))))

(deftest unresolved-source-symlinks-do-not-change-targets
  (fs/create-sym-link (target "dangling-source") (target "missing"))
  (fs/create-sym-link (target "chain-source") (target "dangling-source"))
  (fs/create-sym-link (target "loop-source") (target "loop-source"))
  (fs/create-sym-link (target "existing") (fs/path repo "README.md"))
  (let [source (fn [name] (str (fs/relativize (fs/path repo) (fs/path (target name)))))
        cfg {:link [{:target (target "new") :source (source "dangling-source")}
                    {:target (target "existing") :source (source "chain-source")}
                    {:target (target "loop-target") :source (source "loop-source")}
                    (entry "good")]}]
    (doseq [args [["--dry-run"] []]]
      (let [{:keys [exit out]} (apply link cfg args)]
        (is (= 1 exit))
        (is (str/includes? (summary out) "3 errors."))
        (is (str/includes? (summary out) "source symlink does not resolve:"))
        (is (not (fs/exists? (target "new") {:nofollow-links true})))
        (is (not (fs/exists? (target "loop-target") {:nofollow-links true})))
        (is (= (fs/path repo "README.md") (fs/read-link (target "existing"))))))
    (is (fs/sym-link? (target "good")))))

(deftest valid-source-symlinks-remain-supported
  (fs/create-sym-link (target "source-alias") (fs/path repo "README.md"))
  (let [source (str (fs/relativize (fs/path repo) (fs/path (target "source-alias"))))
        cfg {:link [{:target (target "new") :source source}]}]
    (let [{:keys [exit out]} (link cfg)]
      (is (= 0 exit) out)
      (is (= (fs/path repo source) (fs/read-link (target "new"))))
      (is (= (fs/real-path (target "new")) (fs/real-path (fs/path repo "README.md")))))))

(let [{:keys [fail error]} (run-tests)]
  (System/exit (if (zero? (+ fail error)) 0 1)))
