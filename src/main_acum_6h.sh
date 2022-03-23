#!/bin/bash

PATH_name=/media/lorena/SAVIOR/hidroestimador_unifei

cd ${PATH_name}/output/6horas
#######################################################################
seq -s= 70|tr -d '[:digit:]'
echo "FAZENDO LISTA COM AS DATAS DAS ÚLTIMAS 6 HORAS..."
seq -s= 70|tr -d '[:digit:]'
var_zero=`date -u +%Y%m%d%H --date='6 hours ago'`
var_one=`date -u +%Y%m%d%H --date='5 hours ago'`
var_two=`date -u +%Y%m%d%H --date='4 hours ago'`
var_three=`date -u +%Y%m%d%H --date='3 hours ago'`
var_four=`date -u +%Y%m%d%H --date='2 hours ago'`
var_five=`date -u +%Y%m%d%H --date='1 hour ago'`

cat <<EOF> ultimas_6h.txt
$var_zero
$var_one
$var_two
$var_three
$var_four
$var_five
EOF
#######################################################################
seq -s= 70|tr -d '[:digit:]'
echo "JUNTANDO TODOS OS ARQUIVOS DE UMA HORA E FAZENDO O ACUMULADO..."
seq -s= 70|tr -d '[:digit:]'

for line in `seq 1 6`; do

data=$(cat ${PATH_name}/output/6horas/ultimas_6h.txt | grep -n ^ | grep ^${line} | cut -d: -f2)
echo $data

cd ${PATH_name}/output/
cp S11636382_${data}* 6horas

cd ${PATH_name}/output/6horas
cdo mergetime S11636382_${data}* hidro_horario_${data}.nc
cdo timsum hidro_horario_${data}.nc acum_horario_${data}.nc
done
#######################################################################
seq -s= 70|tr -d '[:digit:]'
echo "FAZENDO OS CÁLCULOS PARA O ACUMULADO DE 6 HORAS..."
seq -s= 70|tr -d '[:digit:]'
cdo mergetime acum_horario_*.nc nc_acum.nc
cdo timsum nc_acum.nc acum_6h_.nc
cdo mulc,0.017 acum_6h_.nc acum_6h.nc
#######################################################################
seq -s= 70|tr -d '[:digit:]'
echo "GEORREFERENCIANDO A CHUVA..."
seq -s= 70|tr -d '[:digit:]'

cat <<EOF> 6h_geo.py

# -*- coding: utf-8 -*-
"""
    Autor: Robson Barreto dos Passos (robsonbarretodospassos@gmail.com)
	
	Este script tem como input um shapefile com os limites municipais e um arquivo netcdf com estimativa de precipitação do hidroestimador.
	
	Output: Arquivo .txt com os valores médios de precipitação para cada município
	
"""

import geopandas as gpd
import xarray as xr
import pandas as pd

#Lendo o arquivo shapefile
mun = gpd.read_file('../../src/shapefile/sul_de_minas/suldeminas.shp', encoding='utf-8')

#Lendo o arquivo netcdf (Delimitei um retângulo no entorno do estado de Minas Gerais)
nc = xr.open_dataset('acum_6h.nc', decode_times=False)['hi'].sel(lat=slice(-14, -24), lon=slice(-52, -39)).isel(time=0)

#Trasformando o netcdf em um dataframe
hi_df = nc.to_dataframe().reset_index().drop(columns=['time'])

#Transformando o dataframe em um geodataframe
hi_gdf = gpd.GeoDataFrame(hi_df, geometry=gpd.points_from_xy(hi_df.lon, hi_df.lat))

#Extraindo a média de precipitação para cada município
lista = []
for idx in range(0, 146):
    mun_mask = hi_gdf['geometry'].within(mun.loc[idx, 'geometry'])
    mun_dados = hi_gdf.loc[mun_mask]
    mun_soma = mun_dados['hi'][mun_dados['hi']>0].mean()
    mun_name = mun[mun.index == idx]['NM_MUNICIP'].values[0]
    row = [mun_name, mun_soma]
    lista.append(row)

#Transformando a lista em um dataframe
lista_df = pd.DataFrame(lista)

#Salvando o dataframe como um arquivo de texto
lista_df.fillna(0).round(2).to_csv('media_municipios.txt', sep=';', index=False, header=False)
EOF

python3 6h_geo.py
########################################################################
seq -s= 70|tr -d '[:digit:]'
echo "APAGANDO OS ARQUIVOS..."
seq -s= 70|tr -d '[:digit:]'

#rm ultimas_6h.txt
#rm S11636382*
#rm hidro_horario*
#rm acum_horario*
#rm nc_acum.nc
#rm acum_6h*
#rm 6h_geo.py
########################################################################
seq -s= 70|tr -d '[:digit:]'
echo "UPANDO ARQUIVOS..."
seq -s= 70|tr -d '[:digit:]'

lftp -f "
open meteorologia.unifei.edu.br
user meteorologia_temp456 sGm#Pkr9NV
lcd $PATH_name/output
mirror --reverse --verbose $PATH_name/output/6horas produtos/hidroestimador/dados
bye
"

seq -s= 70|tr -d '[:digit:]'
echo "FIM DO UPLOAD..."
seq -s= 70|tr -d '[:digit:]'
