(require 'dash)
(require 's)

;;; This file contains some temporary code snippets, it will be loaded after
;;; various oh-my-emacs modules. When you just want to test some code snippets
;;; and don't want to bother with the huge ome.*org files, you can put things
;;; here.

;; For example, oh-my-emacs disables menu-bar-mode by default. If you want it
;; back, just put following code here.
(menu-bar-mode t)

;;; Your email address
(setq user-mail-address "callumw1991@gmail.com")

;;; Calendar settings
;; you can use M-x sunrise-sunset to get the sun time
(setq calendar-latitude 39.9)
(setq calendar-longitude 116.3)
(setq calendar-location-name "Beijing, China")

;;; Time related settings
;; show time in 24hours format
(setq display-time-24hr-format t)
;; show time and date
(setq display-time-and-date t)
;; time change interval
(setq display-time-interval 10)
;; show time
(display-time-mode t)

;;; File backup settings
;; save backups to specified location
(setq backup-directory-alist `(("." . "~/.emacs-backups")))
;; backup by copying (can be slow)
(setq backup-by-copying t)
;; additional backup settings
; (setq delete-old-versions t
;   kept-new-versions 6
;   kept-old-versions 2
;   version-control t)

;;; Debugging settings
;; Suppress debug stack traces for errors
(setq debug-on-error nil)


;;; Other settings
;; Disable auto-fill-mode for text-mode (e.g. Markdown!)
(remove-hook 'text-mode-hook #'turn-on-auto-fill)


;;; Packages
;; enable winner mode
(when (fboundp 'winner-mode)
      (winner-mode 1))



;;; Tools
;;
(defun replace-all-chinese-quote ()
  (interactive)
  (save-excursion
    (mark-whole-buffer)
    (replace-regexp  "”\\|“" "\"")
    (mark-whole-buffer)
    (replace-regexp "’\\|‘" "'")))

;; Comment function for GAS assembly language
(defun gas-comment-region (start end)
  "Comment region for AT&T syntax assembly language The default
comment-char for gas is ';', we need '#' instead"
  (interactive "r")
  (setq end (copy-marker end t))
  (save-excursion
    (goto-char start)
    (while (< (point) end)
      (beginning-of-line)
      (insert "# ")
      (next-line))
    (goto-char end)))

(defun gas-uncomment-region (start end)
  "Uncomment region for AT&T syntax assembly language the
inversion of gas-comment-region"
  (interactive "r")
  (setq end (copy-marker end t))
  (save-excursion
    (goto-char start)
    (while (< (point) end)
      (beginning-of-line)
      (if (equal (char-after) ?#)
          (delete-char 1))
      (next-line))
    (goto-char end)))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes (quote ("e98e6905d1bd8f71c62ee8967ecc8cf7fc8cfd760f0797f23ecd66810d3dd9c8" "0a4879589b651a17e5a1f54d4fecc306fb8631a138d0e5f8585256189fb6740a" "2b5aa66b7d5be41b18cc67f3286ae664134b95ccc4a86c9339c886dfd736132d" "9dae95cdbed1505d45322ef8b5aa90ccb6cb59e0ff26fef0b8f411dfc416c552" default))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )


;; pull all themes in elpa/ into the load path
(-each
   (-map
      (lambda (item)
      (format "~/.emacs.d/elpa/%s" item))
   (-filter
      (lambda (item) (s-contains? "theme" item))
      (directory-files "~/.emacs.d/elpa/")))
   (lambda (item)
      (add-to-list 'custom-theme-load-path item)))

;;; Themes
(defun new-theme-init ()
;; apply Zenburn
;  (load-theme 'zenburn t)

;; apply hc-zenburn
  (load-theme 'hc-zenburn t)

;; apply Dream (colours kind of broken)
;  (load-theme 'dream t)


)
(add-hook 'after-init-hook 'new-theme-init)
