{:user {:plugins [

                  ;; Code quality:
                  ;; [lein-bikeshed "0.5.0" :exclusions [org.clojure/tools.namespace]]
                  ;; [lein-kibit "0.1.6"]
                  ;; [jonase/eastwood "0.3.5"]
                  ;; [lein-cljfmt "0.6.4"]
                  ;; [venantius/yagni "0.1.7"]


                  ;; Other
                  [lein-ancient "0.6.14"]
                  [lein-try "0.4.3"]
                  [lein-nvd "1.0.0" :exclusions [org.slf4j/jcl-over-slf4j
                                                 org.slf4j/slf4j-api]]
                  ;;[venantius/ultra "0.6.0"]

                  ]
        :dependencies [[org.clojure/clojure "1.10.0"] ;default clojure version for repls
                       ;;[spyscope "0.1.6"]
                       ]
        ;;:injections [(require 'spyscope.core)]
        ;; :ultra {:repl true
        ;;         :stacktraces true
        ;;         :tests false
        ;;         :java true
        ;;         :color-scheme :solarized_dark}
        ;; :jvm-opts ["-XX:MaxPermSize=128M"]
        }}
