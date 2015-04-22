{:user {:plugins [[lein-ancient "0.6.2"]
                  [cider/cider-nrepl "0.8.2"]
                  ;; This snapshot contains middleware for cider-debug
                  ;; [cider/cider-nrepl "0.9.0-SNAPSHOT"]
                  [refactor-nrepl "0.2.2"]
                  [joodie/clojure-refactoring "0.6.4" :exclusions [org.clojure/clojure]]
                  [venantius/ultra "0.3.3"]
                  [lein-bikeshed "0.2.0"]
                  [lein-marginalia "0.8.0"]
                  [lein-try "0.4.3"]
                  [lein-droid "0.4.0-alpha1"] ; Clojure android project builder
                  ]
        :ultra {:repl true
                :stacktraces false
                :tests false
                :java false
                :color-scheme :solarized_dark}}
 :cuttle {:plugins [[lein-pprint "1.1.1"]]}}
