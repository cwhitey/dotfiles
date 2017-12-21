;; -*- mode: emacs-lisp -*-
;; This file is loaded by Spacemacs at startup.
;; It must be stored in your home directory.

(defun dotspacemacs/layers ()
  "Configuration Layers declaration.
You should not put any user code in this function besides modifying the variable
values."
  (setq-default
   ;; Base distribution to use. This is a layer contained in the directory
   ;; `+distribution'. For now available distributions are `spacemacs-base'
   ;; or `spacemacs'. (default 'spacemacs)
   dotspacemacs-distribution 'spacemacs
   ;; Lazy installation of layers (i.e. layers are installed only when a file
   ;; with a supported type is opened). Possible values are `all', `unused'
   ;; and `nil'. `unused' will lazy install only unused layers (i.e. layers
   ;; not listed in variable `dotspacemacs-configuration-layers'), `all' will
   ;; lazy install any layer that support lazy installation even the layers
   ;; listed in `dotspacemacs-configuration-layers'. `nil' disable the lazy
   ;; installation feature and you have to explicitly list a layer in the
   ;; variable `dotspacemacs-configuration-layers' to install it.
   ;; (default 'unused)
   dotspacemacs-enable-lazy-installation 'unused
   ;; If non-nil then Spacemacs will ask for confirmation before installing
   ;; a layer lazily. (default t)
   dotspacemacs-ask-for-lazy-installation t
   dotspacemodemacs-configuration-layer-path '()
   ;; List of configuration layers to load.
   dotspacemacs-configuration-layers
   '(
     ;; ----------------------------------------------------------------
     ;; Example of useful layers you may want to use right away.
     ;; Uncomment some layer names and press <SPC f e R> (Vim style) or
     ;; <M-m f e R> (Emacs style) to install them.
     ;; ----------------------------------------------------------------

     ;; Basics
     ivy
     auto-completion
     better-defaults
     emacs-lisp
     syntax-checking

     ;; Tools
     shell
     (git :variables
          git-magit-status-fullscreen t
          git-gutter-use-fringe t)

     ;; Languages
     haskell
     (scala :variables
            scala-enable-eldoc
            scala-indent:default-run-on-strategy 'reluctant
            scala-indent:align-parameters nil
            scala-indent:align-forms nil)
     elixir
     erlang
     python
     go
     shell-scripts

     (ruby :variables
           ruby-version-manager 'chruby
           ruby-test-runner 'rspec
           ruby-enable-enh-ruby-mode t
           enh-ruby-deep-indent-paren nil
           enh-ruby-hanging-paren-deep-indent-level 2
           enh-ruby-hanging-brace-deep-indent-level 2)
     (javascript :variables
                 js2-basic-offset 2
                 js-indent-level 2
                 js2-global-externs '("module" "require" "__dirname" "console" "process"
                                      "describe" "it" "before" "beforeEach" "after" "afterEach"))
     react
     (html :variables
           css-indent-offset 2)
     org
     markdown
     yaml
     )
   ;; List of additional packages that will be installed without being
   ;; wrapped in a layer. If you need some configuration for these
   ;; packages, then consider creating a layer. You can also put the
   ;; configuration in `dotspacemacs/user-config'.
   dotspacemacs-additional-packages '(
                                      ag
                                      easy-kill
                                      super-save
                                      )
   ;; A list of packages that cannot be updated.
   dotspacemacs-frozen-packages '()
   ;; A list of packages that will not be installed and loaded.
   dotspacemacs-excluded-packages '()
   ;; Defines the behaviour of Spacemacs when installing packages.
   ;; Possible values are `used-only', `used-but-keep-unused' and `all'.
   ;; `used-only' installs only explicitly used packages and uninstall any
   ;; unused packages as well as their unused dependencies.
   ;; `used-but-keep-unused' installs only the used packages but won't uninstall
   ;; them if they become unused. `all' installs *all* packages supported by
   ;; Spacemacs and never uninstall them. (default is `used-only')
   dotspacemacs-install-packages 'used-only))

(defun dotspacemacs/init ()
  (setq-default
   dotspacemacs-elpa-https t
   dotspacemacs-elpa-timeout 5
   dotspacemacs-elpa-subdirectory nil
   dotspacemacs-editing-style 'emacs
   dotspacemacs-startup-banner 'official
   dotspacemacs-startup-lists '((recents . 10)
                                (projects . 7))
   dotspacemacs-scratch-mode 'emacs-lisp-mode
   dotspacemacs-themes '(spacemacs-dark
                         spacemacs-light)
   dotspacemacs-colorize-cursor-according-to-state t
   dotspacemacs-default-font '("Source Code Pro"
                               :size 13
                               :weight normal
                               :width normal
                               :powerline-scale 1.1)
   dotspacemacs-emacs-command-key "SPC"
   dotspacemacs-ex-command-key ":"
   dotspacemacs-emacs-leader-key "M-m"
   dotspacemacs-major-mode-leader-key ","
   dotspacemacs-major-mode-emacs-leader-key "C-M-m"
   dotspacemacs-distinguish-gui-tab nil
   dotspacemacs-auto-resume-layouts nil
   dotspacemacs-large-file-size 1
   dotspacemacs-auto-save-file-location 'cache
   dotspacemacs-max-rollback-slots 5
   dotspacemacs-enable-paste-transient-state nil
   dotspacemacs-which-key-delay 0.4
   dotspacemacs-which-key-position 'bottom
   dotspacemacs-loading-progress-bar nil
   dotspacemacs-fullscreen-at-startup t
   dotspacemacs-fullscreen-use-non-native t
   dotspacemacs-maximized-at-startup nil
   dotspacemacs-show-transient-state-title t
   dotspacemacs-show-transient-state-color-guide t
   dotspacemacs-mode-line-unicode-symbols nil
   dotspacemacs-smooth-scrolling t
   dotspacemacs-line-numbers nil
   dotspacemacs-folding-method 'origami
   dotspacemacs-smartparens-strict-mode nil
   dotspacemacs-smart-closing-parenthesis nil
   dotspacemacs-highlight-delimiters 'all
   dotspacemacs-persistent-server nil
   dotspacemacs-search-tools '("ag" "pt" "ack" "grep")
   dotspacemacs-default-package-repository nil
   dotspacemacs-whitespace-cleanup 'changed))

(defun dotspacemacs/user-init ()
  "Initialization function for user code.
It is called immediately after `dotspacemacs/init', before layer configuration
executes.
 This function is mostly useful for variables that need to be set
before packages are loaded. If you are unsure, you should try in setting them in
`dotspacemacs/user-config' first."
  (setq-default
   exec-path-from-shell-check-startup-files nil
   super-save-auto-save-when-idle t
   auto-save-default nil
   scala-use-unicode-arrows nil
   ensime-startup-notification nil
   ensime-startup-notification nil
   ensime-startup-snapshot-notification nil
   ivy-initial-inputs-alist nil
   ivy-re-builders-alist '((t . (lambda (str) (ivy--regex str 1))))
   ))

(defun dotspacemacs/user-config ()
  "Configuration function for user code.
This function is called at the very end of Spacemacs initialization after
layers configuration.
This is the place where most of your configurations should be done. Unless it is
explicitly specified that a variable should be set before a package is loaded,
you should place your code here."

  (super-save-mode +1)

  ;; diminish
  (spacemacs|diminish company-mode)
  (spacemacs|diminish which-key-mode)
  (spacemacs|diminish holy-mode)
  (spacemacs|diminish super-save-mode)


  (define-globalized-minor-mode global-delete-selection-mode delete-selection-mode delete-selection-mode)
  (global-delete-selection-mode 1)

  ;; tweak mouse scrolling
  (setq mouse-wheel-scroll-amount '(2 ((shift) . 3) ((control) . nil)) ;; two lines at a time
        ;; super smooth
        ;; mouse-wheel-scroll-amount '(0.01)
        ;; don't accelerate scroll-ing
        mouse-wheel-progressive-speed nil)

  ;; projectile
  (with-eval-after-load 'projectile
    (define-key projectile-mode-map (kbd "s-f") 'projectile-find-file)
    (define-key projectile-mode-map (kbd "s-s") 'projectile-ag))

  ;; counsel
  (with-eval-after-load 'counsel
    (define-key counsel-mode-map (kbd "M-i") 'counsel-grep-or-swiper)
    (with-eval-after-load 'projectile
      (define-key projectile-mode-map [remap projectile-ag] #'counsel-projectile-ag))

    (advice-add 'counsel-grep-or-swiper :after (lambda (&rest args) (recenter-top-bottom)))
    ;; this doesn't work
    ;; (advice-add 'counsel-projectile-ag :after (lambda (&rest args) (recenter-top-bottom)))
    )

  ;; expand-region
  (global-set-key (kbd "C-=") 'er/expand-region)

  ;; easy-kill
  (with-eval-after-load 'easy-kill
    (global-set-key [remap kill-ring-save] 'easy-mark))

  ;; emacs-lisp
  (with-eval-after-load 'emacs-lisp-mode
    (add-hook 'emacs-lisp-mode 'spacemacs/toggle-aggressive-indent-on))

  (with-eval-after-load 'sbt-mode
    (setq sbt:clear-buffer-before-command nil)

    (defun scala-find-spec-name ()
      "Find spec name of current buffer."
      (concat "*." (file-name-sans-extension (file-name-nondirectory (buffer-name)))))

    (defun sbt-test ()
      "Run test with current file."
      (interactive)
      (sbt-command "test"))

    (defun sbt-test-only ()
      "Run test with current file."
      (interactive)
      (sbt-command (concat "testOnly " (scala-find-spec-name))))

    (defun sbt-test-compile ()
      "Compile project."
      (interactive)
      (sbt-command ";test:compile"))

    (defun sbt-compile-all ()
      "Compile project."
      (interactive)
      (sbt-command ";compile;test:compile")))

  ;; load local machine config (.e.g work machine config). Located at `lisp/local/local.el'
  (use-package local
    :load-path "~/lisp/local"
    :config
    (message "Loaded local config from lisp/local/local.el"))
  )

;; Do not write anything past this comment. This is where Emacs will
;; auto-generate custom variable definitions.
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(ansi-color-names-vector
   ["#d2ceda" "#f2241f" "#67b11d" "#b1951d" "#3a81c3" "#a31db1" "#21b8c7" "#655370"])
 '(custom-safe-themes
   (quote
    ("bffa9739ce0752a37d9b1eee78fc00ba159748f50dc328af4be661484848e476" "fa2b58bb98b62c3b8cf3b6f02f058ef7827a8e497125de0254f56e373abee088" default)))
 '(evil-want-Y-yank-to-eol nil)
 '(package-selected-packages
   (quote
    (origami super-save easy-kill thing-cmds ag insert-shebang fish-mode company-shell helm-themes helm-swoop helm-projectile helm-mode-manager helm-flx helm-descbinds helm-ag ace-jump-helm-line yapfify yaml-mode xterm-color web-mode web-beautify unfill tagedit smeargle slim-mode shell-pop scss-mode sass-mode rvm ruby-tools ruby-test-mode rubocop rspec-mode robe rbenv rake pyvenv pytest pyenv-mode py-isort pug-mode pip-requirements orgit org-projectile org-category-capture org-present org-pomodoro alert log4e gntp org-download ob-elixir noflet mwim multi-term mmm-mode minitest markdown-toc markdown-mode magit-gitflow livid-mode skewer-mode simple-httpd live-py-mode less-css-mode json-mode json-snatcher json-reformat js2-refactor multiple-cursors js2-mode js-doc intero hy-mode htmlize hlint-refactor hindent haskell-snippets haml-mode go-guru go-eldoc gnuplot gitignore-mode gitconfig-mode gitattributes-mode git-timemachine git-messenger git-link gh-md fuzzy flycheck-pos-tip pos-tip flycheck-mix flycheck-haskell flycheck-credo flycheck evil-magit magit magit-popup git-commit with-editor eshell-z eshell-prompt-extras esh-help erlang ensime sbt-mode scala-mode enh-ruby-mode emmet-mode cython-mode company-web web-completion-data company-tern dash-functional tern company-statistics company-go go-mode company-ghci company-ghc ghc haskell-mode company-emacs-eclim eclim company-cabal company-anaconda coffee-mode cmm-mode chruby bundler inf-ruby auto-yasnippet yasnippet anaconda-mode pythonic alchemist company elixir-mode ac-ispell auto-complete ws-butler winum which-key wgrep volatile-highlights vi-tilde-fringe uuidgen use-package toc-org spaceline powerline smex restart-emacs request rainbow-delimiters popwin persp-mode pcre2el paradox spinner org-bullets open-junk-file neotree move-text macrostep lorem-ipsum linum-relative link-hint ivy-hydra info+ indent-guide hydra hungry-delete hl-todo highlight-parentheses highlight-numbers parent-mode highlight-indentation hide-comnt help-fns+ helm-make helm helm-core google-translate golden-ratio flx-ido flx fill-column-indicator fancy-battery eyebrowse expand-region exec-path-from-shell evil-visualstar evil-visual-mark-mode evil-tutor evil-surround evil-search-highlight-persist evil-numbers evil-nerd-commenter evil-mc evil-matchit evil-lisp-state smartparens evil-indent-plus evil-iedit-state iedit evil-exchange evil-escape evil-ediff evil-args evil-anzu anzu evil goto-chg undo-tree eval-sexp-fu highlight elisp-slime-nav dumb-jump popup diminish define-word counsel-projectile projectile pkg-info epl counsel swiper ivy column-enforce-mode clean-aindent-mode bind-map bind-key auto-highlight-symbol auto-compile packed async aggressive-indent adaptive-wrap ace-window ace-link avy org-plus-contrib evil-unimpaired f s dash)))
 '(paradox-github-token t))
(custom-set-faces
 '(company-tooltip-common
   ((t (:inherit company-tooltip :weight bold :underline nil))))
 '(company-tooltip-common-selection
   ((t (:inherit company-tooltip-selection :weight bold :underline nil))))
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
