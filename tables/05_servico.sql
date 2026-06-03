CREATE TABLE IF NOT EXISTS Servico (
    codigo_servico INT PRIMARY KEY,
    nome_servico VARCHAR(300),
    status BOOLEAN,
    codigo_classe INT,

    CONSTRAINT fkcodigo_classe 
    FOREIGN KEY (codigo_classe) REFERENCES Classe(codigo_classe) 
    ON UPDATE CASCADE
    ON DELETE RESTRICT
);
