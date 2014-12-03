USE saoroque

/* Limpando registros e resetando IDENTITY */
TRUNCATE TABLE saoroque.dbo.imoveis_clientes

/* Desligando campos IDENTITY */
SET IDENTITY_INSERT saoroque.dbo.imoveis_clientes ON

INSERT INTO saoroque.dbo.imoveis_clientes (id ,login ,email ,nome ,responsavel ,endereco ,telefone ,logo ,creci ,limite ,tipo ,data ,status ,marca ,nivel ,senha2)
SELECT id ,login ,email ,nome ,responsavel ,endereco ,telefone ,logo ,creci ,limite ,tipo ,data ,status ,marca ,nivel ,senha FROM guia1.dbo.imoveis_clientes

/* Ativando campos IDENTITY */
SET IDENTITY_INSERT saoroque.dbo.imoveis_clientes OFF

/* Criptografando as senhas em MD5 */
UPDATE saoroque.dbo.imoveis_clientes SET senha = SUBSTRING(sys.fn_sqlvarbasetostr(HASHBYTES('MD5', senha2)),3,32)

/* Acertando campo diretorio */
UPDATE saoroque.dbo.imoveis_clientes SET diretorio = 'http://www.votorantimfacil.com.br/imoveis/fotos'

/* Acertando campo Tipo */
UPDATE saoroque.dbo.imoveis_clientes SET tipo = 'Imobiliaria' WHERE tipo = 'imobiliaria'
UPDATE saoroque.dbo.imoveis_clientes SET tipo = 'Pessoa Física' WHERE tipo = 'pessoa fisica'