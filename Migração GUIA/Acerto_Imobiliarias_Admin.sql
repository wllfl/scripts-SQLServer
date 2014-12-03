USE saoroque

/* Limpando registros e resetando IDENTITY */
TRUNCATE TABLE saoroque.dbo.admin_imobiliaria

/* Desligando campos IDENTITY */
--SET IDENTITY_INSERT saoroque.dbo.admin_imobiliaria ON

/* Usu�rios JZ */
INSERT INTO saoroque.dbo.admin_imobiliaria (id_imobiliaria, login, senha, nivel, nome, tipo, email, creci, endereco, cidade, estado)
SELECT 37, login ,senha ,nivel ,nome ,tipo ,email ,creci ,endereco ,cidade ,estado FROM imobiliaria.dbo.admin

/* Usu�rios CGI */
INSERT INTO saoroque.dbo.admin_imobiliaria (id_imobiliaria, login, senha, nivel, nome, tipo, email, status)
SELECT 18, login ,senha ,nivel ,nome ,tipo ,email ,status FROM guia1.dbo.imoveis_admincasa

/* Usu�rios VIT�RIO */
INSERT INTO saoroque.dbo.admin_imobiliaria (id_imobiliaria, login, senha, nivel, nome, tipo, email, status)
SELECT 81, login ,senha ,nivel ,nome ,tipo ,email ,status FROM guia1.dbo.imoveis_adminvitorio

/* Usu�rios ANOVA */
INSERT INTO saoroque.dbo.admin_imobiliaria (id_imobiliaria, login, senha, nivel, nome, tipo, email, status)
SELECT 77, login ,senha ,nivel ,nome ,tipo ,email, status FROM guia1.dbo.imoveis_adminnova

/* Usu�rios MORADA DO SOL */
INSERT INTO saoroque.dbo.admin_imobiliaria (id_imobiliaria, login, senha, nivel, nome, tipo, email, status)
SELECT 31, login ,senha ,nivel ,nome ,tipo ,email, status FROM guia1.dbo.imoveis_adminmorada

/* Ativando campos IDENTITY */
--SET IDENTITY_INSERT saoroque.dbo.admin_imobiliaria OFF