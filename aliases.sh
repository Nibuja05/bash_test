# Some good standards, which are not used if the user
# creates his/her own .bashrc/.bash_profile

# --show-control-chars: help showing Korean or accented characters
alias ls='ls -F --color=auto --show-control-chars'
alias ll='ls -l'
alias gitcom="git log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold cyan)%aD%C(reset) %C(bold green)(%ar)%C(reset)%C(bold yellow)%d%C(reset)%n'' %C(white)%s%C(reset) %C(dim white)- %an%C(reset)' --all"

# custom aliases
alias cls='printf "\033c"'

# custom git additions

MAIN=""

alias g='git'
alias gs='git status'
alias ga='git add .'
alias gc='git commit -m'
alias gp='git push'
alias gpu='git pull'
alias gpup='git push --set-upstream origin'
alias gm='git merge'
alias cont='git merge --continue'
alias update='git fetch origin'

alias lg1="g log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)' --all"
alias lg2="g log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold cyan)%aD%C(reset) %C(bold green)(%ar)%C(reset)%C(bold yellow)%d%C(reset)%n''          %C(white)%s%C(reset) %C(dim white)- %an%C(reset)' --all"
alias log="lg2"

switch () {
	git stash && git checkout $1
}

master () {
	__setmainbranch
	switch $MAIN
}

newbranch () {
	git checkout -b "$1" && gpup "$1"
}

newmasterbranch () {
	__setmainbranch
	switch $MAIN
	newbranch $1
}

mergemaster () {
	__setmainbranch
	update
	BRANCH=$(curbranch)
	switch $MAIN
	gpu
	switch $BRANCH
	gm $MAIN
}

__setmainbranch () {
	if [ "$MAIN" = "" ]; then
		MAIN=$(git remote show origin | grep 'HEAD branch' | cut -d' ' -f5)
	fi
}

curbranch () {
	echo $(git rev-parse --abbrev-ref HEAD)
}

prfixes () {
	C_NAME="PR fixes"
	if [ "$1" != "" ]; then
		C_NAME=$1
	fi
	ga && gc "$C_NAME" && gp
}

case "$TERM" in
xterm*)
	# The following programs are known to require a Win32 Console
	# for interactive usage, therefore let's launch them through winpty
	# when run inside `mintty`.
	for name in node ipython php php5 psql python2.7
	do
		case "$(type -p "$name".exe 2>/dev/null)" in
		''|/usr/bin/*) continue;;
		esac
		alias $name="winpty $name.exe"
	done
	;;
esac
