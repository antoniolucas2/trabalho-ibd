CREATE TABLE IF NOT EXISTS FornecedorUasg(
    id_fornecedor INT NOT NULL,
    uasg INT NOT NULL,
    PRIMARY KEY (id_fornecedor, uasg),

    CONSTRAINT fk_fornecedor 
    FOREIGN KEY (id_fornecedor) 
    REFERENCES Fornecedor(id_fornecedor)
    ON UPDATE CASCADE
    ON DELETE CASCADE,

    CONSTRAINT fk_uasg
    FOREIGN KEY (uasg)
    REFERENCES Uasg(codigo_uasg)
    ON UPDATE CASCADE
    ON DELETE CASCADE
);
