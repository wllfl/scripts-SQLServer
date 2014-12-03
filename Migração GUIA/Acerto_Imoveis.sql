USE saoroque

/* Limpando registros e resetando IDENTITY */
TRUNCATE TABLE saoroque.dbo.imoveis

/* Desligando campos IDENTITY */
SET IDENTITY_INSERT saoroque.dbo.imoveis ON

INSERT INTO saoroque.dbo.imoveis (id ,categoria ,cidade ,endereco ,destaque ,descricao ,cond_pag ,area ,area_c ,quartos ,suites ,tipo ,valor ,data ,usuario ,
imagem1 ,imagem2 ,imagem3 ,imagem4 ,imagem5 ,imagem6 ,imagem7 ,imagem8 ,imagem9 ,imagem10 ,views ,status ,cgi ,morada ,tipo_imovel ,tipo_construcao ,salas ,ambientes ,cozinhas ,wc ,
lavabo ,piscina ,garagem ,telefone ,varanda ,lavanderia ,despensa ,churrasqueira ,campo ,quadra ,sauna ,festas ,hospede ,caseiro ,empregada ,lareira ,gas ,portao ,pomar ,jardim ,lago ,
nascente ,riacho ,pasto ,canil ,escritura ,tipo_escritura ,id_cliente_cgi ,jogos ,obs_ficha ,comissao ,endereco_ficha ,cod_morada ,situacao ,aquecedor ,tipo_piscina ,horta ,condominio ,area_servico ,
jz ,cod_cliente_jz ,cadastrado_jz ,alterado_jz ,cod_jz_antigo ,revisado ,home_jz ,endereco_jz ,obs_jz ,imagem11 ,imagem12 ,imagem13 ,imagem14 ,imagem15 ,imagem16 ,imagem17 ,imagem18 ,imagem19 ,imagem20 ,
corretor ,valor_extenso ,anova ,vitorio ,id_cliente_vitorio)
SELECT  id ,categoria ,cidade ,endereco ,destaque ,descricao ,cond_pag ,area ,area_c ,quartos ,suites ,tipo ,valor ,data ,usuario ,
imagem1 ,imagem2 ,imagem3 ,imagem4 ,imagem5 ,imagem6 ,imagem7 ,imagem8 ,imagem9 ,imagem10 ,views ,status ,cgi ,morada ,tipo_imovel ,tipo_construcao ,salas ,ambientes ,cozinhas ,wc ,
lavabo ,piscina ,garagem ,telefone ,varanda ,lavanderia ,despensa ,churrasqueira ,campo ,quadra ,sauna ,festas ,hospede ,caseiro ,empregada ,lareira ,gas ,portao ,pomar ,jardim ,lago ,
nascente ,riacho ,pasto ,canil ,escritura ,tipo_escritura ,id_cliente_cgi ,jogos ,obs_ficha ,comissao ,endereco_ficha ,cod_morada ,situacao ,aquecedor ,tipo_piscina ,horta ,condominio ,area_servico ,
jz ,cod_cliente_jz ,cadastrado_jz ,alterado_jz ,cod_jz_antigo ,revisado ,home_jz ,endereco_jz ,obs_jz ,imagem11 ,imagem12 ,imagem13 ,imagem14 ,imagem15 ,imagem16 ,imagem17 ,imagem18 ,imagem19 ,imagem20 ,
corretor ,valor_extenso ,anova ,vitorio ,id_cliente_vitorio FROM guia1.dbo.imoveis

/* Ativando campos IDENTITY */
SET IDENTITY_INSERT saoroque.dbo.imoveis OFF
