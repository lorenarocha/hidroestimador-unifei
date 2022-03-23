#!/bin/bash
#Autores: Jefferson Cassemiro
#         Lorena Rocha (para dúvidas: lore.bezerra.r@gmail.com)

#Esse script visa por: 
#                      1) baixar dados do Hidroestimador, algoritmo calculado pelo CPTEC/INPE;
#                      2) transformar o arquivo binário -> netCDF;
#                      3) plotar imagens de precipitação instantanea para: BRASIL, NORTE, NORDESTE, CENTRO-OESTE, SUDESTE, SUL E PARA O ESTADO 				  DE MINAS GERAIS;
#                      4) upar os dados a cada 10 min e imagens para o ftp do site: meteorologia.unifei.edu.br

#para utilizá-lo é necessário mudar o diretório dos arquivos na variável PATH_name
clear

PATH_name=/media/lorena/SAVIOR/hidroestimador_unifei

cd ${PATH_name}/src
#####################################################################################################
seq -s= 70|tr -d '[:digit:]'
echo "BAIXANDO ÚLTIMO DADO..."
seq -s= 70|tr -d '[:digit:]'

ano=`date -u +%Y` 
mes=`date -u +%m`

url=ftp.cptec.inpe.br/goes/goes16/hidroest/est_prec/${ano}/${mes}/

dados=$(curl ${url} | tail -3 | cut -c 56-77 > $PATH_name/lista.txt)

ultimo=$(cat $PATH_name/lista.txt | tail -1)

cd $PATH_name/input/

wget -nc ${url}${ultimo}.bin
#####################################################################################################
seq -s= 70|tr -d '[:digit:]'
echo "DADO BAIXADO..."
seq -s= 70|tr -d '[:digit:]'

cat <<EOF> $PATH_name/último_arquivo.txt
${ultimo}
EOF
#####################################################################################################
seq -s= 70|tr -d '[:digit:]'
echo "CRIANDO O CTL..."
seq -s= 70|tr -d '[:digit:]'

sh $PATH_name/src/sub/criar_ctl.sh
#####################################################################################################
seq -s= 70|tr -d '[:digit:]'
echo "CONVERTENDO BINÁRIO EM NETCDF..."
seq -s= 70|tr -d '[:digit:]'

seq -s= 70|tr -d '[:digit:]'
echo "APAGANDO CTL E BIN..."
seq -s= 70|tr -d '[:digit:]'

sh $PATH_name/src/sub/criar_nc.sh
#####################################################################################################
seq -s= 70|tr -d '[:digit:]'
echo "CRIANDO IMAGEM INSTÂNTANEA..."
seq -s= 70|tr -d '[:digit:]'

sh $PATH_name/src/sub/criar_imagem_brasil.sh
#####################################################################################################
seq -s= 70|tr -d '[:digit:]'
echo "CRIANDO IMAGEM SETORIZADA - CENTRO OESTE..."
seq -s= 70|tr -d '[:digit:]'

sh $PATH_name/src/sub/criar_imagem_CO.sh
#####################################################################################################
seq -s= 70|tr -d '[:digit:]'
echo "CRIANDO IMAGEM SETORIZADA - NORTE..."
seq -s= 70|tr -d '[:digit:]'

sh $PATH_name/src/sub/criar_imagem_N.sh
#####################################################################################################
seq -s= 70|tr -d '[:digit:]'
echo "CRIANDO IMAGEM SETORIZADA - NORDESTE..."
seq -s= 70|tr -d '[:digit:]'

sh $PATH_name/src/sub/criar_imagem_NE.sh
#####################################################################################################
seq -s= 70|tr -d '[:digit:]'
echo "CRIANDO IMAGEM SETORIZADA - SUL..."
seq -s= 70|tr -d '[:digit:]'

sh $PATH_name/src/sub/criar_imagem_S.sh
#####################################################################################################
seq -s= 70|tr -d '[:digit:]'
echo "CRIANDO IMAGEM SETORIZADA - SUDESTE..."
seq -s= 70|tr -d '[:digit:]'

sh $PATH_name/src/sub/criar_imagem_SE.sh
#####################################################################################################
seq -s= 70|tr -d '[:digit:]'
echo "CRIANDO IMAGEM SETORIZADA - MINAS GERAIS..."
seq -s= 70|tr -d '[:digit:]'

sh $PATH_name/src/sub/criar_imagem_MG.sh
####################################################################################################
seq -s= 70|tr -d '[:digit:]'
echo "MOVENDO O ULTIMO NETCDF PARA A PASTA OUTPUT..."
seq -s= 70|tr -d '[:digit:]'

cd $PATH_name/input

cp ${ultimo}.nc $PATH_name/output

rm ${ultimo}.nc
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
#####################################################################################################
seq -s= 70|tr -d '[:digit:]'
echo "APAGANDO TODOS OS ARQUIVOS DA PASTA..."
seq -s= 70|tr -d '[:digit:]'

cd $PATH_name/output

rm *.png

