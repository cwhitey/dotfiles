{:user {:plugins [;; Code quality:
                  [lein-ancient "0.6.14"]
                  [lein-bikeshed "0.2.0"]
                  [lein-kibit "0.1.2"]
                  [jonase/eastwood "0.2.1"]
                  [lein-cljfmt "0.1.10"]
                  [lein-pprint "1.2.0"]
                  [venantius/yagni "0.1.4"]
                  ;; Other
                  ;;[venantius/ultra "0.5.2"]
                  [com.billpiel/sayid "0.0.16"]
                  [lein-try "0.4.3"]]
        :dependencies [[org.clojure/clojure "1.9.0"] ;default clojure version for repls
                       [org.clojure/tools.nrepl "0.2.13"]
                       ;;[spyscope "0.1.6"]
                       ]
        ;;:injections [(require 'spyscope.core)]
        ;; :ultra {:repl true
        ;;         :stacktraces true
        ;;         :tests false
        ;;         :java true
        ;;         :color-scheme :solarized_dark}
        ;; :jvm-opts ["-XX:MaxPermSize=128M"]
        }
 :repl {:plugins [
                  [cider/cider-nrepl "0.17.0"]
                  [refactor-nrepl "2.4.0-snapshot"]
                  ;; [joodie/clojure-refactoring "0.6.4" :exclusions [org.clojure/clojure]]
                  ]}}
