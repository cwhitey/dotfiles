;; The highlighting of long lines with whitespace mode is a bit too intrusive
(setq prelude-whitespace nil)

(scroll-bar-mode -1)

;; Swap Command and Option keys (may only be desirable to macs. We'll see)
(setq mac-command-modifier 'meta)
(setq mac-option-modifier 'super)
(setq ns-command-modifier 'meta)
(setq ns-option-modifier 'super)

;; Nicer mouse wheel scrolling
(setq mouse-wheel-scroll-amount '(1 ((shift) . 1) ((control) . nil)))
(setq mouse-wheel-progressive-speed nil)

;; I just want to use normal arrow keys thank you very much.
(setq prelude-guru nil)
