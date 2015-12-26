(require 'prelude-helm)

(prelude-require-packages '(cljr-helm))

(require 'cljr-helm)

(eval-after-load 'clojure-mode
  '(progn
     (add-hook 'clojure-mode-hook (lambda ()
                                    (global-set-key (kbd "C-c C-r") 'cljr-helm)))))
