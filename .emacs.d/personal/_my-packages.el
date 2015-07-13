;;package-manager

(require 'prelude-packages)

;; (prelude-require-packages '())

(defvar my-auto-install-alist
  '(("\\.boot\\'" clojure-mode clojure-mode)
    (".ssh/config\\'" ssh-config-mode ssh-config-mode) ;TODO ssh-config-mode gets overridden by conf-mode
    ("sshd?_config\\'" ssh-config-mode ssh-config-mode)
    ("known_hosts\\'" ssh-config-mode ssh-config-mode)
    ("authorized_keys2?\\'" ssh-config-mode ssh-config-mode)))

;; build auto-install mappings
(mapc
 (lambda (entry)
   (let ((extension (car entry))
         (package (cadr entry))
         (mode (cadr (cdr entry))))
     (unless (package-installed-p package)
       (prelude-auto-install extension package mode))))
 my-auto-install-alist)


;;end package-manager
