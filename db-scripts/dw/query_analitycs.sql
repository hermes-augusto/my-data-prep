-- TOP CONTEÚDOS
SELECT 
    dc.titulo,
    COUNT(*) AS total_visualizacoes
FROM dw.fato_visualizacao f
JOIN dw.dim_conteudo dc 
    ON dc.sk_conteudo = f.sk_conteudo
GROUP BY dc.titulo
ORDER BY total_visualizacoes DESC;

-- PERFIS MAIS ATIVOS
SELECT 
    dp.nome_perfil,
    COUNT(*) AS total_views,
    AVG(f.percentual) AS media_engajamento
FROM dw.fato_visualizacao f
JOIN dw.dim_perfil dp 
    ON dp.sk_perfil = f.sk_perfil
GROUP BY dp.nome_perfil
ORDER BY total_views DESC;

-- USO POR PLANO
SELECT 
    dpl.nome_plano,
    COUNT(*) AS total_views,
    AVG(f.percentual) AS engajamento_medio
FROM dw.fato_visualizacao f
JOIN dw.dim_plano dpl 
    ON dpl.sk_plano = f.sk_plano
GROUP BY dpl.nome_plano
ORDER BY total_views DESC;


-- TEMPO TOTAL ASSISTIDO
SELECT 
    dp.nome_perfil,
    SUM(f.tempo_assistido) AS tempo_total
FROM dw.fato_visualizacao f
JOIN dw.dim_perfil dp 
    ON dp.sk_perfil = f.sk_perfil
GROUP BY dp.nome_perfil
ORDER BY tempo_total DESC;

-- USO AO LONGO DO TEMPO
SELECT 
    dd.data_completa,
    COUNT(*) AS total_views
FROM dw.fato_visualizacao f
JOIN dw.dim_data dd 
    ON dd.sk_data = f.sk_data
GROUP BY dd.data_completa
ORDER BY dd.data_completa;

-- CONTEÚDOS MAIS “ABANDONADOS”
SELECT 
    dc.titulo,
    AVG(f.percentual) AS media_progresso
FROM dw.fato_visualizacao f
JOIN dw.dim_conteudo dc 
    ON dc.sk_conteudo = f.sk_conteudo
GROUP BY dc.titulo
ORDER BY media_progresso ASC;



-- TAXA DE CONCLUSÃO
SELECT 
    dc.titulo,
    AVG(CASE WHEN f.percentual = 100 THEN 1 ELSE 0 END) AS taxa_conclusao
FROM dw.fato_visualizacao f
JOIN dw.dim_conteudo dc 
    ON dc.sk_conteudo = f.sk_conteudo
GROUP BY dc.titulo
ORDER BY taxa_conclusao DESC;

-- ANÁLISE CRUZADA (PLANO x TIPO)
SELECT 
    dpl.nome_plano,
    dc.tipo,
    COUNT(*) AS total_views
FROM dw.fato_visualizacao f
JOIN dw.dim_plano dpl ON dpl.sk_plano = f.sk_plano
JOIN dw.dim_conteudo dc ON dc.sk_conteudo = f.sk_conteudo
GROUP BY dpl.nome_plano, dc.tipo
ORDER BY total_views DESC;

-- ENGAJAMENTO POR TIPO DE CONTEÚDO
SELECT 
    dc.tipo,
    AVG(f.percentual) AS engajamento_medio,
    COUNT(*) AS total_views
FROM dw.fato_visualizacao f
JOIN dw.dim_conteudo dc 
    ON dc.sk_conteudo = f.sk_conteudo
GROUP BY dc.tipo;

-- TOP DIAS DA SEMANA
SELECT 
    dd.dia_semana,
    COUNT(*) AS total_views
FROM dw.fato_visualizacao f
JOIN dw.dim_data dd 
    ON dd.sk_data = f.sk_data
GROUP BY dd.dia_semana
ORDER BY total_views DESC;

-- retenção (engajamento alto)
SELECT 
    dc.titulo,
    AVG(f.percentual) AS engajamento
FROM dw.fato_visualizacao f
JOIN dw.dim_conteudo dc ON dc.sk_conteudo = f.sk_conteudo
GROUP BY dc.titulo
ORDER BY engajamento DESC;