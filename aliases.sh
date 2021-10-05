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

pushchanges () {
	C_NAME="update"
	if [ "$1" != "" ]; then
		C_NAME=$1
	fi
	ga && gc "$C_NAME" && gp
}

ghelp () {
	echo -e "\033[96mCustom Git Commands Help \033[0m"
	echo -e "\n\033[42;30m g \033[0m as alias for all \033[4mgit\033[0m commands\n"
	echo -e "\033[42;30m gs \033[0m       \033[4mgit status\033[0m"
	echo -e "\033[42;30m gc \033[0m       \033[4mgit commit -m\033[0m [COMMIT_MSG]"
	echo -e "\033[42;30m gp \033[0m       \033[4mgit push\033[0m"
	echo -e "\033[42;30m gpup \033[0m     \033[4mgit push --set-upstream origin\033[0m"
	echo -e "\033[42;30m gu \033[0m       \033[4mgit pull\033[0m"
	echo -e "\033[42;30m gm \033[0m       \033[4mgit merge\033[0m"
	echo -e "\033[42;30m cont \033[0m     \033[4mgit merge --continue\033[0m"
	echo -e "\033[42;30m update \033[0m   \033[4mgit fetch origin\033[0m"
	echo ""
	echo -e "\033[42;30m switch \033[0m + [BRANCH_NAME]            switch to a different branch"
	echo -e "\033[42;30m master \033[0m                            switch to the main branch"
	echo -e "\033[42;30m newbranch \033[0m + [BRANCH_NAME]         create a new branch and push it"
	echo -e "\033[42;30m newmasterbranch \033[0m + [BRANCH_NAME]   create a new branch (from master)"
	echo "                                    and push it"
	echo -e "\033[42;30m mergemaster \033[0m                       update branch from master"
	echo -e "\033[42;30m curbranch \033[0m                         print current branch name"
	echo -e "\033[42;30m prfixes \033[0m + [COMMIG_MSG]            add, commit and push changes"
	echo "                                    defaults to 'PR fixes'"
	echo -e "\033[42;30m pushchanges \033[0m + [COMMIG_MSG]        add, commit and push changes"
	echo "                                    defaults to 'update'"
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
