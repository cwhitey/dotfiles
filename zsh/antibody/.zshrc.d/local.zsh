# Emacs
export PATH="/usr/local/Cellar/emacs/24.5/bin:$PATH"
# Scala
export SCALA_PATH=/usr/local/Cellar/scala/2.11.8
SBT_OPTS="-Xms512M -Xmx1536M -Xss1M -XX:+CMSClassUnloadingEnabled -XX:MaxPermSize=256M"

## REA
export REA_LDAP_USER="callum.white"

# Commands: auth, session
source ~/projects/rca/saml-aws-functions/bash-functions
source ~/.aws-shortcuts/aws-shortcuts.sh
alias auth=authenticate
alias pseeker_db="mysql -hpseeker-replica.listings-prod.realestate.com.au -ureadonly -p PSeeker --password='devR3@donly'"

# Java setup (SLOW)
#export PATH="$HOME/.jenv/bin:$PATH"
#eval "$(jenv init -)"

# NVM setup (SLOW)
#export NVM_DIR="/Users/callum.white/.nvm"
#[ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"  # This loads nvm
