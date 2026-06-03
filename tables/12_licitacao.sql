CREATE TABLE IF NOT EXISTS Licitacao(
    id_compra VARCHAR(50) PRIMARY KEY,
    uasg CHAR(6) NOT NULL,
    codigo_municipio INT,
    codigo_modalidade INT,
    numero_licitacao INT,
    nome_responsavel VARCHAR(100),
    numero_itens INT,
    valor_total DECIMAL(15, 2),
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

    CONSTRAINT fk_codigo_modalidade
    FOREIGN KEY (codigo_modalidade)
    REFERENCES ModalidadeLicitacao(codigo_modalidade)
    ON UPDATE CASCADE
    ON DELETE RESTRICT,

    CONSTRAINT domain_valor_total 
    CHECK (valor_total >= 0)
);
