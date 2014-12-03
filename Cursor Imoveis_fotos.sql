/* Declaração de variáveis */
DECLARE @id_imovel INT
DECLARE @destaque VARCHAR(50)
DECLARE @foto VARCHAR(250)
DECLARE @cod_imobiliaria INT
DECLARE @data VARCHAR(10)
DECLARE @id_externo INT
DECLARE @diretorio_foto VARCHAR(100)
DECLARE @url_foto VARCHAR(900)

/* Cursor para percorrer os nomes das fotos */
DECLARE cursor_fotos CURSOR FOR
	WITH Paginado AS  
	(SELECT ROW_NUMBER() OVER(ORDER BY id) AS linha, id_imovel, destaque, foto, cod_imobiliaria, data, id_externo, diretorio_foto, url_foto FROM jundiai.dbo.imoveis_fotos)
	SELECT TOP (10000) id_imovel, destaque, foto, cod_imobiliaria, data, id_externo, diretorio_foto, url_foto 
	FROM Paginado p  
	WHERE linha > 10000 * (6 - 1)
	
/* Abrindo Cursor para leitura */
OPEN cursor_fotos

/* Lendo a próxima linha */
FETCH NEXT FROM cursor_fotos INTO @id_imovel, @destaque, @foto, @cod_imobiliaria, @data, @id_externo, @diretorio_foto, @url_foto 

/* Percorrendo linhas do cursor (enquanto houverem) */
WHILE @@FETCH_STATUS = 0
BEGIN
	
	/* Inseri os registros */
	INSERT INTO jundiai.dbo.imoveis_fotos2 (id_imovel, destaque, foto, cod_imobiliaria, data, id_externo, diretorio_foto, url_foto)VALUES
								(@id_imovel, @destaque, @foto, @cod_imobiliaria, @data, @id_externo, @diretorio_foto, @url_foto)
	
	/* Lendo a próxima linha */
	FETCH NEXT FROM cursor_fotos INTO @id_imovel, @destaque, @foto, @cod_imobiliaria, @data, @id_externo, @diretorio_foto, @url_foto 
END

/* Fechando Cursor para leitura */
CLOSE cursor_fotos

/* Desalocando o cursor */
DEALLOCATE cursor_fotos