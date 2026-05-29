CREATE TABLE IF NOT EXISTS Servico (
    codigo_servico INT PRIMARY KEY,
    nome_servico VARCHAR(100),
    descricao_servico VARCHAR (500),
    status BOOLEAN,
    codigo_classe INT NOT NULL,

    CONSTRAINT fkcodigo_classe 
    FOREIGN KEY (codigo_classe) REFERENCES Classe(codigo_classe) 
    ON UPDATE CASCADE
    ON DELETE RESTRICT
);
