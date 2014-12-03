USE [barueri]
GO

/****** Cria a tabela de estátistica ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[empregos_estatisticas](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[grafico] [char](2) NULL,
	[rotulo] [varchar](30) NULL,
	[valor] [varchar](10) NULL,
	[data] [date] NULL,
 CONSTRAINT [PK_empregos_estatisticas] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

/****** Cria função que será usada na procedure ******/
CREATE FUNCTION CountCaracter
(
      @Palavra Varchar(100), @String Varchar(Max)
)
RETURNS int AS
BEGIN
 
      Declare @Count int, @CountTexto int
      Set @CountTexto = 0
      Set @Count = 0
      While @Count <= Len(@String)
      Begin
            Set @CountTexto =
            Case When Substring(@String, @Count, Len(@Palavra)) = @Palavra
                        Then @CountTexto + 1
                        Else @CountTexto
                  End
            Set @Count = @Count + 1
 
      End
      Return @CountTexto
 
END

/****** Cria procedure ******/

-- =============================================
-- Author:		<William F. Leite>
-- Create date: <05/08/2014>
-- Description:	<Procedure para contar e agrupar currículos por faixa etária de idade>
-- Parameter:	@param1 intervalo - Intervalo de dias para atualização das estátisticas (Data Última Atualização - Data Atual)
-- =============================================
CREATE PROCEDURE [dbo].[sp_atualiza_estatisticas_curriculos] @intervalo INT = 0
AS
BEGIN
	DECLARE @retorno INT

	-- ================================================================
	-- INÍCIO ESTATÍSTICA GRÁFICO 1: AGRUPAMENTO DE CURRÍCULOS POR SEXO
	-- ================================================================	
	SET @retorno = 0
	SELECT @retorno = DATEDIFF(DAY, data, getDate()) FROM empregos_estatisticas WHERE grafico = 'G1'
	
	IF @retorno >= @intervalo
	BEGIN
		DECLARE @valorM INT
		DECLARE @valorF INT
		DECLARE @contG2 INT
		
		SET @valorF = 0
		SET @valorM = 0
		SET @contG2 = 0
		
		SELECT @valorM = COUNT(*) FROM empregos_curriculos WHERE sexo = 'Masculino'
		SELECT @valorF = COUNT(*) FROM empregos_curriculos WHERE sexo = 'Feminino'
		
		SELECT @contG2 = COUNT(*) FROM empregos_estatisticas WHERE grafico = 'G1'
		IF @contG2 <= 0
		BEGIN
			INSERT INTO empregos_estatisticas (grafico, rotulo, valor, data) SELECT 'G1', 'Masculino', @valorM, getDate() 
			INSERT INTO empregos_estatisticas (grafico, rotulo, valor, data) SELECT 'G1', 'Feminino', @valorF, getDate()
		END
		ELSE
		BEGIN
			UPDATE empregos_estatisticas SET valor = @valorM, data = getDate() WHERE rotulo = 'Masculino' AND grafico = 'G1'
			UPDATE empregos_estatisticas SET valor = @valorF, data = getDate() WHERE rotulo = 'Feminino' AND grafico = 'G1'
		END
	END	
	-- =============================================================================
	-- FIM ESTATÍSTICA GRÁFICO 1: AGRUPAMENTO DE CURRÍCULOS POR SEXO
	-- =============================================================================




	-- =============================================================================
	-- INÍCIO ESTATÍSTICA GRÁFICO 2: AGRUPAMENTO DE CURRÍCULOS POR FAIXA ETÁRIA
	-- =============================================================================
	SET @retorno = 0
	SELECT @retorno = DATEDIFF(DAY, data, getDate()) FROM empregos_estatisticas WHERE grafico = 'G2'
	
	IF @retorno >= @intervalo
	BEGIN
		IF OBJECT_ID('tempdb..#TEMP_IDADE') IS NOT NULL
		BEGIN
				DROP TABLE #TEMP_IDADE
		END
		
		CREATE TABLE #TEMP_IDADE(
			   IDADE INT,
		)

		DECLARE @data VARCHAR(20)
		DECLARE @idade INT
		DECLARE @id INT
		DECLARE @qtde INT
		DECLARE @validacao INT 
		DECLARE @contG1 INT

		DECLARE cursor_curriculos CURSOR FOR
			SELECT id, nascimento
			FROM empregos_curriculos
			WHERE nascimento <> '' AND nascimento is not null AND ISNUMERIC(REPLACE(nascimento, '/','')) = 1 AND
			(substring(nascimento, 1, 2) > 0 AND substring(nascimento, 1, 2) <= 31) AND 
			(substring(nascimento, 4, 2) <= 12 AND substring(nascimento, 4, 2) > 0)

		OPEN cursor_curriculos

		FETCH NEXT FROM cursor_curriculos INTO @id, @data

		SET @validacao = 0
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
			 FETCH NEXT FROM cursor_curriculos INTO @id, @data    
		END
		
		CLOSE cursor_curriculos
		DEALLOCATE cursor_curriculos

		IF OBJECT_ID('tempdb..#TEMP_FAIXA') IS NOT NULL
		BEGIN
				DROP TABLE #TEMP_FAIXA
		END

		CREATE TABLE #TEMP_FAIXA(
			   FAIXA VARCHAR(30),
			   QTDE INT DEFAULT 0
		)

		INSERT #TEMP_FAIXA(FAIXA)VALUES('até 18')
		INSERT #TEMP_FAIXA(FAIXA)VALUES('18 a 25')
		INSERT #TEMP_FAIXA(FAIXA)VALUES('26 a 35')
		INSERT #TEMP_FAIXA(FAIXA)VALUES('36 a 45')
		INSERT #TEMP_FAIXA(FAIXA)VALUES('46 a 60')
		INSERT #TEMP_FAIXA(FAIXA)VALUES('60+')

		DECLARE cursor_idade CURSOR FOR
			SELECT IDADE, COUNT(*) as total
			FROM #TEMP_IDADE
			GROUP BY IDADE

		OPEN cursor_idade
		FETCH NEXT FROM cursor_idade INTO @idade, @qtde

		WHILE @@FETCH_STATUS = 0
		BEGIN
		   IF @idade < 18
		   BEGIN
				UPDATE #TEMP_FAIXA SET QTDE = QTDE + @qtde WHERE FAIXA = 'até 18'
		   END
		   ELSE IF @idade >= 18 AND @idade <= 25
		   BEGIN
				UPDATE #TEMP_FAIXA SET QTDE = QTDE + @qtde WHERE FAIXA = '18 a 25'
		   END
		   ELSE IF @idade >= 26 AND @idade <= 35
		   BEGIN
				UPDATE #TEMP_FAIXA SET QTDE = QTDE + @qtde WHERE FAIXA = '26 a 35'
		   END IF @idade >= 36 AND @idade <= 45
		   BEGIN
				UPDATE #TEMP_FAIXA SET QTDE = QTDE + @qtde WHERE FAIXA = '36 a 45'
		   END IF @idade >= 46 AND @idade <= 60
		   BEGIN
				UPDATE #TEMP_FAIXA SET QTDE = QTDE + @qtde WHERE FAIXA = '46 a 60'
		   END IF @idade > 60
		   BEGIN
				 UPDATE #TEMP_FAIXA SET QTDE = QTDE + @qtde WHERE FAIXA = '60+'
		   END
		   
		   FETCH NEXT FROM cursor_idade INTO @idade, @qtde   
		END

		CLOSE cursor_idade
		DEALLOCATE cursor_idade
		
		SET @contG1 = 0
		SELECT @contG1 = COUNT(*) FROM empregos_estatisticas WHERE grafico = 'G2'
		IF @contG1 <= 0
		BEGIN
			INSERT INTO empregos_estatisticas (grafico, rotulo, valor, data) SELECT 'G2', FAIXA, QTDE, getDate() FROM #TEMP_FAIXA 
		END
		ELSE
		BEGIN
			UPDATE empregos_estatisticas SET valor = t.QTDE, data = getDate() FROM empregos_estatisticas e INNER JOIN #TEMP_FAIXA t ON e.rotulo = t.FAIXA WHERE grafico = 'G2'
		END

		IF OBJECT_ID('tempdb..#TEMP_FAIXA') IS NOT NULL
		BEGIN
				DROP TABLE #TEMP_FAIXA
		END

		IF OBJECT_ID('tempdb..#TEMP_IDADE') IS NOT NULL
		BEGIN
				DROP TABLE #TEMP_IDADE
		END
	END
	-- ==================================================================================
	-- FIM ESTATÍSTICA GRÁFICO 2: AGRUPAMENTO DE CURRÍCULOS POR FAIXA ETÁRIA
	-- ==================================================================================
	
	
	
		
	-- =================================================================================
	-- INÍCIO ESTATÍSTICA GRÁFICO 3: AGRUPAMENTO DE CURRÍCULOS TOP 5 CIDADES
	-- =================================================================================
	SET @retorno = 0
	SELECT @retorno = DATEDIFF(DAY, data, getDate()) FROM empregos_estatisticas WHERE grafico = 'G3'
	
	IF @retorno >= @intervalo
	BEGIN
		DECLARE @contG3 INT
		
		SET @contG3 = 0
		SELECT @contG3 = COUNT(*) FROM empregos_estatisticas WHERE grafico = 'G3'
		IF @contG3 > 0
		BEGIN
			DELETE FROM empregos_estatisticas WHERE grafico = 'G3'
		END
		
		INSERT INTO empregos_estatisticas (grafico, rotulo, valor, data) 
		SELECT TOP 5 'G3', cidade, COUNT(*) AS total, GETDATE()
		FROM empregos_curriculos WHERE cidade <> '' AND cidade IS NOT NULL 
		GROUP BY cidade ORDER BY total DESC
	END
	-- =================================================================================
	-- FIM ESTATÍSTICA GRÁFICO 3: AGRUPAMENTO DE CURRÍCULOS TOP 5 CIDADES
	-- =================================================================================
	
	
		
		
	-- ======================================================================================
	-- INÍCIO ESTATÍSTICA GRÁFICO 4: AGRUPAMENTO DE CURRÍCULOS POR ÁREAS DE MARIOR INTERESSE
	-- ======================================================================================
	SET @retorno = 0
	SELECT @retorno = DATEDIFF(DAY, data, getDate()) FROM empregos_estatisticas WHERE grafico = 'G4'
	
	IF @retorno >= @intervalo
	BEGIN
		DECLARE @contG4 INT
		
		SET @contG4 = 0
		SELECT @contG4 = COUNT(*) FROM empregos_estatisticas WHERE grafico = 'G4'
		IF @contG4 > 0
		BEGIN
			DELETE FROM empregos_estatisticas WHERE grafico = 'G4'
		END
		
		INSERT INTO empregos_estatisticas (grafico, rotulo, valor, data) 
		SELECT TOP 5 'G4', area1, COUNT(area1) AS total, GETDATE() FROM(
		SELECT area1 FROM empregos_curriculos WHERE area1 <> '' UNION ALL 
		SELECT area2 FROM empregos_curriculos WHERE area2 <> '' UNION ALL 
		SELECT area3 FROM empregos_curriculos WHERE area3 <> '') x 
		GROUP BY area1 ORDER BY total DESC 
	END
	-- =====================================================================================
	-- FIM ESTATÍSTICA GRÁFICO 4:  AGRUPAMENTO DE CURRÍCULOS POR ÁREAS DE MARIOR INTERESSE
	-- ======================================================================================
END



