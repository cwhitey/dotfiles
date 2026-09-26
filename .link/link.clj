#!/usr/bin/env bb
;; Dotfiles linker — babashka replacement for dotbot.
;;
;; Usage (see ./.link/link.clj --help):
;;   ./.link/link.clj                       apply links + clean (link.config.edn)
;;   ./.link/link.clj --config other.edn    use a different config (alias: -c)
;;   ./.link/link.clj --dry-run             preview actions, change nothing (-n)
;;
;; Config is read from an EDN file (default link.config.edn) shaped like
;; {:link [{:target ".." :source ".."} ..] :clean [".." ..]}. Only :link and
;; :clean are implemented (the directives the old install.conf.yaml used).
;; Links always relink: an existing symlink pointing at the wrong place is
;; replaced. A real (non-symlink) file/dir at the target is left untouched.
;; Exit codes: 0 success, 1 operation failures (including in dry-run),
;; 2 command-line or configuration errors.

(require '[babashka.cli :as cli]
         '[babashka.fs :as fs]
         '[clojure.edn :as edn]
         '[clojure.string :as str])

;; Repo root is the parent of this script's .link directory.
;; :source entries in the config resolve relative to this.
(def basedir (-> *file* fs/absolutize fs/parent fs/parent fs/normalize str))

(def default-config (str (fs/path basedir "link.config.edn")))

(def ^:dynamic *dry-run* false)
(def ^:dynamic *results* nil)
(def ^:dynamic *config-item* nil)

(defn- log [status path & [detail]]
  (when *results*
    (swap! *results*
           (fn [results]
             (cond-> (update results status (fnil inc 0))
               (= status :error)
               (update :errors (fnil conj [])
                       {:config-item *config-item* :path (str path) :reason detail})))))
  (println (format "%-7s %s%s"
                   (name status)
                   (str path)
                   (if detail (str "  (" detail ")") ""))))

(defn- exception-reason [e]
  ;; Filesystem exceptions often contain only a path in their message.
  ;; Include the type so, for example, AccessDeniedException is actionable.
  (str (.getSimpleName (class e))
       (when-let [message (ex-message e)] (str ": " message))))

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
  (try
    (let [tgt (abs-target target)
          src (abs-source source)]
      (cond
        ;; Follow source symlinks: a dangling source must never replace a
        ;; working target or create another broken link.
        (not (fs/exists? src))
        (log :error tgt (str (if (fs/sym-link? src)
                              "source symlink does not resolve: "
                              "source missing: ") src))

        (fs/sym-link? tgt)
        ;; Compare resolved paths so relative links, . and .., and directory
        ;; symlink aliases don't cause needless relinking. real-path follows
        ;; filesystem semantics (including symlink/..), not just string rules.
        (if (and (fs/exists? tgt)
                 (= (fs/real-path tgt) (fs/real-path src)))
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
          (log (if *dry-run* :would :linked) tgt (str "-> " src)))))
    (catch Exception e
      (log :error target (exception-reason e)))))

(defn- points-into-repo? [path]
  ;; Canonicalize existing symlink ancestors as well as . and .., even when
  ;; the final destination is missing. Path.startsWith compares components,
  ;; so a sibling such as dotfiles-other is never considered inside dotfiles.
  (.startsWith (fs/canonicalize (current-link-dest path))
               (fs/canonicalize basedir)))

(defn clean-one
  "Remove broken symlinks in `dir` that point into the repo (non-recursive)."
  [dir]
  (try
    (let [d (fs/expand-home dir)]
      (when (fs/directory? d)
        (doseq [child (fs/list-dir d)]
          (try
            (when (and (fs/sym-link? child)
                       (not (fs/exists? child)) ; follows links: false => dangling
                       (points-into-repo? child))
              (when-not *dry-run* (fs/delete child))
              (log (if *dry-run* :would :clean) child "dead link into repo"))
            (catch Exception e
              (log :error child (exception-reason e)))))))
    (catch Exception e
      (log :error dir (exception-reason e)))))

(defn- print-summary [results config-path]
  (println
   (format "\nSummary: %d unchanged, %d linked, %d relinked, %d cleaned, %d planned, %d errors."
           (get results :ok 0)
           (get results :linked 0)
           (get results :relink 0)
           (get results :clean 0)
           (get results :would 0)
           (get results :error 0)))
  (when (seq (:errors results))
    (println (str "\nErrors in " config-path " (entry indexes are zero-based):"))
    (doseq [{:keys [config-item path reason]} (:errors results)]
      (println (str "  " (pr-str (:location config-item)) " " (pr-str (:value config-item))))
      (println (str "    Path: " (pr-str path)))
      (println (str "    Reason: " reason)))))

(defn- run-entries [directive entries operation]
  (doseq [[index entry] (map-indexed vector entries)]
    (binding [*config-item* {:location [directive index] :value entry}]
      (operation entry))))

(defn- die [& msg]
  (binding [*out* *err*] (apply println msg))
  (System/exit 2))

(defn validate-config
  "Return all configuration errors, without touching the filesystem.
  Sections are optional; an empty map or empty vectors are valid no-ops."
  [cfg]
  (let [errors (atom [])
        rule (fn [valid? location value message]
               (when-not valid?
                 (swap! errors conj
                        (str (pr-str location) ": " message
                             " (got " (pr-str value) ")"))))
        path-string? (fn [value]
                       (and (string? value) (not (str/blank? value))))]
    ;; Rule 1: the config is a map containing only supported directives.
    (rule (map? cfg) [] cfg "must be a map")
    (when (map? cfg)
      (doseq [key (keys cfg)]
        (rule (contains? #{:link :clean} key) [key] (get cfg key)
              "unknown directive; expected :link or :clean"))

      ;; Rule 2: each provided section is a vector.
      (doseq [key [:link :clean] :when (contains? cfg key)]
        (rule (vector? (get cfg key)) [key] (get cfg key) "must be a vector"))

      ;; Rule 3: every link is a map with only :target and :source.
      (when (vector? (:link cfg))
        (doseq [[index entry] (map-indexed vector (:link cfg))]
          (rule (map? entry) [:link index] entry "must be a map")
          (when (map? entry)
            (doseq [key (keys entry)]
              (rule (contains? #{:target :source} key) [:link index key] (get entry key)
                    "unknown link field; expected :target or :source"))

            ;; Rule 4: both link paths are required, non-blank strings.
            (doseq [key [:target :source]]
              (rule (path-string? (get entry key)) [:link index key] (get entry key)
                    "must be a non-blank path string (required)")))))

      ;; Rule 5: each cleanup directory is a non-blank string.
      (when (vector? (:clean cfg))
        (doseq [[index dir] (map-indexed vector (:clean cfg))]
          (rule (path-string? dir) [:clean index] dir "must be a non-blank path string"))))
    @errors))

;; Declarative CLI: aliases, coercion, defaults and help are derived from this.
(def cli-spec
  {:spec
   {:config  {:alias :c :ref "<file>" :default default-config
              :default-desc "link.config.edn"
              :desc "EDN config file describing :link and :clean"}
    :dry-run {:alias :n :coerce :boolean
              :desc "Preview actions without touching the filesystem"}
    :help    {:alias :h :coerce :boolean
              :desc "Show this help and exit"}}
   :restrict true                                   ; reject unknown flags
   :error-fn (fn [{:keys [msg]}] (die msg))})

(defn- print-help []
  (println "link.clj — symlink dotfiles into place (dotbot replacement)")
  (println)
  (println "Usage: ./.link/link.clj [options]")
  (println)
  (println "Options:")
  (println (cli/format-opts cli-spec)))

(defn load-config [path]
  (let [f (if (fs/absolute? path) path (str (fs/path (fs/cwd) path)))]
    (when-not (fs/exists? f) (die "config not found:" (str f)))
    (try
      (with-open [reader (java.io.PushbackReader. (java.io.StringReader. (slurp (str f))))]
        (let [eof (Object.)
              cfg (edn/read {:eof eof} reader)]
          (when (identical? eof cfg)
            (throw (ex-info "expected one EDN map; file is empty" {})))
          (when-not (identical? eof (edn/read {:eof eof} reader))
            (throw (ex-info "expected one EDN map; found extra data after it" {})))
          cfg))
      (catch Exception e
        (die (str "Cannot read configuration " f ": " (ex-message e)
                  "\nNo changes made."))))))

(defn -main [& args]
  (let [opts (cli/parse-opts args cli-spec)]
    (if (:help opts)
      (print-help)
      (let [cfg (load-config (:config opts))
            errors (validate-config cfg)]
        (when (seq errors)
          (die (str "Invalid configuration in " (:config opts) ":\n"
                    (str/join "\n" (map #(str "  " %) errors))
                    "\nNo changes made.")))
        (binding [*dry-run* (boolean (:dry-run opts))
                  *results* (atom {})]
          (when *dry-run* (println "[dry-run] no filesystem changes will be made\n"))
          (println "Linking:")
          (run-entries :link (:link cfg) link-one)
          (println "\nCleaning:")
          (run-entries :clean (:clean cfg) clean-one)
          (print-summary @*results* (:config opts))
          (when (pos? (get @*results* :error 0))
            (System/exit 1)))))))

(apply -main *command-line-args*)
