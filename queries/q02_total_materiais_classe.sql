/**
    Total gasto com materiais por classe.    
*/

WITH TodosMateriais AS (
    SELECT IL.id_compra, IL.codigo_item_material, 
           IL.valor_estimado as valor_total
    FROM ItemLicitacao AS IL
),
TodosMateriaisClasses AS (
    SELECT TM.*, C.nome_classe, C.codigo_classe 
    FROM Material AS M
    INNER JOIN TodosMateriais AS TM ON M.codigo_item = TM.codigo_item_material
    INNER JOIN Classe AS C ON C.codigo_classe = M.codigo_classe
)
SELECT TMC.nome_classe, TMC.codigo_classe, COALESCE(SUM(TMC.valor_total), 0) AS valor_gasto
FROM TodosMateriaisClasses AS TMC
GROUP BY TMC.nome_classe, TMC.codigo_classe
ORDER BY valor_gasto DESC;
