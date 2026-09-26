#!/usr/bin/env bb
;; End-to-end test for link.clj. MUST run inside a throwaway container
;; (see .link/tests/run.clj) — it writes to the real $HOME and /usr/local/bin.
;;
;; Drives link.clj with .link/tests/test.config.edn (committed fixtures under
;; .link/tests/fixtures/), seeds $HOME with one fixture per branch of the linker, runs
;; the script, then asserts on both its printed output and the filesystem.

(require '[babashka.fs :as fs]
         '[babashka.process :as p]
         '[clojure.string :as str])

(def repo (-> *file* fs/absolutize fs/normalize fs/parent fs/parent fs/parent str))
(def home (str (fs/expand-home "~")))
(def test-config ".link/tests/test.config.edn")

(defn h [& parts] (str (apply fs/path home parts)))
(defn r [& parts] (str (apply fs/path repo parts)))

;; --- result tracking ---------------------------------------------------------
(def results (atom {:pass 0 :fail 0}))

(defn check [ok? msg]
  (if ok?
    (do (swap! results update :pass inc) (println (str "  \033[32mPASS\033[0m " msg)))
    (do (swap! results update :fail inc) (println (str "  \033[31mFAIL\033[0m " msg)))))

;; --- predicates --------------------------------------------------------------
(defn exists? [path] (fs/exists? path {:nofollow-links true}))

(defn link-to? [path src]
  (and (fs/sym-link? path)
       (= (str (fs/canonicalize path)) (str (fs/canonicalize src)))))

(defn real-file? [path content]
  (and (exists? path)
       (not (fs/sym-link? path))
       (fs/regular-file? path)
       (= content (slurp (str path)))))

(defn out-has? [out pattern] (boolean (re-find pattern out)))

;; --- fixtures ----------------------------------------------------------------
(defn nuke [path]
  (cond
    (fs/sym-link? path)  (fs/delete path)
    (fs/directory? path) (fs/delete-tree path)
    (exists? path)       (fs/delete path)))

(defn seed []
  (run! nuke [(h ".dtf-correct") (h ".dtf-wrong") (h ".dtf-realfile")
              (h ".dtf-newfile") (h ".dtf-dir") (h ".dtf-deadlink")
              (h ".dtf-otherdead") "/usr/local/bin/dtf-test"])
  (fs/create-sym-link (h ".dtf-correct") (r ".link/tests/fixtures/correct")) ; correct -> ok
  (fs/create-sym-link (h ".dtf-wrong")   "/etc/hostname")             ; wrong   -> relink
  (spit (h ".dtf-realfile") "do not touch")                          ; real file -> error
  ;; .dtf-newfile / .dtf-dir / /usr/local/bin/dtf-test absent          ; absent  -> linked
  (fs/create-sym-link (h ".dtf-deadlink")  (r "does-not-exist"))      ; dead, into repo -> clean
  (fs/create-sym-link (h ".dtf-otherdead") "/nope/missing"))           ; dead, elsewhere -> kept

(defn run-link-script [& args]
  (let [{:keys [out err]} (apply p/shell {:dir repo :out :string :err :string
                                          :continue true}
                                 "./.link/link.clj" "--config" test-config args)]
    (str out err)))

;; --- run 1: dry-run must change nothing --------------------------------------
(println "==> dry-run (must make no changes)")
(seed)
(let [out (run-link-script "--dry-run")]
  (println out)
  (check (out-has? out #"\[dry-run\]")                "dry-run announces itself")
  (check (not (exists? (h ".dtf-newfile")))           "dry-run did not create .dtf-newfile")
  (check (real-file? (h ".dtf-realfile") "do not touch") "dry-run left real file untouched")
  (check (fs/sym-link? (h ".dtf-deadlink"))           "dry-run left dead link in place")
  (check (not (exists? "/usr/local/bin/dtf-test"))    "dry-run did not create /usr/local/bin link"))

;; --- run 2: real apply -------------------------------------------------------
(println "==> apply (real run)")
(seed)
(let [out (run-link-script)]
  (println out)

  (println "==> output assertions")
  (check (out-has? out #"(?m)^ok\s+.*\.dtf-correct")     "correct symlink reported ok")
  (check (out-has? out #"(?m)^relink\s+.*\.dtf-wrong")   "wrong symlink reported relink")
  (check (out-has? out #"(?m)^error\s+.*\.dtf-realfile") "real file reported error")
  (check (out-has? out #"(?m)^linked\s+.*\.dtf-newfile") "absent target reported linked")
  (check (out-has? out #"(?m)^clean\s+.*\.dtf-deadlink") "dead link into repo reported clean"))

(println "==> filesystem assertions")
(check (link-to? (h ".dtf-correct")  (r ".link/tests/fixtures/correct")) "correct symlink preserved")
(check (link-to? (h ".dtf-wrong")    (r ".link/tests/fixtures/wrong"))   "wrong symlink relinked to repo")
(check (real-file? (h ".dtf-realfile") "do not touch")            "real file NOT clobbered")
(check (link-to? (h ".dtf-newfile")  (r ".link/tests/fixtures/newsrc"))  "absent target linked")
(check (link-to? (h ".dtf-dir")      (r ".link/tests/fixtures/dirsrc"))  "absent dir target linked")
(check (link-to? "/usr/local/bin/dtf-test" (r ".link/tests/fixtures/newsrc")) "/usr/local/bin link created")
(check (not (exists? (h ".dtf-deadlink")))                        "dead link into repo cleaned")
(check (fs/sym-link? (h ".dtf-otherdead"))                        "unrelated dead link left alone")

;; --- summary -----------------------------------------------------------------
(let [{:keys [pass fail]} @results]
  (println)
  (println (format "==> %d passed, %d failed" pass fail))
  (System/exit (if (pos? fail) 1 0)))
