(require 'projectile)
(require 'projectile-rails)

;; Turn on projectile-rails-mode when I'm in a rails app
(add-hook 'projectile-mode-hook 'projectile-rails-on)
;; TODO: Also enable robe-mode for code navigation
