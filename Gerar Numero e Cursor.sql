/* Declaração de variáveis */
DECLARE @Upper INT
DECLARE @Lower INT
DECLARE @id INT
DECLARE @CampCodigo VARCHAR(10)
DECLARE @Codigo VARCHAR(10)
DECLARE @TempCodigo VARCHAR(10)  
DECLARE @Exit CHAR(1) 

/* Inicialização das variáveis */
SET @Lower = 1
SET @Upper = 999999

/* Cursor para percorrer os nomes dos objetos */
DECLARE cursor_anuncios CURSOR FOR
    SELECT id
    FROM anuncios

/* Abrindo Cursor para leitura */
OPEN cursor_anuncios

/* Lendo a próxima linha */
FETCH NEXT FROM cursor_anuncios INTO @id

/* Percorrendo linhas do cursor (enquanto houverem) */
WHILE @@FETCH_STATUS = 0
BEGIN
        /* Inicializa variável com 'N' */
        SET @Exit = 'N'

        /* Loop roda enquanto o código existir */
        WHILE @Exit = 'N'
        BEGIN 
                /* Limpa as variáveis */
                SET @TempCodigo = NULL
                SET @Codigo = NULL
        
                /* Gera o código aleatório com 6 digitos */
                SELECT @Codigo = RIGHT('00000'+ CONVERT(VARCHAR,Cast((@Upper - @Lower -1) * RAND(CAST( NEWID() AS varbinary )) + @Lower as Int)),6)
                
                /* Verifica se o código já existe na tabela */
                SELECT @TempCodigo = codigo FROM anuncios WHERE codigo = @Codigo
                
                /* Se TempCodigo igual NULL o código gerado ainda não existe, seta 'S' para sair do loop */
                IF @TempCodigo IS NULL
                BEGIN
                     SET @Exit = 'S'
                END
        END
        
        /* Atuliza campo código na tabela */
        UPDATE anuncios SET codigo = @Codigo WHERE id = @id
        
        /* Lendo a próxima linha */
        FETCH NEXT FROM cursor_anuncios INTO @id
END

/* Fechando Cursor para leitura */
CLOSE cursor_anuncios

/* Desalocando o cursor */
DEALLOCATE cursor_anuncios

