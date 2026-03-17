INSERT INTO usuarios.contas VALUES
('11111111111','Ana Silva','ana@email.com','2024-01-10','2024-02-10'),
('22222222222','Carlos Souza','carlos@email.com','2024-01-15','2024-02-15'),
('33333333333','Mariana Lima','mariana@email.com','2024-01-20','2024-02-20');

INSERT INTO usuarios.perfil (nome_perfil,avatar,idioma,classificacao_max,infantil,id_conta)
VALUES
('Ana','avatar1.png','PT','18',false,'11111111111'),
('Pedro','avatar2.png','PT','10',true,'11111111111'),
('Carlos','avatar3.png','EN','18',false,'22222222222'),
('Julia','avatar4.png','PT','12',false,'33333333333');


INSERT INTO financeiro.planos (nome_plano,preco_mensal,resolucao_max)
VALUES
('Basic',19.90,'HD'),
('Standard',29.90,'FullHD'),
('Premium',49.90,'4K');


INSERT INTO usuarios.historico_plano (dt_inicio,dt_fim,id_plano,id_conta)
VALUES
('2024-01-10',NULL,2,'11111111111'),
('2024-01-15',NULL,1,'22222222222'),
('2024-01-20',NULL,3,'33333333333');

INSERT INTO financeiro.pagamento (dt_pagamento,valor,data_criacao,id_conta)
VALUES
('2024-02-10',29.90,'2024-02-10','11111111111'),
('2024-02-15',19.90,'2024-02-15','22222222222'),
('2024-02-20',49.90,'2024-02-20','33333333333');

INSERT INTO catalogo.conteudo (titulo,resumo,tipo,classificacao)
VALUES
('Matrix','Sci-fi clássico','FILME','16'),
('Toy Story','Animação','FILME','L'),
('Breaking Bad','Drama','SERIE','18'),
('Stranger Things','Sci-fi','SERIE','14'),
('Interestelar','Espaço','FILME','10');

INSERT INTO catalogo.franquia (nome_franquia,sequencia)
VALUES
('Matrix',1),
('Toy Story',1);

INSERT INTO catalogo.filme VALUES
(1,1,'Primeiro Matrix'),
(2,2,'Toy Story original'),
(5,NULL,'Filme espacial');

INSERT INTO catalogo.series (titulo_serie,detalhes)
VALUES
('Breaking Bad','Química e crime'),
('Stranger Things','Mistério anos 80');

INSERT INTO catalogo.temporada (nro_temp,id_serie)
VALUES
(1,1),
(1,2);

INSERT INTO catalogo.episodio (nro_ep,id_temporada,id_conteudo)
VALUES
(1,1,3),
(1,2,4);

INSERT INTO metadata.pessoa (nome,biografia)
VALUES
('Keanu Reeves','Ator canadense'),
('Bryan Cranston','Ator americano'),
('Tom Hanks','Ator famoso');


INSERT INTO metadata.participacao (papel,personagem,id_pessoa,id_conteudo)
VALUES
('ATOR','Neo',1,1),
('ATOR','Walter White',2,3),
('ATOR','Woody',3,2);

INSERT INTO metadata.idioma (nome)
VALUES
('Português'),
('Inglês'),
('Espanhol');

INSERT INTO metadata.conteudo_idioma
VALUES
(1,1,'audio'),
(1,2,'audio'),
(1,1,'legenda'),
(2,1,'audio'),
(3,2,'audio');

INSERT INTO streaming.historico_visualizacao
(dt_inicio,progresso,concluido,id_perfil,id_conteudo)
VALUES
('2024-02-01',120,true,1,1),
('2024-02-02',45,false,2,2),
('2024-02-03',60,false,3,3),
('2024-02-04',30,false,4,4);