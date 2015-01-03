;; Fullscreen frame
(global-set-key (kbd "C-c m") 'toggle-frame-maximized)

;; Total Mac noob mode
(global-set-key (kbd "M-c") 'copy-region-as-kill)
(global-set-key (kbd "M-v") 'yank)
(global-set-key (kbd "M-z") 'undo)

;; Add windmove keybindings
(when (fboundp 'windmove-default-keybindings)
  (windmove-default-keybindings 'alt))
;; these clashed with 'winner' (window undo) package
;;(global-set-key (kbd "C-c <left>")  'windmove-left)
;;(global-set-key (kbd "C-c <right>") 'windmove-right)
;;(global-set-key (kbd "C-c <up>")    'windmove-up)
;;(global-set-key (kbd "C-c <down>")  'windmove-down)

;; Undo an undo
(global-set-key (kbd "C-S-/") 'undo-tree-redo)

;; Neo-tree
(global-set-key [f8] 'neotree-toggle)

;; CIDER light table Mode
(global-set-key (kbd "M-S-<return>") 'cider-load-current-buffer)

;; Rgrep
;;(global-set-key (kbd "C-c f") 'rgrep)

;; Easy-mode fullscreen rgrep
(global-set-key (kbd "C-c f") 'git-grep-fullscreen)
(global-set-key (kbd "C-c F") 'rgrep-fullscreen)

;; Org-Mode
(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cb" 'org-iswitchb)

(provide 'key-bindings)
