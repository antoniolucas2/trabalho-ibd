CREATE TABLE IF NOT EXISTS ItemLicitacao(
    id_compra_item VARCHAR(50) PRIMARY KEY,
    id_compra VARCHAR(50) NOT NULL,
    numero_item_licitacao INT,
    uasg CHAR(6),
    criterio_julgamento VARCHAR(50),
    codigo_item_material INT, 
    codigo_item_servico INT,
    quantidade INT,
    valor_estimado DECIMAL(15, 2),
    cnpj_fornecedor CHAR(14),
    situacao_item VARCHAR(40),
    descricao_item VARCHAR(1000),

    CONSTRAINT fk_compra
    FOREIGN KEY (id_compra) 
    REFERENCES Licitacao(id_compra)
    ON UPDATE CASCADE
    ON DELETE RESTRICT,

    CONSTRAINT fk_uasg
    FOREIGN KEY (uasg)
    REFERENCES Uasg(codigo_uasg)
    ON UPDATE CASCADE
    ON DELETE RESTRICT,

    CONSTRAINT must_be_material_or_servico
    CHECK ((codigo_item_material IS NOT NULL AND codigo_item_servico IS NULL) 
    OR (codigo_item_material IS NULL AND codigo_item_servico IS NOT NULL)),

    CONSTRAINT fk_material
    FOREIGN KEY (codigo_item_material) 
    REFERENCES Material(codigo_item) 
    ON UPDATE CASCADE
    ON DELETE RESTRICT,

    CONSTRAINT fk_servico
    FOREIGN KEY (codigo_item_servico)
    REFERENCES Servico(codigo_servico)
    ON UPDATE CASCADE
    ON DELETE RESTRICT,

    CONSTRAINT domain_quantidade
    CHECK (quantidade >= 0),

    CONSTRAINT domain_valor_est
    CHECK (valor_estimado >= 0),

    CONSTRAINT domain_numero_item
    CHECK (numero_item_licitacao >= 0),

    CONSTRAINT domain_situacao_item
    CHECK (situacao_item in ('HOMOLOGADO', 'DIRETO / CANCELADO / DESERTO', 'SEM VENCEDOR (ESTIMADO)')),

    CONSTRAINT fk_fornecedor 
    FOREIGN KEY (cnpj_fornecedor)
    REFERENCES Fornecedor(cnpj)
    ON UPDATE CASCADE
    ON DELETE RESTRICT
);
