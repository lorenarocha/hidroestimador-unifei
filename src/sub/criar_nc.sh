#!/bin/bash

PATH_name=/media/lorena/SAVIOR/hidroestimador_unifei

file=$(head -1 $PATH_name/último_arquivo.txt)

cd $PATH_name/input/

cdo -f nc import_binary ${file}.ctl ${file}.nc

rm ${file}.ctl ${file}.bin

