
/* Verifica se a tabela temporária já existe, se verdadeiro exclui a tabela */
IF OBJECT_ID('tempdb..#TEMP_QTDE') IS NOT NULL
BEGIN
        DROP TABLE #TEMP_QTDE
END

/* Cria tabela temporária */
CREATE TABLE #TEMP_QTDE(
        N_CAMPANHA INT,
        QTDE_SUBS INT
)

/* Declaração de variáveis */
DECLARE @campanha INT
DECLARE @qtde INT

/* Cursor para percorrer os nomes dos objetos */
DECLARE cursor_subs CURSOR FOR
    SELECT n_campanha FROM subs a 
    EXCEPT SELECT id FROM banners b

/* Abrindo Cursor para leitura */
OPEN cursor_subs

/* Lendo a próxima linha */
FETCH NEXT FROM cursor_subs INTO @campanha

/* Percorrendo linhas do cursor (enquanto houverem) */
WHILE @@FETCH_STATUS = 0
BEGIN

     /* Conta quantas subs estão na mesma campanha*/
     SELECT @qtde = count(*) FROM subs WHERE n_campanha = @campanha
     
     /* Inseri na tabela temporária */
     INSERT INTO #TEMP_QTDE(N_CAMPANHA, QTDE_SUBS)VALUES(@campanha, @qtde)
     
      /* Lendo a próxima linha */
     FETCH NEXT FROM cursor_subs INTO @campanha
END

/* Fechando Cursor para leitura */
CLOSE cursor_subs

/* Desalocando o cursor */
DEALLOCATE cursor_subs

/* Retorna os dados da tabela temporária */
SELECT * FROM #TEMP_QTDE

