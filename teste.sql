SELECT p.nome_perfil
FROM streaming.historico_visualizacao h
JOIN usuarios.perfil p
ON p.id_perfil = h.id_perfil
JOIN catalogo.conteudo c
ON c.id_conteudo = h.id_conteudo
WHERE c.titulo = 'Matrix';