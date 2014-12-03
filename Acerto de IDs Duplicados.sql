/* Declaração de variáveis */
DECLARE @id_anuncio INT
DECLARE @cont INT
DECLARE @c1 VARCHAR(250)
DECLARE @c2 VARCHAR(250)
DECLARE @c3 VARCHAR(250)
DECLARE @c4 VARCHAR(250)
DECLARE @c5 VARCHAR(250)
DECLARE @c6 VARCHAR(250)
DECLARE @c7 VARCHAR(250)
DECLARE @c8 VARCHAR(250)
DECLARE @c9 VARCHAR(250)
DECLARE @c10 VARCHAR(250)
DECLARE @c11 VARCHAR(250)
DECLARE @c12 VARCHAR(250)
DECLARE @c13 VARCHAR(250)
DECLARE @c14 VARCHAR(250)
DECLARE @c15 VARCHAR(250)

/* Cursor para percorrer os nomes dos objetos */
DECLARE cursor_anuncios CURSOR FOR
    SELECT id, c1, c2, c3, c4, c5, c6, c7, c8, c9, c10, c11, c12, c13, c14, c15
    FROM saoroque.dbo.anuncios

/* Abrindo Cursor para leitura */
OPEN cursor_anuncios
SET @cont = 0

/* Lendo a próxima linha */
FETCH NEXT FROM cursor_anuncios INTO @id_anuncio, @c1, @c2, @c3, @c4, @c5, @c6, @c7, @c8, @c9, @c10, @c11, @c12, @c13, @c14, @c15

IF OBJECT_ID('tempdb..#TEMP_SUBS') IS NOT NULL
BEGIN
		DROP TABLE #TEMP_SUBS
END

CREATE TABLE #TEMP_SUBS(
	   anuncio INT,
	   sub VARCHAR(10),
	   id_sub INT
)

/* Percorrendo linhas do cursor (enquanto houverem) */
WHILE @@FETCH_STATUS = 0
BEGIN
	 IF @c1 <> 0 
	 BEGIN
		SELECT @cont = COUNT(*) FROM subs WHERE id = @c1
		IF @cont <= 0 INSERT INTO #TEMP_SUBS(anuncio, sub, id_sub)VALUES(@id_anuncio, 'C1', @c1) 
	 END 
	 
	 IF @c2 <> 0 
	 BEGIN
		SELECT @cont = COUNT(*) FROM subs WHERE id = @c2
		IF @cont <= 0 INSERT INTO #TEMP_SUBS(anuncio, sub, id_sub)VALUES(@id_anuncio, 'C2', @c2) 
	 END 
	 
	 IF @c3 <> 0 
	 BEGIN
		SELECT @cont = COUNT(*) FROM subs WHERE id = @c3
		IF @cont <= 0 INSERT INTO #TEMP_SUBS(anuncio, sub, id_sub)VALUES(@id_anuncio, 'C3', @c3) 
	 END 
	 
	 IF @c4 <> 0 
	 BEGIN
		SELECT @cont = COUNT(*) FROM subs WHERE id = @c4
		IF @cont <= 0 INSERT INTO #TEMP_SUBS(anuncio, sub, id_sub)VALUES(@id_anuncio, 'C4', @c4) 
	 END 
	 
	 
	 IF @c5 <> 0 
	 BEGIN
		SELECT @cont = COUNT(*) FROM subs WHERE id = @c5
		IF @cont <= 0 INSERT INTO #TEMP_SUBS(anuncio, sub, id_sub)VALUES(@id_anuncio, 'C5', @c5) 
	 END 
	 
	 IF @c6 <> 0 
	 BEGIN
		SELECT @cont = COUNT(*) FROM subs WHERE id = @c6
		IF @cont <= 0 INSERT INTO #TEMP_SUBS(anuncio, sub, id_sub)VALUES(@id_anuncio, 'C6', @c6) 
	 END 
	 
	 IF @c7 <> 0 
	 BEGIN
		SELECT @cont = COUNT(*) FROM subs WHERE id = @c7
		IF @cont <= 0 INSERT INTO #TEMP_SUBS(anuncio, sub, id_sub)VALUES(@id_anuncio, 'C7', @c7) 
	 END 
	 
	 IF @c8 <> 0 
	 BEGIN
		SELECT @cont = COUNT(*) FROM subs WHERE id = @c8
		IF @cont <= 0 INSERT INTO #TEMP_SUBS(anuncio, sub, id_sub)VALUES(@id_anuncio, 'C8', @c8) 
	 END 
	 
	 
	 IF @c9 <> 0 
	 BEGIN
		SELECT @cont = COUNT(*) FROM subs WHERE id = @c9
		IF @cont <= 0 INSERT INTO #TEMP_SUBS(anuncio, sub, id_sub)VALUES(@id_anuncio, 'C9', @c9) 
	 END 
	 
	 IF @c10 <> 0 
	 BEGIN
		SELECT @cont = COUNT(*) FROM subs WHERE id = @c10
		IF @cont <= 0 INSERT INTO #TEMP_SUBS(anuncio, sub, id_sub)VALUES(@id_anuncio, 'C10', @c10) 
	 END 
	 
	 IF @c11 <> 0 
	 BEGIN
		SELECT @cont = COUNT(*) FROM subs WHERE id = @c11
		IF @cont <= 0 INSERT INTO #TEMP_SUBS(anuncio, sub, id_sub)VALUES(@id_anuncio, 'C11', @c11) 
	 END 
	 
	 IF @c12 <> 0 
	 BEGIN
		SELECT @cont = COUNT(*) FROM subs WHERE id = @c12
		IF @cont <= 0 INSERT INTO #TEMP_SUBS(anuncio, sub, id_sub)VALUES(@id_anuncio, 'C12', @c12) 
	 END 
	 
	 IF @c13 <> 0 
	 BEGIN
		SELECT @cont = COUNT(*) FROM subs WHERE id = @c13
		IF @cont <= 0 INSERT INTO #TEMP_SUBS(anuncio, sub, id_sub)VALUES(@id_anuncio, 'C13', @c13) 
	 END 
	 
	 IF @c14 <> 0 
	 BEGIN
		SELECT @cont = COUNT(*) FROM subs WHERE id = @c14
		IF @cont <= 0 INSERT INTO #TEMP_SUBS(anuncio, sub, id_sub)VALUES(@id_anuncio, 'C14', @c14) 
	 END 
	 
	 IF @c15 <> 0 
	 BEGIN
		SELECT @cont = COUNT(*) FROM subs WHERE id = @c15
		IF @cont <= 0 INSERT INTO #TEMP_SUBS(anuncio, sub, id_sub)VALUES(@id_anuncio, 'C15', @c15) 
	 END 
		 	
	
	 /* Lendo a próxima linha */
	FETCH NEXT FROM cursor_anuncios INTO @id_anuncio, @c1, @c2, @c3, @c4, @c5, @c6, @c7, @c8, @c9, @c10, @c11, @c12, @c13, @c14, @c15
END

/* Fechando Cursor para leitura */
CLOSE cursor_anuncios

/* Desalocando o cursor */
DEALLOCATE cursor_anuncios

SELECT * FROM #TEMP_SUBS