
TRUNCATE TABLE saoroque.dbo.anuncios

SET IDENTITY_INSERT saoroque.dbo.anuncios ON

INSERT INTO saoroque.dbo.anuncios(id, tipo ,c1 ,c2 ,c3 ,c4 ,c5 ,c6 ,titulo ,endereco ,telefone ,telefone2 ,telefone3 ,telefone4 ,telefone5 ,telefone6 ,email ,email2 ,site ,contato ,
descricao ,mapa ,zoom ,responsavel ,status ,visitas ,peso ,frase ,ligacao ,data_ligacao ,latitude ,data_txt)
SELECT  id ,tipo ,c1 ,c2 ,c3 ,c4 ,c5 ,c6 ,titulo ,endereco ,telefone ,telefone2 ,telefone3 ,telefone4 ,telefone5 ,telefone6 ,email ,email2 ,site ,contato ,descricao ,mapa ,zoom,
responsavel ,status ,visitas ,peso , frase ,ligacao ,data_ligacao ,latitude ,data_txt 
FROM guia1.dbo.anuncios

SET IDENTITY_INSERT saoroque.dbo.anuncios OFF