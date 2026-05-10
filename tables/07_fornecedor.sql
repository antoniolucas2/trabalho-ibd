CREATE TABLE Fornecedor (
    id_fornecedor SERIAL PRIMARY KEY,
    cnpj CHAR(14), 
    cpf CHAR (11),
    habilitado_licitar BOOLEAN,
    codigo_cnae VARCHAR(50),
    nome_cnae VARCHAR(200),
    codigo_municipio INT,
    nome_razao_social VARCHAR(300),

    CONSTRAINT at_least_one_identificator
    CHECK (cpf IS NOT NULL OR cnpj IS NOT NULL),

    CONSTRAINT fk_municipio
    FOREIGN KEY (codigo_municipio) 
    REFERENCES Municipio(codigo_ibge) 
    ON UPDATE CASCADE
    ON DELETE RESTRICT
);
