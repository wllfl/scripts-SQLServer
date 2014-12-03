/* Limpando registros e resetando IDENTITY */
TRUNCATE TABLE saoroque.dbo.empregos_vagas

/* Desligando campos IDENTITY */
SET IDENTITY_INSERT saoroque.dbo.empregos_vagas ON

INSERT INTO saoroque.dbo.empregos_vagas (id ,id_usuario ,ramo ,porte ,titulo ,descricao ,requisitos ,faixa_salarial ,beneficios ,numero_vagas ,tipo_contrato ,cidade ,horario ,data ,views ,status ,revisada)
SELECT id ,id_usuario ,ramo ,porte ,titulo ,descricao ,requisitos ,faixa_salarial ,beneficios ,numero_vagas ,tipo_contrato ,cidade ,horario ,
data ,views ,status ,revisada FROM guia1.dbo.empregos_vagas

/* Ativando campos IDENTITY */
SET IDENTITY_INSERT saoroque.dbo.empregos_vagas OFF