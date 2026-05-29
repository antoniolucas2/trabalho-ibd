CREATE TABLE IF NOT EXISTS Uasg (
    codigo_uasg INT PRIMARY KEY,
    nome_uasg VARCHAR(200) NOT NULL,
    codigo_orgao INT NOT NULL,
    codigo_municipio INT,
    status BOOLEAN,
    
    CONSTRAINT fk_orgao 
    FOREIGN KEY (codigo_orgao) 
    REFERENCES Orgao(codigo_orgao) 
    ON UPDATE CASCADE
    ON DELETE RESTRICT,

    CONSTRAINT fk_municipio 
    FOREIGN KEY (codigo_municipio)
    REFERENCES Municipio(codigo_ibge)
    ON UPDATE CASCADE
    ON DELETE RESTRICT
);
