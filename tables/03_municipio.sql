CREATE TABLE IF NOT EXISTS Municipio (
    codigo_ibge INT PRIMARY KEY,
    nome_municipio VARCHAR(100) NOT NULL,
    sigla_uf CHAR(2) NOT NULL,
    regiao VARCHAR (50),
    populacao INT,

    CONSTRAINT format_uf 
    CHECK (sigla_uf ~ '^[A-Z]{2}$'),
    
    CONSTRAINT domain_pop_est 
    CHECK (populacao > 0)
);
