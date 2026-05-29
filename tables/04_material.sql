CREATE TABLE IF NOT EXISTS Material (
    codigo_item INT PRIMARY KEY,
    nome_material VARCHAR(100),
    descricao_item VARCHAR (500),
    item_sustentavel BOOLEAN, 
    status BOOLEAN,
    codigo_classe INT NOT NULL,

    CONSTRAINT fkcodigo_classe 
    FOREIGN KEY (codigo_classe) REFERENCES Classe(codigo_classe) 
    ON UPDATE CASCADE
    ON DELETE RESTRICT
);
