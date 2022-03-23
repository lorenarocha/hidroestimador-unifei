#!/bin/bash

PATH_name=/media/lorena/SAVIOR/hidroestimador_unifei

cd ${PATH_name}/output

var_anterior=`date -u +%Y%m%d --date='1 day ago'`

rm S11636382_${var_anterior}*
