CREATE TABLE IF NOT EXISTS Grupo (
    codigo_grupo INT PRIMARY KEY,
    nome_grupo VARCHAR(100) NOT NULL,
    tipo_item VARCHAR(20) NOT NULL,
    
    CONSTRAINT domain_tipo_item CHECK (tipo_item IN ('servico', 'material')) 
);
