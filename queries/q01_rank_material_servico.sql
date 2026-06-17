/**
    Top 15 Materiais ou Servicos mais comprados
*/

SELECT COALESCE(M.nome_material, S.nome_servico) as nome_item,
        CASE 
            WHEN i.codigo_item_material IS NOT NULL THEN 'Material'
            ELSE 'Servico'
        END AS tipo, 
    COUNT(I.id_compra_item) AS vezes_comprado,
    SUM(I.quantidade) AS volume_total_itens, 
    SUM(I.valor_estimado) AS valor_total_estimado
FROM ItemLicitacao AS I
LEFT JOIN Material AS M ON I.codigo_item_material = M.codigo_item
LEFT JOIN Servico AS S ON I.codigo_item_servico = S.codigo_servico
WHERE I.situacao_item = 'HOMOLOGADO'
GROUP BY nome_item, I.codigo_item_material, I.codigo_item_servico
ORDER BY vezes_comprado DESC, valor_total_estimado DESC
LIMIT 15;
    
