/**
    10 municipios com o maior valor médio gasto por licitação
*/

SELECT M.nome_municipio, M.sigla_uf AS estado, ROUND(COALESCE(AVG(L.valor_total), 0), 2) AS gasto_medio_por_licitacao
FROM Licitacao AS L
INNER JOIN Municipio AS M ON L.codigo_municipio = M.codigo_ibge
GROUP BY M.codigo_ibge, M.nome_municipio, M.sigla_uf
ORDER BY gasto_medio_por_licitacao  DESC
LIMIT 10;

