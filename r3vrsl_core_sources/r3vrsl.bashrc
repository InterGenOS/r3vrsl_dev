set +h
umask 022
R3VRSL=/mnt/r3vrsl
LC_ALL=POSIX
R3VRSL_TGT=$(uname -m)-r3vrsl-linux-gnu
PATH=/tools/bin:/bin:/usr/bin
export R3VRSL LC_ALL R3VRSL_TGT PATH
