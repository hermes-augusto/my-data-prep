-- =========================
-- CHECKS (regras de negócio)
-- =========================

ALTER TABLE usuarios.contas
ADD CONSTRAINT chk_email_format
CHECK (email LIKE '%@%');

ALTER TABLE financeiro.planos
ADD CONSTRAINT chk_preco_positivo
CHECK (preco_mensal > 0);

ALTER TABLE catalogo.conteudo
ADD CONSTRAINT chk_classificacao
CHECK (classificacao BETWEEN 0 AND 18);

ALTER TABLE streaming.historico_visualizacao
ADD CONSTRAINT chk_progresso
CHECK (progresso BETWEEN 0 AND 100);
    

-- =========================
-- DEFAULTS importantes
-- =========================

ALTER TABLE streaming.historico_visualizacao
ALTER COLUMN concluido SET DEFAULT FALSE;