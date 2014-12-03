/* Limpando registros e resetando IDENTITY */
TRUNCATE TABLE saoroque.dbo.empregos_clientes

/* Desligando campos IDENTITY */
SET IDENTITY_INSERT saoroque.dbo.empregos_clientes ON

INSERT INTO saoroque.dbo.empregos_clientes(id ,email ,senha2 ,nome ,status ,nivel ,tipo)
SELECT id, email, senha, nome, status, nivel, tipo FROM guia1.dbo.empregos_admin

/* Ativando campos IDENTITY */
SET IDENTITY_INSERT saoroque.dbo.empregos_clientes OFF

/* Criptografando as senhas em MD5 */
UPDATE saoroque.dbo.empregos_clientes SET senha = SUBSTRING(sys.fn_sqlvarbasetostr(HASHBYTES('MD5', senha2)),3,32)