clear && ~/.i3/info

#{{{ git prompt

. /home/pheonix/.git-prompt.bash

precmd() {
    echo `git_prompt_precmd`
}

#}}}

#{{{ HISTORY CLEANUP

# remove duplicates while preserving input order
function dedup {
   awk '! x[$0]++' $@
}

# removes $HISTIGNORE commands from input
function remove_histignore {
   if [ -n "$HISTIGNORE" ]; then
      # replace : with |, then * with .*
      local IGNORE_PAT=`echo "$HISTIGNORE" | sed s/\:/\|/g | sed s/\*/\.\*/g`
      # negated grep removes matches
      grep -vx "$IGNORE_PAT" $@
   else
      cat $@
   fi
}

# clean up the history file by remove duplicates and commands matching
# $HISTIGNORE entries
function history_cleanup {
   local HISTFILE_SRC=~/.bash_history
   local HISTFILE_DST=/tmp/.$USER.bash_history.clean
   if [ -f $HISTFILE_SRC ]; then
      \cp $HISTFILE_SRC $HISTFILE_SRC.backup
      dedup $HISTFILE_SRC | remove_histignore >| $HISTFILE_DST
      \mv $HISTFILE_DST $HISTFILE_SRC
      chmod go-r $HISTFILE_SRC
      history -c
      history -r
   fi
}

#}}}

#{{{ Git Commands

alias gpl='git pull'
alias gcl='git clone'
alias ga='git add'
alias gc='git commit -m'
alias gp='git push'
alias gr='git rm'
alias grd='git rm -r'

#{{{ Basic Commands

alias cdl="cdls"
alias ..="cdl .."
alias ...="cdl ../.."
alias ....="cdl ../../.."
alias ~="cd ~ && source ~/.bashrc"
alias top="vtop --theme wizard"
alias histcln="$(history_cleanup)"

alias sZ='source ~/.bashrc'
alias eZ='vim ~/.bashrc'
alias e3='vim ~/.config/i3/config'
alias eC='vim ~/.conkyrc'
alias eCC='vim ~/.conkyrc2'

alias l='ls --color'
alias la='ls -a --color'

alias yt='youtube-dl'
alias ytm='youtube-dl --extract-audio --audio-format mp3'

alias rmd='rm -r'
alias srm='sudo rm'
alias srmd='sudo rm -r'
alias cpd='cp -R'
alias scp='sudo cp'
alias scpd='sudo cp -R'

alias lin='sudo ln -s'

alias tre='tree -aIC'
alias panes='sh ~/.config/color-scripts/color-scripts/panes'

#}}}

#{{{ Package management

alias ins='sudo emerge -v'
alias inp='sudo emerge -vp'
alias ind='sudo emerge --ask --depclean'
alias inu='sudo emerge --unmerge'
alias cln='sudo emerge --ask --depclean'

alias unmsk='sudo emerge --autounmask-write'
alias keych='sudo etc-update'

alias f='eix'

alias pumask='sudo vim /etc/portage/package.unmask/custom'
alias pmask='sudo vim /etc/portage/package.mask/custom'
alias puse='sudo vim /etc/portage/package.use/custom'
alias pkey='sudo vim /etc/portage/package.keywords/custom'
alias vworld='sudo vim /var/lib/portage/world'

alias eqf='equery f'
alias equ='equery u'
alias eqh='equery h'
alias eqa='equery a'
alias eqb='equery b'
alias eql='equery l'
alias eqd='equery d'
alias eqg='equery g'
alias eqc='equery c'
alias eqk='equery k'
alias eqm='equery m'
alias eqy='equery y'
alias eqs='equery s'
alias eqw='equery w'

#}}}

HISTSIZE=5000
HISTFILESIZE=10000
shopt -s histappend
export HISTCONTROL=ignoreboth:erasedups   # no duplicate entries
bind "set completion-ignore-case on" # note: bind used instead of sticking these in .inputrc
bind "set bell-style none" # no bell
bind "set show-all-if-ambiguous On" # show list automatically, without double tab

#{{{ SSH

alias serv='ssh brad@192.168.1.5'

#}}}

SELECT(){
	if [ "$?" -eq 0 ]
    then
		echo ""
	else 
		echo "[X]"
fi
}

COLOR_BLACK="\[$(tput setaf 0)\]"
COLOR_RED="\[$(tput setaf 1)\]"
COLOR_GREEN="\[$(tput setaf 2)\]"
COLOR_YELLOW="\[$(tput setaf 3)\]"
COLOR_BLUE="\[$(tput setaf 4)\]"
COLOR_PURPLE="\[$(tput setaf 5)\]"
COLOR_CYAN="\[$(tput setaf 6)\]"
COLOR_WHITE="\[$(tput setaf 7)\]"
COLOR_RESET="\[$(tput sgr0)\]"


PS1="${COLOR_CYAN}┌─${COLOR_RED}\$(SELECT)${COLOR_CYAN}[${COLOR_RESET}\\w${COLOR_CYAN}]-[${COLOR_RESET}\\@${COLOR_CYAN}]${COLOR_PURPLE}\$(precmd)
${COLOR_CYAN}└─[${COLOR_YELLOW}::${COLOR_CYAN}]${COLOR_RESET} "

mkcd() {
        if [ $# != 1 ]; then
                echo "Usage: mkcd <dir>"
        else
                mkdir -p $1 && cd $1
        fi
}
cdls() { 
	cd "$@" && l; 
}

rd(){
    pwd > "$HOME/.lastdir_$1"
}

crd(){
        lastdir="$(cat "$HOME/.lastdir_$1")">/dev/null 2>&1
        if [ -d "$lastdir" ]; then
                cd "$lastdir"
        else
                echo "no existing directory stored in buffer $1">&2
        fi
}
extract () {
   if [ -f $1 ] ; then
       case $1 in
           *.tar.bz2)   tar xvjf $1    ;;
           *.tar.gz)    tar xvzf $1    ;;
           *.bz2)       bunzip2 $1     ;;
           *.rar)       unrar x $1       ;;
           *.gz)        gunzip $1      ;;
           *.tar)       tar xvf $1     ;;
           *.tbz2)      tar xvjf $1    ;;
           *.tgz)       tar xvzf $1    ;;
           *.zip)       unzip $1       ;;
           *.Z)         uncompress $1  ;;
           *.7z)        7z x $1        ;;
           *)           echo "don't know how to extract '$1'..." ;;
       esac
   else
       echo "'$1' is not a valid file!"
   fi
 }
