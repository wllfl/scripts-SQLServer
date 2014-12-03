USE saoroque

/* Inserir id do an�ncio nos contatos */
UPDATE saoroque.dbo.anuncios_contatos SET id_anuncio = a.id FROM saoroque.dbo.anuncios_contatos c INNER JOIN saoroque.dbo.anuncios a ON c.nome_empresa = a.titulo


/* Inserir id da imobili�ria nos contatos */
UPDATE saoroque.dbo.imoveis_contato SET cod_imobiliaria = a.id FROM saoroque.dbo.imoveis_contato c INNER JOIN saoroque.dbo.imoveis_clientes a ON c.imobiliaria = a.nome