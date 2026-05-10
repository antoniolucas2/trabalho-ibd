/**
    Projetar a razao social de todos os fornecedores que 
    providenciam materias sustentaveis.
*/

WITH MSustentaveis AS (
    SELECT M.codigo_item 
    FROM Material AS M
    WHERE M.item_sustentavel
),
IDFonItensSus AS (
    SELECT I.id_fornecedor 
    FROM ItemLicitacao AS I
    INNER JOIN MSustentaveis AS MS ON I.codigo_item_material = MS.codigo_item
)
SELECT F.nome_razao_social AS razao_social
FROM Fornecedor AS F
INNER JOIN IDFonItensSus AS IDF ON F.id_fornecedor = IDF.id_fornecedor; 
