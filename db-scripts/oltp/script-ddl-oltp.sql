-- =========================
-- SCHEMAS
-- =========================
DROP SCHEMA IF EXISTS streaming CASCADE;
DROP SCHEMA IF EXISTS catalogo CASCADE;
DROP SCHEMA IF EXISTS financeiro CASCADE;
DROP SCHEMA IF EXISTS usuarios CASCADE;
DROP SCHEMA IF EXISTS metadata CASCADE;

CREATE SCHEMA IF NOT EXISTS usuarios;
CREATE SCHEMA IF NOT EXISTS financeiro;
CREATE SCHEMA IF NOT EXISTS catalogo;
CREATE SCHEMA IF NOT EXISTS streaming;
CREATE SCHEMA IF NOT EXISTS metadata;

-- =========================
-- USUARIOS
-- =========================
CREATE TABLE IF NOT EXISTS usuarios.contas (
    cpf VARCHAR(11) PRIMARY KEY,
    nome TEXT NOT NULL,
    email TEXT NOT NULL UNIQUE,
    data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    data_renovacao DATE
);

CREATE TABLE IF NOT EXISTS usuarios.perfil (
    id_perfil SERIAL PRIMARY KEY,
    id_conta VARCHAR(11) NOT NULL,
    nome_perfil TEXT NOT NULL,
    avatar TEXT,
    idioma TEXT,
    classificacao INTEGER,
    CONSTRAINT fk_perfil_conta
        FOREIGN KEY (id_conta) REFERENCES usuarios.contas(cpf),
    CONSTRAINT uq_perfil UNIQUE (id_conta, nome_perfil)
);

-- =========================
-- FINANCEIRO
-- =========================
CREATE TABLE IF NOT EXISTS financeiro.pagamento (
    id_pagamento SERIAL PRIMARY KEY,
    dt_pagamento DATE NOT NULL,
    valor NUMERIC(10,2) NOT NULL,
    data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    cpf VARCHAR(11) NOT NULL,
    CONSTRAINT fk_pagamento_conta
        FOREIGN KEY (cpf) REFERENCES usuarios.contas(cpf)
);

CREATE TABLE IF NOT EXISTS financeiro.planos (
    id_plano SERIAL PRIMARY KEY,
    nome_plano TEXT NOT NULL,
    preco_mensal NUMERIC(10,2) NOT NULL CHECK (preco_mensal > 0),
    resolucao_max TEXT
);

CREATE TABLE IF NOT EXISTS financeiro.historico_plano (
    id_hist_plan SERIAL PRIMARY KEY,
    dt_inicio DATE NOT NULL,
    dt_fim DATE,
    id_plano INTEGER NOT NULL,
    cpf VARCHAR(11) NOT NULL,
    CONSTRAINT fk_hist_plano_plano
        FOREIGN KEY (id_plano) REFERENCES financeiro.planos(id_plano),
    CONSTRAINT fk_hist_plano_conta
        FOREIGN KEY (cpf) REFERENCES usuarios.contas(cpf)
);

-- =========================
-- CATALOGO
-- =========================
CREATE TABLE IF NOT EXISTS catalogo.conteudo (
    id_conteudo SERIAL PRIMARY KEY,
    titulo TEXT NOT NULL,
    resumo TEXT,
    tipo TEXT,
    classificacao INTEGER CHECK (classificacao BETWEEN 0 AND 18),
    genero TEXT,
    ano_lancamento INTEGER,
    duracao INTEGER
);

CREATE TABLE IF NOT EXISTS catalogo.franquia (
    id_franquia SERIAL PRIMARY KEY,
    nome_franquia TEXT NOT NULL,
    sequencia INTEGER
);

CREATE TABLE IF NOT EXISTS catalogo.filmes (
    id_filme SERIAL PRIMARY KEY,
    detalhes TEXT,
    id_franquia INTEGER,
    id_conteudo INTEGER NOT NULL,
    CONSTRAINT fk_filme_franquia
        FOREIGN KEY (id_franquia) REFERENCES catalogo.franquia(id_franquia),
    CONSTRAINT fk_filme_conteudo
        FOREIGN KEY (id_conteudo) REFERENCES catalogo.conteudo(id_conteudo)
);

CREATE TABLE IF NOT EXISTS catalogo.series (
    id_serie SERIAL PRIMARY KEY,
    titulo_serie TEXT NOT NULL,
    detalhes TEXT,
    classificacao_serie INTEGER
);

CREATE TABLE IF NOT EXISTS catalogo.temporada (
    id_temporada SERIAL PRIMARY KEY,
    nro_temp INTEGER NOT NULL,
    id_serie INTEGER NOT NULL,
    CONSTRAINT fk_temporada_serie
        FOREIGN KEY (id_serie) REFERENCES catalogo.series(id_serie)
);

CREATE TABLE IF NOT EXISTS catalogo.episodio (
    id_ep SERIAL PRIMARY KEY,
    nro_ep INTEGER NOT NULL,
    id_temporada INTEGER NOT NULL,
    id_conteudo INTEGER NOT NULL,
    CONSTRAINT fk_ep_temporada
        FOREIGN KEY (id_temporada) REFERENCES catalogo.temporada(id_temporada),
    CONSTRAINT fk_ep_conteudo
        FOREIGN KEY (id_conteudo) REFERENCES catalogo.conteudo(id_conteudo)
);

CREATE TABLE IF NOT EXISTS catalogo.elenco_direcao (
    id_elenco SERIAL PRIMARY KEY,
    papel TEXT,
    biografia TEXT
);

CREATE TABLE IF NOT EXISTS catalogo.participacao (
    id_participacao SERIAL PRIMARY KEY,
    personagem TEXT,
    id_elenco INTEGER NOT NULL,
    id_conteudo INTEGER NOT NULL,
    CONSTRAINT fk_part_elenco
        FOREIGN KEY (id_elenco) REFERENCES catalogo.elenco_direcao(id_elenco),
    CONSTRAINT fk_part_conteudo
        FOREIGN KEY (id_conteudo) REFERENCES catalogo.conteudo(id_conteudo)
);

-- =========================
-- METADATA
-- =========================
CREATE TABLE IF NOT EXISTS metadata.idioma (
    id_idioma SERIAL PRIMARY KEY,
    nome TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS metadata.conteudo_idioma (
    id_conteudo INTEGER NOT NULL,
    id_idioma INTEGER NOT NULL,
    detalhes TEXT,
    PRIMARY KEY (id_conteudo, id_idioma),
    CONSTRAINT fk_ci_conteudo
        FOREIGN KEY (id_conteudo) REFERENCES catalogo.conteudo(id_conteudo),
    CONSTRAINT fk_ci_idioma
        FOREIGN KEY (id_idioma) REFERENCES metadata.idioma(id_idioma)
);

-- =========================
-- STREAMING
-- =========================
CREATE TABLE IF NOT EXISTS streaming.historico_visualizacao (
    id_hist_vis SERIAL PRIMARY KEY,
    dt_inicio TIMESTAMP,
    progresso NUMERIC(5,2) CHECK (progresso BETWEEN 0 AND 100),
    concluido BOOLEAN DEFAULT FALSE,
    id_perfil INTEGER NOT NULL,
    id_conteudo INTEGER NOT NULL,
    CONSTRAINT fk_hist_vis_perfil
        FOREIGN KEY (id_perfil) REFERENCES usuarios.perfil(id_perfil),
    CONSTRAINT fk_hist_vis_conteudo
        FOREIGN KEY (id_conteudo) REFERENCES catalogo.conteudo(id_conteudo)
);