USE saoroque

DECLARE @INICIO DATETIME
SELECT @INICIO = GETDATE()

/* Declaração de variáveis */
DECLARE @id_imovel INT
DECLARE @data varchar(20)
DECLARE @imagem1 VARCHAR(250)
DECLARE @imagem2 VARCHAR(250)
DECLARE @imagem3 VARCHAR(250)
DECLARE @imagem4 VARCHAR(250)
DECLARE @imagem5 VARCHAR(250)
DECLARE @imagem6 VARCHAR(250)
DECLARE @imagem7 VARCHAR(250)
DECLARE @imagem8 VARCHAR(250)
DECLARE @imagem9 VARCHAR(250)
DECLARE @imagem10 VARCHAR(250)
DECLARE @imagem11 VARCHAR(250)
DECLARE @imagem12 VARCHAR(250)
DECLARE @imagem13 VARCHAR(250)
DECLARE @imagem14 VARCHAR(250)
DECLARE @imagem15 VARCHAR(250)
DECLARE @imagem16 VARCHAR(250)
DECLARE @imagem17 VARCHAR(250)
DECLARE @imagem18 VARCHAR(250)
DECLARE @imagem19 VARCHAR(250)
DECLARE @imagem20 VARCHAR(250)

/* Cursor para percorrer os nomes dos objetos */
DECLARE cursor_fotos CURSOR FOR
    SELECT id, data, imagem1, imagem2, imagem3, imagem4, imagem5, imagem6, imagem7, imagem8, imagem9, imagem10, imagem11, imagem12, imagem13, imagem14, imagem15, imagem16, imagem17, imagem18, imagem19, imagem20
    FROM guia1.dbo.imoveis

/* Abrindo Cursor para leitura */
OPEN cursor_fotos

/* Lendo a próxima linha */
FETCH NEXT FROM cursor_fotos INTO @id_imovel, @data,@imagem1, @imagem2, @imagem3, @imagem4, @imagem5, @imagem6, @imagem7, @imagem8, @imagem9, @imagem10, @imagem11, @imagem12, @imagem13, @imagem14, @imagem15, @imagem16, @imagem17, @imagem18, @imagem19, @imagem20

/* Limpando registros e resetando IDENTITY */
TRUNCATE TABLE saoroque.dbo.imoveis_fotos

PRINT 'Iniciando extração das fotos'

/* Percorrendo linhas do cursor (enquanto houverem) */
WHILE @@FETCH_STATUS = 0
BEGIN		
	INSERT INTO saoroque.dbo.imoveis_fotos(id_imovel, foto, destaque, data)values(@id_imovel, @imagem1, 'SIM', @data)
	INSERT INTO saoroque.dbo.imoveis_fotos(id_imovel, foto, destaque, data)values(@id_imovel, @imagem2, 'NAO', @data)
	INSERT INTO saoroque.dbo.imoveis_fotos(id_imovel, foto, destaque, data)values(@id_imovel, @imagem3, 'NAO', @data)
	INSERT INTO saoroque.dbo.imoveis_fotos(id_imovel, foto, destaque, data)values(@id_imovel, @imagem4, 'NAO', @data)
	INSERT INTO saoroque.dbo.imoveis_fotos(id_imovel, foto, destaque, data)values(@id_imovel, @imagem5, 'NAO', @data)
	INSERT INTO saoroque.dbo.imoveis_fotos(id_imovel, foto, destaque, data)values(@id_imovel, @imagem6, 'NAO', @data)
	INSERT INTO saoroque.dbo.imoveis_fotos(id_imovel, foto, destaque, data)values(@id_imovel, @imagem7, 'NAO', @data)
	INSERT INTO saoroque.dbo.imoveis_fotos(id_imovel, foto, destaque, data)values(@id_imovel, @imagem8, 'NAO', @data)
	INSERT INTO saoroque.dbo.imoveis_fotos(id_imovel, foto, destaque, data)values(@id_imovel, @imagem9, 'NAO', @data)
	INSERT INTO saoroque.dbo.imoveis_fotos(id_imovel, foto, destaque, data)values(@id_imovel, @imagem10, 'NAO', @data)
	INSERT INTO saoroque.dbo.imoveis_fotos(id_imovel, foto, destaque, data)values(@id_imovel, @imagem11, 'NAO', @data)
	INSERT INTO saoroque.dbo.imoveis_fotos(id_imovel, foto, destaque, data)values(@id_imovel, @imagem12, 'NAO', @data)
	INSERT INTO saoroque.dbo.imoveis_fotos(id_imovel, foto, destaque, data)values(@id_imovel, @imagem13, 'NAO', @data)
	INSERT INTO saoroque.dbo.imoveis_fotos(id_imovel, foto, destaque, data)values(@id_imovel, @imagem14, 'NAO', @data)
	INSERT INTO saoroque.dbo.imoveis_fotos(id_imovel, foto, destaque, data)values(@id_imovel, @imagem15, 'NAO', @data)
	INSERT INTO saoroque.dbo.imoveis_fotos(id_imovel, foto, destaque, data)values(@id_imovel, @imagem16, 'NAO', @data)
	INSERT INTO saoroque.dbo.imoveis_fotos(id_imovel, foto, destaque, data)values(@id_imovel, @imagem17, 'NAO', @data)
	INSERT INTO saoroque.dbo.imoveis_fotos(id_imovel, foto, destaque, data)values(@id_imovel, @imagem18, 'NAO', @data)
	INSERT INTO saoroque.dbo.imoveis_fotos(id_imovel, foto, destaque, data)values(@id_imovel, @imagem19, 'NAO', @data)
	INSERT INTO saoroque.dbo.imoveis_fotos(id_imovel, foto, destaque, data)values(@id_imovel, @imagem20, 'NAO', @data)
	
	 /* Lendo a próxima linha */
	FETCH NEXT FROM cursor_fotos INTO @id_imovel, @data, @imagem1, @imagem2, @imagem3, @imagem4, @imagem5, @imagem6, @imagem7, @imagem8, @imagem9, @imagem10, @imagem11, @imagem12, @imagem13, @imagem14, @imagem15, @imagem16, @imagem17, @imagem18, @imagem19, @imagem20
END

PRINT 'Extração finalizada'

/* Fechando Cursor para leitura */
CLOSE cursor_fotos

/* Desalocando o cursor */
DEALLOCATE cursor_fotos

PRINT 'Limpando imagens padrão'

/* Limpar registros com imagens 'padrao.gif' */
DELETE saoroque.dbo.imoveis_fotos WHERE foto = 'padrao.gif'

SELECT DATEDIFF(SS, @INICIO, GETDATE()) / 60