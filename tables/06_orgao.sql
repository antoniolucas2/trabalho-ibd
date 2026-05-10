CREATE TABLE Orgao(
    codigo_orgao INT PRIMARY KEY,
    nome_orgao VARCHAR(200),
    codigo_municipio INT NOT NULL,
    codigo_orgao_superior INT,
    codigo_adm INT,
    nome_adm VARCHAR(200),
    poder VARCHAR(25),
    esfera VARCHAR(25),

    CONSTRAINT domain_poder 
    CHECK (poder IN ('legislativo', 'judiciario', 'executivo')),

    CONSTRAINT domain_esfera 
    CHECK (esfera IN ('federal', 'estadual', 'municipal')),

    CONSTRAINT fk_orgao_superior 
    FOREIGN KEY (codigo_orgao_superior) 
    REFERENCES Orgao(codigo_orgao)
    ON UPDATE CASCADE
    ON DELETE SET NULL,

    CONSTRAINT fk_municipio 
    FOREIGN KEY (codigo_municipio)
    REFERENCES Municipio(codigo_ibge)
    ON UPDATE CASCADE
    ON DELETE RESTRICT
);
