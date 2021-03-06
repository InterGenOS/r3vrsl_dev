#!/usr/bin/bash
# initial_setup.sh
# -------------------------------------------------------
# R3VRSL: Behavioral.Code.Memory
# build: 1.0
# Github: https://github.com/r3vrsl
# ---------------------------------------------------
# R3VRSL: 2-12-2016
# Copyright (c) 2016: R3VRSL Development
# URL: https://r3vrsl.com
# --------------------------------
# License: GPL-2.0+
# URL: http://opensource.org/licenses/gpl-license.php
# ---------------------------------------------------
# R3VRSL is free software:
# You may redistribute it and/or modify it under the terms of the
# GNU General Public License as published by the Free Software
# Foundation, either version 2 of the License, or (at your discretion)
# any later version.
# ------------------

#############################################
##-----------------------------------------##
## BEGIN - MAKE SURE WE'RE RUNNING AS ROOT ##
##-----------------------------------------##
#############################################

if [ "$(id -u)" != "0" ]; then
    echo -e "\n\n  \e[1m\e[5m\e[37m--------\e[0m"
    echo -e "  \e[1m\e[5m\e[31mWARNING!\e[0m"
    echo -e "  \e[1m\e[5m\e[37m--------\e[0m\n\n"
    echo -e "  \e[1m\e[30mR\e[1m\e[31m3\e[1m\e[30mVRSL\e[0m \e[1m\e[37mmust be built as \e[1m\e[31mROOT\e[1m\e[37m!\e[0m\n\n"
    echo -e "  \e[1m\e[37m(\e[0mExiting Now...\e[1m\e[37m)\e[0m\n\n"
    exit 1
fi

###########################################
##---------------------------------------##
## END - MAKE SURE WE'RE RUNNING AS ROOT ##
##---------------------------------------##
###########################################

###########################################
##---------------------------------------##
## BEGIN - INITIAL VARIABLE DECLARATIONS ##
##---------------------------------------##
###########################################

# Sets timestamp format 20160101-010101CST
timestamp="$(date +"%Y%m%d-%H%M%S")"CST

# Sets build mount point
export R3VRSL=/mnt/r3vrsl

# Sets terminal colors
BLINK="\e[5m"
BLUE="\e[1m\e[34m"
CYAN="\e[1m\e[36m"
GREEN="\e[1m\e[32m"
GREY="\e[1m\e[30m"
NOCOLOR="\e[0m"
RED="\e[1m\e[31m"
UNDERLINE_TEXT="\e[4m"
WHITE="\e[1m\e[37m"
YELLOW="\e[1m\e[33m"

#########################################
##-------------------------------------##
## END - INITIAL VARIABLE DECLARATIONS ##
##-------------------------------------##
#########################################

##############################
##--------------------------##
## BEGIN - SCRIPT FUNCTIONS ##
##--------------------------##
##############################

#----------------------------------#
# BEGIN - DISPLAY LAYOUT FUNCTIONS #
#----------------------------------#

# Creates uniform look during script execution when called after clear command
HEADER1 () {

    echo -e "  ${GREY}__________________________________________${NOCOLOR}"
    echo -e "\n   ${GREY}R${RED}3${GREY}VRSL${NOCOLOR} ${WHITE}Behavioral.Code.Memory  Build:${NOCOLOR}1.0"
    echo -e "  ${GREY}__________________________________________${NOCOLOR}\n"

}

# Simple divider
DIVIDER1 () {

    case $1 in

        BLUE) echo -e "\n\n  ${BLUE}----------------------------------------------------------${NOCOLOR}\n\n";;
        CYAN) echo -e "\n\n  ${CYAN}----------------------------------------------------------${NOCOLOR}\n\n";;
        GREEN) echo -e "\n\n  ${GREEN}----------------------------------------------------------${NOCOLOR}\n\n";;
        GREY) echo -e "\n\n  ${GREY}----------------------------------------------------------${NOCOLOR}\n\n";;
        RED) echo -e "\n\n  ${RED}----------------------------------------------------------${NOCOLOR}\n\n";;
        WHITE) echo -e "\n\n  ${WHITE}----------------------------------------------------------${NOCOLOR}\n\n";;
        YELLOW) echo -e "\n\n  ${YELLOW}----------------------------------------------------------${NOCOLOR}\n\n";;
        *) echo -e "\n\n  ----------------------------------------------------------\n\n";;

    esac

}

# Clears $ amount of lines when called
CLEARLINE () {

    # To use, set CLINES=$# before function if you need to clear more than one line
    if [ -z "$CLINES" ]; then
        tput cuu 1 && tput el
    else
        tput cuu "$CLINES" && tput el
        unset CLINES
    fi

}


#--------------------------------#
# END - DISPLAY LAYOUT FUNCTIONS #
#--------------------------------#

GET_TARGET_BUILD_PARTITION () {

    #---------------------------------------#
    # Create build partition selection list #
    #---------------------------------------#

    clear && HEADER1 && sleep 1
    echo -e "\n  Select the partition to build ${GREY}R${RED}3${GREY}VRSL${NOCOLOR} in:\n"
    lsblk | grep part | cut -d 'd' -f 2- | sed -e 's/^/sd/' | awk '{printf "%- 13s %s\n", $1"  "$4, $6" "$7;}' > partitions
    sed = partitions | sed 'N;s/\n/\t/' > partitionlist && sed -i 's/^/#/g' partitionlist
    DIVIDER1 BLUE
    cat partitionlist
    DIVIDER1 BLUE
    echo -en "  ${GREEN}[${WHITE}enter selection${GREEN}]${NOCOLOR}: "
    read -r PARTITION_CHOICE

    #------------------------------------------------------#
    # Read target partition from build partition selection #
    #------------------------------------------------------#

    TARGET_PARTITION="$(grep -m 1 \#"$PARTITION_CHOICE" partitionlist | awk '{print $2}')"
    printf "\n\n"

    #--------------------------------#
    # Confirm target build partition #
    #--------------------------------#

    echo -en "    Build ${GREY}R${RED}3${GREY}VRSL${NOCOLOR} in ${GREEN}${TARGET_PARTITION}${NOCOLOR}, correct ${WHITE}(${NOCOLOR}y/N${WHITE})${NOCOLOR}? "
    read -r TARGET_CONFIRMATION
    printf "\n\n"
    if [[ "$TARGET_CONFIRMATION" = "Y" || "y" || "Yes" || "YES" || "yes" ]]; then
        sleep 2
        rm partitions partitionlist
        SETUP_BUILD
    else
        echo -e "   ${RED}Build cancelled by user${NOCOLOR}\n\n"
        echo -e "    (exiting...)\n\n\n"
        rm partitions partitionlist
        exit 1
    fi

}

SETUP_BUILD () {

    #------------------------------------#
    # Make and mount the build directory #
    #------------------------------------#

    clear && HEADER1
    echo -e "\n  ${GREEN}Setting up build directory mount...${NOCOLOR}\n\n"
    mkdir -pv "$R3VRSL" || echo -e "\n  Unable to create mount directory ${R3VRSL}\n\n  (exiting...)\n\n\n" > /home/failure
    if [ -f /home/failure ]; then
        echo -e "\n\n  ${RED}FATAL ERROR${NOCOLOR}\n $(cat /home/failure)\n\n"
        rm /home/failure
        exit 1
    fi
    mount -v -t ext4 /dev/"$TARGET_PARTITION" "$R3VRSL" || echo -e "\n\n  Unable to mount ${R3VRSL} on /dev/${TARGET_PARTITION}!\n\n  (exiting...)\n\n\n" > /home/failure
    if [ -f /home/failure ]; then
        echo -e "\n\n  ${RED}FATAL ERROR${NOCOLOR}\n $(cat /home/failure)\n\n"
        rm /home/failure
        exit 1
    fi
    sleep 2 && echo -e "\n\n  ${GREEN}Build directory mount setup complete${NOCOLOR}" && sleep 3

    #---------------------------------------------------#
    # Set build variables in root and system user accts #
    #---------------------------------------------------#

    clear && HEADER1
    echo -en "\n  ${GREEN}Please enter your system username${NOCOLOR}: "
    read -r USER
    echo -e "\n  ${GREEN}Adding build environment variables to bash initialization files...${NOCOLOR}\n\n"
    echo "export R3VRSL=/mnt/r3vrsl" >> /home/"$USER"/.bashrc
    echo "export R3VRSL=/mnt/r3vrsl" >> /root/.bashrc
    echo "export R3VRSL=/mnt/r3vrsl" >> /root/.bash_profile
    echo "export R3VRSL_PART=/dev/$TARGET_PARTITION" >> /home/"$USER"/.bash_profile
    echo "export R3VRSL_PART=/dev/$TARGET_PARTITION" >> /root/.bash_profile
    sleep 2 && echo -e "\n\n  ${GREEN}Variable additions complete${NOCOLOR}" && sleep 3

    #-------------------------#
    # Set up source directory #
    #-------------------------#

    clear && HEADER1
    echo -e "\n  ${GREEN}Creating source directory...${NOCOLOR}\n\n"
    mkdir -pv "$R3VRSL"/sources || echo -e "\n\n  Unable to create source directory ${R3VRSL}/sources!\n\n  (exiting...)\n\n\n" > /home/failure
    if [ -f /home/failure ]; then
        echo -e "\n\n  ${RED}FATAL ERROR${NOCOLOR}\n $(cat /home/failure)\n\n"
        rm /home/failure
        exit 1
    fi
    chmod -v a+wt "$R3VRSL"/sources
    sleep 2 && echo -e "\n\n  ${GREEN}Source directory creation complete${NOCOLOR}" && sleep 3

    #------------------#
    # Download sources #
    #------------------#

    clear && HEADER1
    echo -e "\n  ${GREEN}Fetching sources... ${NOCOLOR}(this might take a little while...)\n\n"
    wget -q https://github.com/InterGenOS/r3vrsl_dev/archive/master.zip -P "$R3VRSL" || echo -e "\n\n  Unable to fetch sources!\n\n  (exiting...)\n\n\n" > /home/failure
    if [ -f /home/failure ]; then
        echo -e "\n\n  ${RED}FATAL ERROR${NOCOLOR}\n $(cat /home/failure)\n\n"
        rm /home/failure
        exit 1
    fi
    sleep 2 && echo -e "\n\n  ${GREEN}Source retrieval complete${NOCOLOR}" && sleep 3

    #-------------------------#
    # Move sources into place #
    #-------------------------#

    clear && HEADER1
    echo -e "\n  ${GREEN}Preparing sources for compilation...${NOCOLOR}\n\n" && sleep 2
    cd "$R3VRSL" || echo -e "\n\n  Unable to move into ${R3VRSL}!\n\n  (exiting...)\n\n\n" > /home/failure
    if [ -f /home/failure ]; then
        echo -e "\n\n  ${RED}FATAL ERROR${NOCOLOR}\n $(cat /home/failure)\n\n"
        rm /home/failure
        exit 1
    fi
    unzip master.zip 2>&1 && rm master.zip
    mv r3vrsl_dev-master/r3vrsl_core_sources/* "$R3VRSL"/sources && rm -rf r3vrsl_dev-master/r3vrsl_core_sources
    mv r3vrsl_dev-master/r3vrsl_core_buildscripts/* "$R3VRSL"/ && rm -rf r3vrsl_dev-master
    mkdir -v "$R3VRSL"/tools && ln -sv "$R3VRSL"/tools /
    sleep 2 && echo -e "\n\n  ${GREEN}Source preparation complete${NOCOLOR}" && sleep 3

    #--------------------------#
    # Create build system user #
    #--------------------------#

    clear && HEADER1
    echo -e "\n  ${GREEN}Creating user ${WHITE}r3vrsl ${GREEN}with password ${WHITE}r3vrsldev${GREEN}...${NOCOLOR}\n\n"
    groupadd r3vrsl
    useradd -s /bin/bash -g r3vrsl -m -k /dev/null r3vrsl
    echo "r3vrsl:r3vrsldev" | chpasswd
    sleep 2 && echo -e "\n\n  ${GREEN}User creation completed${NOCOLOR}" && sleep 3

    #----------------------------------#
    # Assign build directory ownership #
    #----------------------------------#

    clear && HEADER1
    echo -e "\n  ${GREEN}Assigning ownership of ${WHITE}${R3VRSL}/{${NOCOLOR}sources,tools${WHITE}} ${GREEN}to user ${WHITE}r3vrsl${GREEN}...${NOCOLOR}\n\n"
    chown -v r3vrsl "$R3VRSL"/{tools,sources}
    sleep 2 && echo -e "\n\n  ${GREEN}Directory ownership assignment complete${NOCOLOR}" && sleep 3

    #--------------------------------------------#
    # Setup r3vrsl shell for 'build_temp_sys.sh' #
    #--------------------------------------------#

    clear && HEADER1
    echo -e "\n  ${GREEN}Preparing shell variables for user ${WHITE}r3vrsl${GREEN}...${NOCOLOR}\n\n"
    chown -v r3vrsl "$R3VRSL"/*.sh
    chmod +x "$R3VRSL"/*.sh
    mv "$R3VRSL"/sources/r3vrsl.bash_profile /home/r3vrsl/.bash_profile
    mv "$R3VRSL"/sources/r3vrsl.bashrc /home/r3vrsl/.bashrc
    chown -v r3vrsl:users /home/r3vrsl/{.bashrc,.bash_profile}

    #------------------------#
    # Set UUID in etc--fstab #
    #------------------------#

    RUUID="$(blkid | grep "$TARGET_PARTITION" | sed 's/"/ /g' | awk '{print $3}')"
    sed -i -e "s/T_PT/$RUUID/" "$R3VRSL"/sources/etc--fstab

    #-------------------------------------------------#
    # Get 'target.drive' for use in 'finalize_sys.sh' #
    #-------------------------------------------------#

    echo "$TARGET_PARTITION" | sed 's/[0-9]//' > "$R3VRSL"/target.drive
    sleep 2 && echo -e "\n\n  ${GREEN}Shell variable preparation complete${NOCOLOR}" && sleep 3

}

SETUP_CHROOT () {

    #-----------------------#
    # Set correct ownership #
    #-----------------------#

    clear && HEADER1
    echo -e "\n  ${GREEN}Changing temporary tools directory ownership...${NOCOLOR}\n\n"
    chown -R root:root "$R3VRSL"/tools
    sleep 2 && echo -e "\n\n  ${GREEN}Temporary tools directory ownership change complete${NOCOLOR}" && sleep 3

    #------------------------------#
    # Bind and mount system mounts #
    #------------------------------#

    clear && HEADER1
    echo -e "\n  ${GREEN}Preparing virtual kernel file system...${NOCOLOR}\n\n"
    mkdir -pv "$R3VRSL"/{dev,proc,sys,run}
    mknod -m 600 "$R3VRSL"/dev/console c 5 1
    mknod -m 666 "$R3VRSL"/dev/null c 1 3
    mount -v --bind /dev "$R3VRSL"/dev
    mount -vt devpts devpts "$R3VRSL"/dev/pts -o gid=5,mode=620
    mount -vt proc proc "$R3VRSL"/proc
    mount -vt sysfs sysfs "$R3VRSL"/sys
    mount -vt tmpfs tmpfs "$R3VRSL"/run
    if [ -h "$R3VRSL"/dev/shm ]; then
      mkdir -pv "$R3VRSL"/$(readlink "$R3VRSL"/dev/shm)
    fi
    sleep 2 && echo -e "\n\n  ${GREEN}Virtual kernel file system preparation complete${NOCOLOR}\n\n\n" && sleep 3
    echo -e "  Entering chroot environment...\n\n" && sleep 3

}


############################
##------------------------##
## END - SCRIPT FUNCTIONS ##
##------------------------##
############################

#########################
##---------------------##
## BEGIN - CORE SCRIPT ##
##---------------------##
#########################

#------------------------#
# Create log directories #
#------------------------#

mdkir -p /var/log/R3VRSL/BuildLogs/TempSys_Buildlogs || echo -e "\n\n  Unable to create log directories!\n\n  (exiting...)\n\n\n" > /home/failure
if [ -f /home/failure ]; then
    echo -e "\n\n  ${RED}FATAL ERROR${NOCOLOR}\n $(cat /home/failure)\n\n"
    rm /home/failure
    exit 1
fi
chmod -R 777 /var/log/R3VRSL

#---------------------#
# Begin initial setup #
#---------------------#

GET_TARGET_BUILD_PARTITION 2>&1 | tee /var/log/R3VRSL/BuildLogs/TempSys_Buildlogs/"$timestamp"_inital_setup.log
sed -i -e 's/[\x01-\x1F\x7F]//g' -e 's|\[1m||g' -e 's|\[32m||g' -e 's|\[34m||g' -e 's|(B\[m||g' -e 's|\[1m\[32m||g' -e 's|\[H\[2J||g' -e 's|\[1m\[31m||g' -e 's|\[1m\[34m||g' -e 's|\[5A\[K||g' -e 's|\[1m\[33m||g' /var/log/R3VRSL/BuildLogs/TempSys_Buildlogs/"$timestamp"_inital_setup.log

#------------------------------------------------------------------#
# Begin temporary system build in separate shell as the build user #
#------------------------------------------------------------------#

cd "$R3VRSL" || echo -e "\n\n  Unable to move to build directory ${R3VRSL} for temp system build!\n\n  (exiting...)\n\n\n" > /home/failure
if [ -f /home/failure ]; then
    echo -e "\n\n  ${RED}FATAL ERROR${NOCOLOR}\n $(cat /home/failure)\n\n"
    rm /home/failure
    exit 1
fi
sudo -u r3vrsl ./clean_environment.sh &&
printf "\n\n\n"

#---------------------------------------------------------#
# Setup the chroot environment for r3vrsl system building #
#---------------------------------------------------------#

SETUP_CHROOT 2>&1 | tee /var/log/R3VRSL/BuildLogs/"$timestamp"_setup_chroot.log
sed -i -e 's/[\x01-\x1F\x7F]//g' -e 's|\[1m||g' -e 's|\[32m||g' -e 's|\[34m||g' -e 's|(B\[m||g' -e 's|\[1m\[32m||g' -e 's|\[H\[2J||g' -e 's|\[1m\[31m||g' -e 's|\[1m\[34m||g' -e 's|\[5A\[K||g' -e 's|\[1m\[33m||g' /var/log/R3VRSL/BuildLogs/"$timestamp"_setup_chroot.log

#--------------------------------------------------#
# Enter chroot to begin building the r3vrsl system #
#--------------------------------------------------#

cd "$R3VRSL" || echo -e "\n\n  Unable to move to build directory ${R3VRSL} for chroot entry!\n\n  (exiting...)\n\n\n" > /home/failure
if [ -f /home/failure ]; then
    echo -e "\n\n  ${RED}FATAL ERROR${NOCOLOR}\n $(cat /home/failure)\n\n"
    rm /home/failure
    exit 1
fi
sudo -u root ./enter_chroot.sh 2>&1 | tee /var/log/R3VRSL/BuildLogs/"$timestamp"_sys_build.log &&
sed -i -e 's/[\x01-\x1F\x7F]//g' -e 's|\[1m||g' -e 's|\[32m||g' -e 's|\[34m||g' -e 's|(B\[m||g' -e 's|\[1m\[32m||g' -e 's|\[H\[2J||g' -e 's|\[1m\[31m||g' -e 's|\[1m\[34m||g' -e 's|\[5A\[K||g' -e 's|\[1m\[33m||g' /var/log/R3VRSL/BuildLogs/"$timestamp"_sys_build.log

#----------------------------------------------------#
# Re-enter chroot to begin using newly compiled bash #
#----------------------------------------------------#

clear && HEADER1
echo -e "\n  ${GREEN}Entered Root Shell successfully${NOCOLOR}\n\n"
DIVIDER1 BLUE && sleep 3
echo -e "\n  ${GREEN}Entering chroot environment for post-bash package builds...${NOCOLOR}\n\n" && sleep 3
cd "$R3VRSL" || echo -e "\n\n  Unable to move to build directory ${R3VRSL} for post-bash package builds!\n\n  (exiting...)\n\n\n" > /home/failure
if [ -f /home/failure ]; then
    echo -e "\n\n  ${RED}FATAL ERROR${NOCOLOR}\n $(cat /home/failure)\n\n"
    rm /home/failure
    exit 1
fi
sudo -u root ./enter_chroot_post-bash.sh 2>&1 | tee /var/log/R3VRSL/BuildLogs/"$timestamp"_chroot_post-bash.log &&
sed -i -e 's/[\x01-\x1F\x7F]//g' -e 's|\[1m||g' -e 's|\[32m||g' -e 's|\[34m||g' -e 's|(B\[m||g' -e 's|\[1m\[32m||g' -e 's|\[H\[2J||g' -e 's|\[1m\[31m||g' -e 's|\[1m\[34m||g' -e 's|\[5A\[K||g' -e 's|\[1m\[33m||g' /var/log/R3VRSL/BuildLogs/"$timestamp"_chroot_post-bash.log
printf "\n\n"

#-------------------------------------------------------------#
# Re-enter chroot to strip unnecessary binaries and libraries #
#-------------------------------------------------------------#

clear && HEADER1
echo -e "\n  ${GREEN}Entered Root Shell successfully${NOCOLOR}\n\n"
DIVIDER1 BLUE && sleep 3
echo -e "\n  ${GREEN}Entering chroot environment for binary and library stripping...${NOCOLOR}\n\n" && sleep 3
cd "$R3VRSL" || echo -e "\n\n  Unable to move to build directory ${R3VRSL} for binary and library stripping!\n\n  (exiting...)\n\n\n" > /home/failure
if [ -f /home/failure ]; then
    echo -e "\n\n  ${RED}FATAL ERROR${NOCOLOR}\n $(cat /home/failure)\n\n"
    rm /home/failure
    exit 1
fi
sudo -u root ./enter_chroot_stripping.sh 2>&1 | tee /var/log/R3VRSL/BuildLogs/"$timestamp"_chroot_stripping.log &&
sed -i -e 's/[\x01-\x1F\x7F]//g' -e 's|\[1m||g' -e 's|\[32m||g' -e 's|\[34m||g' -e 's|(B\[m||g' -e 's|\[1m\[32m||g' -e 's|\[H\[2J||g' -e 's|\[1m\[31m||g' -e 's|\[1m\[34m||g' -e 's|\[5A\[K||g' -e 's|\[1m\[33m||g' /var/log/R3VRSL/BuildLogs/"$timestamp"_chroot_stripping.log
printf "\n\n"

#------------------------------------------#
# Re-enter chroot to finalize system build #
#------------------------------------------#

clear && HEADER1
echo -e "\n  ${GREEN}Entered Root Shell successfully${NOCOLOR}\n\n"
DIVIDER1 BLUE && sleep 3
echo -e "\n  ${GREEN}Entering chroot environment for System Finalization...${NOCOLOR}\n\n" && sleep 3
cd "$R3VRSL" || echo -e "\n\n  Unable to move to build directory ${R3VRSL} for system finalization!\n\n  (exiting...)\n\n\n" > /home/failure
if [ -f /home/failure ]; then
    echo -e "\n\n  ${RED}FATAL ERROR${NOCOLOR}\n $(cat /home/failure)\n\n"
    rm /home/failure
    exit 1
fi
sudo -u root ./enter_chroot_finalize.sh 2>&1 | tee /var/log/R3VRSL/BuildLogs/"$timestamp"_chroot_finalize.log &&
sed -i -e 's/[\x01-\x1F\x7F]//g' -e 's|\[1m||g' -e 's|\[32m||g' -e 's|\[34m||g' -e 's|(B\[m||g' -e 's|\[1m\[32m||g' -e 's|\[H\[2J||g' -e 's|\[1m\[31m||g' -e 's|\[1m\[34m||g' -e 's|\[5A\[K||g' -e 's|\[1m\[33m||g' /var/log/R3VRSL/BuildLogs/"$timestamp"_chroot_finalize.log
printf "\n\n"

#-----------------------#
# Cleanup build scripts #
#-----------------------#

rm /build_* /clean_* /enter_* /finalize_* /strip_*

#------------------------#
# Completed Notification #
#------------------------#

clear && HEADER1
echo -e "\n\n   ${GREY}R${RED}3${GREY}VRSL${NOCOLOR} ${WHITE}Behavioral.Code.Memory  Build:${NOCOLOR}1.0 ${GREEN}COMPLETED${NOCOLOR}\n\n" && sleep 3
DIVIDER1 BLUE
echo -e "  ${WHITE}Thank you for your participation in the project!${NOCOLOR}\n\n"
echo -e "  ${WHITE}Any errors you find and would like to report will be greatly appreciated!${NOCOLOR}\n\n"
echo -e "  ${WHITE}Send any submissions to:${NOCOLOR}\n\n\n"
echo -e "                         ${GREEN}R3VRSL${WHITE}@${GREEN}R3VRSL.COM${NOCOLOR}\n\n\n"
echo -e "  ${RED}${BLINK}***${NOCOLOR}${YELLOW}IMPORTANT - ${RED}${UNDERLINE_TEXT}IMPORTANT${NOCOLOR}${YELLOW} - IMPORTANT${RED}${BLINK}***${NOCOLOR}\n\n"
echo -e "  ${WHITE}            YOU MUST NOW DO THE FOLLOWING:${NOCOLOR}\n"
echo -e "                      ${GREEN}1)${WHITE} Re-Install Grub (or your preferred bootloader)${NOCOLOR}\n"
echo -e "                             ie:  'sudo grub-install /dev/sd_'"
echo -e "                      ${GREEN}2)${WHITE} Create a new bootloader config${NOCOLOR}\n"
echo -e "                             ie:  'sudo grub-mkconfig -o /boot/grub/grub.cfg'\n\n"
echo -e "  ${RED}${BLINK}***${NOCOLOR}${YELLOW}IMPORTANT - ${RED}${UNDERLINE_TEXT}IMPORTANT${NOCOLOR}${YELLOW} - IMPORTANT${RED}${BLINK}***${NOCOLOR}\n\n"
echo -e "  ${WHITE}You should then be able to restart and select 'R3VRSL' from your boot menu"
DIVIDER1 BLUE && sleep 3


#######################
##-------------------##
## END - CORE SCRIPT ##
##-------------------##
#######################

exit 0
