/* Checa se todas as p�ginas da mem�ria foram gravadas em disco */
CHECKPOINT 
GO
/* Limpa as entradas do cache da sessao */
DBCC FREESESSIONCACHE;
GO
/* Eliminar as p�ginas de buffer limpas */
DBCC DROPCLEANBUFFERS
GO
/* Eliminar todas as entradas do CACHE de "Procedures" */
DBCC FREEPROCCACHE
GO
/* Limpar as entradas de Cache n�o utilizadas */
DBCC FREESYSTEMCACHE ('ALL')


/* Detectar fragmenta��o da tabela forma antiga */
DECLARE @table_id int
SET @table_id = OBJECT_ID('imoveis_contato')
DBCC SHOWCONTIG(@table_id)

/* Detectar fragmenta��o da tabela forma recente */
SELECT * FROM sys.dm_db_index_physical_stats  (DB_ID(N'guia'), OBJECT_ID(N'imoveis_contato'), NULL, NULL , 'DETAILED');


/* Quantidade de mem�ria utilizada por tipo de cache */
SELECT  type, SUM(single_pages_kb)/1024. AS [SPA Mem, MB],SUM(Multi_pages_kb)/1024. AS [MPA Mem,MB]
FROM sys.dm_os_memory_clerks
GROUP BY type
HAVING  SUM(single_pages_kb) + sum(Multi_pages_kb)  > 40000 
ORDER BY SUM(single_pages_kb) DESC


/* Quantidade total de mem�ria sendo utilizada pelo cache */
SELECT  SUM(single_pages_kb)/1024. AS [SPA Mem, KB],SUM(Multi_pages_kb)/1024. AS [MPA Mem, KB]
FROM sys.dm_os_memory_clerks


/* Quantidade de mem�ria utilizada para cache por banco de dados */
SELECT DB_NAME(database_id) AS [Database Name],
COUNT(*) * 8/1024.0 AS [Cached Size (MB)]
FROM sys.dm_os_buffer_descriptors
WHERE database_id > 4
AND database_id <> 32767
GROUP BY DB_NAME(database_id)
ORDER BY [Cached Size (MB)] DESC;


/* Quantidade de mem�ria que o SQL Server pode utilizar no servidor */
select counter_name ,cntr_value,cast((cntr_value/1024.0)/1024.0 as numeric(8,2)) as Gb
from sys.dm_os_performance_counters
where counter_name like '%server_memory%'


/* Expectativa de vida em segundos de uma p�gina de dados na mem�ria (Recomendado acima de 300 segundos)*/
SELECT [object_name],
[counter_name],
[cntr_value]
FROM sys.dm_os_performance_counters
WHERE [object_name] LIKE '%Manager%'
AND [counter_name] = 'Page life expectancy'