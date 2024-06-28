alias gbcurr='git branch --show-current'

alias gpup='git push --set-upstream origin $(gbcurr)'

alias glastcommit='git log -1 --pretty=format:"%h %s"'

alias gcrb='gcb $(gbcurr)-rb'

# https://github.com/typicode/husky/issues/447#issuecomment-499144972
alias grbi='HUSKY_SKIP_HOOKS=1 git rebase -i ${@}'

function ghclone() {
  user=$1
  repo=$2
  shift 2
  git clone "https://github.com/${user}/${repo}.git" "$@"
}

function gbbranchdiff() {
  branch1=$1
  branch2=$2
  git rev-list --left-right --count $branch1...$branch2
}

# Ref: https://stackoverflow.com/a/692763
alias rbreset="grhh ORIG_HEAD"

alias gbresetorig='grhh origin/$(gbcurr)'

# Open branch in github
function ghopen() {
  # NOTE: Only supports a single remote
  # NOTE: Doesn't support ssh remotes. Only https
  branchname=${1-$(gbcurr)}

  # What is NR: https://stackoverflow.com/a/22190928
  # Getting just the first line from the git remote output
  # The first line of remote is the "fetch" remote reference. The 2nd one is "push"
  # Taking the "fetch" reference for convinience. Either way, for me, both fetch and
  # push remotes are same for this use-case since I need to do neither of them.
  remotebaseurl=$(git remote -v | awk 'NR==1{print $2}')

  # The remote url in the git remote list ends with a ".git"
  # Need to remove that so that it functions like a proper URL that a browser can open
  # Thanks to: https://stackoverflow.com/a/61294531
  remotebaseurlwithoutdotgit=${remotebaseurl%.git}

  fullremoteurlwithbranch=$remotebaseurlwithoutdotgit/tree/$branchname

  # TODO: better to open the current working directory instead
  # find the relative path by finding nearest .git directory
  filepath=${2-""}
  fullremoteurlwithbranchandfilepath=$fullremoteurlwithbranch/$filepath

  xdg-open $fullremoteurlwithbranchandfilepath

  # WOW this worked lol. Wasn't expecting it to. Nice!
}

function gcbtmp() {
  prefix=${1-"tmp"}

  gcb $prefix-$(date +"%Y%m%d_%H%M%S")
}

function gbpr() {
  : ${1?"Usage: $0 ARGUMENT"}
  pr_number=${1}

  pr_branch_name=$(gh pr view $pr_number --json headRefName -q ".headRefName")

  echo $pr_branch_name
}

function gcopr() {
  : ${1?"Usage: $0 ARGUMENT"}

  pr_number=${1}
  pr_branch_name=$(gbpr $pr_number)

  gco $pr_branch_name
}

function grbipr() {
  : ${1?"Usage: $0 ARGUMENT"}

  pr_number=${1}
  pr_branch_name=$(gbpr $pr_number)

  echo $pr_branch_name

  grbi $pr_branch_name
}

function gcbbck() {
  gcbtmp $(gbcurr)-backup
}
