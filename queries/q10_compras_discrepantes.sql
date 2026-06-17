-- Seleciona as compras que foram realizadas com preço
-- acima do praticado no mercado

WITH PrecoMercado AS (
    SELECT codigo_item_material as codigo_material,
           codigo_item_servico as codigo_servico,
          AVG(valor_estimado / NULLIF(quantidade, 0)) AS preco_medio
    FROM ItemLicitacao
    WHERE situacao_item = 'HOMOLOGADO' AND quantidade > 0
    GROUP BY codigo_item_material, codigo_item_servico
    HAVING AVG(valor_estimado / NULLIF(quantidade, 0)) > 0
)
SELECT I.id_compra, I.id_compra_item,
       COALESCE(M.nome_material, S.nome_servico) as nome_item,
       ROUND((I.valor_estimado / I.quantidade), 2) AS preco_unitario_praticado,
       ROUND(PM.preco_medio, 2) AS preco_medio_mercado,
       ROUND((I.valor_estimado / I.quantidade) / PM.preco_medio, 2) AS vezes_acima
FROM ItemLicitacao AS I
LEFT JOIN Material AS M ON I.codigo_item_material = M.codigo_item
LEFT JOIN Servico AS S ON I.codigo_item_servico = S.codigo_servico
JOIN PrecoMercado AS PM ON 
    (I.codigo_item_material = PM.codigo_material OR 
     I.codigo_item_servico = PM.codigo_servico)
WHERE I.situacao_item = 'HOMOLOGADO' AND quantidade > 0 AND 
      (I.valor_estimado / I.quantidade) > (PM.preco_medio * 3)
ORDER BY vezes_acima DESC
LIMIT 15;
