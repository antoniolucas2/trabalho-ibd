CREATE TABLE Licitacao (
    id_compra VARCHAR(50) PRIMARY KEY,
    uasg CHAR(6) NOT NULL,
    codigo_municipio INT,
    codigo_modalidade CHAR(2),
    nome_modalidade VARCHAR(50),
    numero_licitacao INT,
    nome_responsavel VARCHAR(100),
    numero_itens INT,
    valor_homologado_total DECIMAL(15, 2),
    data_publicacao DATE,

    CONSTRAINT fk_codigo_municipio
    FOREIGN KEY (codigo_municipio) 
    REFERENCES Municipio(codigo_ibge)
    ON UPDATE CASCADE
    ON DELETE RESTRICT,

    CONSTRAINT fk_uasg 
    FOREIGN KEY (uasg)
    REFERENCES Uasg(codigo_uasg)
    ON UPDATE CASCADE
    ON DELETE RESTRICT,

    CONSTRAINT domain_valor_homo_total 
    CHECK (valor_homologado_total > 0)
);
