USE saoroque

DECLARE @INICIO DATETIME
SELECT @INICIO = GETDATE()

/* Declara��o de vari�veis */
DECLARE @id_curriculo INT
DECLARE @saoroque VARCHAR(250)
DECLARE @sorocaba VARCHAR(250)
DECLARE @mairinque VARCHAR(250)
DECLARE @aluminio VARCHAR(250)
DECLARE @aracariguama VARCHAR(250)
DECLARE @votorantim VARCHAR(250)
DECLARE @piedade VARCHAR(250)
DECLARE @ibiuna VARCHAR(250)
DECLARE @cotia VARCHAR(250)
DECLARE @vargem_grande VARCHAR(250)
DECLARE @cidades VARCHAR(MAX)

/* Cursor para percorrer os nomes dos objetos */
DECLARE cursor_empregos CURSOR FOR
    SELECT id, saoroque, sorocaba, mairinque, aluminio, aracariguama, votorantim, piedade, ibiuna, cotia, vargem_grande
    FROM saoroque.dbo.empregos_curriculos

/* Abrindo Cursor para leitura */
OPEN cursor_empregos

/* Lendo a pr�xima linha */
FETCH NEXT FROM cursor_empregos INTO @id_curriculo, @saoroque, @sorocaba, @mairinque, @aluminio, @aracariguama, @votorantim, @piedade, @ibiuna, @cotia, @vargem_grande

PRINT 'Iniciando extra��o das cidades'
SET @cidades = ''

/* Percorrendo linhas do cursor (enquanto houverem) */
WHILE @@FETCH_STATUS = 0
BEGIN		
	
	IF @saoroque      = 'SIM' SET @cidades = @cidades + 'S�o Roque, '
	IF @sorocaba      = 'SIM' SET @cidades = @cidades + 'Sorocaba, '
	IF @mairinque     = 'SIM' SET @cidades = @cidades + 'Mairinque, '
	IF @aluminio      = 'SIM' SET @cidades = @cidades + 'Alum�nio, '
	IF @aracariguama  = 'SIM' SET @cidades = @cidades + 'Ara�ariguama, '
	IF @votorantim    = 'SIM' SET @cidades = @cidades + 'Votorantim, '
	IF @piedade       = 'SIM' SET @cidades = @cidades + 'Piedade, '
	IF @ibiuna        = 'SIM' SET @cidades = @cidades + 'Ibi�na, '
	IF @cotia         = 'SIM' SET @cidades = @cidades + 'Cotia, '
	IF @vargem_grande = 'SIM' SET @cidades = @cidades + 'Vargem Grande, '
	
	/* Retira espa�o e v�rgula do final da string */
	IF SUBSTRING(@cidades, LEN(@cidades), 2) = ', ' SET @cidades = SUBSTRING(@cidades, 1, LEN(@cidades)-1)
	
	/* Atualiza o campo cidade_interesse */
	UPDATE saoroque.dbo.empregos_curriculos SET cidade_interesse = @cidades WHERE id = @id_curriculo
	SET @cidades = ''
	
	 /* Lendo a pr�xima linha */
	FETCH NEXT FROM cursor_empregos INTO @id_curriculo, @saoroque, @sorocaba, @mairinque, @aluminio, @aracariguama, @votorantim, @piedade, @ibiuna, @cotia, @vargem_grande
END

PRINT 'Extra��o finalizada'

/* Fechando Cursor para leitura */
CLOSE cursor_empregos

/* Desalocando o cursor */
DEALLOCATE cursor_empregos

SELECT DATEDIFF(SS, @INICIO, GETDATE()) / 60