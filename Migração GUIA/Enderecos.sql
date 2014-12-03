use guia2

--select top 50 endereco from anuncios

-- SEPARA RUA DO ENDEREÇO
-- select endereco, substring(endereco, 1, charindex(',', endereco)) from anuncios
--update anuncios set temp_rua = substring(endereco, 1, charindex(',', endereco)) from anuncios
--update anuncios set temp_rua = replace(temp_rua, ',', '')


select endereco, substring(endereco, charindex(', ', endereco), charindex('–', endereco)) 
from anuncios where ISNUMERIC(substring(endereco, charindex(', ', endereco), charindex('–', endereco))) = 1

update anuncios set temp_numero = substring(endereco, charindex(',', endereco), charindex(' ', endereco)) 
from anuncios where ISNUMERIC(substring(endereco, charindex(',', endereco), charindex(' ', endereco))) = 1

update anuncios set temp_numero = replace(temp_numero, ',', '')



select endereco, temp_rua, temp_numero from anuncios

Rua Capitão José Vicente de Moraes, 37 - Centro - São Roque/SP (ao lado do fórum) 
Av. Tiradentes, 270 – Sala 03, Centro – São Roque

use saoroque

SELECT id, titulo, destaque, area, descricao, quartos, cidade, categoria, tipo, valor
FROM imoveis where cod_usuario='81' and categoria='Apartamento' and aprovado='SIM' AND status = 'Ativo' order by id desc

SELECT foto FROM imoveis_fotos WHERE id_imovel = 13625 AND destaque = 'SIM'