DROP SCHEMA IF EXISTS dw CASCADE;
CREATE SCHEMA dw;

-- =========================
-- DIM_DATA (SCD 0)
-- =========================
CREATE TABLE dw.dim_data (
    sk_data INT PRIMARY KEY,
    data_completa DATE NOT NULL,
    dia INT,
    mes INT,
    ano INT,
    dia_semana VARCHAR(20)
);

-- =========================
-- DIM_PERFIL (SCD 1)
-- =========================
CREATE TABLE dw.dim_perfil (
    sk_perfil SERIAL PRIMARY KEY,
    id_perfil INT,
    nome_perfil TEXT,
    idioma TEXT,
    classificacao INT
);

-- =========================
-- DIM_CONTEUDO (SCD 2)
-- =========================
CREATE TABLE dw.dim_conteudo (
    sk_conteudo SERIAL PRIMARY KEY,
    id_conteudo INT,
    titulo TEXT,
    tipo TEXT,
    classificacao INT,
    ano_lancamento INT,
    data_inicio TIMESTAMP NOT NULL,
    data_fim TIMESTAMP,
    flag_ativo BOOLEAN DEFAULT TRUE
);

-- =========================
-- DIM_PLANO (SCD 2)
-- =========================
CREATE TABLE dw.dim_plano (
    sk_plano SERIAL PRIMARY KEY,
    id_plano INT,
    nome_plano TEXT,
    preco NUMERIC(10,2),
    resolucao TEXT,
    data_inicio TIMESTAMP NOT NULL,
    data_fim TIMESTAMP,
    flag_ativo BOOLEAN DEFAULT TRUE
);

-- =========================
-- FATO_VISUALIZACAO
-- =========================
CREATE TABLE dw.fato_visualizacao (
    sk_fato SERIAL PRIMARY KEY,
    sk_perfil INT REFERENCES dw.dim_perfil(sk_perfil),
    sk_conteudo INT REFERENCES dw.dim_conteudo(sk_conteudo),
    sk_data INT REFERENCES dw.dim_data(sk_data),
    sk_plano INT REFERENCES dw.dim_plano(sk_plano),
    tempo_assistido INT,
    percentual NUMERIC(5,2),
    qtde_visualizacao INT
);

