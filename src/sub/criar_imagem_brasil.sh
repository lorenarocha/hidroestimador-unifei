#!/bin/bash

PATH_name=/media/lorena/SAVIOR/hidroestimador_unifei

file=$(head -1 $PATH_name/último_arquivo.txt)

var_data=$(head -1 $PATH_name/último_arquivo.txt | cut -c 11-23)

cd $PATH_name/input

cat <<EOF> ${file}_brasil.gs

'reinit'
'sdfopen ${file}.nc'
'set display color white'
'set mpdraw off'
'c'

'set ylint 5'
'set xlint 6'
'set xlopts 1 12 0.19'
'set ylopts 1 12 0.19'
'set annot 1 12'

'set parea 0.7 8.3 0.8 10.7'

'q time'
data=subwrd(result,3)

'set lat -35 7'
'set lon -77 -32'

'set grads off';'set grid off'

'set gxout shaded'
'../src/grads/color 0 55 5 -kind white->darkorchid->mediumblue->dodgerblue->palegreen->yellowgreen->khaki->gold->orange->red'
'd hi/10'
'../src/grads/xcbar 0.8 8.1 0.7 0.93 -ft 12 -line on -edge triangle'

'set shpopts -1'
'set line 1 1 12'
'draw shp ../src/shapefile/brasil/brasil.shp'

'set font 4'
'draw title PRECIPITACAO INSTANTANEA (mm/h) \ BRASIL - 'data''
'set xlab LONGITUDE'
'set ylab LATITUDE'

'printim ../output/ultima_img_brasil.png x1000 y1400'

'quit'
EOF

grads -pbc "${file}_brasil.gs"
rm ${file}_brasil.gs
