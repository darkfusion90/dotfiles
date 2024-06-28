WINDOWS_PATH='/mnt/c/Users/<username>'

# Make WSL terminal startup in $HOME since default behavior is to start in $WINDOWS_PATH
if [ "$PWD" = "$WINDOWS_PATH" ]; then
    cd $HOME
fi

function cdwindows() {
    cd "$WINDOWS_PATH"
}

function cpfile() {
    cat "$1" | clip.exe
}

function fixssh() {
    # ref: somewhere in a GitHub issue but I forgot to link it at that time and
    # now I have no idea how I found the solution
    sudo ifconfig eth0 mtu 1350
}

# Source (ofcourse it is copied from the internet): https://superuser.com/a/1602624
function fix_wsl2_interop() {
    for i in $(pstree -np -s $$ | grep -o -E '[0-9]+'); do
        if [[ -e "/run/WSL/${i}_interop" ]]; then
            export WSL_INTEROP=/run/WSL/${i}_interop
        fi
    done
}

alias cls="clear"

function up() {
    levels=${1:-1}

    path='./'
    for i in {1..$levels}; do
        path="$path../"
    done

    cd "$path"
}

# Why -z: https://superuser.com/a/1183338 (TLDR: to avoid the newline after dir name)
alias curdirname='basename -z $(pwd)'

alias python="python3 ${@}"

export PATH=$PATH:~/.local/bin

alias cppwd='pwd | clip.exe'

# Make `cd` from a vscode terminal go to the workspace root instead of WSL root
# Assume the following is in vscode settings:
# "terminal.integrated.env.linux":  {"VSCODE_WS": "${workspaceFolder}"},
# "terminal.integrated.env.windows":{"VSCODE_WS": "${workspaceFolder}"},
# When in filemode / not in a workspace, `VSCODE_WS` is set to the literal
# `${workspaceFolder}` so we check and ignore that
# Credit: https://superuser.com/a/1586795
if [[ -v VSCODE_WORKSPACE_FOLDER ]] && [[ "$VSCODE_WORKSPACE_FOLDER" != '${workspaceFolder}' ]]; then
    alias cd="HOME=\"${VSCODE_WORKSPACE_FOLDER}\" cd"
fi

function getlastpathfromurl() {
    url=$1

    # Get last part of url (https://example.com/abcd -> abcd)
    # Credit: https://unix.stackexchange.com/a/325501
    lastpartdirty=$(basename "$url")
    # Remove query params (all that follows "?")
    # Credit: https://stackoverflow.com/a/4170409
    lastpart=${lastpartdirty%%\?*}
    echo $lastpart
}

# Credit: https://stackoverflow.com/a/49035906
function slugify() {
    echo "$1" | iconv -c -t ascii//TRANSLIT | sed -r s/[~\^]+//g | sed -r s/[^a-zA-Z0-9]+/-/g | sed -r s/^-+\|-+$//g | tr A-Z a-z
}

alias untargz="tar xvzf ${@}"
