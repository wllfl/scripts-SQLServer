
/* Limpando registros e resetando IDENTITY */
TRUNCATE TABLE saoroque.dbo.imoveis_contato

/* Desligando campos IDENTITY */
SET IDENTITY_INSERT saoroque.dbo.imoveis_contato ON

INSERT INTO saoroque.dbo.imoveis_contato (id,imobiliaria,email_imob,nome,email,telefone,mensagem,data,id_imovel,status)
SELECT id,imobiliaria,email_imob,nome,email,telefone,mensagem,data,id_imovel,status FROM guia1.dbo.imoveis_contato

/* Ativando campos IDENTITY */
SET IDENTITY_INSERT saoroque.dbo.imoveis_contato OFF

/* Inserir id da imobiliária nos contatos */
UPDATE saoroque.dbo.imoveis_contato SET cod_imobiliaria = a.id FROM saoroque.dbo.imoveis_contato c INNER JOIN saoroque.dbo.imoveis_clientes a ON c.imobiliaria = a.nome