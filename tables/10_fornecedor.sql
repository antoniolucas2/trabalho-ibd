CREATE TABLE IF NOT EXISTS Fornecedor (
    cnpj CHAR(14) PRIMARY KEY,
    codigo_cnae INT,
    codigo_municipio INT,
    nome_razao_social VARCHAR(300),

    CONSTRAINT fk_municipio
    FOREIGN KEY (codigo_municipio) 
    REFERENCES Municipio(codigo_ibge) 
    ON UPDATE CASCADE
    ON DELETE RESTRICT,

    CONSTRAINT fk_codigo_cnae
    FOREIGN KEY (codigo_cnae)
    REFERENCES CNAE(codigo_cnae)
    ON UPDATE CASCADE
    ON DELETE RESTRICT
);
