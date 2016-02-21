##############################################################################
####                                                                      ####
####  ~/.bashrc for System User                                           ####
####  Written by Christopher 'InterGen' Cork <chris@intergenstudios.com>  ####
####  2/25/15                                                             ####
####                                                                      ####
##############################################################################


###################################
####                           ####
####  Interactive shell check  ####
####                           ####
###################################


[[ $- != *i* ]] && return


#######################################
####                               ####
####  Bash prompt for System User  ####
####                               ####
##################################################################
####                                                          ####
####  You can set an alternative bash prompt by placing your  ####
####  prompt code in-between the '' below and removing the #  ####
####  before 'export'                                         ####
####                                                          ####
##################################################################

#export PS1=''


#################################
####                         ####
####  System User Variables  ####
####                         ####
#################################


export EDITOR=nano
export LC_COLLATE="C"


###############################
####                       ####
####  System User Aliases  ####
####                       ####
###############################


alias ping='ping -c 3'
alias ls='ls -a --group-directories-first --time-style=+"%d.%m.%Y %H:%M" --color=auto -F'
alias grep='grep --color=auto'
alias ll='ls -lah'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'


#################################
####                         ####
####  System User Functions  ####
####                         ####
#################################



################################################################################
####                                                                        ####
####  System User environment variables and startup programs should go in   ####
####  ~/.bash_profile.  System wide environment variables and startup       ####
####  programs are in /etc/profile.  System wide aliases and functions are  ####
####  in /etc/bashrc.                                                       ####
####                                                                        ####
################################################################################


if [ -f "/etc/bashrc" ] ; then
  source /etc/bashrc
fi


#########################################
####                                 ####
####  END ~/.bashrc for system user  ####
####                                 ####
#########################################
