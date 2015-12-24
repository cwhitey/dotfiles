(prelude-require-packages '(projectile
                           projectile-rails))

;; Turn on projectile-rails-mode when I'm in a rails app
(add-hook 'projectile-mode-hook 'projectile-rails-on)
;; TODO: Make sure robe-mode is working for all rails files (how to enable for slim files?)
