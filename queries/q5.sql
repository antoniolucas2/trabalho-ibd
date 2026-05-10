/**
    Fornecedores que nao podem mais servir e orgao 
    aos quais eles ainda estao atrelados.
*/

WITH FornNaoAptos AS (
    SELECT F.nome_razao_social, U.codigo_orgao, F.id_fornecedor, U.codigo_uasg
    FROM Fornecedor AS F
    INNER JOIN FornecedorUasg AS FU ON F.id_fornecedor = FU.id_fornecedor
    INNER JOIN Uasg AS U ON U.codigo_uasg = FU.uasg
    WHERE NOT F.habilitado_licitar 
)
SELECT FNA.nome_razao_social, O.nome_orgao
FROM Orgao AS O
INNER JOIN FornNaoAptos AS FNA ON O.codigo_orgao = FNA.codigo_orgao; 

