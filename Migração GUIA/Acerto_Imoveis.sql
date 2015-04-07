USE saoroque


/* Desligando campos IDENTITY */
SET IDENTITY_INSERT sertaozinho.dbo.imoveis ON

INSERT INTO sertaozinho.dbo.imoveis (id, categoria, tipo, cidade, endereco, titulo, descricao, cond_pag, area, area_c, quartos, suites, tipo_construcao, salas, ambientes, cozinhas, 
wc, lavabo, piscina, garagem, telefone, varanda, lavanderia, despensa, churrasqueira, campo, quadra, sauna, festas, hospede, caseiro, empregada, lareira, gas, portao, pomar, 
jardim, lago, nascente, riacho, pasto, canil, jogos, data, cod_usuario, views, status, aprovado, valor, pasta, bairro, id_cliente, mapa_google, replicar)
SELECT  id, categoria, tipo, cidade, endereco, titulo, descricao, cond_pag, area, area_c, quartos, suites, tipo_construcao, salas, ambientes, cozinhas, wc, lavabo, piscina, garagem, 
telefone, varanda, lavanderia, despensa, churrasqueira, campo, quadra, sauna, festas, hospede, caseiro, empregada, lareira, gas, portao, pomar, jardim, lago, nascente, riacho, 
pasto, canil, jogos, data, cod_usuario, views, status, aprovado, valor, pasta, bairro, id_cliente, mapa_google, replicar FROM ribeirao.dbo.imoveis
WHERE cidade = 'Sertãozinho'

/* Ativando campos IDENTITY */
SET IDENTITY_INSERT sertaozinho.dbo.imoveis OFF




SET IDENTITY_INSERT varzea.dbo.imoveis_fotos ON

INSERT INTO varzea.dbo.imoveis_fotos(id, id_imovel, destaque, foto,cod_imobiliaria, data, id_externo, diretorio_foto, url_foto, replicar)
SELECT f.id, f.id_imovel, f.destaque, f.foto,cod_imobiliaria, f.data, f.id_externo, f.diretorio_foto, f.url_foto, f.replicar FROM jundiai.dbo.imoveis_fotos f INNER JOIN jundiai.dbo.imoveis i ON f.id_imovel = i.id
WHERE i.cidade = 'Várzea Paulista'

/* Ativando campos IDENTITY */
SET IDENTITY_INSERT varzea.dbo.imoveis_fotos OFF




SET IDENTITY_INSERT sertaozinho.dbo.empregos_vagas ON

INSERT INTO sertaozinho.dbo.empregos_vagas(id_usuario, ramo, porte, titulo, descricao, requisitos, faixa_salarial, beneficios, numero_vagas, tipo_contrato, cidade, horario, data, views, status, revisada, id_cliente, id, data_sistema, replicar)
SELECT id_usuario, ramo, porte, titulo, descricao, requisitos, faixa_salarial, beneficios, numero_vagas, tipo_contrato, cidade, horario, data, views, status, revisada, id_cliente, id, data_sistema, replicar FROM ribeirao.dbo.empregos_vagas 
WHERE cidade = 'Sertãozinho'

/* Ativando campos IDENTITY */
SET IDENTITY_INSERT sertaozinho.dbo.empregos_vagas OFF




SET IDENTITY_INSERT varzea.dbo.anuncios ON

INSERT INTO varzea.dbo.anuncios(id, id_cliente, tipo, c1, c2, c3, c4, c5, c6, logo, titulo, descricao, endereco, numero, complemento, bairro, cidade, estado, cep, telefone, 
email, site, tags, contato, peso, mapa, obs, cliques, data, usuario, pagamento, status, lembrete, empregos, responsavel, c7, c8, c9, c10, c11, c12, c13, c14, c15, views, email2, 
telefone2, telefone3, telefone4, telefone5, telefone6, frase, celular, ligacao, data_ligacao, coletivo, google_plus, facebook, twitter, youtube, horario1, horario2, horario3, 
horario4, forma_pagamento, pagamento_cartao, pagamento_cartao_detalhe, pagamento_cheque, pagamento_cheque_detalhe, pagamento_vale, pagamento_vale_detalhe, pagamento_carne, 
pagamento_carne_detalhe, pagamento_boleto, pagamento_boleto_detalhe, pagamento_outros, pagamento_outros_detalhe, opcional1, opcional2, opcional3, opcional4, opcional5, 
preco, id_banner, codigo, data_txt, id_historico, adulto, id_central, email_promocao, longitude, latitude)
SELECT id, id_cliente, tipo, c1, c2, c3, c4, c5, c6, logo, titulo, descricao, endereco, numero, complemento, bairro, cidade, estado, cep, telefone, 
email, site, tags, contato, peso, mapa, obs, cliques, data, usuario, pagamento, status, lembrete, empregos, responsavel, c7, c8, c9, c10, c11, c12, c13, c14, c15, views, email2, 
telefone2, telefone3, telefone4, telefone5, telefone6, frase, celular, ligacao, data_ligacao, coletivo, google_plus, facebook, twitter, youtube, horario1, horario2, horario3, 
horario4, forma_pagamento, pagamento_cartao, pagamento_cartao_detalhe, pagamento_cheque, pagamento_cheque_detalhe, pagamento_vale, pagamento_vale_detalhe, pagamento_carne, 
pagamento_carne_detalhe, pagamento_boleto, pagamento_boleto_detalhe, pagamento_outros, pagamento_outros_detalhe, opcional1, opcional2, opcional3, opcional4, opcional5, 
preco, id_banner, codigo, data_txt, id_historico, adulto, id_central, email_promocao, longitude, latitude FROM ribeirao.dbo.anuncios 
WHERE cidade = 'Sertãozinho'

/* Ativando campos IDENTITY */
SET IDENTITY_INSERT varzea.dbo.anuncios OFF





SET IDENTITY_INSERT varzea.dbo.anuncios_fotos ON

INSERT INTO varzea.dbo.anuncios_fotos(id, id_anuncio, foto, logo, ordem, diretorio,id_central)
SELECT f.id, f.id_anuncio, f.foto, f.logo, f.ordem, f.diretorio, f.id_central FROM jundiai.dbo.anuncios_fotos f INNER JOIN jundiai.dbo.anuncios a ON f.id_anuncio = a.id
WHERE a.cidade = 'Várzea Paulista'

/* Ativando campos IDENTITY */
SET IDENTITY_INSERT varzea.dbo.anuncios_fotos OFF



update varzea.dbo.anuncios set descricao = REPLACE(descricao, '../../', 'http://www.jundiaionline.com.br/')

exec sp_helptext 'trg_noticia_IUD'

USE saoroque
SELECT OBJECT_NAME(parent_id) as Parent_Object_Name, *
FROM sys.triggers


use varzea

SET IDENTITY_INSERT varzea.dbo.destaques ON
INSERT INTO varzea.dbo.destaques(id, id_categoria, titulo, descricao, url, foto, data, status)
SELECT id, id_categoria, titulo, replace(descricao, 'votorantimfacil', 'varzeafacil'), url, foto, data, status FROM votorantim.dbo.destaques
SET IDENTITY_INSERT varzea.dbo.destaques OFF

update destaques set url = REPLACE(url, 'votorantimfacil', 'varzeafacil')

select * from varzea.dbo.categorias_painel

SET IDENTITY_INSERT varzea.dbo.categorias_painel ON
INSERT INTO varzea.dbo.categorias_painel(id, id_categoria, titulo, url, foto, status, data)
SELECT id, id_categoria, titulo, replace(url, 'votorantimfacil', 'varzeafacil'), foto, status, data FROM votorantim.dbo.categorias_painel
SET IDENTITY_INSERT varzea.dbo.categorias_painel OFF

select top 30 * from jundiai.dbo.eventos order by id desc

SET IDENTITY_INSERT varzea.dbo.eventos ON
INSERT INTO varzea.dbo.eventos(id, titulo, data, data2, dia, mes, ano, dia_semana, miniatura, descricao, resumo, date, local, cadastro, horario, id_anuncio)
SELECT id, titulo, data, data2, dia, mes, ano, dia_semana, miniatura, REPLACE(descricao, '../../../', 'http://www.jundiaionline.com.br/'), resumo, date, local, cadastro, horario, id_anuncio FROM jundiai.dbo.eventos
SET IDENTITY_INSERT varzea.dbo.eventos OFF

update varzea.dbo.eventos set descricao = REPLACE(descricao, '../../', 'http://www.jundiaionline.com.br/')
update varzea.dbo.eventos set descricao = REPLACE(descricao, '../', 'http://www.jundiaionline.com.br/')


