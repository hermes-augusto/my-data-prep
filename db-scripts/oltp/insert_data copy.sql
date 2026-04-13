-- =========================
-- USUARIOS (50)
-- =========================
INSERT INTO usuarios.contas (cpf, nome, email, data_criacao)
SELECT 
    LPAD(i::text,11,'0'),
    'Usuario ' || i,
    'user'||i||'@email.com',
    NOW() - (i || ' days')::interval
FROM generate_series(1,50) i;

-- =========================
-- PERFIS (~80)
-- =========================
INSERT INTO usuarios.perfil (id_conta, nome_perfil, classificacao)
SELECT 
    c.cpf,
    CASE gs
        WHEN 1 THEN 'Principal'
        WHEN 2 THEN 'Kids'
        WHEN 3 THEN 'Convidado'
    END,
    (random()*18)::int
FROM usuarios.contas c
CROSS JOIN generate_series(1,2) gs;

-- =========================
-- PLANOS
-- =========================
INSERT INTO financeiro.planos (nome_plano, preco_mensal, resolucao_max) VALUES
('Basico',19.90,'HD'),
('Padrao',29.90,'Full HD'),
('Premium',49.90,'4K');

-- =========================
-- HISTORICO PLANO (50)
-- =========================
INSERT INTO financeiro.historico_plano (dt_inicio, id_plano, cpf)
SELECT 
    NOW() - (random()*365 || ' days')::interval,
    (random()*2 + 1)::int,
    cpf
FROM usuarios.contas;

-- =========================
-- PAGAMENTOS (~100)
-- =========================
INSERT INTO financeiro.pagamento (dt_pagamento, valor, cpf)
SELECT 
    NOW() - (random()*30 || ' days')::interval,
    (ARRAY[19.90,29.90,49.90])[floor(random()*3)+1],
    cpf
FROM usuarios.contas
CROSS JOIN generate_series(1,2);

-- =========================
-- CONTEUDO (25)
-- =========================
INSERT INTO catalogo.conteudo (titulo, tipo, classificacao, genero, ano_lancamento, duracao)
SELECT 
    'Conteudo ' || i,
    CASE WHEN i <= 15 THEN 'filme' ELSE 'serie' END,
    (random()*18)::int,
    (ARRAY['acao','drama','comedia','ficcao'])[floor(random()*4)+1],
    2000 + (random()*24)::int,
    CASE WHEN i <= 15 THEN 90 + (random()*60)::int ELSE NULL END
FROM generate_series(1,25) i;

-- =========================
-- SERIES (10)
-- =========================
INSERT INTO catalogo.series (titulo_serie, classificacao_serie)
SELECT titulo, classificacao
FROM catalogo.conteudo
WHERE tipo = 'serie';

-- =========================
-- TEMPORADAS (~20)
-- =========================
INSERT INTO catalogo.temporada (nro_temp, id_serie)
SELECT 
    gs,
    s.id_serie
FROM catalogo.series s
CROSS JOIN generate_series(1,2) gs;

-- =========================
-- EPISODIOS (~40)
-- =========================
INSERT INTO catalogo.episodio (nro_ep, id_temporada, id_conteudo)
SELECT 
    gs,
    t.id_temporada,
    (SELECT id_conteudo FROM catalogo.conteudo ORDER BY random() LIMIT 1)
FROM catalogo.temporada t
CROSS JOIN generate_series(1,2) gs;

-- =========================
-- IDIOMA
-- =========================
INSERT INTO metadata.idioma (nome) VALUES
('Português'),('Inglês'),('Espanhol');

-- =========================
-- CONTEUDO_IDIOMA
-- =========================
INSERT INTO metadata.conteudo_idioma (id_conteudo, id_idioma)
SELECT 
    id_conteudo,
    (random()*2 + 1)::int
FROM catalogo.conteudo;

-- =========================
-- HISTORICO VISUALIZACAO (~300)
-- =========================
INSERT INTO streaming.historico_visualizacao
(dt_inicio, progresso, concluido, id_perfil, id_conteudo)
SELECT 
    NOW() - (random()*10 || ' days')::interval,
    (random()*100)::numeric(5,2),
    random() > 0.5,
    p.id_perfil,
    c.id_conteudo
FROM usuarios.perfil p
CROSS JOIN catalogo.conteudo c
WHERE random() < 0.2;