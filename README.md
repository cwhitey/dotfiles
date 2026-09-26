# Dotfiles

These dotfiles can be linked with the Babashka linker:

```sh
bb link --dry-run
bb link
```

Link definitions live in `link.config.edn`; the implementation is in `link/`.
Run `bb link --help` for options; `./link/link.clj` can also be invoked directly.
Run the local linker tests with `bb link/tests/link-results-tests.clj`, or the
container tests with `bb link/tests/run.clj`.

## New-machine setup

Install Homebrew and Babashka manually, then initialise Homebrew's shell
environment. From this repository, run:

```sh
bb setup
```

`bb setup` installs the full [Brewfile](modules/osx/Brewfile), links dotfiles, and
installs Zim plugins. It includes command-line tools, applications, and VS Code
extensions. Use `bb deps` to install only the Brewfile profile.

Plugins are declared in `modules/zsh/.zimrc` (linked to `~/.zimrc`). Edit that
list to add or remove plugins, then open a new terminal: Zim installs missing
modules and regenerates its loader when the list changes. Downloads and generated
files live in `~/.zim`, outside the repository.

Run these tasks from the repository:

```sh
bb tasks          # Show available tasks
bb link           # Link dotfiles and clean broken links
bb deps           # Install the Homebrew profile
bb setup          # Install dependencies, link files, and install Zsh plugins
bb shell:install  # Install missing plugins and regenerate the loader
bb shell:update   # Update plugins and regenerate the loader
```

Homebrew manages Zim itself (`brew upgrade zimfw`). Existing Antidote caches
are no longer used. Your aliases, keybindings and Homebrew Pure prompt remain
in use. Other tool integrations in `.zshrc`, such as fnm and SDKMAN, still need
their respective tools installed.

Use the supported `glow` command for terminal Markdown viewing; it is included
in the Brewfile.

## Dependencies

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
