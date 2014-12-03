USE saoroque

/* Limpa a tabela clientes_imobiliarias e reseta o IDENTITY */
TRUNCATE TABLE saoroque.dbo.clientes_imobiliarias 

/* Acerto de clientes da ANOVA */
INSERT INTO saoroque.dbo.clientes_imobiliarias (id_temp, nome,rg,cpf,endereco,bairro,cidade,estado,telefone_residencial, telefone_comercial,celular,email,obs,data,cod_imobiliaria,cep)
SELECT id, proprietario, rg, cpf, endereco, bairro, cidade, estado, telefone_residencial, telefone_comercial,celular, email, obs, data, '77', cep FROM guia1.dbo.anova_clientes


/* Acerto de clientes da CGI */
INSERT INTO saoroque.dbo.clientes_imobiliarias (id_temp, nome,rg,cpf,endereco,bairro,cidade,estado,telefone_residencial, telefone_comercial,celular,email,obs,data,cod_imobiliaria,cep)
SELECT id, proprietario, rg, cpf, endereco, bairro, cidade, estado, telefone_residencial, telefone_comercial,celular, email, obs, data, '18', cep FROM guia1.dbo.cgi_clientes


/* Acerto de clientes da VITORIO */
INSERT INTO saoroque.dbo.clientes_imobiliarias (id_temp, nome,rg,cpf,endereco,bairro,cidade,estado,telefone_residencial, telefone_comercial,celular,email,obs,data,cod_imobiliaria,cep)
SELECT id, proprietario, rg, cpf, endereco, bairro, cidade, estado, telefone_residencial, telefone_comercial,celular, email, obs, data, '81', cep FROM guia1.dbo.imoveis_vitorio_clientes


/* Acerto de clientes da JZ */
INSERT INTO saoroque.dbo.clientes_imobiliarias (id_temp, nome,rg,cpf,endereco,bairro,cidade,estado,telefone_residencial,celular,email,obs,data,cod_imobiliaria)
SELECT id, nome, rg, cpf, endereco, bairro, cidade, estado, telefone, celular, email, obs, data, '37' FROM imobiliaria.dbo.clientes


/* Adiciona o código do cliente individual de cada imobiliária na tabela imoveis JZ */
UPDATE saoroque.dbo.imoveis SET cod_cliente = ci.id 
FROM saoroque.dbo.clientes_imobiliarias ci INNER JOIN saoroque.dbo.imoveis i ON ci.id_temp = i.cod_cliente_jz
WHERE cod_usuario = 37


/* Adiciona o código do cliente individual de cada imobiliária na tabela imoveis VITÓRIO */
UPDATE saoroque.dbo.imoveis SET cod_cliente = ci.id 
FROM saoroque.dbo.clientes_imobiliarias ci INNER JOIN saoroque.dbo.imoveis i ON ci.id_temp = i.id_cliente_vitorio
WHERE cod_usuario = 81


/* Adiciona o código do cliente individual de cada imobiliária na tabela imoveis CGI */
UPDATE saoroque.dbo.imoveis SET cod_cliente = ci.id 
FROM saoroque.dbo.clientes_imobiliarias ci INNER JOIN saoroque.dbo.imoveis i ON ci.id_temp = i.id_cliente_cgi
WHERE cod_usuario = 18


/* Adiciona o código do cliente individual de cada imobiliária na tabela imoveis ANOVA */
UPDATE saoroque.dbo.imoveis SET cod_cliente = ci.id 
FROM saoroque.dbo.clientes_imobiliarias ci INNER JOIN saoroque.dbo.imoveis i ON ci.id_temp = i.id_cliente_cgi
WHERE cod_usuario = 77




							
																						    
																								 
																								 
							