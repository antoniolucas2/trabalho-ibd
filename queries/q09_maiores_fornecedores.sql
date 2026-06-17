-- Seleciona os 10 fornecedores que mais
-- faturaram com licitacoes

SELECT F.cnpj, COALESCE(F.nome_razao_social, 'Não Informado') AS razao_social, 
    COUNT(I.id_compra_item) AS contratos_ganhos,
    SUM(COALESCE(I.valor_estimado, 0)) AS faturamento_total_licitacao
FROM Fornecedor AS F
INNER JOIN ItemLicitacao AS I ON F.cnpj = I.cnpj_fornecedor
WHERE I.situacao_item =  'HOMOLOGADO' AND F.nome_razao_social IS NOT NULL
GROUP BY F.cnpj, F.nome_razao_social
ORDER BY contratos_ganhos DESC, faturamento_total_licitacao DESC
LIMIT 10;
