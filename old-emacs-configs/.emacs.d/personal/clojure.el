(require 'prelude-programming)
(prelude-require-packages '(align-cljlet
                            clj-refactor))
(require 'align-cljlet)

(require 'clj-refactor)

(defun clj-refactor-hook ()
  (clj-refactor-mode 1)
  (yas-minor-mode 1) ; for adding require/use/import
  (cljr-add-keybindings-with-prefix "C-c C-m"))

(add-hook 'clojure-mode-hook #'clj-refactor-hook)
