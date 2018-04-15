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

     ;; osx

     ;; Basics
     ivy
     (auto-completion :variables
                      auto-completion-enable-snippets-in-popup t)
     (better-defaults :variables
                      better-defaults-move-to-end-of-code-first t)
     emacs-lisp
     syntax-checking
     themes-megapack

     ;; Tools
     shell
     (git :variables
          git-magit-status-fullscreen t
          git-gutter-use-fringe t)
     github

     ;; Languages
     clojure
     haskell
     (scala :variables
            scala-indent:default-run-on-strategy 'reluctant
            scala-indent:align-parameters nil
            scala-indent:align-forms nil)
     elixir
     erlang
     python
     go
     shell-scripts
     csv
     sql

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
     docker
     )
   ;; List of additional packages that will be installed without being
   ;; wrapped in a layer. If you need some configuration for these
   ;; packages, then consider creating a layer. You can also put the
   ;; configuration in `dotspacemacs/user-config'.
   dotspacemacs-additional-packages '(
                                      ergoemacs-mode
                                      ag
                                      easy-kill
                                      super-save
                                      key-chord
                                      crux
                                      )
   ;; A list of packages that cannot be updated.
   dotspacemacs-frozen-packages '()
   ;; A list of packages that will not be installed and loaded.
   dotspacemacs-excluded-packages '(highlight-parentheses)
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
   dotspacemacs-startup-banner nil
   dotspacemacs-startup-lists '((recents . 10)
                                (projects . 7))
   dotspacemacs-scratch-mode 'emacs-lisp-mode
   dotspacemacs-themes '(monokai
                         ample-flat
                         sanityinc-solarized-dark
                         spacemacs-dark
                         spacemacs-light)
   dotspacemacs-colorize-cursor-according-to-state t
   dotspacemacs-default-font '("mononoki"
                               :size 16
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
   dotspacemacs-fullscreen-at-startup nil
   dotspacemacs-fullscreen-use-non-native nil
   dotspacemacs-maximized-at-startup t
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
   dotspacemacs-whitespace-cleanup 'changed)

  ;;(add-to-list 'configuration-layer--elpa-archives '("melpa-stable" . "http://stable.melpa.org/packages/"))
  ;;(add-to-list 'package-pinned-packages '(cider . "melpa-stable") t)
  )

(defun dotspacemacs/user-init ()
  "Initialization function for user code.
It is called immediately after `dotspacemacs/init', before layer configuration
executes.
 This function is mostly useful for variables that need to be set
before packages are loaded. If you are unsure, you should try in setting them in
`dotspacemacs/user-config' first."
  )

(defun dotspacemacs/user-config ()
  "Configuration function for user code.
This function is called at the very end of Spacemacs initialization after
layers configuration.
This is the place where most of your configurations should be done. Unless it is
explicitly specified that a variable should be set before a package is loaded,
you should place your code here."

  (setq-default key-chord-two-keys-delay 0.1
                ;; cursor-type 'bar
                ;; default-cursor-type 'bar
                )

  (setq mac-option-modifier  'meta
        mac-command-modifier 'super)
  ;;(setq mouse-wheel-scroll-amount '(2 ((shift) . 1))) ;; two lines at a time
  ;;(setq mouse-wheel-progressive-speed nil) ;; don't accelerate scrolling
  ;;(setq mouse-wheel-follow-mouse 't) ;; scroll window under mouse

  (setq
   ;; cursor-type 'bar
   ;; default-cursor-type 'bar
   frame-title-format '("%b")
   exec-path-from-shell-check-startup-files nil
   echo-keystrokes 0.1
   minibuffer-message-timeout 0.5
   enable-recursive-minibuffers t
   ;; tweak mouse scrolling
   mouse-wheel-scroll-amount '(2 ((shift) . 1))
   ;; mouse-wheel-scroll-amount '(2 ((shift) . 3) ((control) . nil)) ;; two lines at a time
   mouse-wheel-progressive-speed nil ;; don't accelerate scroll-ing
   mouse-wheel-follow-mouse 't
   ;;super-save-auto-save-when-idle t
   auto-save-default nil
   undo-tree-enable-undo-in-region nil
   ivy-height 16
   ivy-extra-directories nil
   ivy-initial-inputs-alist nil
   ivy-re-builders-alist '((t . (lambda (str) (ivy--regex str 1))))
   counsel-yank-pop-separator (propertize "\n------------------------------\n" 'face 'error)
   company-minimum-prefix-length 2
   scala-use-unicode-arrows nil
   ensime-startup-notification nil
   ensime-startup-snapshot-notification nil
   )

  ;; minibuffer
  (minibuffer-depth-indicate-mode 1)

  ;; enable modes
  (super-save-mode +1)
  (key-chord-mode t)

  ;; diminish
  (spacemacs|diminish company-mode)
  (spacemacs|diminish which-key-mode)
  (spacemacs|diminish holy-mode)
  (spacemacs|diminish super-save-mode)

  ;; general keybindings
  (global-unset-key (kbd "C-x C-b")) ;; unset annoying primitive buffer list key
  (global-set-key (kbd "C-x C-b") 'ivy-switch-buffer)
  (global-set-key (kbd "C-=") 'er/expand-region)
  (global-set-key (kbd "C--") 'er/contract-region)
  ;; (global-set-key (kbd "M-S-g") 'goto-line)
  (global-set-key (kbd "<C-S-backspace>") 'delete-indentation)
  (global-set-key (kbd "C-S-k") 'crux-kill-whole-line)
  (global-set-key (kbd "C-s") 'isearch-forward)

  ;; key chords
  (key-chord-define-global "xx" 'execute-extended-command)
  (key-chord-define-global "yy" 'yank-pop)
  (key-chord-define-global "jj" 'dumb-jump-go)

  ;; yasnippet
  (define-key yas-minor-mode-map (kbd "M-m i s") 'yas-insert-snippet)

  ;; smartparens
  (sp-use-paredit-bindings)

  ;; make typed text replace a region
  (define-globalized-minor-mode global-delete-selection-mode delete-selection-mode delete-selection-mode)
  (global-delete-selection-mode 1)

  ;; ivy
  (with-eval-after-load 'ivy
    (define-key ivy-mode-map (kbd "C-x C-r") 'ivy-resume))

  ;; counsel
  (with-eval-after-load 'counsel
    (define-key counsel-mode-map (kbd "M-i") 'counsel-grep-or-swiper)
    (define-key counsel-mode-map (kbd "M-I") 'spacemacs/swiper-region-or-symbol)
    (define-key counsel-mode-map (kbd "C-c r") 'counsel-recentf)
    (define-key counsel-mode-map (kbd "s-S") 'counsel-git-grep)
    (with-eval-after-load 'projectile
      (define-key projectile-mode-map (kbd "s-f") #'counsel-projectile-find-file)
      (define-key projectile-mode-map (kbd "s-s") #'counsel-projectile-ag)
      (advice-add 'counsel-projectile-ag :after (lambda (&rest args) (recenter-top-bottom))))
    (advice-add 'counsel-grep-or-swiper :after (lambda (&rest args) (recenter-top-bottom))))

  ;; company
  (with-eval-after-load 'company
    ;; unbind any emacs editing bindings
    (define-key company-active-map (kbd "C-/") nil)
    (define-key company-active-map (kbd "C-d") nil))
  ;; easy-kill
  (with-eval-after-load 'easy-kill
    (global-set-key [remap kill-ring-save] 'easy-mark))

  ;; emacs-lisp
  (add-hook 'emacs-lisp-mode 'spacemacs/toggle-aggressive-indent-on)
  (add-hook 'emacs-lisp-mode 'spacemacs/toggle-smartparens-on)

  ;; clojure
  (add-hook 'cider-repl-mode-hook 'rainbow-delimiters-mode)

  ;; scala
  (with-eval-after-load 'sbt-mode
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
      (sbt-command ";compile;test:compile"))

    (define-key scala-mode-map (kbd "C-c C-s t") #'sbt-test)
    (define-key scala-mode-map (kbd "C-c C-s o") #'sbt-test-only)
    (define-key scala-mode-map (kbd "C-c C-s c") #'sbt-test-compile)
    (define-key scala-mode-map (kbd "C-c C-s C") #'sbt-compile-all))

  (load-local))

(defun load-local ()
  "Load local machine config (.e.g work machine config)
located at `lisp/local/local.el'"
  (if (file-exists-p "~/lisp/local/local.el")
      (use-package local
        :load-path "~/lisp/local"
        :catch nil ;ignore errors when loading
        :config
        (message "Loading local config from lisp/local/local.el"))))

;; some example snippets for local:
;; (eval-after-load "git-link"
;;   '(progn
;;      (add-to-list 'git-link-remote-alist
;;                   '("git.my-company.com.au" git-link-github))
;;      (add-to-list 'git-link-commit-remote-alist
;;                   '("git.my-company.com.au" git-link-commit-github))))


;; Do not write anything past this comment. This is where Emacs will
;; auto-generate custom variable definitions.
(defun dotspacemacs/emacs-custom-settings ()
  "Emacs custom settings.
This is an auto-generated function, do not modify its content directly, use
Emacs customize menu instead.
This function is called at the very end of Spacemacs initialization."
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (docker tablist docker-tramp midje-mode magit-gh-pulls github-search github-clone github-browse-file gist gh marshal logito pcache ht csv-mode sql-indent yapfify yaml-mode xterm-color ws-butler winum which-key wgrep web-mode web-beautify volatile-highlights vi-tilde-fringe uuidgen use-package unfill toc-org tagedit super-save spaceline powerline smex smeargle slim-mode shell-pop scss-mode sass-mode rvm ruby-tools ruby-test-mode rubocop rspec-mode robe restart-emacs request rbenv rake rainbow-delimiters pyvenv pytest pyenv-mode py-isort pug-mode popwin pip-requirements persp-mode pcre2el paradox origami orgit org-projectile org-category-capture org-present org-pomodoro alert log4e gntp org-mime org-download org-bullets open-junk-file ob-elixir org-plus-contrib noflet neotree mwim multi-term move-text mmm-mode minitest markdown-toc markdown-mode magit-gitflow macrostep lorem-ipsum livid-mode skewer-mode simple-httpd live-py-mode linum-relative link-hint less-css-mode key-chord json-mode json-snatcher json-reformat js2-refactor js2-mode js-doc ivy-hydra intero insert-shebang indent-guide hy-mode hungry-delete htmlize hlint-refactor hl-todo hindent highlight-parentheses highlight-numbers parent-mode highlight-indentation helm-make helm helm-core haskell-snippets haml-mode google-translate golden-ratio go-guru go-eldoc gnuplot gitignore-mode gitconfig-mode gitattributes-mode git-timemachine git-messenger git-link gh-md fuzzy flycheck-pos-tip pos-tip flycheck-mix flycheck-haskell flycheck-credo flycheck flx-ido flx fish-mode fill-column-indicator fancy-battery eyebrowse expand-region exec-path-from-shell evil-visualstar evil-visual-mark-mode evil-unimpaired evil-tutor evil-surround evil-search-highlight-persist evil-numbers evil-nerd-commenter evil-mc evil-matchit evil-magit magit magit-popup git-commit ghub let-alist with-editor evil-lisp-state smartparens evil-indent-plus evil-iedit-state iedit evil-exchange evil-escape evil-ediff evil-args evil-anzu anzu evil goto-chg eshell-z eshell-prompt-extras esh-help erlang ergoemacs-mode undo-tree ensime sbt-mode scala-mode enh-ruby-mode emmet-mode elisp-slime-nav easy-kill dumb-jump diminish define-word cython-mode crux counsel-projectile projectile counsel swiper ivy company-web web-completion-data company-tern dash-functional tern company-statistics company-shell company-go go-mode company-ghci company-ghc ghc haskell-mode company-cabal company-anaconda column-enforce-mode coffee-mode cmm-mode clojure-snippets clj-refactor hydra inflections edn multiple-cursors paredit peg clean-aindent-mode cider-eval-sexp-fu eval-sexp-fu highlight cider seq spinner queue clojure-mode chruby bundler inf-ruby bind-map bind-key auto-yasnippet yasnippet auto-highlight-symbol auto-compile packed async anaconda-mode pythonic f alchemist company elixir-mode pkg-info epl aggressive-indent ag s dash adaptive-wrap ace-window ace-link avy ac-ispell auto-complete popup)))
 '(paradox-github-token t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (midje-mode magit-gh-pulls github-search github-clone github-browse-file gist gh marshal logito pcache ht csv-mode sql-indent yapfify yaml-mode xterm-color ws-butler winum which-key wgrep web-mode web-beautify volatile-highlights vi-tilde-fringe uuidgen use-package unfill toc-org tagedit super-save spaceline powerline smex smeargle slim-mode shell-pop scss-mode sass-mode rvm ruby-tools ruby-test-mode rubocop rspec-mode robe restart-emacs request rbenv rake rainbow-delimiters pyvenv pytest pyenv-mode py-isort pug-mode popwin pip-requirements persp-mode pcre2el paradox origami orgit org-projectile org-category-capture org-present org-pomodoro alert log4e gntp org-mime org-download org-bullets open-junk-file ob-elixir org-plus-contrib noflet neotree mwim multi-term move-text mmm-mode minitest markdown-toc markdown-mode magit-gitflow macrostep lorem-ipsum livid-mode skewer-mode simple-httpd live-py-mode linum-relative link-hint less-css-mode key-chord json-mode json-snatcher json-reformat js2-refactor js2-mode js-doc ivy-hydra intero insert-shebang indent-guide hy-mode hungry-delete htmlize hlint-refactor hl-todo hindent highlight-parentheses highlight-numbers parent-mode highlight-indentation helm-make helm helm-core haskell-snippets haml-mode google-translate golden-ratio go-guru go-eldoc gnuplot gitignore-mode gitconfig-mode gitattributes-mode git-timemachine git-messenger git-link gh-md fuzzy flycheck-pos-tip pos-tip flycheck-mix flycheck-haskell flycheck-credo flycheck flx-ido flx fish-mode fill-column-indicator fancy-battery eyebrowse expand-region exec-path-from-shell evil-visualstar evil-visual-mark-mode evil-unimpaired evil-tutor evil-surround evil-search-highlight-persist evil-numbers evil-nerd-commenter evil-mc evil-matchit evil-magit magit magit-popup git-commit ghub let-alist with-editor evil-lisp-state smartparens evil-indent-plus evil-iedit-state iedit evil-exchange evil-escape evil-ediff evil-args evil-anzu anzu evil goto-chg eshell-z eshell-prompt-extras esh-help erlang ergoemacs-mode undo-tree ensime sbt-mode scala-mode enh-ruby-mode emmet-mode elisp-slime-nav easy-kill dumb-jump diminish define-word cython-mode crux counsel-projectile projectile counsel swiper ivy company-web web-completion-data company-tern dash-functional tern company-statistics company-shell company-go go-mode company-ghci company-ghc ghc haskell-mode company-cabal company-anaconda column-enforce-mode coffee-mode cmm-mode clojure-snippets clj-refactor hydra inflections edn multiple-cursors paredit peg clean-aindent-mode cider-eval-sexp-fu eval-sexp-fu highlight cider seq spinner queue clojure-mode chruby bundler inf-ruby bind-map bind-key auto-yasnippet yasnippet auto-highlight-symbol auto-compile packed async anaconda-mode pythonic f alchemist company elixir-mode pkg-info epl aggressive-indent ag s dash adaptive-wrap ace-window ace-link avy ac-ispell auto-complete popup)))
 '(paradox-github-token t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
