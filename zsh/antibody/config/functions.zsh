## ls after cd (auto)
# function chpwd() {
#   emulate -L zsh
#   ls -la
# }

function debug_zsh_config() {
    ## -i Force shell to be interactive
    ## -x Set XTRACE option
    ## -c Take the first argument as a command to execute rather than reading from scripts or standard input
    zsh -i -x -c exit
}
