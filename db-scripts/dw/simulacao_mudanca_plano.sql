-- =========================
-- ALTERAÇÃO NO OLTP
-- =========================
UPDATE financeiro.planos
SET preco_mensal = 34.90
WHERE nome_plano = 'Padrao';


-- 4.1 NOVOS
INSERT INTO dw.dim_plano (
    id_plano,
    nome_plano,
    preco,
    resolucao,
    data_inicio,
    data_fim,
    flag_ativo
)
SELECT 
    hp.id_plano,
    p.nome_plano,
    p.preco_mensal,
    p.resolucao_max,
    hp.dt_inicio,
    hp.dt_fim,
    TRUE
FROM financeiro.historico_plano hp
JOIN financeiro.planos p 
    ON p.id_plano = hp.id_plano
WHERE NOT EXISTS (
    SELECT 1 
    FROM dw.dim_plano dp
    WHERE dp.id_plano = hp.id_plano
      AND dp.data_inicio = hp.dt_inicio
);

-- 4.2 ALTERAÇÕES
WITH modificados AS (
    SELECT hp.*, p.nome_plano, p.preco_mensal, p.resolucao_max
    FROM financeiro.historico_plano hp
    JOIN financeiro.planos p 
        ON p.id_plano = hp.id_plano
    JOIN dw.dim_plano dp 
        ON dp.id_plano = hp.id_plano
    WHERE dp.flag_ativo = TRUE
      AND (
        p.preco_mensal IS DISTINCT FROM dp.preco OR
        p.resolucao_max IS DISTINCT FROM dp.resolucao
      )
),

fechar AS (
    UPDATE dw.dim_plano dp
    SET data_fim = CURRENT_TIMESTAMP,
        flag_ativo = FALSE
    FROM modificados m
    WHERE dp.id_plano = m.id_plano
      AND dp.flag_ativo = TRUE
)

INSERT INTO dw.dim_plano (
    id_plano,
    nome_plano,
    preco,
    resolucao,
    data_inicio,
    data_fim,
    flag_ativo
)
SELECT 
    id_plano,
    nome_plano,
    preco_mensal,
    resolucao_max,
    CURRENT_TIMESTAMP,
    NULL,
    TRUE
FROM modificados;