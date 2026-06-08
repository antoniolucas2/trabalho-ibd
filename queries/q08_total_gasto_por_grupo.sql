-- total gasto por grupo

WITH ClasseGrupo AS (
    SELECT C.codigo_classe, G.codigo_grupo, G.nome_grupo, G.tipo_item
    FROM Classe as C
    INNER JOIN Grupo AS G ON C.codigo_grupo = G.codigo_grupo
)
SELECT CG.codigo_grupo, CG.nome_grupo, COALESCE(SUM(I.valor_estimado), 0) as total, CG.tipo_item
FROM ItemLicitacao AS I
LEFT JOIN Material AS M ON I.codigo_item_material = M.codigo_item
LEFT JOIN Servico AS S ON I.codigo_item_servico = S.codigo_servico
INNER JOIN ClasseGrupo CG ON (I.codigo_item_material IS NOT NULL AND M.codigo_classe = CG.codigo_classe) OR
                                 (I.codigo_item_servico IS NOT NULL AND S.codigo_classe = CG.codigo_classe)
GROUP BY CG.codigo_grupo, CG.nome_grupo, CG.tipo_item
ORDER BY total DESC;
