(ns installer
  (:require [babashka.process :as p]))

(def ^:private frames ["⠋" "⠙" "⠹" "⠸" "⠼" "⠴" "⠦" "⠧" "⠇" "⠏"])
(defn- c [code s] (str "\033[" code "m" s "\033[0m"))

(defn execute
  "Run `f` while showing a spinner labelled `title`.

  Opts:
    :optional?  when true, a failure prints a yellow warning instead of a
                red cross and returns nil rather than re-throwing — so the
                step won't abort the install."
  ([title f] (execute {} title f))
  ([{:keys [optional?]} title f]
   (let [done (atom false)
         spin (future
                (loop [i 0]
                  (when-not @done
                    (print (str "\r" (nth frames (mod i (count frames))) " " title "\033[K"))
                    (flush)
                    (Thread/sleep 80)
                    (recur (inc i)))))]
     (try
       (let [r (f)]
         (reset! done true) @spin
         (println (str "\r\033[K" (c "32" "✓") " " title))   ; green check
         r)
       (catch Exception e
         (reset! done true) @spin
         (if optional?
           (do
             (println (str "\r\033[K" (c "33" "⚠") " " title (c "33" " (optional, skipped)")))
             (when-let [err (:err (ex-data e))]               ; dim the captured stderr
               (println (c "33" err)))
             nil)
           (do
             (println (str "\r\033[K" (c "31" "✗") " " title)) ; red cross
             (when-let [err (:err (ex-data e))]               ; show captured stderr
               (println (c "31" err)))
             (throw e))))))))

(comment
  ;; capture output instead of inheriting it, so subprocess output
  ;; doesn't smear across the spinner line
  (try
    ;; required step — failure aborts the install
    (execute "Installing fonts"
      #(p/shell {:out :string :err :string} "some-cmd"))
    ;; optional step — failure warns and continues
    (execute {:optional? true} "Installing nice-to-have extras"
      #(p/shell {:out :string :err :string} "maybe-cmd"))
    (catch Exception _
      (println (c "31" "Install failed — see above."))
      (System/exit 1))))
