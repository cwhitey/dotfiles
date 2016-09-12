{:user {:plugins [
                  ;; Code quality:
                  [lein-ancient "0.6.7"]
                  ;; [lein-bikeshed "0.2.0"]
                  ;; [lein-kibit "0.1.2"]
                  ;; [jonase/eastwood "0.2.1"]
                  ;; [lein-cljfmt "0.1.10"]
                  ;; [venantius/yagni "0.1.4"]

                  ;; Android
                  ;; [lein-droid "0.4.0-alpha4"] ;;Clojure android project builder
                  
                  ;; Other
                  ;; [venantius/ultra "0.4.1"]
                  ;; [lein-marginalia "0.9.0"]
                  [lein-try "0.4.3"]]

        :dependencies [;; [com.cemerick/piggieback "0.2.1"]
                       ;; [slamhound "1.5.5"]
                       [org.clojure/tools.nrepl "0.2.12"]
                       ]
        
        ;; :repl-options {:nrepl-middleware [cemerick.piggieback/wrap-cljs-repl]}

        ;; :aliases {"slamhound" ["run" "-m" "slam.hound"]
        ;;           "analyze"   ["yagni"]
        ;;           "qa"        ["do" ["clean"] ["with-profile" "production" "deps" ":tree"] ["ancient"] ["kibit"] ["bikeshed"] ["cljfmt check"] ["yagni"]]}

        ;; :jvm-opts ["-XX:MaxPermSize=128M"]
        
        :ultra {:repl true
                :stacktraces true
                :tests false
                :java true
                :color-scheme :solarized_dark}}
 :repl {:plugins [
                  ;; Cider (Emacs):
                  [refactor-nrepl "2.2.0"]
                  [cider/cider-nrepl "0.13.0"]
                  ;; [joodie/clojure-refactoring "0.6.4" :exclusions [org.clojure/clojure]]
                  ]}
 ;; :cuttle {:plugins [[lein-pprint "1.1.1"]]}
 }
