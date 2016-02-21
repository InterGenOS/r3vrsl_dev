#!/usr/bin/bash
# dep_check.sh
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
# Simple script to list version numbers of critical development tools

###########################################
##---------------------------------------##
## BEGIN - INITIAL VARIABLE DECLARATIONS ##
##---------------------------------------##
###########################################

GREEN="\e[1m\e[32m"
GREY="\e[1m\e[30m"
NOCOLOR="\e[0m"
RED="\e[1m\e[31m"
WHITE="\e[1m\e[37m"

export LC_ALL=C

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

HEADER1 () {

    clear
    echo -e "  ${GREY}_______________________________________________${NOCOLOR}"
    echo -e "\n   ${GREY}R${RED}3${GREY}VRSL${NOCOLOR} ${WHITE}Critical Build Tools Dependency Checks${NOCOLOR}"
    echo -e "  ${GREY}_______________________________________________${NOCOLOR}\n"

}

HEADER2 () {

    echo -e "  ${GREY}________________________________${NOCOLOR}"
    echo -e "\n   ${GREY}R${RED}3${GREY}VRSL${NOCOLOR} ${WHITE}Critical Library Checks${NOCOLOR}"
    echo -e "  ${GREY}________________________________${NOCOLOR}\n"

}

FOOTER () {

    echo -e "  ${GREY}_________________________${NOCOLOR}"
    echo -e "\n   ${GREY}R${RED}3${GREY}VRSL${NOCOLOR} ${WHITE}Checks Completed${NOCOLOR}"
    echo -e "  ${GREY}_________________________${NOCOLOR}\n\n"

}

#--------------------------------#
# END - DISPLAY LAYOUT FUNCTIONS #
#--------------------------------#

BC_Check () {

    hash bc 2>/dev/null || bc_check=failed
    if [ "$bc_check" = "failed" ]; then
        clear
        echo -e "\n\n  ${RED}bc binary not found on system!${NOCOLOR}\n"
        echo -e "  The 'bc' binary is necessary for dependency checks"
        echo -e "  Please install your distribution's bc package and"
        echo -e "  re-run the setup utility.\n\n"
        echo -e "  (Exiting now...)\n\n\n"
        exit 1
    fi

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

BC_Check
HEADER1

bash_version="$(bash --version | head -n1 | cut -d" " -f2-4 | sed 's/-release//' | awk '{print $3}' | cut -d '.' -f 1-2)"
if (( $(echo "$bash_version >= 3.1" |bc -l) )); then
    echo -e "  Bash Version: ${GREEN}$(bash --version | head -n1 | cut -d" " -f2-4 | sed 's/-release//' | awk '{print $3}')${NOCOLOR}"
else
    echo -e "  Bash Version: ${RED}$(bash --version | head -n1 | cut -d" " -f2-4 | sed 's/-release//' | awk '{print $3}')${NOCOLOR}"
fi

bash_link_check="$(readlink -f /bin/sh)"
if [ "$bash_link_check" = "/usr/bin/bash" ] || [ "$bash_link_check" = "/bin/bash" ]; then
    echo -e "  Bash link check: ${GREEN}PASS${NOCOLOR} /bin/sh -> ${bash_link_check}"
else
    echo -e "  Bash link check: ${RED}FAIL${NOCOLOR} /bin/sh != /usr/bin/bash or /bin/bash"
fi

binutils_version="$(ld --version | head -n1 | cut -d" " -f3- | sed 's/(GNU Binutils) //' | cut -d '.' -f 1-2)"
if (( $(echo "$binutils_version >= 2.17" |bc -l) )); then
    echo -e "  Binutils Version: ${GREEN}$(ld --version | head -n1 | cut -d" " -f3- | sed 's/(GNU Binutils) //')${NOCOLOR}"
else
    echo -e "  Binutils Version: ${RED}$(ld --version | head -n1 | cut -d" " -f3- | sed 's/(GNU Binutils) //')${NOCOLOR}"
fi

bison_version="$(bison --version | head -n1 | sed 's/(GNU Bison) //' | awk '{print $2}' | cut -d '.' -f 1-2)"
if (( $(echo "$bison_version >= 2.3" |bc -l) )); then
    echo -e "  Bison Version: ${GREEN}$(bison --version | head -n1 | sed 's/(GNU Bison) //' | awk '{print $2}')${NOCOLOR}"
else
    echo -e "  Bison Version: ${RED}$(bison --version | head -n1 | sed 's/(GNU Bison) //' | awk '{print $2}')${NOCOLOR}"
fi

if [ -h /usr/bin/yacc ]; then
    yacc_check="$(readlink -f /usr/bin/yacc)"
    echo -e "  YACC check: ${GREEN}PASS${NOCOLOR} /usr/bin/yacc -> ${yacc_check}";
elif [ -x /usr/bin/yacc ]; then
    yacc_check="$(/usr/bin/yacc --version | head -n1 | sed 's/(GNU Bison) //')"
    echo -e "  YACC check: ${GREEN}PASS${NOCOLOR} yacc is ${yacc_check}"
else
    echo -e "  YACC check: ${RED}FAIL${NOCOLOR} yacc not found"
fi

bzip2_version="$(bzip2 --version 2>&1 < /dev/null | head -n1 | cut -d" " -f1,6- | sed 's/,/ /g' | awk '{print $3}' | cut -d '.' -f 2-3)"
if (( $(echo "$bzip2_version >= 0.4" |bc -l) )); then
    echo -e "  Bzip2 Version: ${GREEN}$(bzip2 --version 2>&1 < /dev/null | head -n1 | cut -d" " -f1,6- | sed 's/,/ /g' | awk '{print $3}')${NOCOLOR}"
else
    echo -e "  Bzip2 Version: ${RED}$(bzip2 --version 2>&1 < /dev/null | head -n1 | cut -d" " -f1,6- | sed 's/,/ /g' | awk '{print $3}')${NOCOLOR}"
fi

coreutils_version="$(chown --version | head -n1 | cut -d")" -f2 | awk '{print $1}')"
if (( $(echo "$coreutils_version >= 6.9" |bc -l) )); then
    echo -e "  Coreutils Version: ${GREEN}${coreutils_version}${NOCOLOR}"
else
    echo -e "  Coreutils Version: ${RED}${coreutils_version}${NOCOLOR}"
fi

diffutils_version="$(diff --version | head -n1 | sed 's/(GNU diffutils) //' | awk '{print $2}' | cut -d '.' -f 1-2)"
if (( $(echo "$diffutils_version >= 2.8" |bc -l) )); then
    echo -e "  Diffutils Version: ${GREEN}$(diff --version | head -n1 | sed 's/(GNU diffutils) //' | awk '{print $2}')${NOCOLOR}"
else
    echo -e "  Diffutils Version: ${RED}$(diff --version | head -n1 | sed 's/(GNU diffutils) //' | awk '{print $2}')${NOCOLOR}"
fi

findutils_version="$(find --version | head -n1 | sed 's/(GNU findutils) //' | awk '{print $2}' | cut -d '.' -f 2-3)"
if (( $(echo "$findutils_version >= 2.31" |bc -l) )); then
    echo -e "  Findutils Version: ${GREEN}$(find --version | head -n1 | sed 's/(GNU findutils) //' | awk '{print $2}')${NOCOLOR}"
else
    echo -e "  Findutils Version: ${RED}$(find --version | head -n1 | sed 's/(GNU findutils) //' | awk '{print $2}')${NOCOLOR}"
fi

gawk_version="$(gawk --version | head -n1 | cut -d ',' -f 1 | awk '{print $3}' | cut -d '.' -f 2-3)"
if (( $(echo "$gawk_version >= 0.1" |bc -l) )); then
    echo -e "  Gawk Version: ${GREEN}$(gawk --version | head -n1 | cut -d ',' -f 1 | awk '{print $3}')${NOCOLOR}"
else
    echo -e "  Gawk Version: ${RED}$(gawk --version | head -n1 | cut -d ',' -f 1 | awk '{print $3}')${NOCOLOR}"
fi

if [ -h /usr/bin/awk ]; then
    awk_check="$(readlink -f /usr/bin/awk)"
    echo -e "  Awk check: ${GREEN}PASS${NOCOLOR} /usr/bin/awk -> ${awk_check}";
elif [ -x /usr/bin/awk ]; then
    awk_check="$(/usr/bin/awk --version | head -n1)"
    echo -e "  Awk check: ${GREEN}PASS${NOCOLOR} /usr/bin/awk -> ${awk_check}"
else
    echo -e "  Awk check: ${RED}FAIL${NOCOLOR} awk not found"
fi

gcc_version="$(gcc --version | head -n1 | sed 's/(GCC) //' | awk '{print $2}' | cut -d '.' -f 1-2)"
if (( $(echo "$gcc_version >= 4.1" |bc -l) )); then
    echo -e "  GCC Version: ${GREEN}$(gcc --version | head -n1 | sed 's/(GCC) //' | awk '{print $2}')${NOCOLOR}"
else
    echo -e "  GCC Version: ${RED}$(gcc --version | head -n1 | sed 's/(GCC) //' | awk '{print $2}')${NOCOLOR}"
fi

gplusplus_version="$(g++ --version | head -n1 | sed 's/(GCC) //' | awk '{print $2}' | cut -d '.' -f 1-2)"
if (( $(echo "$gplusplus_version >= 4.1" |bc -l) )); then
    echo -e "  G++ Version: ${GREEN}$(g++ --version | head -n1 | sed 's/(GCC) //' | awk '{print $2}')${NOCOLOR}"
else
    echo -e "  G++ Version: ${RED}$(g++ --version | head -n1 | sed 's/(GCC) //' | awk '{print $2}')${NOCOLOR}"
fi

glibc_version="$(ldd --version | head -n1 | cut -d" " -f2-  | awk '{print $3}')"
if (( $(echo "$glibc_version >= 2.11" |bc -l) )); then
    echo -e "  Glibc Version: ${GREEN}${glibc_version}${NOCOLOR}"
else
    echo -e "  Glibc Version: ${RED}${glibc_version}${NOCOLOR}"
fi

grep_version="$(grep --version | head -n1 | awk '{print $4}' | cut -d '.' -f 2-3)"
if (( $(echo "$grep_version >= 5.1" |bc -l) )); then
    echo -e "  Grep Version: ${GREEN}$(grep --version | head -n1 | awk '{print $4}')${NOCOLOR}"
else
    echo -e "  Grep Version: ${RED}$(grep --version | head -n1 | awk '{print $4}')${NOCOLOR}"
fi

gzip_version="$(gzip --version | head -n1 | awk '{print $2}' | cut -d '.' -f 1-2)"
if (( $(echo "$gzip_version >= 1.4" |bc -l) )); then
    echo -e "  Gzip Version: ${GREEN}$(gzip --version | head -n1 | awk '{print $2}')${NOCOLOR}"
else
    echo -e "  Gzip Version: ${RED}$(gzip --version | head -n1 | awk '{print $2}')${NOCOLOR}"
fi

kernel_version="$(awk '{print $3}' /proc/version | cut -d '.' -f 1-2)"
if (( $(echo "$kernel_version >= 2.7" |bc -l) )); then
    echo -e "  Linux Kernel: ${GREEN}$(awk '{print $3}' /proc/version)${NOCOLOR}"
else
    echo -e "  Gzip Version: ${RED}$(awk '{print $3}' /proc/version)${NOCOLOR}"
fi

m4_version="$(m4 --version | head -n1 | awk '{print $4}' | cut -d '.' -f 2-3)"
if (( $(echo "$m4_version >= 4.1" |bc -l) )); then
    echo -e "  M4 Version: ${GREEN}$(m4 --version | head -n1 | awk '{print $4}')${NOCOLOR}"
else
    echo -e "  M4 Version: ${RED}$(m4 --version | head -n1 | awk '{print $4}')${NOCOLOR}"
fi

make_version="$(make --version | head -n1 | awk '{print $3}')"
if (( $(echo "$make_version >= 3.8" |bc -l) )); then
    echo -e "  Make Version: ${GREEN}${make_version}${NOCOLOR}"
else
    echo -e "  Make Version: ${RED}${make_version}${NOCOLOR}"
fi

patch_version="$(patch --version | head -n1 | awk '{print $3}' | cut -d '.' -f 1-2)"
if (( $(echo "$patch_version >= 2.5" |bc -l) )); then
    echo -e "  Patch Version: ${GREEN}$(patch --version | head -n1 | awk '{print $3}')${NOCOLOR}"
else
    echo -e "  Patch Version: ${RED}$(patch --version | head -n1 | awk '{print $3}')${NOCOLOR}"
fi

perl_version="$(echo Perl `perl -V:version` | sed -e "s/'/ /g" -e "s/=//" | cut -d ';' -f 1 | awk '{print $3}' | cut -d '.' -f 2-3)"
if (( $(echo "$perl_version >= 8.8" |bc -l) )); then
    echo -e "  Perl Version: ${GREEN}$(echo Perl `perl -V:version` | sed -e "s/'/ /g" -e "s/=//" | cut -d ';' -f 1 | awk '{print $3}')${NOCOLOR}"
else
    echo -e "  Perl Version: ${RED}$(echo Perl `perl -V:version` | sed -e "s/'/ /g" -e "s/=//" | cut -d ';' -f 1 | awk '{print $3}')${NOCOLOR}"
fi

sed_version="$(sed --version | head -n1 | sed 's/(GNU sed) //' | awk '{print $2}' | cut -d '.' -f 2-3)"
if (( $(echo "$sed_version >= 1.5" |bc -l) )); then
    echo -e "  Sed Version: ${GREEN}$(sed --version | head -n1 | sed 's/(GNU sed) //' | awk '{print $2}')${NOCOLOR}"
else
    echo -e "  Sed Version: ${RED}$(sed --version | head -n1 | sed 's/(GNU sed) //' | awk '{print $2}')${NOCOLOR}"
fi

tar_version="$(tar --version | head -n1 | sed 's/(GNU tar) //' | awk '{print $2}')"
if (( $(echo "$tar_version >= 1.22" |bc -l) )); then
    echo -e "  Tar Version: ${GREEN}${tar_version}${NOCOLOR}"
else
    echo -e "  Tar Version: ${RED}${tar_version}${NOCOLOR}"
fi

texinfo_version="$(makeinfo --version | head -n1 | awk '{print $4}')"
if (( $(echo "$texinfo_version >= 4.7" |bc -l) )); then
    echo -e "  Texinfo Version: ${GREEN}${texinfo_version}${NOCOLOR}"
else
    echo -e "  Texinfo Version: ${RED}${texinfo_version}${NOCOLOR}"
fi

xz_version="$(xz --version | head -n1 | awk '{print $4}' | cut -d '.' -f 1-2)"
if (( $(echo "$xz_version >= 5.0" |bc -l) )); then
    echo -e "  Xz Version: ${GREEN}$(xz --version | head -n1 | awk '{print $4}')${NOCOLOR}"
else
    echo -e "  Xz Version: ${RED}$(xz --version | head -n1 | awk '{print $4}')${NOCOLOR}"
fi

echo 'main(){}' > dummy.c && g++ -o dummy dummy.c
if [ -x dummy ]; then
    echo -e "  Compiler check: ${GREEN}g++ compilation OK${NOCOLOR}"
else
    echo -e "  Compiler check: ${RED}g++ compilation failed${NOCOLOR}"
fi
rm -f dummy.c dummy

HEADER2

if [[ -f "/usr/lib/libgmp.la" ]] && [[ -f "/usr/lib/libmpfr.la" ]] && [[ -f "/usr/lib/libmpc.la" ]]; then
    echo -e "  ${GREEN}PASS${NOCOLOR}!\n"
    echo -e "  All Libraries Are Present"
    echo -e "  On System!\n"
elif ! [[ -f "/usr/lib/libgmp.la" ]] && ! [[ -f "/usr/lib/libmpfr.la" ]] && ! [[ -f "/usr/lib/libmpc.la" ]]; then
    echo -e "  ${GREEN}PASS${NOCOLOR}!\n"
    echo -e "  All Libraries Are Absent"
    echo -e "  From System!\n"
else
    echo -e "  ${RED}FAIL${NOCOLOR}!\n"
    echo -e "  /usr/lib/libgmp.la"
    echo -e "  /usr/lib/libmpfr.la"
    echo -e "  /usr/lib/libmpc.la\n"
    echo -e "  Libraries MUST be either"
    echo -e "  ALL PRESENT or ALL ABSENT"
    echo -e "  from the system!\n"
fi

for lib in lib{gmp,mpfr,mpc}.la; do
    echo -e "  ${GREEN}${lib}${NOCOLOR}:\
    $(if find /usr/lib* -name $lib | grep -q $lib; then
          :
      else
          echo Not
      fi) Found"
done
unset lib

FOOTER

#######################
##-------------------##
## END - CORE SCRIPT ##
##-------------------##
#######################

exit 0

