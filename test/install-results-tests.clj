#!/usr/bin/env bb
;; Focused exit-code and summary checks. Safe to run locally: all targets
;; and cleanup directories are created under a temporary directory.
;; Usage: bb test/install-results-tests.clj
(require '[babashka.fs :as fs]
         '[babashka.process :as p]
         '[clojure.string :as str]
         '[clojure.test :refer [deftest is run-tests]])

(def repo (-> *file* fs/absolutize fs/parent fs/parent str))
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

(defn install [config & args]
  (let [config-file (target "config.edn")]
    (spit config-file (pr-str config))
    (apply p/shell {:dir repo :out :string :err :string :continue true}
           "bb" "install.clj" "--config" config-file args)))

(defn summary [out]
  (last (str/split out #"\nSummary: " 2)))

(deftest success-and-unchanged
  (let [config {:link [(entry "linked")]}]
    (let [{:keys [exit out]} (install config)]
      (is (= 0 exit))
      (is (fs/sym-link? (target "linked")))
      (is (not (str/includes? (summary out) "Errors in")))
      (is (str/includes? out "Summary: 0 unchanged, 1 linked, 0 relinked, 0 cleaned, 0 planned, 0 errors.")))
    (let [{:keys [exit out]} (install config)]
      (is (= 0 exit))
      (is (str/includes? out "Summary: 1 unchanged, 0 linked, 0 relinked, 0 cleaned, 0 planned, 0 errors.")))))

(deftest failures-are-counted-and-work-continues
  (spit (target "conflict") "keep me")
  (spit (target "parent-file") "not a directory")
  (fs/create-sym-link (target "dead") (fs/path repo "missing-results-test-source"))
  (let [{:keys [exit out]}
        (install {:link [{:target (target "missing") :source "missing-results-test-source"}
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
        (install {:link [(entry "conflict") (entry "new")]
                  :clean [(str *tmp*)]} "--dry-run")]
    (is (= 1 exit))
    (is (= "keep me" (slurp (target "conflict"))))
    (is (not (fs/exists? (target "new") {:nofollow-links true})))
    (is (fs/sym-link? (target "dead")))
    (is (str/includes? (summary out) (str "[:link 0] " (pr-str (entry "conflict")))))
    (is (str/includes? out "Summary: 0 unchanged, 0 linked, 0 relinked, 0 cleaned, 2 planned, 1 errors."))))

(deftest successful-dry-run
  (let [{:keys [exit out]} (install {:link [(entry "new")]} "--dry-run")]
    (is (= 0 exit))
    (is (not (fs/exists? (target "new") {:nofollow-links true})))
    (is (str/includes? out "Summary: 0 unchanged, 0 linked, 0 relinked, 0 cleaned, 1 planned, 0 errors."))))

(deftest cleanup-exceptions-do-not-stop-later-directories
  (fs/create-sym-link (target "dead") (fs/path repo "missing-results-test-source"))
  (let [{:keys [exit out]} (install {:clean [(str "invalid" (char 0)) (str *tmp*)]})]
    (is (= 1 exit))
    (is (not (fs/sym-link? (target "dead"))))
    (is (str/includes? (summary out) (str "[:clean 0] " (pr-str (str "invalid" (char 0))))))
    (is (str/includes? (summary out) "Reason: InvalidPathException:"))
    (is (str/includes? out "Summary: 0 unchanged, 0 linked, 0 relinked, 1 cleaned, 0 planned, 1 errors."))))

(let [{:keys [fail error]} (run-tests)]
  (System/exit (if (zero? (+ fail error)) 0 1)))
