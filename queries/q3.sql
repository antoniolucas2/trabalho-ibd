/**
    10 Municipios com mais licitacoes por habitantes
    ordenados decrescentemente
*/

WITH MunLic AS (
    SELECT M.codigo_ibge, M.nome_municipio, M.populacao, L.id_compra
    FROM Municipio AS M
    INNER JOIN Licitacao AS L ON M.codigo_ibge = L.codigo_municipio
)
SELECT ML.codigo_ibge, ML.nome_municipio,
       ML.populacao, COUNT(ML.id_compra) AS qnt_licitacao, 
           (ROUND( COUNT(ML.id_compra) / (ML.populacao)::NUMERIC , 5)) * 100 AS "taxa %"
FROM MunLic AS ML
GROUP BY ML.codigo_ibge, ML.nome_municipio, ML.populacao
ORDER BY "taxa %" DESC
LIMIT 30;
