{:user {:plugins [[lein-ancient "0.6.2"]
                  [cider/cider-nrepl "0.8.2"]
                  ;; This snapshot contains middleware for cider-debug
                  ;; [cider/cider-nrepl "0.9.0-SNAPSHOT"]
                  [refactor-nrepl "0.2.2"]
                  [joodie/clojure-refactoring "0.6.4" :exclusions [org.clojure/clojure]]
                  ;; [venantius/ultra "0.1.9"]
                  [lein-bikeshed "0.2.0"]
                  [lein-marginalia "0.8.0"]
                  [lein-try "0.4.3"]]
        :ultra {:repl false
                :stacktraces false
                :tests false
                :java false
                :color-scheme :solarized_dark}}
 :cuttle {:plugins [[lein-pprint "1.1.1"]]}}
