-- total gasto por grupo

WITH GastosPorGrupo AS (
    SELECT 
        G.codigo_grupo, 
        G.nome_grupo, 
        G.tipo_item,
        SUM(I.valor_estimado) AS subtotal
    FROM ItemLicitacao AS I
    INNER JOIN Material AS M ON I.codigo_item_material = M.codigo_item
    INNER JOIN Classe AS C ON M.codigo_classe = C.codigo_classe
    INNER JOIN Grupo AS G ON C.codigo_grupo = G.codigo_grupo
    GROUP BY G.codigo_grupo, G.nome_grupo, G.tipo_item

    UNION ALL

    SELECT 
        G.codigo_grupo, 
        G.nome_grupo, 
        G.tipo_item,
        SUM(I.valor_estimado) AS subtotal
    FROM ItemLicitacao I
    INNER JOIN Servico S ON I.codigo_item_servico = S.codigo_servico
    INNER JOIN Classe C ON S.codigo_classe = C.codigo_classe
    INNER JOIN Grupo G ON C.codigo_grupo = G.codigo_grupo
    GROUP BY G.codigo_grupo, G.nome_grupo, G.tipo_item
)
SELECT 
    codigo_grupo, 
    nome_grupo, 
    COALESCE(SUM(subtotal), 0) AS total, 
    tipo_item
FROM GastosPorGrupo
GROUP BY codigo_grupo, nome_grupo, tipo_item
ORDER BY total DESC;
