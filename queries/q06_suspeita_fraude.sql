-- Encontrar Uasgs que mais fazem licitações sem 
-- imformar o preço total ou a quantidade de itens

WITH LicitacoesSuspeitasUasg AS (
    SELECT count(id_compra) as compras_suspeitas, uasg AS uasg
    FROM licitacao as l
    WHERE (l.valor_total IS NULL OR l.valor_total = 0) OR
          (l.numero_itens = 0 OR l.numero_itens IS NULL)
    GROUP BY l.uasg
),
UasgsSuspeitasTodasLicitacoes AS (
    SELECT count(id_compra) AS compras, uasg AS uasg
    FROM licitacao as l
    WHERE uasg IN (SELECT uasg FROM LicitacoesSuspeitasUasg)
    GROUP BY l.uasg
)
SELECT LS.uasg as uasgs_suspeitas,
    LS.compras_suspeitas as compras_suspeitas,
    UTL.compras as compras,
    ROUND((LS.compras_suspeitas)::DECIMAL(10, 2) 
          / (UTL.compras)::DECIMAL(10, 2), 2) * 100 as taxa_compras_suspeitas  
FROM LicitacoesSuspeitasUasg AS LS 
INNER JOIN UasgsSuspeitasTodasLicitacoes AS UTL ON LS.uasg = UTL.uasg
ORDER BY compras_suspeitas DESC, taxa_compras_suspeitas DESC
LIMIT 30;
