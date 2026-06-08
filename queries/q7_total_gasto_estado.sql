-- Calcular o total gasto com licitiações
-- por estado.

SELECT M.sigla_uf as estado, SUM(L.valor_total) as total_gasto
FROM Licitacao AS L
INNER JOIN  Municipio as M ON L.codigo_municipio = M.codigo_ibge
GROUP BY M.sigla_uf
ORDER BY total_gasto DESC;

