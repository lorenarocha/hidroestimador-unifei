# Estimativa de Precipitação por Satélite (algoritmo Hidroestimador)

<div align="justify">

Trabalho decorrente da disciplina "Ferramentas de Previsão de Curtíssimo Prazo (<i>nowcasting</i>) pertencente ao curso de graduação em Ciências Atmosféricas da Universidade Federal de Itajubá (Unifei).

O  Hidroestimador  tem  como  principal característica estimar precipitação empregando-se da temperatura do canal infravermelho do satélite GOES-16. 

O objetivo deste projeto foi montar e operacionalizar um produto de estimativa de precipitação por satélite contextualizado para a região de Itajubá. A operação está disponível no site do curso [Ciências  Atmosféricas](https://meteorologia.unifei.edu.br) desde o ano de 2020, com o objetivo de auxiliar moradores, Defesa Civil, tomadores de decisão e agricultores locais com essa informação.

A partir de arquivos binários do Hidroestimador obtidos pelo Centro de Previsão de Tempo e Estudos Climáticos (CPTEC), tem-se:
- imagem instântanea para todo o Brasil
- imagens setorizadas das 5 regiões do país
- imagem para o estado de Minas Gerais
- imagem da precipitação acumulada diária no Brasil
- tabela com os acumulados de precipitação das últimas 6 horas para cada município do sul de Minas Gerais

Para a utilização do produto, é necessário ter pré-instalado os seguintes recursos, além de acesso à Internet: 
- <i>software</i> CDO
- <i>software</i> GrADS
- Python com os módulos: geopandas, xarray, pandas
- Linguagem Shell

O repositório está dividido em três diretórios, que tem a função de guardar os dados de entrada e imagens criadas. O diagrama do produto pode ser visualizado abaixo:

<img src="img\descricao.png">

O [produto](https://meteorologia.unifei.edu.br/produtos/hidroestimador/) está em operação no site de Meteorologia da Unifei, com as três formas de visualizar dados de precipitação, atualizados a cada 10 minutos.

<img src="img\operacao.png">

Para maiores informações e todo o produto detalhado, acesse o [manual](hidroestimador.pdf).

\
Autores:

[Lorena B. da Rocha](mailto:lore.bezerra.r@gmail.com) \
[Jefferson M. Cassemiro](mailto:cassemirojefferson@gmail.com)


</div>