CREATE TABLE IF NOT EXISTS Material (
    codigo_item INT PRIMARY KEY,
    nome_material VARCHAR(300),
    descricao_item VARCHAR (800),
    item_sustentavel BOOLEAN, 
    status BOOLEAN,
    codigo_classe INT,

    CONSTRAINT fkcodigo_classe 
    FOREIGN KEY (codigo_classe) REFERENCES Classe(codigo_classe) 
    ON UPDATE CASCADE
    ON DELETE RESTRICT
);
