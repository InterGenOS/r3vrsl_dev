#!/usr/bin/bash
# build_tempsys.sh
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

###########################################
##---------------------------------------##
## BEGIN - INITIAL VARIABLE DECLARATIONS ##
##---------------------------------------##
###########################################

# Set build variables
set +h
umask 022
R3VRSL=/mnt/r3vrsl
LC_ALL=POSIX
R3VRSL_TGT=$(uname -m)-r3vrsl-linux-gnu
PATH=/tools/bin:/bin:/usr/bin
export R3VRSL LC_ALL R3VRSL_TGT PATH

# Sets a logging timestamp
TIMESTAMP="$(date +"%Y%m%d-%H%M%S")"

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

# Creates a $ line gap for easier log review
SPACER () {

    case $1 in

        15) printf "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n";;
        10) printf "\n\n\n\n\n\n\n\n\n\n";;
         *) printf "\n\n\n\n\n"

    esac

}

#--------------------------------#
# END - DISPLAY LAYOUT FUNCTIONS #
#--------------------------------#

#--------------------------------------------------#
# BEGIN - TEMPORARY SYSTEM PACKAGE BUILD FUNCTIONS #
#--------------------------------------------------#

BUILD_BINUTILS_PASS1 () {

    clear && HEADER1
    echo -e "  ${GREEN}Building binutils-2.25.1 PASS 1...${NOCOLOR}\n\n"
    sleep 5

    #####################
    ## Binutils-2.25.1 ##
    ## =============== ##
    ##    PASS -1-     ##
    #############################################################################################################
    ## To determine SBUs, use the following command:                                                           ##
    ## =============================================                                                           ##
    ## time { ../binutils-2.25.1/configure --prefix=/tools --with-sysroot=$R3VRSL --with-lib-path=/tools/lib \ ##
    ## --target=$R3VRSL_TGT --disable-nls --disable-werror && make && case $(uname -m) in \                    ##
    ## x86_64) mkdir -v /tools/lib && ln -sv lib /tools/lib64 ;; esac && make install; }                       ##
    ## =================================================================================                       ##
    ## Example results for a single SBU measurement with the following hardware:                               ##
    ## =========================================================================                               ##
    ## 8GB Memory, Intel Core i3, SSD:                                                                         ##
    ## real - 2m 1.212s                                                                                        ##
    ## user - 1m 32.530s                                                                                       ##
    ## sys  - 0m 5.540s                                                                                        ##
    ## ================                                                                                        ##
    #############################################################################################################
    ## Example results for full temporary system build with the following hardware:                            ##
    ## ============================================================================                            ##
    ## 16GB Memory, Intel Core i3, SSD:                                                                        ##
    ## real - 38m 13.192s                                                                                      ##
    ## user - 35m 39.140s                                                                                      ##
    ## sys  - 2m  20.787s                                                                                      ##
    ## ==================                                                                                      ##
    #############################################################################################################

    tar xf binutils-2.25.1.tar.gz &&
    cd binutils-2.25.1/
    mkdir -v ../binutils-build
    cd ../binutils-build
    ../binutils-2.25.1/configure   \
        --prefix=/tools            \
        --with-sysroot=$R3VRSL     \
        --with-lib-path=/tools/lib \
        --target=$R3VRSL_TGT       \
        --disable-nls              \
        --disable-werror &&
    make &&
    case $(uname -m) in
        x86_64) mkdir -v /tools/lib && ln -sv lib /tools/lib64 ;;
    esac &&
    make install &&
    cd "$R3VRSL"/sources
    rm -rf binutils-2.25.1 binutils-build/
    printf "\n\n"
    echo -e "  ${GREEN}binutils-2.25.1 PASS 1 completed...${NOCOLOR}"
    SPACER
    sleep 5

}

BUILD_GCC_PASS1 () {

    clear && HEADER1
    echo -e "  ${GREEN}Building gcc-5.2.0 PASS 1...${NOCOLOR}\n\n" && sleep 3

    ###############
    ## Gcc-5.2.0 ##
    ## ========= ##
    ##  PASS -1- ##
    ###############

    tar xf gcc-5.2.0.tar.gz
    cd gcc-5.2.0/
    tar -xf ../mpfr-3.1.3.tar.gz
    mv -v mpfr-3.1.3 mpfr
    tar -xf ../gmp-6.0.0.tar.gz
    mv -v gmp-6.0.0 gmp
    tar -xf ../mpc-1.0.3.tar.gz
    mv -v mpc-1.0.3 mpc
    for file in $(find gcc/config -name linux64.h -o -name linux.h -o -name sysv4.h); do
        cp -uv $file{,.orig}
        sed -e 's@/lib\(64\)\?\(32\)\?/ld@/tools&@g' -e 's@/usr@/tools@g' $file.orig > $file
        echo '
    #undef STANDARD_STARTFILE_PREFIX_1
    #undef STANDARD_STARTFILE_PREFIX_2
    #define STANDARD_STARTFILE_PREFIX_1 "/tools/lib/"
    #define STANDARD_STARTFILE_PREFIX_2 ""' >> $file
        touch $file.orig
    done
    mkdir -v ../gcc-build
    cd ../gcc-build
    ../gcc-5.2.0/configure                               \
        --target=$R3VRSL_TGT                             \
        --prefix=/tools                                  \
        --with-glibc-version=2.11                        \
        --with-sysroot=$R3VRSL                           \
        --with-newlib                                    \
        --without-headers                                \
        --with-local-prefix=/tools                       \
        --with-native-system-header-dir=/tools/include   \
        --disable-nls                                    \
        --disable-shared                                 \
        --disable-multilib                               \
        --disable-decimal-float                          \
        --disable-threads                                \
        --disable-libatomic                              \
        --disable-libgomp                                \
        --disable-libquadmath                            \
        --disable-libssp                                 \
        --disable-libvtv                                 \
        --disable-libstdcxx                              \
        --enable-languages=c,c++ &&
    make &&
    make install &&
    cd "$R3VRSL"/sources
    rm -rf gcc-5.2.0 gcc-build/
    echo -e "\n\n  ${GREEN}gcc-5.2.0 PASS 1 completed${NOCOLOR}"
    SPACER 15
    sleep 5

}

# In Development
