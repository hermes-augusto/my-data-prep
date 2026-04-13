
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