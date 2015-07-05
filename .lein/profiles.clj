{:user {:plugins [
                  ;; Code quality:
                  [lein-ancient "0.6.2"]
                  [lein-bikeshed "0.2.0"]
                  [lein-kibit "0.1.2"]
                  [jonase/eastwood "0.2.1"]
                  [lein-cljfmt "0.1.10"]

                  ;; Cider (Emacs):
                  [cider/cider-nrepl "0.10.0-SNAPSHOT"]
                  [refactor-nrepl "1.1.0-SNAPSHOT"]
                  ;; [joodie/clojure-refactoring "0.6.4" :exclusions [org.clojure/clojure]]

                  ;; Other
                  ;; [venantius/ultra "0.3.3"]
                  ;; [lein-marginalia "0.8.0"]
                  [lein-try "0.4.3"]
                  ;; [lein-droid "0.4.0-alpha1"] ;;Clojure android project builder
                  ]

        :dependencies [[com.cemerick/piggieback "0.2.1"]
                       [org.clojure/tools.nrepl "0.2.10"]
                       [slamhound "1.5.5"]]
        :repl-options {:nrepl-middleware [cemerick.piggieback/wrap-cljs-repl]}

        :aliases {"slamhound" ["run" "-m" "slam.hound"]
                  "qa" ["do" ["clean"] ["with-profile" "production" "deps" ":tree"] ["ancient"] ["kibit"] ["bikeshed"] ["cljfmt check"]]}

        :ultra {:repl true
                :stacktraces false
                :tests false
                :java false
                :color-scheme :solarized_dark}}

 :cuttle {:plugins [[lein-pprint "1.1.1"]]}}
