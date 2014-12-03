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
DECLARE @foto11 VARCHAR(250)
DECLARE @foto12 VARCHAR(250)
DECLARE @foto13 VARCHAR(250)
DECLARE @foto14 VARCHAR(250)
DECLARE @foto15 VARCHAR(250)
DECLARE @foto16 VARCHAR(250)
DECLARE @foto17 VARCHAR(250)
DECLARE @foto18 VARCHAR(250)
DECLARE @foto19 VARCHAR(250)
DECLARE @foto20 VARCHAR(250)

/* Cursor para percorrer os nomes dos objetos */
DECLARE cursor_fotos CURSOR FOR
    SELECT id, logo, foto1, foto2, foto3, foto4, foto5, foto6, foto7, foto8, foto9, foto10, foto11, foto12, foto13, foto14, foto15, foto16, foto17, foto18, foto19, foto20
    FROM guia1.dbo.anuncios

/* Abrindo Cursor para leitura */
OPEN cursor_fotos

/* Lendo a próxima linha */
FETCH NEXT FROM cursor_fotos INTO @id_anuncio, @logo, @foto1, @foto2, @foto3, @foto4, @foto5, @foto6, @foto7, @foto8, @foto9, @foto10, @foto11, @foto12, @foto13, @foto14, @foto15, @foto16, @foto17, @foto18, @foto19, @foto20


/* Limpando registros e resetando IDENTITY */
TRUNCATE TABLE saoroque.dbo.anuncios_fotos

PRINT 'Iniciando extração das fotos'

/* Percorrendo linhas do cursor (enquanto houverem) */
WHILE @@FETCH_STATUS = 0
BEGIN
	 IF @logo <> ''
		INSERT INTO saoroque.dbo.anuncios_fotos(id_anuncio, foto, logo)values(@id_anuncio, @logo, 'SIM')
		
	 INSERT INTO saoroque.dbo.anuncios_fotos(id_anuncio, foto)values(@id_anuncio, @foto1)
	 INSERT INTO saoroque.dbo.anuncios_fotos(id_anuncio, foto)values(@id_anuncio, @foto2)
	 INSERT INTO saoroque.dbo.anuncios_fotos(id_anuncio, foto)values(@id_anuncio, @foto3)
	 INSERT INTO saoroque.dbo.anuncios_fotos(id_anuncio, foto)values(@id_anuncio, @foto4)
	 INSERT INTO saoroque.dbo.anuncios_fotos(id_anuncio, foto)values(@id_anuncio, @foto5)
	 INSERT INTO saoroque.dbo.anuncios_fotos(id_anuncio, foto)values(@id_anuncio, @foto6)
	 INSERT INTO saoroque.dbo.anuncios_fotos(id_anuncio, foto)values(@id_anuncio, @foto7)
	 INSERT INTO saoroque.dbo.anuncios_fotos(id_anuncio, foto)values(@id_anuncio, @foto8)
	 INSERT INTO saoroque.dbo.anuncios_fotos(id_anuncio, foto)values(@id_anuncio, @foto9)
	 INSERT INTO saoroque.dbo.anuncios_fotos(id_anuncio, foto)values(@id_anuncio, @foto10)
	 INSERT INTO saoroque.dbo.anuncios_fotos(id_anuncio, foto)values(@id_anuncio, @foto11)
	 INSERT INTO saoroque.dbo.anuncios_fotos(id_anuncio, foto)values(@id_anuncio, @foto12)
	 INSERT INTO saoroque.dbo.anuncios_fotos(id_anuncio, foto)values(@id_anuncio, @foto13)
	 INSERT INTO saoroque.dbo.anuncios_fotos(id_anuncio, foto)values(@id_anuncio, @foto14)
	 INSERT INTO saoroque.dbo.anuncios_fotos(id_anuncio, foto)values(@id_anuncio, @foto15)
	 INSERT INTO saoroque.dbo.anuncios_fotos(id_anuncio, foto)values(@id_anuncio, @foto16)
	 INSERT INTO saoroque.dbo.anuncios_fotos(id_anuncio, foto)values(@id_anuncio, @foto17)
	 INSERT INTO saoroque.dbo.anuncios_fotos(id_anuncio, foto)values(@id_anuncio, @foto18)
	 INSERT INTO saoroque.dbo.anuncios_fotos(id_anuncio, foto)values(@id_anuncio, @foto19)
	 INSERT INTO saoroque.dbo.anuncios_fotos(id_anuncio, foto)values(@id_anuncio, @foto20)
	
	 /* Lendo a próxima linha */
	FETCH NEXT FROM cursor_fotos INTO @id_anuncio, @logo, @foto1, @foto2, @foto3, @foto4, @foto5, @foto6, @foto7, @foto8, @foto9, @foto10, @foto11, @foto12, @foto13, @foto14, @foto15, @foto16, @foto17, @foto18, @foto19, @foto20
END

PRINT 'Extração finalizada'

/* Fechando Cursor para leitura */
CLOSE cursor_fotos

/* Desalocando o cursor */
DEALLOCATE cursor_fotos

PRINT 'Limpando imagens padrão'

/* Limpar registros com imagens 'padrao.gif' */
DELETE saoroque.dbo.anuncios_fotos WHERE foto = 'padrao.gif'

SELECT DATEDIFF(SS, @INICIO, GETDATE()) / 60