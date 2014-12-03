USE saoroque

DECLARE @INICIO DATETIME
SELECT @INICIO = GETDATE()

/* Declaração de variáveis */
DECLARE @id_anuncio INT
DECLARE @logo VARCHAR(250)
DECLARE @foto1 VARCHAR(250)
DECLARE @foto2 VARCHAR(250)
DECLARE @foto3 VARCHAR(250)
DECLARE @foto4 VARCHAR(250)
DECLARE @foto5 VARCHAR(250)
DECLARE @foto6 VARCHAR(250)
DECLARE @foto7 VARCHAR(250)
DECLARE @foto8 VARCHAR(250)
DECLARE @foto9 VARCHAR(250)
DECLARE @foto10 VARCHAR(250)

/* Cursor para percorrer os nomes dos objetos */
DECLARE cursor_fotos CURSOR FOR
    SELECT s.id, i.logo, i.foto1, i.foto2, i.foto3, i.foto4, i.foto5, i.foto6, i.foto7, i.foto8, i.foto9, i.foto10
    FROM imobiliaria.dbo.anuncios i INNER JOIN saoroque.dbo.anuncios s ON i.titulo = s.titulo
    WHERE s.id >= 3608

/* Abrindo Cursor para leitura */
OPEN cursor_fotos

/* Lendo a próxima linha */
FETCH NEXT FROM cursor_fotos INTO @id_anuncio, @logo, @foto1, @foto2, @foto3, @foto4, @foto5, @foto6, @foto7, @foto8, @foto9, @foto10


/* Limpando registros e resetando IDENTITY */
--TRUNCATE TABLE saoroque.dbo.anuncios_fotos

PRINT 'Iniciando extração das fotos'

/* Percorrendo linhas do cursor (enquanto houverem) */
WHILE @@FETCH_STATUS = 0
BEGIN
	 IF @logo <> ''
		INSERT INTO saoroque.dbo.anuncios_fotos(id_anuncio, foto, logo)values(@id_anuncio, 'turismo_'+@logo, 'SIM')
		
	 INSERT INTO saoroque.dbo.anuncios_fotos(id_anuncio, foto)values(@id_anuncio, 'turismo_'+@foto1)
	 INSERT INTO saoroque.dbo.anuncios_fotos(id_anuncio, foto)values(@id_anuncio, 'turismo_'+@foto2)
	 INSERT INTO saoroque.dbo.anuncios_fotos(id_anuncio, foto)values(@id_anuncio, 'turismo_'+@foto3)
	 INSERT INTO saoroque.dbo.anuncios_fotos(id_anuncio, foto)values(@id_anuncio, 'turismo_'+@foto4)
	 INSERT INTO saoroque.dbo.anuncios_fotos(id_anuncio, foto)values(@id_anuncio, 'turismo_'+@foto5)
	 INSERT INTO saoroque.dbo.anuncios_fotos(id_anuncio, foto)values(@id_anuncio, 'turismo_'+@foto6)
	 INSERT INTO saoroque.dbo.anuncios_fotos(id_anuncio, foto)values(@id_anuncio, 'turismo_'+@foto7)
	 INSERT INTO saoroque.dbo.anuncios_fotos(id_anuncio, foto)values(@id_anuncio, 'turismo_'+@foto8)
	 INSERT INTO saoroque.dbo.anuncios_fotos(id_anuncio, foto)values(@id_anuncio, 'turismo_'+@foto9)
	 INSERT INTO saoroque.dbo.anuncios_fotos(id_anuncio, foto)values(@id_anuncio, 'turismo_'+@foto10)
	
	 /* Lendo a próxima linha */
	FETCH NEXT FROM cursor_fotos INTO @id_anuncio, @logo, @foto1, @foto2, @foto3, @foto4, @foto5, @foto6, @foto7, @foto8, @foto9, @foto10
END

PRINT 'Extração finalizada'

/* Fechando Cursor para leitura */
CLOSE cursor_fotos

/* Desalocando o cursor */
DEALLOCATE cursor_fotos

PRINT 'Limpando imagens padrão'

/* Limpar registros com imagens 'padrao.gif' */
DELETE saoroque.dbo.anuncios_fotos WHERE foto = 'turismo_padrao.gif'

SELECT DATEDIFF(SS, @INICIO, GETDATE()) / 60