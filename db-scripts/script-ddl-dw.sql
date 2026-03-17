CREATE TABLE IF NOT EXISTS usuarios.contas (
    cpf VARCHAR(14) PRIMARY KEY,
    nome VARCHAR(200) NOT NULL,
    email VARCHAR(200) NOT NULL,
    data_criacao DATE NOT NULL,
    data_renovacao DATE
);

CREATE TABLE IF NOT EXISTS usuarios.perfil (
    id_perfil SERIAL PRIMARY KEY,
    nome_perfil VARCHAR(100) NOT NULL,
    avatar VARCHAR(255),
    idioma VARCHAR(50),
    classificacao_max VARCHAR(10),
    infantil BOOLEAN DEFAULT FALSE,
    id_conta VARCHAR(14) NOT NULL,

    CONSTRAINT fk_perfil_conta
        FOREIGN KEY (id_conta)
        REFERENCES usuarios.contas(cpf)
);

CREATE TABLE IF NOT EXISTS usuarios.historico_plano (
    id_hist_plan SERIAL PRIMARY KEY,
    dt_inicio DATE NOT NULL,
    dt_fim DATE,
    id_plano INT NOT NULL,
    id_conta VARCHAR(14) NOT NULL
);

CREATE TABLE IF NOT EXISTS financeiro.planos (
    id_plano SERIAL PRIMARY KEY,
    nome_plano VARCHAR(100) NOT NULL,
    preco_mensal NUMERIC(10,2) NOT NULL,
    resolucao_max VARCHAR(20)
);

CREATE TABLE IF NOT EXISTS financeiro.pagamento (
    id_pagamento SERIAL PRIMARY KEY,
    dt_pagamento DATE NOT NULL,
    valor NUMERIC(10,2) NOT NULL,
    data_criacao DATE,
    id_conta VARCHAR(14) NOT NULL,

    CONSTRAINT fk_pagamento_conta
        FOREIGN KEY (id_conta)
        REFERENCES usuarios.contas(cpf)
);

ALTER TABLE usuarios.historico_plano
ADD CONSTRAINT fk_hist_plano_plano
FOREIGN KEY (id_plano)
REFERENCES financeiro.planos(id_plano);

ALTER TABLE usuarios.historico_plano
ADD CONSTRAINT fk_hist_plano_conta
FOREIGN KEY (id_conta)
REFERENCES usuarios.contas(cpf);



CREATE TABLE IF NOT EXISTS catalogo.conteudo (
    id_conteudo SERIAL PRIMARY KEY,
    titulo VARCHAR(200) NOT NULL,
    resumo TEXT,
    tipo VARCHAR(20),
    classificacao VARCHAR(10)
);

CREATE TABLE IF NOT EXISTS catalogo.franquia (
    id_franquia SERIAL PRIMARY KEY,
    nome_franquia VARCHAR(200),
    sequencia INT
);

CREATE TABLE IF NOT EXISTS catalogo.filme (
    id_conteudo INT PRIMARY KEY,
    id_franquia INT,
    detalhes TEXT,

    CONSTRAINT fk_filme_conteudo
        FOREIGN KEY (id_conteudo)
        REFERENCES catalogo.conteudo(id_conteudo),

    CONSTRAINT fk_filme_franquia
        FOREIGN KEY (id_franquia)
        REFERENCES catalogo.franquia(id_franquia)
);

CREATE TABLE IF NOT EXISTS catalogo.series (
    id_serie SERIAL PRIMARY KEY,
    titulo_serie VARCHAR(200),
    detalhes TEXT
);

CREATE TABLE IF NOT EXISTS catalogo.temporada (
    id_temporada SERIAL PRIMARY KEY,
    nro_temp INT,
    id_serie INT NOT NULL,

    CONSTRAINT fk_temporada_serie
        FOREIGN KEY (id_serie)
        REFERENCES catalogo.series(id_serie)
);

CREATE TABLE IF NOT EXISTS catalogo.episodio (
    id_ep SERIAL PRIMARY KEY,
    nro_ep INT,
    id_temporada INT NOT NULL,
    id_conteudo INT NOT NULL,

    CONSTRAINT fk_ep_temporada
        FOREIGN KEY (id_temporada)
        REFERENCES catalogo.temporada(id_temporada),

    CONSTRAINT fk_ep_conteudo
        FOREIGN KEY (id_conteudo)
        REFERENCES catalogo.conteudo(id_conteudo)
);

CREATE TABLE IF NOT EXISTS streaming.historico_visualizacao (
    id_hist_vis SERIAL PRIMARY KEY,
    dt_inicio DATE,
    progresso INT,
    concluido BOOLEAN DEFAULT FALSE,
    id_perfil INT NOT NULL,
    id_conteudo INT NOT NULL,

    CONSTRAINT fk_hist_perfil
        FOREIGN KEY (id_perfil)
        REFERENCES usuarios.perfil(id_perfil),

    CONSTRAINT fk_hist_conteudo
        FOREIGN KEY (id_conteudo)
        REFERENCES catalogo.conteudo(id_conteudo)
);

CREATE TABLE IF NOT EXISTS metadata.pessoa (
    id_pessoa SERIAL PRIMARY KEY,
    nome VARCHAR(200),
    biografia TEXT
);

CREATE TABLE IF NOT EXISTS metadata.participacao (
    id_participacao SERIAL PRIMARY KEY,
    papel VARCHAR(50),
    personagem VARCHAR(200),
    id_pessoa INT NOT NULL,
    id_conteudo INT NOT NULL,

    CONSTRAINT fk_part_pessoa
        FOREIGN KEY (id_pessoa)
        REFERENCES metadata.pessoa(id_pessoa),

    CONSTRAINT fk_part_conteudo
        FOREIGN KEY (id_conteudo)
        REFERENCES catalogo.conteudo(id_conteudo)
);

CREATE TABLE IF NOT EXISTS metadata.idioma (
    id_idioma SERIAL PRIMARY KEY,
    nome VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS metadata.conteudo_idioma (
    id_conteudo INT NOT NULL,
    id_idioma INT NOT NULL,
    tipo VARCHAR(20),

    PRIMARY KEY (id_conteudo, id_idioma, tipo),

    CONSTRAINT fk_ci_conteudo
        FOREIGN KEY (id_conteudo)
        REFERENCES catalogo.conteudo(id_conteudo),

    CONSTRAINT fk_ci_idioma
        FOREIGN KEY (id_idioma)
        REFERENCES metadata.idioma(id_idioma)
);