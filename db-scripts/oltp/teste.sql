SELECT genero, COUNT(*) AS total
FROM streaming.historico_visualizacao hv
JOIN catalogo.conteudo ct ON hv.id_conteudo = ct.id_conteudo
GROUP BY genero
ORDER BY total DESC;

SELECT c.nome,
       COUNT(*) FILTER (WHERE hv.concluido = true) AS completos
FROM streaming.historico_visualizacao hv
JOIN usuarios.perfil p ON hv.id_perfil = p.id_perfil
JOIN usuarios.contas c ON p.id_conta = c.cpf
GROUP BY c.nome
HAVING COUNT(*) FILTER (WHERE hv.concluido = true) >= 2;

SELECT c.nome, COUNT(*) AS total_views
FROM streaming.historico_visualizacao hv
JOIN usuarios.perfil p ON hv.id_perfil = p.id_perfil
JOIN usuarios.contas c ON p.id_conta = c.cpf
GROUP BY c.nome
ORDER BY total_views DESC;

SELECT ct.titulo,
       ROUND(AVG(CASE WHEN hv.concluido THEN 1 ELSE 0 END)*100,2) AS taxa_conclusao
FROM streaming.historico_visualizacao hv
JOIN catalogo.conteudo ct ON hv.id_conteudo = ct.id_conteudo
GROUP BY ct.titulo;


SELECT c.nome,
       ROUND(AVG(CASE WHEN hv.concluido THEN 1 ELSE 0 END)*100,2) AS taxa_conclusao
FROM streaming.historico_visualizacao hv
JOIN usuarios.perfil p ON hv.id_perfil = p.id_perfil
JOIN usuarios.contas c ON p.id_conta = c.cpf
GROUP BY c.nome
ORDER BY taxa_conclusao DESC;