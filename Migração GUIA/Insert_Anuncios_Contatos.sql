

/* Limpando registros e resetando IDENTITY */
TRUNCATE TABLE saoroque.dbo.anuncios_contatos

/* Desligando campos IDENTITY */
SET IDENTITY_INSERT saoroque.dbo.anuncios_contatos ON

INSERT INTO saoroque.dbo.anuncios_contatos (id,nome,email,telefone,cidade,mensagem,email_empresa,email_empresa2,nome_empresa,url,status,data)
SELECT id ,nome ,email ,telefone ,cidade ,mensagem ,email_empresa ,email_empresa2 ,nome_empresa ,url ,status ,data FROM guia1.dbo.anuncios_contatos

/* Ativando campos IDENTITY */
SET IDENTITY_INSERT saoroque.dbo.anuncios_contatos OFF
