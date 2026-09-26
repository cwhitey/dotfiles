# Dotfiles

These dotfiles can be linked with the Babashka linker:

```sh
bb link --dry-run
bb link
```

Link definitions live in `link.config.edn`; the implementation is in `.link/`.
Run `bb link --help` for options; `./.link/link.clj` can also be invoked directly.
Run the local linker tests with `bb .link/tests/link-results-tests.clj`, or the
container tests with `bb .link/tests/run.clj`.

The legacy `./install` entry point still uses Dotbot.

## Zsh setup

After installing Homebrew and Babashka and initialising `brew shellenv`:

```sh
brew install zimfw fzf pure eza
bb link
bb shell:install
```

Open a new terminal after setup. The full machine dependency list is in
`osx/Brewfile`; the command above installs only the shell's plugin manager,
fuzzy finder, prompt and directory preview tool.

Plugins are declared in `zsh/antibody/.zimrc` (linked to `~/.zimrc`). The
historical directory name is retained so existing shell symlinks keep working.
Edit that list to add or remove plugins, then open a new terminal: Zim installs
missing modules and regenerates its loader when the list changes. Downloads and
generated files live in `~/.zim`, outside the repository.

Run these tasks from the repository:

```sh
bb tasks          # Show available tasks
bb link           # Link dotfiles and clean broken links
bb shell:install  # Install missing plugins and regenerate the loader
bb shell:update   # Update plugins and regenerate the loader
```

Homebrew manages Zim itself (`brew upgrade zimfw`). Existing Antidote caches
are no longer used. Your aliases, keybindings and Homebrew Pure prompt remain
in use. Other tool integrations in `.zshrc`, such as fnm and SDKMAN, still need
their respective tools installed.

## Dependencies

### general
- dotbot config mananger (`brew install dotbot`)

### zsh
- Zim zsh plugin manager
    - See Zsh setup above.
- pure prompt 
    - `brew install pure`
- emacs
    - `brew tap railwaycat/emacsmacport`
    - `brew install emacs-mac --with-modules`
- doom emacs
    - Instructions here: https://github.com/doomemacs/doomemacs/blob/master/docs/getting_started.org
- source-highlight
    - `brew install source-highlight`
- fasd
    - no longer available via. Homebrew. Run the following: 
    - `git clone https://github.com/whjvenyl/fasd.git`
    - `sudo make install`
- fzf (completion)
    - `brew install fzf`
- the_silver_surfer
    - `brew install ag`

## TODO
- Use Stow
