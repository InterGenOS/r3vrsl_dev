##############################################################################
####                                                                      ####
####  Begin ~/.bashrc for Root User                                       ####
####  Written by Christopher 'InterGen' Cork <chris@intergenstudios.com>  ####
####  2/25/15                                                             ####
####                                                                      ####
##############################################################################



#####################################
####                             ####
####  Bash prompt for Root User  ####
####                             ####
##################################################################
####                                                          ####
####  You can set an alternative bash prompt by placing your  ####
####  prompt code in-between the '' below and removing the #  ####
####  before 'export'                                         ####
####                                                          ####
##################################################################


#export PS1=''


###############################
####                       ####
####  Root User Variables  ####
####                       ####
###############################


export EDITOR=nano
export LC_COLLATE="C"


#############################
####                     ####
####  Root User Aliases  ####
####                     ####
#############################


alias ping='ping -c 3'
alias ls='ls -a --group-directories-first --time-style=+"%d.%m.%Y %H:%M" --color=auto -F'
alias grep='grep --color=auto'
alias ll='ls -lah'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'


###############################
####                       ####
####  Root User Functions  ####
####                       ####
###############################



################################################################################
####                                                                        ####
####  Root User environment variables and startup programs should go in     ####
####  ~/.bash_profile.  System wide environment variables and startup       ####
####  programs are in /etc/profile.  System wide aliases and functions are  ####
####  in /etc/bashrc.                                                       ####
####                                                                        ####
################################################################################


if [ -f "/etc/bashrc" ] ; then
  source /etc/bashrc
fi


#######################################
####                               ####
####  END ~/.bashrc for Root user  ####
####                               ####
#######################################
