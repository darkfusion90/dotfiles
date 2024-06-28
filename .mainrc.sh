export $DOTFILES=$HOME/.customsh

source $DOTFILE/.miscrc.sh
source $DOTFILES/work/clickup/.clickuprc.sh

# https://github.com/shyiko/jabba
[ -s "$JABBA_HOME/jabba.sh" ] && source "$JABBA_HOME/jabba.sh"
