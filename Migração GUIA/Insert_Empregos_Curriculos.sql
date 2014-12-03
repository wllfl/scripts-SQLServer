/* Limpando registros e resetando IDENTITY */
TRUNCATE TABLE saoroque.dbo.empregos_curriculos

/* Desligando campos IDENTITY */
SET IDENTITY_INSERT saoroque.dbo.empregos_curriculos ON

INSERT INTO saoroque.dbo.empregos_curriculos(id ,cpf ,senha ,nome ,sobrenome ,email ,nascimento ,sexo ,estado_civil ,cep ,endereco ,numero ,complemento ,bairro ,cidade ,tel_residencial ,tel_celular ,formacao ,curso ,detalhes ,curso_extra ,empresa1 ,
 cargo1 ,data1 ,experiencia1 ,empresa2 ,cargo2 ,data2 ,informatica ,outros_conhecimentos ,ingles ,espanhol ,outros_idiomas ,area1 ,area2 ,area3 ,newsletter ,data_cadastro ,status ,ultimo_login ,ultima_alteracao ,
 formacao2 ,curso2 ,detalhes2 ,curso_extra2 ,empresa3 ,cargo3 ,data3 ,experiencia3 ,experiencia2 ,apresentacao ,homepage ,sorocaba ,votorantim ,mairinque ,saoroque ,aracariguama ,aluminio ,pretensao_salarial ,
 tipo_vaga ,salario1 ,salario2 ,salario3 ,piedade ,ibiuna ,cotia ,vargem_grande)
SELECT id ,cpf ,senha ,nome ,sobrenome ,email ,nascimento ,sexo ,estado_civil ,cep ,endereco ,numero ,complemento ,bairro ,cidade ,tel_residencial ,tel_celular ,formacao ,
curso ,detalhes ,curso_extra ,empresa1 ,cargo1 ,data1 ,experiencia1 ,empresa2 ,cargo2 ,data2 ,informatica ,outros_conhecimentos ,ingles ,espanhol ,outros_idiomas ,area1 ,
area2 ,area3 ,newsletter ,data_cadastro ,status ,ultimo_login ,ultima_alteracao ,formacao2 ,curso2 ,detalhes2 ,curso_extra2 ,empresa3 ,cargo3 ,data3 ,experiencia3 ,
experiencia2 ,apresentacao ,homepage ,sorocaba ,votorantim ,mairinque ,saoroque ,aracariguama ,aluminio ,pretensao_salarial ,tipo_vaga ,salario1 ,salario2 ,salario3 ,
piedade ,ibiuna ,cotia ,vargem_grande
FROM guia1.dbo.empregos_curriculos

/* Ativando campos IDENTITY */
SET IDENTITY_INSERT saoroque.dbo.empregos_curriculos OFF