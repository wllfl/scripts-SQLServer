/* Limpando registros e resetando IDENTITY */
TRUNCATE TABLE saoroque.dbo.empregos_contatos

/* Desligando campos IDENTITY */
SET IDENTITY_INSERT saoroque.dbo.empregos_contatos ON

INSERT INTO saoroque.dbo.empregos_contatos (id, cod_vaga, cod_cliente, nome, telefone, email, data, curriculo)
SELECT id, cod_vaga, cod_cliente, nome, telefone, email, data, curriculo FROM guia1.dbo.contatos_empregos

/* Ativando campos IDENTITY */
SET IDENTITY_INSERT saoroque.dbo.empregos_contatos OFF
