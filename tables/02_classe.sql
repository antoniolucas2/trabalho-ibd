CREATE TABLE IF NOT EXISTS Classe (
    codigo_classe INT PRIMARY KEY,
    nome_classe VARCHAR(300),
    codigo_grupo INT NOT NULL,

    CONSTRAINT fkcodigo_grupo 
    FOREIGN KEY (codigo_grupo) 
    REFERENCES Grupo(codigo_grupo) 
    ON UPDATE CASCADE 
    ON DELETE CASCADE
); 
