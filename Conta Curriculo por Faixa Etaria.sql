/* Verifica se a tabela temporária já existe, se verdadeiro exclui a tabela */
IF OBJECT_ID('tempdb..#TEMP_IDADE') IS NOT NULL
BEGIN
        DROP TABLE #TEMP_IDADE
END

/* Cria tabela temporária */
CREATE TABLE #TEMP_IDADE(
       IDADE INT,
)

DECLARE @data VARCHAR(20)
DECLARE @idade INT
DECLARE @id INT
DECLARE @qtde INT
DECLARE @validacao INT 

/* Cursor para percorrer os nomes dos objetos */
DECLARE cursor_curriculos CURSOR FOR
    SELECT id, nascimento
    FROM empregos_curriculos
    WHERE nascimento <> '' AND nascimento is not null AND ISNUMERIC(REPLACE(nascimento, '/','')) = 1 AND
    (substring(nascimento, 1, 2) > 0 AND substring(nascimento, 1, 2) <= 31) AND 
    (substring(nascimento, 4, 2) <= 12 AND substring(nascimento, 4, 2) > 0)

/* Abrindo Cursor para leitura */
OPEN cursor_curriculos

/* Lendo a próxima linha */
FETCH NEXT FROM cursor_curriculos INTO @id, @data

SET @validacao = 0

/* Percorrendo linhas do cursor (enquanto houverem) */
WHILE @@FETCH_STATUS = 0
BEGIN
     SET @validacao = dbo.CountCaracter('/', @data) 
    
     IF @validacao = 2 
     BEGIN
             IF LEN(@data) = 8
             BEGIN
                select @idade = datediff(year, convert(date, nascimento, 3), getDate()) from empregos_curriculos where id = @id 
             END 
             ELSE IF LEN(@data) = 10
             BEGIN
                select @idade = datediff(year, convert(date, nascimento, 103), getDate()) from empregos_curriculos where id = @id 
             END
             
             INSERT INTO #TEMP_IDADE(IDADE)VALUES(@idade)
     END
     
     /* Lendo a próxima linha */
     FETCH NEXT FROM cursor_curriculos INTO @id, @data    
END

/* Fechando Cursor para leitura */
CLOSE cursor_curriculos

/* Desalocando o cursor */
DEALLOCATE cursor_curriculos

/* Verifica se a tabela temporária já existe, se verdadeiro exclui a tabela */
IF OBJECT_ID('tempdb..#TEMP_FAIXA') IS NOT NULL
BEGIN
        DROP TABLE #TEMP_FAIXA
END

/* Cria tabela temporária */
CREATE TABLE #TEMP_FAIXA(
       FAIXA VARCHAR(30),
       QTDE INT DEFAULT 0
)

INSERT #TEMP_FAIXA(FAIXA)VALUES('-18')
INSERT #TEMP_FAIXA(FAIXA)VALUES('18 - 25')
INSERT #TEMP_FAIXA(FAIXA)VALUES('26 - 35')
INSERT #TEMP_FAIXA(FAIXA)VALUES('36 - 45')
INSERT #TEMP_FAIXA(FAIXA)VALUES('46 - 60')
INSERT #TEMP_FAIXA(FAIXA)VALUES('+60')

/* Cursor para percorrer os nomes dos objetos */
DECLARE cursor_idade CURSOR FOR
    SELECT IDADE, COUNT(*) as total
    FROM #TEMP_IDADE
    GROUP BY IDADE

/* Abrindo Cursor para leitura */
OPEN cursor_idade

/* Lendo a próxima linha */
FETCH NEXT FROM cursor_idade INTO @idade, @qtde

/* Percorrendo linhas do cursor (enquanto houverem) */
WHILE @@FETCH_STATUS = 0
BEGIN
   IF @idade < 18
   BEGIN
        UPDATE #TEMP_FAIXA SET QTDE = QTDE + @qtde WHERE FAIXA = '-18'
   END
   ELSE IF @idade >= 18 AND @idade <= 25
   BEGIN
        UPDATE #TEMP_FAIXA SET QTDE = QTDE + @qtde WHERE FAIXA = '18 - 25'
   END
   ELSE IF @idade >= 26 AND @idade <= 35
   BEGIN
        UPDATE #TEMP_FAIXA SET QTDE = QTDE + @qtde WHERE FAIXA = '26 - 35'
   END IF @idade >= 36 AND @idade <= 45
   BEGIN
        UPDATE #TEMP_FAIXA SET QTDE = QTDE + @qtde WHERE FAIXA = '36 - 45'
   END IF @idade >= 46 AND @idade <= 60
   BEGIN
        UPDATE #TEMP_FAIXA SET QTDE = QTDE + @qtde WHERE FAIXA = '46 - 60'
   END IF @idade > 60
   BEGIN
         UPDATE #TEMP_FAIXA SET QTDE = QTDE + @qtde WHERE FAIXA = '+60'
   END
   
   /* Lendo a próxima linha */
   FETCH NEXT FROM cursor_idade INTO @idade, @qtde   
END

/* Fechando Cursor para leitura */
CLOSE cursor_idade

/* Desalocando o cursor */
DEALLOCATE cursor_idade

SELECT * FROM #TEMP_FAIXA

/* Verifica se a tabela temporária já existe, se verdadeiro exclui a tabela */
IF OBJECT_ID('tempdb..#TEMP_FAIXA') IS NOT NULL
BEGIN
        DROP TABLE #TEMP_FAIXA
END

/* Verifica se a tabela temporária já existe, se verdadeiro exclui a tabela */
IF OBJECT_ID('tempdb..#TEMP_IDADE') IS NOT NULL
BEGIN
        DROP TABLE #TEMP_IDADE
END

