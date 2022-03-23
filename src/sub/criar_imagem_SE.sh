#!/bin/bash

PATH_name=/media/lorena/SAVIOR/hidroestimador_unifei

file=$(head -1 $PATH_name/último_arquivo.txt)

var_data=$(head -1 $PATH_name/último_arquivo.txt | cut -c 11-23)

cd $PATH_name/input

cat <<EOF> ${file}_SE.gs

'reinit'
'sdfopen ${file}.nc'
'set display color white'
'set mpdraw off'
'c'

'set ylint 2'
'set xlint 3'
'set xlopts 1 12 0.19'
'set ylopts 1 12 0.19'
'set annot 1 12'

'set parea 1.3 10.3 0.5 7.6'

'q time'
data=subwrd(result,3)

'set lat -25.5 -14'
'set lon -54 -39'

'set grads off';'set grid off'

'set gxout shaded'
'../src/grads/color 0 55 5 -kind white->darkorchid->mediumblue->dodgerblue->palegreen->yellowgreen->khaki->gold->orange->red'
'd hi/10'
'../src/grads/xcbar 10.1 10.33 0.6 7.5 -ft 12 -line on -edge triangle'

'set shpopts -1'
'set line 1 1 12'
'draw shp ../src/shapefile/sudeste/sudeste.shp'

'set font 4'
'draw title PRECIPITACAO INSTANTANEA (mm/h) \ SUDESTE - 'data''
'set xlab LONGITUDE'
'set ylab LATITUDE'

'printim ../output/ultima_img_SE.png x1400 y1000'

'quit'
EOF

grads -lbc "${file}_SE.gs"
rm ${file}_SE.gs
