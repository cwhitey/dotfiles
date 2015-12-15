;;; Code:
(prelude-require-packages '(cljr-helm))

(eval-after-load 'clojure-mode
  '(progn
     (add-hook 'clojure-mode-hook (lambda ()
                                    (global-set-key (kbd "C-c C-r") 'cljr-helm)))))
