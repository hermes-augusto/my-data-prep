-- =========================
-- CARGA INICIAL - DIM_DATA
-- =========================
INSERT INTO dw.dim_data (
    sk_data,
    data_completa,
    dia,
    mes,
    ano,
    dia_semana
)
SELECT 
    TO_CHAR(datum, 'YYYYMMDD')::INT,
    datum,
    EXTRACT(DAY FROM datum),
    EXTRACT(MONTH FROM datum),
    EXTRACT(YEAR FROM datum),
    TO_CHAR(datum, 'TMDay')
FROM generate_series(
    DATE '2020-01-01',
    DATE '2030-12-31',
    INTERVAL '1 day'
) AS datum
WHERE NOT EXISTS (
    SELECT 1 FROM dw.dim_data d
    WHERE d.data_completa = datum
);

-- =========================
-- CARGA INICIAL - DIM_PERFIL
-- =========================
INSERT INTO dw.dim_perfil (
    id_perfil,
    nome_perfil,
    idioma,
    classificacao
)
SELECT 
    p.id_perfil,
    p.nome_perfil,
    p.idioma,
    p.classificacao
FROM usuarios.perfil p
WHERE NOT EXISTS (
    SELECT 1 FROM dw.dim_perfil dp
    WHERE dp.id_perfil = p.id_perfil
);

-- =========================
-- CARGA INICIAL - DIM_CONTEUDO
-- =========================
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
    SELECT 1 FROM dw.dim_conteudo dc
    WHERE dc.id_conteudo = c.id_conteudo
);
-- =========================
-- CARGA INICIAL - DIM_PLANO
-- =========================
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
    SELECT 1 FROM dw.dim_plano dp
    WHERE dp.id_plano = hp.id_plano
      AND dp.data_inicio = hp.dt_inicio
);

-- =========================
-- CARGA INICIAL - FATO
-- =========================
INSERT INTO dw.fato_visualizacao (
    sk_perfil,
    sk_conteudo,
    sk_data,
    sk_plano,
    tempo_assistido,
    percentual,
    qtde_visualizacao
)
SELECT DISTINCT ON (
    hv.id_perfil,
    hv.id_conteudo,
    DATE(hv.dt_inicio)
)

dp.sk_perfil,
dc.sk_conteudo,
dd.sk_data,
dpl.sk_plano,

COALESCE(c.duracao, 45) * (hv.progresso / 100.0),
hv.progresso,
1

FROM streaming.historico_visualizacao hv

-- PERFIL
JOIN usuarios.perfil p 
  ON p.id_perfil = hv.id_perfil

JOIN dw.dim_perfil dp 
  ON dp.id_perfil = p.id_perfil

-- CONTEUDO (SCD2)
JOIN catalogo.conteudo c 
  ON c.id_conteudo = hv.id_conteudo

JOIN dw.dim_conteudo dc 
  ON dc.id_conteudo = c.id_conteudo
 AND dc.flag_ativo = TRUE

-- DATA
JOIN dw.dim_data dd 
  ON dd.data_completa = DATE(hv.dt_inicio)

-- CONTA
JOIN usuarios.contas ct 
  ON ct.cpf = p.id_conta

-- PLANO HISTÓRICO
JOIN financeiro.historico_plano hp 
  ON hp.cpf = ct.cpf
 AND hv.dt_inicio >= hp.dt_inicio
 AND (hp.dt_fim IS NULL OR hv.dt_inicio <= hp.dt_fim)

-- DIM_PLANO SCD2
JOIN dw.dim_plano dpl 
  ON dpl.id_plano = hp.id_plano
 AND hv.dt_inicio >= dpl.data_inicio
 AND (dpl.data_fim IS NULL OR hv.dt_inicio <= dpl.data_fim)


WHERE NOT EXISTS (
    SELECT 1
    FROM dw.fato_visualizacao f
    WHERE f.sk_perfil = dp.sk_perfil
      AND f.sk_conteudo = dc.sk_conteudo
      AND f.sk_data = dd.sk_data
)

ORDER BY 
    hv.id_perfil,
    hv.id_conteudo,
    DATE(hv.dt_inicio),
    hv.dt_inicio DESC;