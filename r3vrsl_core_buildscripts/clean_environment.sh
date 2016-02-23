#!/usr/bin/bash
# clean_environment.sh
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

#------------------------------#
# BEGIN WRAPPER SCRIPT COMMAND #
#------------------------------#

env -i HOME=$HOME TERM=$TERM PS1='\u:\w\$ ' PATH=/tools/bin:/bin:/usr/bin /bin/bash ./build_tempsys.sh &&

#----------------------------#
# END WRAPPER SCRIPT COMMAND #
#----------------------------#

exit 0
