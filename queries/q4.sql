/**
    Descobrir quais municipios possuem algum orgao
    da esfera federal.
*/

SELECT M.nome_municipio AS Municipio
FROM Municipio AS M
INNER JOIN Orgao AS O ON M.codigo_ibge = O.codigo_municipio
WHERE O.esfera = 'federal';
