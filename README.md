# Dotfiles

These dotfiles use dotbot for linkage.

- First run `git submodule --update --init`
- `./install`

## Dependencies

### general
- dotbot config mananger (`brew install dotbot`)

### zsh
- antidote zsh plugin manager 
    - `brew install antidote`
    - `antidote load zsh/antidote/antidote-packages.txt`
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
