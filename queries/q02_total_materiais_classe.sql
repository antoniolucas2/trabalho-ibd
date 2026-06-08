/**
    Total gasto com materiais por classe.    
*/

WITH AllMateriais AS (
    SELECT IL.id_compra, IL.codigo_item_material, 
           IL.valor_estimado as valor_total
    FROM ItemLicitacao AS IL
),
AllMateriaisClass AS (
    SELECT AM.*, C.nome_classe, C.codigo_classe 
    FROM Material AS M
    INNER JOIN AllMateriais AS AM ON M.codigo_item = AM.codigo_item_material
    INNER JOIN Classe AS C ON C.codigo_classe = M.codigo_classe
)
SELECT AMC.nome_classe, AMC.codigo_classe, COALESCE(SUM(AMC.valor_total), 0) AS valor_gasto
FROM AllMateriaisClass AS AMC
GROUP BY AMC.nome_classe, AMC.codigo_classe
ORDER BY valor_gasto DESC;
