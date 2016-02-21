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

    clear && HEADER1 && sleep 1
    echo -e "\n  Select the partition to build ${GREY}R${RED}3${GREY}VRSL${NOCOLOR} in:\n"
    # Create build partition selection list
    lsblk | grep part | cut -d 'd' -f 2- | sed -e 's/^/sd/' | awk '{printf "%- 13s %s\n", $1"  "$4, $6" "$7;}' > partitions
    sed = partitions | sed 'N;s/\n/\t/' > partitionlist && sed -i 's/^/#/g' partitionlist
    DIVIDER1 BLUE
    cat partitionlist
    DIVIDER1 BLUE
    echo -en "  ${GREEN}[${WHITE}enter selection${GREEN}]${NOCOLOR}: "
    read PARTITION_CHOICE
    # Read target partition from build partition selection
    TARGET_PARTITION="$(grep -m 1 \#"$PARTITION_CHOICE" partitionlist | awk '{print $2}')"
    printf "\n\n"
    # Confirm target build partition
    echo -en "    Build ${GREY}R${RED}3${GREY}VRSL${NOCOLOR} in ${GREEN}${TARGET_PARTITION}${NOCOLOR}, correct ${WHITE}(${NOCOLOR}y/N${WHITE})${NOCOLOR}? "
    read TARGET_CONFIRMATION
    printf "\n\n"
    if [ "$TARGET_CONFIRMATION" = "Y" ] || [ "$TARGET_CONFIRMATION" = "y" ] || [ "$TARGET_CONFIRMATION" = "Yes" ] || [ "$TARGET_CONFIRMATION" = "yes" ]; then
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

    # Mount the build directory
    clear && HEADER1
    echo -e "\n  ${GREEN}Setting up build directory mount...${NOCOLOR}"
    mkdir -pv "$R3VRSL" || echo -e "\n  Unable to create mount directory ${R3VRSL}\n\n  (exiting...)\n\n\n" > /home/failure
    if [ -f /home/failure ]; then
        echo -e "\n\n  ${RED}FATAL ERROR${NOCOLOR}\n $(cat /home/failure)"
        rm /home/failure
        exit 1
    fi
    mount -v -t ext4 /dev/"$TARGET_PARTITION" "$R3VRSL" || echo -e "\n\n  Unable to mount ${R3VRSL} on /dev/${TARGET_PARTITION}!\n\n  (exiting...)\n\n\n" > /home/failure
    if [ -f /home/failure ]; then
        echo -e "\n\n  ${RED}FATAL ERROR${NOCOLOR}\n $(cat /home/failure)"
        rm /home/failure
        exit 1
    fi
    sleep 2 && echo -e "\n  ${GREEN}Build directory mount setup complete${NOCOLOR}" && sleep 3

    # Set build variables in root and system user accts
    clear && HEADER1
    echo -en "\n  ${GREEN}Please enter your system username${NOCOLOR}: "
    read USER
    echo -e "\n  ${GREEN}Adding build environment variables to bash initialization files...${NOCOLOR}"
    if [ -z "$(grep "export R3VRSL" /home/"$USER"/.bashrc)" ]; then
        echo "export R3VRSL=/mnt/r3vrsl" >> /home/"$USER"/.bashrc
    fi
    if [ -f /root/.bashrc ]; then
        if [ -z "$(grep "export R3VRSL" /root/.bashrc)" ]; then
            echo "export R3VRSL=/mnt/r3vrsl" >> /root/.bashrc
        fi
    else
        if [ -z "$(grep "export R3VRSL" /root/.bash_profile)" ]; then
            echo "export R3VRSL=/mnt/r3vrsl" >> /root/.bash_profile
        fi
    fi
    if [ -z "$(grep "export R3VRSL_PART" /home/"$USER"/.bash_profile)" ]; then
        echo "export R3VRSL_PART=/dev/$TARGET_PARTITION" >> /home/"$USER"/.bash_profile
    fi
    if [ -z "$(grep "export R3VRSL_PART" /root/.bash_profile)" ]; then
        echo "export R3VRSL_PART=/dev/$TARGET_PARTITION" >> /root/.bash_profile
    fi
    sleep 2 && echo -e "\n  ${GREEN}Variable additions complete${NOCOLOR}" && sleep 3

    # Set up source directory
    clear && HEADER1
    echo -e "\n  ${GREEN}Creating source directory...${NOCOLOR}"
    mkdir -pv "$R3VRSL"/sources || echo -e "\n\n  Unable to create source directory ${R3VRSL}/sources!\n\n  (exiting...)\n\n\n" > /home/failure
    if [ -f /home/failure ]; then
        echo -e "\n\n  ${RED}FATAL ERROR${NOCOLOR}\n $(cat /home/failure)"
        rm /home/failure
        exit 1
    fi
    chmod -v a+wt "$R3VRSL"/sources
    sleep 2 && echo -e "\n  ${GREEN}Source directory creation complete${NOCOLOR}" && sleep 3

    # Download sources
    clear && HEADER1
    echo -e "\n  ${GREEN}Fetching sources... ${NOCOLOR}(this might take a little while...)\n\n"
    wget -q https://github.com/InterGenOS/r3vrsl_dev/archive/master.zip -P "$R3VRSL" || echo -e "\n\n  Unable to fetch sources!\n\n  (exiting...)\n\n\n" > /home/failure
    if [ -f /home/failure ]; then
        echo -e "\n\n  ${RED}FATAL ERROR${NOCOLOR}\n $(cat /home/failure)"
        rm /home/failure
        exit 1
    fi
    sleep 2 && echo -e "  ${GREEN}Source retrieval complete${NOCOLOR}\n\n" && sleep 3

    # Move sources into place
    clear && HEADER1
    echo -e "\n  ${GREEN}Preparing sources for compilation...${NOCOLOR}\n\n"
    cd "$R3VRSL" || echo -e "\n\n  Unable to move into ${R3VRSL}!\n\n  (exiting...)\n\n\n" > /home/failure
    if [ -f /home/failure ]; then
        echo -e "\n\n  ${RED}FATAL ERROR${NOCOLOR}\n $(cat /home/failure)"
        rm /home/failure
        exit 1
    fi
    unzip master.zip 2>&1 && rm master.zip
    mv r3vrsl_dev/r3vrsl_core_sources/* "$R3VRSL"/sources && rm -rf r3vrsl_dev/r3vrsl_core_sources
    mv r3vrsl_dev/r3vrsl_core_buildscripts/* "$R3VRSL"/ && rm -rf r3vrsl_dev
    mkdir -v "$R3VRSL"/tools && ln -sv "$R3VRSL"/tools /
    sleep 2 && echo -e "  ${GREEN}Source preparation complete${NOCOLOR}" && sleep 3

    # Create build system user
    clear && HEADER1
    echo -e "\n  ${GREEN}Creating user ${WHITE}r3vrsl ${GREEN}with password ${WHITE}r3vrsldev${GREEN}...${NOCOLOR}\n\n"
    groupadd r3vrsl
    useradd -s /bin/bash -g r3vrsl -m -k /dev/null r3vrsl
    echo "r3vrsl:r3vrsldev" | chpasswd
    sleep 2 && echo -e "  ${GREEN}User creation completed${NOCOLOR}" && sleep 3

    # Assign build directory ownership
    clear && HEADER1
    echo -e "\n  ${GREEN}Assigning ownership of ${WHITE}${R3VRSL}/{${NOCOLOR}sources,tools${WHITE}} ${GREEN}to user ${WHITE}r3vrsl${GREEN}...${NOCOLOR}\n\n"
    chown -v r3vrsl "$R3VRSL"/{tools,sources}
    sleep 2 && echo -e "  ${GREEN}Directory ownership assignment complete${NOCOLOR}" && sleep 3

    # Setup r3vrsl shell for 'build_temp_sys.sh'
    clear && HEADER1
    echo -e "\n  ${GREEN}Preparing shell variables for user ${WHITE}r3vrsl${GREEN}...${NOCOLOR}\n\n"
    chown -v r3vrsl "$R3VRSL"/*.sh
    chmod +x "$R3VRSL"/*.sh
    mv "$R3VRSL"/sources/r3vrsl.* /home/r3vrsl/ && chown -v r3vrsl:users /home/r3vrsl/*

    # Set UUID in etc--fstab
    RUUID="$(blkid | grep "$TARGET_PARTITION" | sed 's/"/ /g' | awk '{print $3}')"
    sed -i -e "s/T_PT/$RUUID/" "$R3VRSL"/sources/etc--fstab

    # Get 'target.drive' for use in 'finalize_sys.sh'
    echo $TARGET_PARTITION | sed 's/[0-9]//' > "$R3VRSL"/target.drive
    sleep 2 && echo -e "  ${GREEN}Shell variable preparation complete${NOCOLOR}" && sleep 3

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

HEADER1
GET_TARGET_BUILD_PARTITION
SETUP_BUILD

#######################
##-------------------##
## END - CORE SCRIPT ##
##-------------------##
#######################
