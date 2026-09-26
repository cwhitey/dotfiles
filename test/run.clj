#!/usr/bin/env bb
;; Build the throwaway image and run the link.clj test harness in a
;; container. Usage: test/run.clj   (override engine with CONTAINER_ENGINE)

(require '[babashka.fs :as fs]
         '[babashka.process :as p])

(def repo (-> *file* fs/absolutize fs/normalize fs/parent fs/parent str))

(defn container-engine []
  (or (not-empty (System/getenv "CONTAINER_ENGINE"))
      (some #(when (fs/which %) %) ["docker" "podman"])
      (do (println "no docker or podman found (set CONTAINER_ENGINE)")
          (System/exit 1))))

(let [engine (container-engine)
      run (fn [& args] (apply p/shell {:dir repo} engine args))]
  (run "build" "-f" "test/Dockerfile" "-t" "dotfiles-install-test" ".")
  (run "run" "--rm" "dotfiles-install-test"))
