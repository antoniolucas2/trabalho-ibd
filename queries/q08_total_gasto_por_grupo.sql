-- total gasto por grupo

WITH ClasseGrupo AS (
    SELECT C.codigo_classe, G.codigo_grupo, G.nome_grupo
    FROM Classe as C
    INNER JOIN Grupo AS G ON C.codigo_grupo = G.codigo_grupo
),
MaterialGrupo AS (
    SELECT M.codigo_item, CG.codigo_grupo, CG.nome_grupo, 'Material' as tipo
    FROM Material AS M
    INNER JOIN ClasseGrupo AS CG ON M.codigo_classe = CG.codigo_classe
),
ServicoGrupo AS (
    SELECT S.codigo_servico, CG.codigo_grupo, CG.nome_grupo, 'Servico' as tipo
    FROM Servico AS S
    INNER JOIN ClasseGrupo AS CG ON S.codigo_classe = CG.codigo_classe 
),
TotalGastoMaterial AS (
    SELECT codigo_grupo, nome_grupo, SUM(COALESCE(valor_estimado, 0)) AS total_gasto, tipo
    FROM ItemLicitacao AS IL
    INNER JOIN MaterialGrupo AS MG ON IL.codigo_item_material = MG.codigo_item
    GROUP BY codigo_grupo, nome_grupo, tipo
),
TotalGastoServico AS (
    SELECT codigo_grupo, nome_grupo, SUM(COALESCE(valor_estimado, 0)) AS total_gasto, tipo
    FROM ItemLicitacao AS IL
    INNER JOIN ServicoGrupo AS SG ON IL.codigo_item_servico = SG.codigo_servico
    GROUP BY codigo_grupo, nome_grupo, tipo
)
SELECT * FROM TotalGastoMaterial
UNION SELECT * FROM TotalGastoServico
ORDER BY total_gasto DESC;
