# Use `hub` as our git wrapper:
#   http://defunkt.github.com/hub/
hub_path=$(which hub)
if (( $+commands[hub] ))
then
  alias git=$hub_path
fi

# The rest of my fun git aliases
alias gl='git pull --prune'
alias gp='git push origin HEAD'
alias ga='git add'
alias gc='git commit'
alias gco='git checkout'
alias gcb='git copy-branch-name'
alias gb='git branch'
alias gst='git status -sb' # upgrade your git if -sb breaks for you. it's fun.
alias gac='git add -A && git commit -m'
alias ge='git-edit-new'

# View abbreviated SHA, description, and history graph of the latest commits
alias glog="git log --graph --pretty=format:'%Cred%h%Creset %an: %s - %Creset %C(yellow)%d%Creset %Cgreen(%cr)%Creset' --abbrev-commit --date=relative"

# Remove `+` and `-` from start of diff lines; just rely upon color.
alias gd='git diff --color | sed "s/^\([^-+ ]*\)[-+ ]/\\1/" | less -r'

# Commit all changes
alias gca="git add -A && git commit -av"

# Switch to a branch, creating it if necessary
ggo() { git checkout -b $1 2> /dev/null || git checkout $1; }

# Show verbose output about tags, branches or remotes
alias gtags="git tag -l"
alias gbranches="git branch -a"
alias gremotes="git remote -v"

# List aliases
alias galiases="git config --get-regexp alias"

# Amend the currently staged files to the latest commit
alias gamend="git commit --amend --reuse-message=HEAD"

# Credit an author on the latest commit
gcredit() { git commit --amend --author \"$1 <$2>\" -C HEAD; }

# Interactive rebase with the given number of latest commits
greb() { git rebase -i HEAD~$1; }

# Remove the old tag with this name and tag the latest commit with it.
gretag() { git tag -d $1 && git push origin :refs/tags/$1 && git tag $1; }

# Find branches containing commit
gfb() { git branch -a --contains $1; }

# Find tags containing commit
gft() { git describe --always --contains $1; }

# Find commits by source code
gfc() { git log --pretty=format:'%C(yellow)%h  %Cblue%ad  %Creset%s%Cgreen  [%cn] %Cred%d' --decorate --date=short -S$1; }

# Find commits by commit message
gfm() { git log --pretty=format:'%C(yellow)%h  %Cblue%ad  %Creset%s%Cgreen  [%cn] %Cred%d' --decorate --date=short --grep=$1; }

# Remove branches that have already been merged with master
# a.k.a. ‘delete merged’
alias gdm="!git branch --merged | grep -v '\\*' | xargs -n 1 git branch -d"

# List contributors with number of commits
alias gcontributors="git shortlog --summary --numbered"

# Merge GitHub pull request on top of the current branch or,
# if a branch name is specified, on top of the specified branch
gmpr() { \
	declare currentBranch=\"$(git symbolic-ref --short HEAD)\"; \
	declare branch=\"${2:-$currentBranch}\"; \
	if [ $(printf \"%s\" \"$1\" | grep '^[0-9]\\+$' > /dev/null; printf $?) -eq 0 ]; then \
		git fetch origin refs/pull/$1/head:pr/$1 && \
		git checkout -B $branch && \
		git rebase $branch pr/$1 && \
		git checkout -B $branch && \
		git merge pr/$1 && \
		git branch -D pr/$1 && \
		git commit --amend -m \"$(git log -1 --pretty=%B)\n\nCloses #$1.\"; \
	fi \
}

# Show the user email for the current repository.
alias gwhoami="git config user.email"   
