-- =========================
-- USUARIOS
-- =========================
INSERT INTO usuarios.contas VALUES
('11111111111','Joao Silva','joao@email.com',NOW(),NULL),
('22222222222','Maria Souza','maria@email.com',NOW(),NULL),
('33333333333','Pedro Lima','pedro@email.com',NOW(),NULL);

INSERT INTO usuarios.perfil (id_conta,nome_perfil,classificacao) VALUES
('11111111111','Joao',18),
('11111111111','Kids',10),
('22222222222','Maria',18),
('33333333333','Pedro',18);

-- =========================
-- FINANCEIRO
-- =========================
INSERT INTO financeiro.planos (nome_plano,preco_mensal,resolucao_max) VALUES
('Basico',19.90,'HD'),
('Padrao',29.90,'Full HD'),
('Premium',49.90,'4K');

INSERT INTO financeiro.pagamento (dt_pagamento,valor,cpf) VALUES
('2024-01-01',29.90,'11111111111'),
('2024-01-01',49.90,'22222222222'),
('2024-01-01',19.90,'33333333333');

INSERT INTO financeiro.historico_plano (dt_inicio,id_plano,cpf) VALUES
('2024-01-01',2,'11111111111'),
('2024-01-01',3,'22222222222'),
('2024-01-01',1,'33333333333');

-- =========================
-- CATALOGO
-- =========================
INSERT INTO catalogo.conteudo (titulo,tipo,classificacao,genero,ano_lancamento,duracao) VALUES
('Matrix','filme',16,'acao',1999,120),
('Matrix Reloaded','filme',16,'acao',2003,130),
('Breaking Bad','serie',18,'drama',2008,NULL),
('Stranger Things','serie',16,'ficcao',2016,NULL),
('Dark','serie',18,'ficcao',2017,NULL);

INSERT INTO catalogo.franquia (nome_franquia,sequencia) VALUES
('Matrix',1),
('Matrix',2);

INSERT INTO catalogo.filmes (id_franquia,id_conteudo) VALUES
(1,1),
(2,2);

INSERT INTO catalogo.series (titulo_serie,classificacao_serie) VALUES
('Breaking Bad',18),
('Stranger Things',16),
('Dark',18);

INSERT INTO catalogo.temporada (nro_temp,id_serie) VALUES
(1,1),(2,1),
(1,2),(2,2),
(1,3);

INSERT INTO catalogo.episodio (nro_ep,id_temporada,id_conteudo) VALUES
(1,1,3),
(2,1,3),
(1,2,3),
(1,3,4),
(1,5,5);

-- =========================
-- METADATA
-- =========================
INSERT INTO metadata.idioma (nome) VALUES
('Português'),('Inglês'),('Espanhol');

INSERT INTO metadata.conteudo_idioma VALUES
(1,1,'Dublado'),
(1,2,'Original'),
(2,1,'Dublado'),
(3,2,'Original'),
(4,1,'Dublado');

-- =========================
-- STREAMING
-- =========================
INSERT INTO streaming.historico_visualizacao
(dt_inicio,progresso,concluido,id_perfil,id_conteudo) VALUES
(NOW(),100,true,1,1),
(NOW(),50,false,1,2),
(NOW(),100,true,2,4),
(NOW(),80,false,3,3),
(NOW(),100,true,4,5);