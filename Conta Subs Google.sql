
/* Declaração de variáveis */
DECLARE @id_google INT
DECLARE @qtde INT
DECLARE @qtde_excluida INT
DECLARE @qtde_google INT
DECLARE @campanha INT
DECLARE @total INT

/* Inicializa a variável */
SET @qtde_excluida = 0
SET @qtde_google = 0
SET @qtde = 0
SET @total = 0

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
     
     /* Atribui valor acumulativo*/
     SET @qtde_excluida = @qtde_excluida + @qtde
     
      /* Lendo a próxima linha */
     FETCH NEXT FROM cursor_subs INTO @campanha
END

/* Fechando Cursor para leitura */
CLOSE cursor_subs

/* Desalocando o cursor */
DEALLOCATE cursor_subs

/* Captura o id do banner Google */
SELECT @id_google = id FROM banners WHERE titulo = '_Google'

/* Conta quantos registros são do Google */
SELECT @qtde_google = COUNT(*) FROM subs WHERE campanha = '_Google' OR n_campanha = @id_google

/* Finaliza somando os totalizadores */
SET @total = @qtde_excluida + @qtde_google

SELECT @total As RETORNO





