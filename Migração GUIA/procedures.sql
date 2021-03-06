USE [guia]
GO
/****** Object:  StoredProcedure [dbo].[SearchAndReplace]    Script Date: 09/26/2014 12:13:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SearchAndReplace]
(
	@SearchStr nvarchar(100),
	@ReplaceStr nvarchar(100)
)
AS
BEGIN

	-- Copyright © 2002 Narayana Vyas Kondreddi. All rights reserved.
	-- Purpose: To search all columns of all tables for a given search string and replace it with another string
	-- Written by: Narayana Vyas Kondreddi
	-- Site: http://vyaskn.tripod.com
	-- Tested on: SQL Server 7.0 and SQL Server 2000
	-- Date modified: 2nd November 2002 13:50 GMT

	SET NOCOUNT ON

	DECLARE @TableName nvarchar(256), @ColumnName nvarchar(128), @SearchStr2 nvarchar(110), @SQL nvarchar(4000), @RCTR int
	SET  @TableName = ''
	SET @SearchStr2 = QUOTENAME('%' + @SearchStr + '%','''')
	SET @RCTR = 0

	WHILE @TableName IS NOT NULL
	BEGIN
		SET @ColumnName = ''
		SET @TableName = 
		(
			SELECT MIN(QUOTENAME(TABLE_SCHEMA) + '.' + QUOTENAME(TABLE_NAME))
			FROM 	INFORMATION_SCHEMA.TABLES
			WHERE 		TABLE_TYPE = 'BASE TABLE'
				AND	QUOTENAME(TABLE_SCHEMA) + '.' + QUOTENAME(TABLE_NAME) > @TableName
				AND	OBJECTPROPERTY(
						OBJECT_ID(
							QUOTENAME(TABLE_SCHEMA) + '.' + QUOTENAME(TABLE_NAME)
							 ), 'IsMSShipped'
						       ) = 0
		)

		WHILE (@TableName IS NOT NULL) AND (@ColumnName IS NOT NULL)
		BEGIN
			SET @ColumnName =
			(
				SELECT MIN(QUOTENAME(COLUMN_NAME))
				FROM 	INFORMATION_SCHEMA.COLUMNS
				WHERE 		TABLE_SCHEMA	= PARSENAME(@TableName, 2)
					AND	TABLE_NAME	= PARSENAME(@TableName, 1)
					AND	DATA_TYPE IN ('char', 'varchar', 'nchar', 'nvarchar')
					AND	QUOTENAME(COLUMN_NAME) > @ColumnName
			)
	
			IF @ColumnName IS NOT NULL
			BEGIN
				SET @SQL=	'UPDATE ' + @TableName + 
						' SET ' + @ColumnName 
						+ ' =  REPLACE(' + @ColumnName + ', ' 
						+ QUOTENAME(@SearchStr, '''') + ', ' + QUOTENAME(@ReplaceStr, '''') + 
						') WHERE ' + @ColumnName + ' LIKE ' + @SearchStr2
				EXEC (@SQL)
				SET @RCTR = @RCTR + @@ROWCOUNT
			END
		END	
	END

	SELECT 'Replaced ' + CAST(@RCTR AS varchar) + ' occurence(s)' AS 'Outcome'
END
GO
/****** Object:  StoredProcedure [dbo].[SearchAllTables]    Script Date: 09/26/2014 12:13:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SearchAllTables]
(
	@SearchStr nvarchar(100)
)
AS
BEGIN

	-- Copyright © 2002 Narayana Vyas Kondreddi. All rights reserved.
	-- Purpose: To search all columns of all tables for a given search string
	-- Written by: Narayana Vyas Kondreddi
	-- Site: http://vyaskn.tripod.com
	-- Tested on: SQL Server 7.0 and SQL Server 2000
	-- Date modified: 28th July 2002 22:50 GMT


	CREATE TABLE #Results (ColumnName nvarchar(370), ColumnValue nvarchar(3630))

	SET NOCOUNT ON

	DECLARE @TableName nvarchar(256), @ColumnName nvarchar(128), @SearchStr2 nvarchar(110)
	SET  @TableName = ''
	SET @SearchStr2 = QUOTENAME('%' + @SearchStr + '%','''')

	WHILE @TableName IS NOT NULL
	BEGIN
		SET @ColumnName = ''
		SET @TableName = 
		(
			SELECT MIN(QUOTENAME(TABLE_SCHEMA) + '.' + QUOTENAME(TABLE_NAME))
			FROM 	INFORMATION_SCHEMA.TABLES
			WHERE 		TABLE_TYPE = 'BASE TABLE'
				AND	QUOTENAME(TABLE_SCHEMA) + '.' + QUOTENAME(TABLE_NAME) > @TableName
				AND	OBJECTPROPERTY(
						OBJECT_ID(
							QUOTENAME(TABLE_SCHEMA) + '.' + QUOTENAME(TABLE_NAME)
							 ), 'IsMSShipped'
						       ) = 0
		)

		WHILE (@TableName IS NOT NULL) AND (@ColumnName IS NOT NULL)
		BEGIN
			SET @ColumnName =
			(
				SELECT MIN(QUOTENAME(COLUMN_NAME))
				FROM 	INFORMATION_SCHEMA.COLUMNS
				WHERE 		TABLE_SCHEMA	= PARSENAME(@TableName, 2)
					AND	TABLE_NAME	= PARSENAME(@TableName, 1)
					AND	DATA_TYPE IN ('char', 'varchar', 'nchar', 'nvarchar')
					AND	QUOTENAME(COLUMN_NAME) > @ColumnName
			)
	
			IF @ColumnName IS NOT NULL
			BEGIN
				INSERT INTO #Results
				EXEC
				(
					'SELECT ''' + @TableName + '.' + @ColumnName + ''', LEFT(' + @ColumnName + ', 3630) 
					FROM ' + @TableName + ' (NOLOCK) ' +
					' WHERE ' + @ColumnName + ' LIKE ' + @SearchStr2
				)
			END
		END	
	END

	SELECT ColumnName, ColumnValue FROM #Results
END
GO
/****** Object:  StoredProcedure [dbo].[sp_acessos_admin]    Script Date: 09/26/2014 12:13:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_acessos_admin]
@c int,
@id int
AS
Update admps set acessos = @c where idlogin = @id
GO
/****** Object:  StoredProcedure [dbo].[sp_conta_anuncios_gratuitos]    Script Date: 09/26/2014 12:13:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_conta_anuncios_gratuitos] @c varchar(400) = NULL AS
DECLARE @sql nvarchar(4000)
SELECT @sql = ' SELECT COUNT(*) as Total' +
              ' FROM anuncios Where status = ''Ativo'' and tipo = ''gratuito'''
IF @c IS NOT NULL
  SELECT @sql = @sql + ' and (c1 = @c or c2 = @c or c3 = @c or c4 = @c or c5 = @c or c6 = @c or c7 = @c or c8 = @c or c9 = @c or c10 = @c or c11 = @c or c12 = @c or c13 = @c or c14 = @c or c15 = @c)'
EXEC sp_executesql @sql, N'@c varchar(400)',@c

ALTER TABLE anuncios add data_txt DATE
GO
/****** Object:  StoredProcedure [dbo].[sp_consultasubs]    Script Date: 09/26/2014 12:13:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_consultasubs] @cat varchar(400) = NULL AS
DECLARE @sql nvarchar(4000)
SELECT @sql = ' SELECT * ' +
              ' FROM subs Where '
IF @cat IS NOT NULL
  SELECT @sql = @sql + ' id LIKE @cat'
EXEC sp_executesql @sql, N'@cat varchar(400)',@cat
GO
/****** Object:  StoredProcedure [dbo].[sp_lista_anuncios_gratuitos]    Script Date: 09/26/2014 12:13:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_lista_anuncios_gratuitos] @c varchar(400) = NULL AS
DECLARE @sql nvarchar(4000)
SELECT @sql = ' SELECT * ' +
              ' FROM anuncios Where status = ''Ativo'' and tipo = ''gratuito'''
IF @c IS NOT NULL
  SELECT @sql = @sql + ' and (c1 = @c or c2 = @c or c3 = @c or c4 = @c or c5 = @c or c6 = @c or c7 = @c or c8 = @c or c9 = @c or c10 = @c or c11 = @c or c12 = @c or c13 = @c or c14 = @c or c15 = @c) order by titulo'
EXEC sp_executesql @sql, N'@c varchar(400)',@c
GO
/****** Object:  StoredProcedure [dbo].[sp_lista_anuncios_especial]    Script Date: 09/26/2014 12:13:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_lista_anuncios_especial] 
@p varchar(100),
@p2 varchar(100),
@p3 varchar(100),
@c varchar(400) = NULL AS
DECLARE @sql nvarchar(4000)
SELECT @sql = ' SELECT *' +
              ' FROM anuncios Where status = ''Ativo'' and tipo = ''completo'' and (id <> ' + @p + ' and id <> ' + @p2 + ' and id <> ' + @p3 + ')'
IF @c IS NOT NULL
  SELECT @sql = @sql + ' and (c1 = @c or c2 = @c or c3 = @c or c4 = @c or c5 = @c or c6 = @c or c7 = @c or c8 = @c or c9 = @c or c10 = @c or c11 = @c or c12 = @c or c13 = @c or c14 = @c or c15 = @c) order by peso desc, newid()'
EXEC sp_executesql @sql, N'@c varchar(400)',@c
GO
/****** Object:  StoredProcedure [dbo].[sp_lista_anuncios_completos]    Script Date: 09/26/2014 12:13:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_lista_anuncios_completos] 
@c varchar(400) = NULL AS
DECLARE @sql nvarchar(4000)
SELECT @sql = ' SELECT *' +
              ' FROM anuncios Where status = ''Ativo'' and tipo = ''completo'''
IF @c IS NOT NULL
  SELECT @sql = @sql + ' and (c1 = @c or c2 = @c or c3 = @c or c4 = @c or c5 = @c or c6 = @c or c7 = @c or c8 = @c or c9 = @c or c10 = @c or c11 = @c or c12 = @c or c13 = @c or c14 = @c or c15 = @c) order by peso desc, titulo asc'
EXEC sp_executesql @sql, N'@c varchar(400)',@c
GO
/****** Object:  StoredProcedure [dbo].[sp_lista_anuncios]    Script Date: 09/26/2014 12:13:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_lista_anuncios] 
@p varchar(100),
@p2 varchar(100),
@p3 varchar(100),
@c varchar(400) = NULL AS
DECLARE @sql nvarchar(4000)
SELECT @sql = ' SELECT *' +
              ' FROM anuncios Where status = ''Ativo'' and tipo = ''completo'' and (id <> ' + @p + ' and id <> ' + @p2 + ' and id <> ' + @p3 + ')'
IF @c IS NOT NULL
  SELECT @sql = @sql + ' and (c1 = @c or c2 = @c or c3 = @c or c4 = @c or c5 = @c or c6 = @c or c7 = @c or c8 = @c or c9 = @c or c10 = @c or c11 = @c or c12 = @c or c13 = @c or c14 = @c or c15 = @c) order by peso desc, titulo asc'
EXEC sp_executesql @sql, N'@c varchar(400)',@c
GO
/****** Object:  StoredProcedure [dbo].[sp_logar_sistema]    Script Date: 09/26/2014 12:13:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_logar_sistema]
@l varchar(100),
@s varchar(100)
AS
SELECT * from admps where login = @l and senha = @s and status = 'Ativo'
GO
/****** Object:  StoredProcedure [dbo].[sp_totaliza_completos]    Script Date: 09/26/2014 12:13:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_totaliza_completos] @c varchar(400) = NULL AS
DECLARE @sql nvarchar(4000)
SELECT @sql = ' SELECT count (*) as total ' +
              ' FROM anuncios Where status = ''Ativo'' and tipo = ''Completo'''
IF @c IS NOT NULL
  SELECT @sql = @sql + ' and (c1 = @c or c2 = @c or c3 = @c or c4 = @c or c5 = @c or c6 = @c or c7 = @c or c8 = @c or c9 = @c or c10 = @c or c11 = @c or c12 = @c or c13 = @c or c14 = @c or c15 = @c)'
EXEC sp_executesql @sql, N'@c varchar(400)',@c
GO
/****** Object:  StoredProcedure [dbo].[sp_ultimo_login]    Script Date: 09/26/2014 12:13:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_ultimo_login]
@ultimo varchar(100), 
@usuario varchar(100)
AS
Update admps set ultimo = @ultimo where idlogin = @usuario
GO
/****** Object:  StoredProcedure [dbo].[sp_totaliza_gratuitos]    Script Date: 09/26/2014 12:13:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_totaliza_gratuitos] @c varchar(400) = NULL AS
DECLARE @sql nvarchar(4000)
SELECT @sql = ' SELECT count (*) as total ' +
              ' FROM anuncios Where status = ''Ativo'' and tipo = ''gratuito'''
IF @c IS NOT NULL
  SELECT @sql = @sql + ' and (c1 = @c or c2 = @c or c3 = @c or c4 = @c or c5 = @c or c6 = @c or c7 = @c or c8 = @c or c9 = @c or c10 = @c or c11 = @c or c12 = @c or c13 = @c or c14 = @c or c15 = @c)'
EXEC sp_executesql @sql, N'@c varchar(400)',@c
GO
/****** Object:  StoredProcedure [dbo].[sp_totaliza_completos_busca_palavra]    Script Date: 09/26/2014 12:13:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_totaliza_completos_busca_palavra]
@c int,
@p varchar(100)
AS
SELECT count (*) as total FROM anuncios Where status = 'Ativo' and tipo = 'completo' and (c1 = @c or c2 = @c or c3 = @c or c4 = @c or c5 = @c or c6 = @c or c7 = @c or c8 = @c or c9 = @c or c10 = @c or c11 = @c or c12 = @c or c13 = @c or c14 = @c or c15 = @c) and (titulo like '%' + @p + '%' or descricao like '%' + @p + '%' or endereco like '%' + @p + '%' or numero like '%' + @p + '%' or complemento like '%' + @p + '%' or bairro like '%' + @p + '%' or cidade like '%' + @p + '%' or telefone like '%' + @p + '%' or site like '%' + @p + '%' or tags like '%' + @p + '%')
GO
/****** Object:  StoredProcedure [dbo].[sp_totaliza_completos_busca_bairro]    Script Date: 09/26/2014 12:13:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_totaliza_completos_busca_bairro]
@c varchar(100),
@b varchar(100)
AS
SELECT count (*) as total FROM anuncios Where status = 'Ativo' and tipo = 'completo' and bairro = @b and (c1 = ''+@c+'' or c2 = ''+@c+'' or c3 = ''+@c+'' or c4 = ''+@c+'' or c5 = ''+@c+'' or c6 = ''+@c+'' or c7 = ''+@c+'' or c8 = ''+@c+'' or c9 = ''+@c+'' or c10 = ''+@c+'' or c11 = ''+@c+'' or c12 = ''+@c+'' or c13 = ''+@c+'' or c14 = ''+@c+'' or c15 = ''+@c+'')
GO
/****** Object:  StoredProcedure [dbo].[sp_totaliza_gratuitos_busca_palavra]    Script Date: 09/26/2014 12:13:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_totaliza_gratuitos_busca_palavra]
@c varchar(100),
@p varchar(100)
AS
SELECT count (*) as total FROM anuncios Where status = 'Ativo' and tipo = 'gratuito' and (c1 = ''+@c+'' or c2 = ''+@c+'' or c3 = ''+@c+'' or c4 = ''+@c+'' or c5 = ''+@c+'' or c6 = ''+@c+'' or c7 = ''+@c+'' or c8 = ''+@c+'' or c9 = ''+@c+'' or c10 = ''+@c+'' or c11 = ''+@c+'' or c12 = ''+@c+'' or c13 = ''+@c+'' or c14 = ''+@c+'' or c15 = ''+@c+'') and (titulo like '%' + @p + '%' or descricao like '%' + @p + '%' or endereco like '%' + @p + '%' or numero like '%' + @p + '%' or complemento like '%' + @p + '%' or bairro like '%' + @p + '%' or cidade like '%' + @p + '%' or telefone like '%' + @p + '%' or site like '%' + @p + '%' or tags like '%' + @p + '%')
GO
/****** Object:  StoredProcedure [dbo].[sp_totaliza_gratuitos_busca_bairro]    Script Date: 09/26/2014 12:13:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_totaliza_gratuitos_busca_bairro]
@c varchar(100),
@b varchar(100)
AS
SELECT count (*) as total FROM anuncios Where status = 'Ativo' and tipo = 'gratuito' and bairro = @b and (c1 = ''+@c+'' or c2 = ''+@c+'' or c3 = ''+@c+'' or c4 = ''+@c+'' or c5 = ''+@c+'' or c6 = ''+@c+'' or c7 = ''+@c+'' or c8 = ''+@c+'' or c9 = ''+@c+'' or c10 = ''+@c+'' or c11 = ''+@c+'' or c12 = ''+@c+'' or c13 = ''+@c+'' or c14 = ''+@c+'' or c15 = ''+@c+'')
GO
/****** Object:  StoredProcedure [dbo].[sp_pgn_imoveis_contatos]    Script Date: 09/26/2014 12:13:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		William F. Leite
-- Create date: 19/05/2014
-- Description:	Store Procedure para paginar registros, tabela de imoveis_contatos
-- =============================================
CREATE PROCEDURE [dbo].[sp_pgn_imoveis_contatos] @TamanhoPagina int, @NumeroPagina int, @id_imobiliaria int=NULL, @status Varchar(20)='SIM', @id_imovel Varchar(20)=null
AS
BEGIN
	IF @id_imovel <> '' 
	BEGIN
		WITH Paginado AS (SELECT ROW_NUMBER() OVER(ORDER BY id DESC) AS linha, id, nome, email, mensagem, data, id_imovel 
		FROM imoveis_contato WITH (NOLOCK) 
		WHERE cod_imobiliaria = @id_imobiliaria AND status = @status AND id_imovel = @id_imovel)
		SELECT TOP (@TamanhoPagina) linha, *
		FROM Paginado p
		WHERE linha > @TamanhoPagina * (@NumeroPagina - 1)
		ORDER BY id DESC;
	END
	ELSE
	BEGIN
		WITH Paginado AS (SELECT ROW_NUMBER() OVER(ORDER BY id DESC) AS linha, id, nome, email, mensagem, data, id_imovel 
		FROM imoveis_contato WITH (NOLOCK) 
		WHERE cod_imobiliaria = @id_imobiliaria AND status = @status)
		SELECT TOP (@TamanhoPagina) linha, *
		FROM Paginado p
		WHERE linha > @TamanhoPagina * (@NumeroPagina - 1)
		ORDER BY id DESC;
	END
END
GO
/****** Object:  StoredProcedure [dbo].[sp_pgn_imoveis_clientes]    Script Date: 09/26/2014 12:13:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		William F. Leite
-- Create date: 19/05/2014
-- Description:	Store Procedure para paginar registros, tabela de imoveis_clientes
-- =============================================
CREATE PROCEDURE [dbo].[sp_pgn_imoveis_clientes] @TamanhoPagina int, @NumeroPagina int, @Nivel int=NULL, @Nome Varchar(100)=NULL, @Email Varchar(100)=NULL, @Destaque Char(3)=NULL
AS
BEGIN
	/* Verifica se foi passado um nível por parâmetro */
	IF @Nivel != NULL OR @Nivel > 0
	BEGIN
		WITH Paginado AS (SELECT ROW_NUMBER() OVER(ORDER BY nome) AS linha, * FROM imoveis_clientes WITH (NOLOCK) WHERE nivel = @Nivel)
		SELECT TOP (@TamanhoPagina) linha, *
		FROM Paginado p
		WHERE linha > @TamanhoPagina * (@NumeroPagina - 1);
	END
	ELSE
	BEGIN
		WITH Paginado AS (SELECT ROW_NUMBER() OVER(ORDER BY nome) AS linha, * FROM imoveis_clientes WITH (NOLOCK) WHERE nome LIKE '%'+@Nome+'%' OR email LIKE '%'+@Email+'%' OR destaque = @Destaque)
		SELECT TOP (@TamanhoPagina) linha, *
		FROM Paginado p
		WHERE linha > @TamanhoPagina * (@NumeroPagina - 1)
		ORDER BY nome;
	END	
END
GO
/****** Object:  StoredProcedure [dbo].[sp_pgn_imoveis]    Script Date: 09/26/2014 12:13:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		William F. Leite
-- Create date: 19/05/2014
-- Description:	Store Procedure para paginar registros, tabela de imoveis
-- =============================================
CREATE PROCEDURE [dbo].[sp_pgn_imoveis] @TamanhoPagina int, @NumeroPagina int, @id_usuario int=NULL, @busca varchar(100)=null 
AS
BEGIN
	IF(@busca <> '')
	BEGIN
		IF (ISNUMERIC(@busca) = 1)
		BEGIN
			WITH Paginado AS (SELECT ROW_NUMBER() OVER(ORDER BY id DESC) AS linha, id, titulo, views, status, data FROM imoveis WITH (NOLOCK) 
			WHERE cod_usuario = @id_usuario  AND (id LIKE @busca + '%'  OR titulo LIKE @busca + '%' OR descricao LIKE @busca + '%' OR tipo LIKE @busca + '%' OR categoria LIKE @busca + '%' OR endereco LIKE @busca + '%' OR cidade LIKE @busca + '%' OR bairro LIKE @busca + '%'))
			SELECT TOP (@TamanhoPagina) linha, *
			FROM Paginado p
			WHERE linha > @TamanhoPagina * (@NumeroPagina - 1)
			ORDER BY id DESC;
		END
		ELSE
		BEGIN
			WITH Paginado AS (SELECT ROW_NUMBER() OVER(ORDER BY id DESC) AS linha, id, titulo, views, status, data FROM imoveis WITH (NOLOCK) 
			WHERE cod_usuario = @id_usuario  AND (titulo LIKE @busca + '%' OR descricao LIKE @busca + '%' OR tipo LIKE @busca + '%' OR categoria LIKE @busca + '%' OR endereco LIKE @busca + '%' OR cidade LIKE @busca + '%' OR bairro LIKE @busca + '%'))
			SELECT TOP (@TamanhoPagina) linha, *
			FROM Paginado p
			WHERE linha > @TamanhoPagina * (@NumeroPagina - 1)
			ORDER BY id DESC;
		END
	END
	ELSE
	BEGIN
		WITH Paginado AS (SELECT ROW_NUMBER() OVER(ORDER BY id DESC) AS linha, id, titulo, views, status, data FROM imoveis WITH (NOLOCK) 
		WHERE cod_usuario = @id_usuario)
		SELECT TOP (@TamanhoPagina) linha, *
		FROM Paginado p
		WHERE linha > @TamanhoPagina * (@NumeroPagina - 1)
		ORDER BY id DESC;
	END
END
GO
/****** Object:  StoredProcedure [dbo].[sp_pgn_empregos_clientes]    Script Date: 09/26/2014 12:13:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		William F. Leite
-- Create date: 16/05/2014
-- Description:	Store Procedure para paginar registros, tabela de empregos_clientes
-- =============================================

CREATE PROCEDURE [dbo].[sp_pgn_empregos_clientes] @TamanhoPagina int, @NumeroPagina int, @Nivel int=NULL, @Nome Varchar(100)=NULL, @Email Varchar(100)=NULL
AS
BEGIN
	/* Verifica se foi passado um nível por parâmetro */
	IF (@Nivel > 0)
	BEGIN
		WITH Paginado AS (SELECT ROW_NUMBER() OVER(ORDER BY nome) AS linha, * FROM empregos_clientes WITH (NOLOCK) WHERE nivel = @Nivel)
		SELECT TOP (@TamanhoPagina) linha, *
		FROM Paginado p
		WHERE linha > @TamanhoPagina * (@NumeroPagina - 1);
	END
	ELSE
	BEGIN
		WITH Paginado AS (SELECT ROW_NUMBER() OVER(ORDER BY nome) AS linha, * FROM empregos_clientes WITH (NOLOCK) WHERE nome LIKE '%'+@Nome+'%' OR email LIKE '%'+@Email+'%')
		SELECT TOP (@TamanhoPagina) linha, *
		FROM Paginado p
		WHERE linha > @TamanhoPagina * (@NumeroPagina - 1)
		ORDER BY nome;
	END	
END
GO
/****** Object:  StoredProcedure [dbo].[sp_lista_gratuitos_busca_palavra]    Script Date: 09/26/2014 12:13:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_lista_gratuitos_busca_palavra]
@c varchar(100),
@p varchar(100)
AS
SELECT * FROM anuncios Where status = 'Ativo' and tipo = 'gratuito' and (c1 = ''+@c+'' or c2 = ''+@c+'' or c3 = ''+@c+'' or c4 = ''+@c+'' or c5 = ''+@c+'' or c6 = ''+@c+'' or c7 = ''+@c+'' or c8 = ''+@c+'' or c9 = ''+@c+'' or c10 = ''+@c+'' or c11 = ''+@c+'' or c12 = ''+@c+'' or c13 = ''+@c+'' or c14 = ''+@c+'' or c15 = ''+@c+'') and (titulo like '%' + @p + '%' or descricao like '%' + @p + '%' or endereco like '%' + @p + '%' or numero like '%' + @p + '%' or complemento like '%' + @p + '%' or bairro like '%' + @p + '%' or cidade like '%' + @p + '%' or telefone like '%' + @p + '%' or site like '%' + @p + '%' or tags like '%' + @p + '%') order by titulo
GO
/****** Object:  StoredProcedure [dbo].[sp_lista_gratuitos_busca_bairro]    Script Date: 09/26/2014 12:13:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_lista_gratuitos_busca_bairro]
@c varchar(100),
@b varchar(100)
AS
SELECT * FROM anuncios Where status = 'Ativo' and tipo = 'gratuito' and bairro = @b and (c1 = ''+@c+'' or c2 = ''+@c+'' or c3 = ''+@c+'' or c4 = ''+@c+'' or c5 = ''+@c+'' or c6 = ''+@c+'' or c7 = ''+@c+'' or c8 = ''+@c+'' or c9 = ''+@c+'' or c10 = ''+@c+'' or c11 = ''+@c+'' or c12 = ''+@c+'' or c13 = ''+@c+'' or c14 = ''+@c+'' or c15 = ''+@c+'') order by titulo
GO
/****** Object:  StoredProcedure [dbo].[sp_lista_completos_busca_palavra]    Script Date: 09/26/2014 12:13:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_lista_completos_busca_palavra]
@c varchar(100),
@p varchar(100)
AS
SELECT * FROM anuncios Where status = 'Ativo' and tipo = 'completo' and (c1 = ''+@c+'' or c2 = ''+@c+'' or c3 = ''+@c+'' or c4 = ''+@c+'' or c5 = ''+@c+'' or c6 = ''+@c+'' or c7 = ''+@c+'' or c8 = ''+@c+'' or c9 = ''+@c+'' or c10 = ''+@c+'' or c11 = ''+@c+'' or c12 = ''+@c+'' or c13 = ''+@c+'' or c14 = ''+@c+'' or c15 = ''+@c+'') and (titulo like '%' + @p + '%' or descricao like '%' + @p + '%' or endereco like '%' + @p + '%' or numero like '%' + @p + '%' or complemento like '%' + @p + '%' or bairro like '%' + @p + '%' or cidade like '%' + @p + '%' or telefone like '%' + @p + '%' or site like '%' + @p + '%' or tags like '%' + @p + '%') order by titulo
GO
/****** Object:  StoredProcedure [dbo].[sp_lista_completos_busca_bairro]    Script Date: 09/26/2014 12:13:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_lista_completos_busca_bairro]
@c int,
@b varchar(100)
AS
SELECT * FROM anuncios Where status = 'Ativo' and tipo = 'completo' and bairro = @b and (c1 = @c or c2 = @c or c3 = @c or c4 = @c or c5 = @c or c6 = @c or c7 = @c or c8 = @c or c9 = @c or c10 = @c or c11 = @c or c12 = @c or c13 = @c or c14 = @c or c15 = @c) order by titulo
GO
/****** Object:  StoredProcedure [dbo].[sp_lista_bairros_segmento]    Script Date: 09/26/2014 12:13:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_lista_bairros_segmento]
@c varchar(100)
AS
SELECT DISTINCT bairro FROM anuncios Where c1 = @c or c2 = @c or c3 = @c or c4 = @c or c5 = @c or c6 = @c or c7 = @c or c8 = @c or c9 = @c or c10 = @c or c11 = @c or c12 = @c or c13 = @c or c14 = @c or c15 = @c
GO
/****** Object:  StoredProcedure [dbo].[sp_lista_anuncios_intervalo]    Script Date: 09/26/2014 12:13:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_lista_anuncios_intervalo] @c varchar(400) = NULL, @tipo varchar(20), @limite integer
AS
SELECT * FROM anuncios 
Where status = 'Ativo' and tipo = @tipo and datediff(day, data_txt, GETDATE()) >= @limite 
and (c1 = @c or c2 = @c or c3 = @c or c4 = @c or c5 = @c or c6 = @c or c7 = @c or c8 = @c or c9 = @c or c10 = @c or c11 = @c or c12 = @c or c13 = @c or c14 = @c or c15 = @c)
GO
/****** Object:  StoredProcedure [dbo].[sp_conta_subs_invalidas]    Script Date: 09/26/2014 12:13:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,William>
-- Create date: <Create 29/07/2014>
-- Description:	<Description Procedure para calcular a quantidade de subs inválidas + Google>
-- =============================================
CREATE PROCEDURE [dbo].[sp_conta_subs_invalidas]
AS
BEGIN
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
END
GO
/****** Object:  StoredProcedure [dbo].[sp_conta_categoria]    Script Date: 09/26/2014 12:13:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_conta_categoria] @id int
AS
BEGIN
	SELECT 
	(SELECT CASE c1 WHEN '0' THEN 0 ELSE 1 END FROM anuncios WHERE id=@id)+
	(SELECT CASE c2 WHEN '0' THEN 0 ELSE 1 END FROM anuncios WHERE id=@id)+
	(SELECT CASE c3 WHEN '0' THEN 0 ELSE 1 END FROM anuncios WHERE id=@id)+
	(SELECT CASE c4 WHEN '0' THEN 0 ELSE 1 END FROM anuncios WHERE id=@id)+
	(SELECT CASE c5 WHEN '0' THEN 0 ELSE 1 END FROM anuncios WHERE id=@id)+
	(SELECT CASE c6 WHEN '0' THEN 0 ELSE 1 END FROM anuncios WHERE id=@id)+
	(SELECT CASE c7 WHEN '0' THEN 0 ELSE 1 END FROM anuncios WHERE id=@id)+
	(SELECT CASE c8 WHEN '0' THEN 0 ELSE 1 END FROM anuncios WHERE id=@id)+
	(SELECT CASE c9 WHEN '0' THEN 0 ELSE 1 END FROM anuncios WHERE id=@id)+
	(SELECT CASE c10 WHEN '0' THEN 0 ELSE 1 END FROM anuncios WHERE id=@id)+
	(SELECT CASE c11 WHEN '0' THEN 0 ELSE 1 END FROM anuncios WHERE id=@id)+
	(SELECT CASE c12 WHEN '0' THEN 0 ELSE 1 END FROM anuncios WHERE id=@id)+
	(SELECT CASE c13 WHEN '0' THEN 0 ELSE 1 END FROM anuncios WHERE id=@id)+
	(SELECT CASE c14 WHEN '0' THEN 0 ELSE 1 END FROM anuncios WHERE id=@id)+
	(SELECT CASE c15 WHEN '0' THEN 0 ELSE 1 END FROM anuncios WHERE id=@id) as total
END
GO
/****** Object:  StoredProcedure [dbo].[sp_calcula_paginacao_imoveis_contatos]    Script Date: 09/26/2014 12:13:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		William F. Leite
-- Create date: 16/05/2014
-- Description:	Store Procedure para cálcular quantidade de página
-- necessárias para paginação dos dados da tabela imoveis_contatos.
-- =============================================
CREATE PROCEDURE [dbo].[sp_calcula_paginacao_imoveis_contatos] @TamanhoPagina int, @id_imobiliaria int=NULL, @status Varchar(20)='SIM', @id_imovel Varchar(20)=null
AS
BEGIN
	IF @id_imovel <> '' 
	BEGIN
		SELECT (count(*) / @TamanhoPagina) + CASE WHEN (count(*) % @TamanhoPagina )> 0 THEN 1 ELSE 0 END AS total 
		FROM imoveis_contato 
		WHERE cod_imobiliaria = @id_imobiliaria AND status = @status AND id_imovel = @id_imovel
	END
	ELSE
	BEGIN
		SELECT (count(*) / @TamanhoPagina) + CASE WHEN (count(*) % @TamanhoPagina )> 0 THEN 1 ELSE 0 END AS total 
		FROM imoveis_contato 
		WHERE cod_imobiliaria = @id_imobiliaria AND status = @status
	END
END
GO
/****** Object:  StoredProcedure [dbo].[sp_calcula_paginacao_imoveis_admin]    Script Date: 09/26/2014 12:13:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		William F. Leite
-- Create date: 16/05/2014
-- Description:	Store Procedure para calcular quantidade de página
-- necessárias para paginação dos dados da tabela imoveis.
-- =============================================
CREATE PROCEDURE [dbo].[sp_calcula_paginacao_imoveis_admin] @TamanhoPagina int, @id_imobiliaria int=NULL, @busca varchar(100)=null 
AS
BEGIN 
	IF(@busca <> '')
	BEGIN
		IF (ISNUMERIC(@busca) = 1)
		BEGIN
			SELECT (count(*) / @TamanhoPagina) + CASE WHEN (count(*) % @TamanhoPagina )> 0 THEN 1 ELSE 0 END AS total 
			FROM imoveis
			WHERE cod_usuario = @id_imobiliaria AND (id LIKE @busca + '%' OR titulo LIKE @busca + '%' OR descricao LIKE @busca + '%' OR tipo LIKE @busca + '%' OR categoria LIKE @busca + '%' OR endereco LIKE @busca + '%' OR cidade LIKE @busca + '%' OR bairro LIKE @busca + '%')
		END
		ELSE
		BEGIN
			SELECT (count(*) / @TamanhoPagina) + CASE WHEN (count(*) % @TamanhoPagina )> 0 THEN 1 ELSE 0 END AS total 
			FROM imoveis
			WHERE cod_usuario = @id_imobiliaria AND (titulo LIKE @busca + '%' OR descricao LIKE @busca + '%' OR tipo LIKE @busca + '%' OR categoria LIKE @busca + '%' OR endereco LIKE @busca + '%' OR cidade LIKE @busca + '%' OR bairro LIKE @busca + '%')
		END
	END
	ELSE
	BEGIN
		SELECT (count(*) / @TamanhoPagina) + CASE WHEN (count(*) % @TamanhoPagina )> 0 THEN 1 ELSE 0 END AS total 
		FROM imoveis
		WHERE cod_usuario = @id_imobiliaria
	END
END
GO
/****** Object:  StoredProcedure [dbo].[sp_calcula_paginacao_imoveis]    Script Date: 09/26/2014 12:13:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		William F. Leite
-- Create date: 19/05/2014
-- Description:	Store Procedure para cálcular quantidade de página
-- necessárias para paginação dos dados da tabela imoveis_clientes.
-- =============================================
CREATE PROCEDURE [dbo].[sp_calcula_paginacao_imoveis] @TamanhoPagina int, @Nivel int=NULL
AS
BEGIN
	/* Verifica se foi passado um nível por parâmetro */
	IF (@Nivel > 0)
	BEGIN
		SELECT (count(*) / @TamanhoPagina) + CASE WHEN (count(*) % @TamanhoPagina )> 0 THEN 1 ELSE 0 END AS total FROM imoveis_clientes WHERE nivel = @Nivel
	END
	ELSE
	BEGIN
		SELECT (count(*) / @TamanhoPagina) + CASE WHEN (count(*) % @TamanhoPagina )> 0 THEN 1 ELSE 0 END AS total FROM imoveis_clientes 
	END
END
GO
/****** Object:  StoredProcedure [dbo].[sp_calcula_paginacao]    Script Date: 09/26/2014 12:13:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		William F. Leite
-- Create date: 16/05/2014
-- Description:	Store Procedure para cálcular quantidade de página
-- necessárias para paginação dos dados da tabela empregos_clientes.
-- =============================================
CREATE PROCEDURE [dbo].[sp_calcula_paginacao] @TamanhoPagina int, @Nivel int=NULL
AS
BEGIN
	/* Verifica se foi passado um nível por parâmetro */
	IF (@Nivel > 0)
	BEGIN
		SELECT (count(*) / @TamanhoPagina) + CASE WHEN (count(*) % @TamanhoPagina )> 0 THEN 1 ELSE 0 END AS total FROM empregos_clientes WHERE nivel = @Nivel
	END
	ELSE
	BEGIN
		SELECT (count(*) / @TamanhoPagina) + CASE WHEN (count(*) % @TamanhoPagina )> 0 THEN 1 ELSE 0 END AS total FROM empregos_clientes 
	END
END
GO
/****** Object:  StoredProcedure [dbo].[sp_atualiza_estatisticas_curriculos]    Script Date: 09/26/2014 12:13:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
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
GO
