CREATE TABLE IF NOT EXISTS FornecedorUasg(
    cnpj_fornecedor CHAR(14) NOT NULL,
    uasg CHAR(6) NOT NULL,
    PRIMARY KEY (cnpj_fornecedor, uasg),

    CONSTRAINT fk_fornecedor 
    FOREIGN KEY (cnpj_fornecedor) 
    REFERENCES Fornecedor(cnpj)
    ON UPDATE CASCADE
    ON DELETE CASCADE,

    CONSTRAINT fk_uasg
    FOREIGN KEY (uasg)
    REFERENCES Uasg(codigo_uasg)
    ON UPDATE CASCADE
    ON DELETE CASCADE
);
