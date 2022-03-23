#!/bin/bash

PATH_name=/media/lorena/SAVIOR/hidroestimador_unifei

file=$(head -1 $PATH_name/último_arquivo.txt)

ano=`date -u +%Y` 

export LC_ALL=C
MES=$(date -u "+%b" -d "$data")  

dia=$(echo $file | cut -c 17-18) 

hora=$(echo $file | cut -c 19-20) 

min=$(echo $file | cut -c 21-22)
########################################################################
cat <<EOF> $PATH_name/input/${file}.ctl
dset $PATH_name/input/${file}.bin
options yrev
undef 32767
title hi
options little_endian
ydef 1613 linear -44.95 0.0359477
xdef 1349 linear -82.00 0.0382513
tdef 1 linear  ${hora}:${min}z${dia}${MES}${ano} 10mn
zdef 1 levels 1
vars 1
hi 0 -1,40,2,-1 hi
endvars
EOF

