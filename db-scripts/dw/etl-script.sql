-- =========================
-- DELTA - DIM_PERFIL (SCD1)
-- =========================
MERGE INTO dw.dim_perfil tgt
USING usuarios.perfil src
ON tgt.id_perfil = src.id_perfil

WHEN MATCHED AND (
    tgt.nome_perfil IS DISTINCT FROM src.nome_perfil OR
    tgt.idioma IS DISTINCT FROM src.idioma OR
    tgt.classificacao IS DISTINCT FROM src.classificacao
)
THEN UPDATE SET
    nome_perfil = src.nome_perfil,
    idioma = src.idioma,
    classificacao = src.classificacao

WHEN NOT MATCHED THEN
INSERT (id_perfil, nome_perfil, idioma, classificacao)
VALUES (src.id_perfil, src.nome_perfil, src.idioma, src.classificacao);

-- =========================
-- DELTA - DIM_PERFIL (SCD2)
-- =========================
MERGE INTO dw.dim_perfil tgt
USING usuarios.perfil src
ON tgt.id_perfil = src.id_perfil

WHEN MATCHED AND (
    tgt.nome_perfil IS DISTINCT FROM src.nome_perfil OR
    tgt.idioma IS DISTINCT FROM src.idioma OR
    tgt.classificacao IS DISTINCT FROM src.classificacao
)
THEN UPDATE SET
    nome_perfil = src.nome_perfil,
    idioma = src.idioma,
    classificacao = src.classificacao

WHEN NOT MATCHED THEN
INSERT (id_perfil, nome_perfil, idioma, classificacao)
VALUES (src.id_perfil, src.nome_perfil, src.idioma, src.classificacao);

-- =========================
-- DELTA - DIM_CONTEUDO (SCD2)
-- =========================
-- 3.1 NOVOS
INSERT INTO dw.dim_conteudo (
    id_conteudo,
    titulo,
    tipo,
    classificacao,
    ano_lancamento,
    data_inicio,
    data_fim,
    flag_ativo
)
SELECT 
    c.id_conteudo,
    c.titulo,
    c.tipo,
    c.classificacao,
    c.ano_lancamento,
    CURRENT_TIMESTAMP,
    NULL,
    TRUE
FROM catalogo.conteudo c
WHERE NOT EXISTS (
    SELECT 1 
    FROM dw.dim_conteudo dc
    WHERE dc.id_conteudo = c.id_conteudo
);

-- 3.2 ALTERAÇÕES (SCD2)
WITH modificados AS (
    SELECT c.*
    FROM catalogo.conteudo c
    JOIN dw.dim_conteudo dc
      ON c.id_conteudo = dc.id_conteudo
    WHERE dc.flag_ativo = TRUE
      AND (
        c.titulo IS DISTINCT FROM dc.titulo OR
        c.tipo IS DISTINCT FROM dc.tipo OR
        c.classificacao IS DISTINCT FROM dc.classificacao
      )
),

fechar AS (
    UPDATE dw.dim_conteudo dc
    SET data_fim = CURRENT_TIMESTAMP,
        flag_ativo = FALSE
    FROM modificados m
    WHERE dc.id_conteudo = m.id_conteudo
      AND dc.flag_ativo = TRUE
)

INSERT INTO dw.dim_conteudo (
    id_conteudo,
    titulo,
    tipo,
    classificacao,
    ano_lancamento,
    data_inicio,
    data_fim,
    flag_ativo
)
SELECT 
    id_conteudo,
    titulo,
    tipo,
    classificacao,
    ano_lancamento,
    CURRENT_TIMESTAMP,
    NULL,
    TRUE
FROM modificados;

-- =========================
-- DELTA - DIM_PLANO (SCD2)

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

-- =========================
-- DELTA - FATO_VISUALIZACAO
TRUNCATE TABLE dw.fato_visualizacao;
INSERT INTO dw.fato_visualizacao (
    sk_perfil,
    sk_conteudo,
    sk_data,
    sk_plano,
    tempo_assistido,
    percentual,
    qtde_visualizacao
)
SELECT 

dp.sk_perfil,
dc.sk_conteudo,
dd.sk_data,
dpl.sk_plano,

COALESCE(c.duracao, 45) * (hv.progresso / 100.0),
hv.progresso,
1

FROM streaming.historico_visualizacao hv

JOIN usuarios.perfil p 
    ON p.id_perfil = hv.id_perfil

JOIN dw.dim_perfil dp 
    ON dp.id_perfil = p.id_perfil

JOIN catalogo.conteudo c 
    ON c.id_conteudo = hv.id_conteudo

JOIN dw.dim_conteudo dc 
    ON dc.id_conteudo = c.id_conteudo
   AND dc.flag_ativo = TRUE

JOIN dw.dim_data dd 
    ON dd.sk_data = TO_CHAR(hv.dt_inicio, 'YYYYMMDD')::INT

JOIN usuarios.contas ct 
    ON ct.cpf = p.id_conta

JOIN financeiro.historico_plano hp 
    ON hp.cpf = ct.cpf

JOIN dw.dim_plano dpl 
    ON dpl.id_plano = hp.id_plano
   AND dpl.flag_ativo = TRUE

WHERE NOT EXISTS (
    SELECT 1
    FROM dw.fato_visualizacao f
    WHERE f.sk_perfil = dp.sk_perfil
      AND f.sk_conteudo = dc.sk_conteudo
      AND f.sk_data = dd.sk_data
);