
/* Limpando registros e resetando IDENTITY */
TRUNCATE TABLE saoroque.dbo.cadastro

/* Desligando campos IDENTITY */
SET IDENTITY_INSERT saoroque.dbo.cadastro ON

INSERT INTO saoroque.dbo.cadastro ( id ,nome_empresa ,cnpj ,cep ,endereco ,numero ,complemento ,bairro ,cidade ,email_empresa ,
telefone_empresa ,telefone_opcional ,servicos ,nome_responsavel ,email_responsavel ,data ,status ,facebook ,site)
SELECT  id ,nome_empresa ,cnpj ,cep ,endereco ,numero ,complemento ,bairro ,cidade ,email_empresa ,telefone_empresa ,
telefone_opcional ,servicos ,nome_responsavel ,email_responsavel ,data ,status ,facebook ,site FROM guia1.dbo.cadastro

/* Ativando campos IDENTITY */
SET IDENTITY_INSERT saoroque.dbo.cadastro OFF