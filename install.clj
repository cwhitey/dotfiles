#!/usr/bin/env bb
;; Dotfiles installer — babashka replacement for dotbot.
;;
;; Usage (see ./install.clj --help):
;;   ./install.clj                       apply links + clean (install.config.edn)
;;   ./install.clj --config other.edn    use a different config (alias: -c)
;;   ./install.clj --dry-run             preview actions, change nothing (-n)
;;
;; Config is read from an EDN file (default install.config.edn) shaped like
;; {:link [{:target ".." :source ".."} ..] :clean [".." ..]}. Only :link and
;; :clean are implemented (the directives the old install.conf.yaml used).
;; Links always relink: an existing symlink pointing at the wrong place is
;; replaced. A real (non-symlink) file/dir at the target is left untouched.

(require '[babashka.cli :as cli]
         '[babashka.fs :as fs]
         '[clojure.edn :as edn]
         '[clojure.string :as str])

;; Repo root, derived from this script's location (like dotbot's BASEDIR).
;; :source entries in the config resolve relative to this.
(def basedir (str (fs/normalize (fs/parent (fs/absolutize *file*)))))

(def default-config (str (fs/path basedir "install.config.edn")))

(def ^:dynamic *dry-run* false)

(defn- log [status path & [detail]]
  (println (format "%-7s %s%s"
                   (name status)
                   (str path)
                   (if detail (str "  (" detail ")") ""))))

(defn- abs-target [target]
  (str (fs/absolutize (fs/expand-home target))))

(defn- abs-source [source]
  (str (fs/absolutize (fs/path basedir source))))

(defn- current-link-dest
  "Absolute path the symlink at `path` points to, or nil if not a symlink."
  [path]
  (when (fs/sym-link? path)
    (let [raw (fs/read-link path)]
      (str (fs/absolutize (if (fs/absolute? raw)
                            raw
                            (fs/path (fs/parent path) raw)))))))

(defn link-one [{:keys [target source]}]
  (let [tgt (abs-target target)
        src (abs-source source)]
    (try
      (cond
        (not (fs/exists? src {:nofollow-links true}))
        (log :error tgt (str "source missing: " src))

        (fs/sym-link? tgt)
        (if (= (current-link-dest tgt) src)
          (log :ok tgt)
          (do
            (when-not *dry-run*
              (fs/delete tgt)
              (fs/create-sym-link tgt src))
            (log (if *dry-run* :would :relink) tgt (str "-> " src))))

      ;; exists as a real file/dir: don't clobber. Flag it loudly so it can be
      ;; resolved by hand rather than silently skipped.
        (fs/exists? tgt {:nofollow-links true})
        (log :error tgt
             (format "%s already exists as a file/dir. manually resolve to link this file -> %s"
                     (if (fs/directory? tgt) "directory" "file") src))

        :else
        (do
          (when-not *dry-run*
            (let [parent (fs/parent tgt)]
              (when-not (fs/exists? parent) (fs/create-dirs parent)))
            (fs/create-sym-link tgt src))
          (log (if *dry-run* :would :linked) tgt (str "-> " src))))
      (catch Exception e
        (log :error tgt (ex-message e))))))

(defn clean-one
  "Remove broken symlinks in `dir` that point into the repo (non-recursive)."
  [dir]
  (let [d (fs/expand-home dir)]
    (when (fs/directory? d)
      (doseq [child (fs/list-dir d)]
        (when (and (fs/sym-link? child)
                   (not (fs/exists? child)) ; follows links: false => dangling
                   (str/starts-with? (str (current-link-dest child)) basedir))
          (when-not *dry-run* (fs/delete child))
          (log (if *dry-run* :would :clean) child "dead link into repo"))))))

(defn- die [& msg]
  (binding [*out* *err*] (apply println msg))
  (System/exit 2))

;; Declarative CLI: aliases, coercion, defaults and help are derived from this.
(def cli-spec
  {:spec
   {:config  {:alias :c :ref "<file>" :default default-config
              :default-desc "install.config.edn"
              :desc "EDN config file describing :link and :clean"}
    :dry-run {:alias :n :coerce :boolean
              :desc "Preview actions without touching the filesystem"}
    :help    {:alias :h :coerce :boolean
              :desc "Show this help and exit"}}
   :restrict true                                   ; reject unknown flags
   :error-fn (fn [{:keys [msg]}] (die msg))})

(defn- print-help []
  (println "install.clj — symlink dotfiles into place (dotbot replacement)")
  (println)
  (println "Usage: ./install.clj [options]")
  (println)
  (println "Options:")
  (println (cli/format-opts cli-spec)))

(defn load-config [path]
  (let [f (if (fs/absolute? path) path (str (fs/path (fs/cwd) path)))]
    (when-not (fs/exists? f) (die "config not found:" (str f)))
    (edn/read-string (slurp (str f)))))

(defn -main [& args]
  (let [opts (cli/parse-opts args cli-spec)]
    (if (:help opts)
      (print-help)
      (let [cfg (load-config (:config opts))]
        (binding [*dry-run* (boolean (:dry-run opts))]
          (when *dry-run* (println "[dry-run] no filesystem changes will be made\n"))
          (println "Linking:")
          (run! link-one (:link cfg))
          (println "\nCleaning:")
          (run! clean-one (:clean cfg)))))))

(apply -main *command-line-args*)
