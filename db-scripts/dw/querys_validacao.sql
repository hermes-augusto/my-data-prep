-- =========================
-- VALIDAR HISTÓRICO
-- =========================
SELECT 
    id_plano,
    nome_plano,
    preco,
    data_inicio,
    data_fim,
    flag_ativo
FROM dw.dim_plano
WHERE nome_plano = 'Padrao'
ORDER BY data_inicio;

SELECT count(1) FROM dw.fato_visualizacao;

SELECT *
FROM dw.fato_visualizacao f
LEFT JOIN dw.dim_perfil dp ON dp.sk_perfil = f.sk_perfil
WHERE dp.sk_perfil IS NULL;

SELECT 
    sk_perfil,
    sk_conteudo,
    sk_data,
    COUNT(*)
FROM dw.fato_visualizacao
GROUP BY 1,2,3
HAVING COUNT(*) > 1;


SELECT 
    hv.id_perfil,
    hv.dt_inicio,
    hp.dt_inicio,
    hp.dt_fim
FROM streaming.historico_visualizacao hv
JOIN usuarios.perfil p ON p.id_perfil = hv.id_perfil
JOIN usuarios.contas ct ON ct.cpf = p.id_conta
LEFT JOIN financeiro.historico_plano hp ON hp.cpf = ct.cpf;

SELECT 
    dc.titulo,
    f.percentual
FROM dw.fato_visualizacao f
JOIN dw.dim_conteudo dc 
    ON dc.sk_conteudo = f.sk_conteudo;
