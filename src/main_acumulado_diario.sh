#!/bin/bash

PATH_name=/media/lorena/SAVIOR/hidroestimador_unifei

cd ${PATH_name}/output

var_data=`date +%Y%m%d`

ano=`date +%Y`
mes=`date +%m`
dia=`date +%d`

seq -s= 70|tr -d '[:digit:]'
echo "GERANDO UM ARQUIVO COM TODOS OS TEMPOS DO DIA, CRIA UM CTL..."
seq -s= 70|tr -d '[:digit:]'

cdo mergetime S11636382_${var_data}*.nc hidroestimador_${dia}.nc
cdo gradsdes hidroestimador_${dia}.nc
#######################################################################
seq -s= 70|tr -d '[:digit:]'
echo "CRIA UM ARQUIVO DO ACUMULADO DIÁRIO..."
seq -s= 70|tr -d '[:digit:]'

cat <<EOF> gera_acum.gs
'reinit'
'open hidroestimador_${dia}.ctl'
'set t last'
'q dims'
lin=sublin(result,5)
tempo=subwrd(lin,9)
say tempo

'define acum=sum(hi*0.017, t=1, t='tempo')'
'set sdfwrite hidroestimador_${dia}_.nc'
'sdfwrite acum'
'quit'
EOF
grads -lbc gera_acum.gs
#######################################################################
seq -s= 70|tr -d '[:digit:]'
echo "ARRUMA O EIXO TEMPORAL DO ARQUIVO..."
seq -s= 70|tr -d '[:digit:]'

cdo -r settaxis,${ano}-${mes}-${dia},00:00:00,1day hidroestimador_${dia}_.nc hidroestimador_${dia}_acum.nc
#######################################################################
seq -s= 70|tr -d '[:digit:]'
echo "CRIA A IMAGEM DE PRECIPITAÇÃO DIÁRIA PARA O BRASIL..."
seq -s= 70|tr -d '[:digit:]'

cat <<EOF> hidroestimador_brasil_acum.gs

'reinit'
'sdfopen hidroestimador_${dia}_acum.nc'
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
'../src/grads/color 0 100 10 -kind white->darkorchid->mediumblue->dodgerblue->palegreen->yellowgreen->khaki->gold->orange->red'
'd acum'
'../src/grads/xcbar 0.8 8.1 0.7 0.93 -ft 12 -line on -edge triangle'

'set shpopts -1'
'set line 1 1 12'
'draw shp ../src/shapefile/brasil/brasil.shp'

'set font 4'
'draw title PRECIPITACAO DIARIA ACUMULADA (mm) \ BRASIL - 'data''
'set xlab LONGITUDE'
'set ylab LATITUDE'

'printim ../output/precip_diaria_hidro_${var_data}_brasil.png x1000 y1400'

'quit'
EOF

grads -pbc "hidroestimador_brasil_acum.gs"

seq -s= 70|tr -d '[:digit:]'
echo "APAGANDO TODOS OS ARQUIVOS CRIADOS..."
seq -s= 70|tr -d '[:digit:]'


#rm hidroestimador*
#rm gera_acum.gs
#####################################################################################################
seq -s= 70|tr -d '[:digit:]'
echo "UPANDO ARQUIVOS..."
seq -s= 70|tr -d '[:digit:]'

lftp -f "
open meteorologia.unifei.edu.br
user meteorologia_temp456 sGm#Pkr9NV
lcd $PATH_name/output
mirror --reverse --verbose $PATH_name/output produtos/hidroestimador/dados
bye
"

seq -s= 70|tr -d '[:digit:]'
echo "FIM DO UPLOAD..."
seq -s= 70|tr -d '[:digit:]'
########################################################################

