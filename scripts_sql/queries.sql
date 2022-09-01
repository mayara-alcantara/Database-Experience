USE e_commerce;


-- *********************************************************************
-- *                             QUERIES                               *
-- *********************************************************************

-- Vendedor de determinado produto

SELECT p.name as `Nome do Produto`,p.description as `Descrição`, p.value as `Valor`, sl.name as `Vendedor`, sl.cnpj as `CNPJ` FROM product as p INNER JOIN seller as sl
	ON p.sold_by_id = sl.id
		WHERE p.id = 1;
        
-- Compras com valor acima de mil e menor que 3.5mil.

SELECT SUM(p.value*pc.qty) + pr.value_to_send as `Valor da Compra`, c.name as `Nome`, pr.date as `Data da Compra`  FROM product as p INNER JOIN product_purchase as pc 
	ON p.id = pc.product_id
		INNER JOIN purchase AS pr ON pr.id = pc.purchase_id
			INNER JOIN customer as c ON pr.customer_id = c.id
				GROUP BY pr.id
					HAVING  SUM((p.value*pc.qty) + pr.value_to_send) > 1000 and  SUM((p.value*pc.qty) + pr.value_to_send) <=3500;
                    
                    
-- Compras feitas por determinado cliente, com quantidade de itens comprados, item e o valor gasto total gasto por cada tipo de item comprado

SELECT p.id as `ID da Compra`, c.name as `Nome do Cliente`, pr.name as `Nome do Produto`, pp.qty as `Quantidade`, pr.value as `Valor Unitário`, (pr.value*pp.qty) as `Valor Total`, p.date as `Data da Compra` FROM purchase as p INNER JOIN product_purchase as pp
	ON p.id = pp.purchase_id
		INNER JOIN product as pr ON pr.id = pp.product_id
			INNER JOIN customer as c ON p.customer_id = c.id
				GROUP BY pp.id
					ORDER BY p.date;

-- Recolher informações a respeito dos atributos relacionados ao produto


SELECT p.name as `Nome do Produto`, p.description as `Descrição`, p.value as `Valor Unitário`, b.name as `Marca`,sl.name as `Vendedor`, s.name as `Fornecedor`, c.name as `Categoria`, tp.description as `Tipo do Produto` FROM product as p INNER JOIN type_product as tp 
	ON p.type_id = tp.id
		INNER JOIN brand as b ON p.brand_id = b.id
			INNER JOIN supplier as s ON p.supplier_id = s.id
				INNER JOIN category as c ON p.category_id = c.id
					INNER JOIN seller as sl ON sl.id = p.sold_by_id;
                    
-- Valor total da compra incluindo o valor do frete

SELECT SUM(p.value*pc.qty) + pr.value_to_send as `Valor Total da Compra (Frete Incluso)`, c.name as `Nome do Cliente`, pr.date as `Data da Compra`  FROM product as p INNER JOIN product_purchase as pc 
	ON p.id = pc.product_id
		INNER JOIN purchase AS pr ON pr.id = pc.purchase_id
			INNER JOIN customer as c ON pr.customer_id = c.id
				GROUP BY pr.id;
                
-- Nome do produto, ID, ordem de serviço a qual se refere, quantidade de cada produto e a data compra.
SELECT pd.id as `ID - PRODUTO`, od.id `ID - ORDEM SERVIÇO`, pc.qty as `Quantidade`, p.date `Data da Compra` FROM purchase  as p INNER JOIN 
	product_purchase  as pc ON pc.purchase_id = p.id
		INNER JOIN product as pd ON pc.product_id = pd.id
			INNER JOIN payment as py ON py.purchase_id = p.id
				INNER JOIN order_number as od ON od.payment_id = py.id
						WHERE od.id = 9;
                        
-- ********************************************************************
-- *                             FUNCTION                             *
-- ********************************************************************

DELIMITER §
	CREATE FUNCTION people_type_function( id_cliente INT)
    RETURNS VARCHAR (45) DETERMINISTIC
    BEGIN
		DECLARE type_cliente VARCHAR(45);
		SET @id_cliente = id_cliente;
        RETURN IF ((SELECT pf_or_pj FROM customer as c WHERE c.id = @id_cliente) = 0, "Pessoa Física", "Pessoa Juridica");
    END §
DELIMITER ;


-- produtos com determinado status, nome cliente e afins
-- PARA EXECUTAR ESTA QUERY, EXECUTE A CRIAÇÃO DA PROCEDURE ACIMA.

 -- ********************************************************************
-- *                             PROCEDURE                             *
-- *********************************************************************

DELIMITER §
	CREATE PROCEDURE info_customer_purchase_geral (id_cliente INT)
    BEGIN
    SET @id = id_cliente;
		SELECT c.name as `Nome do Cliente`,tp.type as `Tipo de Cliente`, c.email as `E-mail`, (SELECT people_type_function(@id)) as `Pessoa Física/Jurídica`,
		ps.tracking as `Número de Rastreio`, pr.name as `Nome do Produto`, pr.description as `Descrição`, ss.status as `Status da Entrega`
			FROM customer as c INNER JOIN purchase as p
				ON c.id = p.customer_id
					INNER JOIN payment as py ON p.id = py.purchase_id
						INNER JOIN order_number as o ON o.payment_id = py.id
							INNER JOIN seller as s ON s.id = o.responsible_id
								INNER JOIN product_to_send as ps ON ps.order_number_id = o.id
									INNER JOIN status_to_send as ss ON ss.id = ps.status_id	
										INNER JOIN product as pr ON pr.id = ps.product_id
											INNER JOIN type_customer as tp ON tp.id = c.type_customer
												WHERE p.id = @id
													GROUP BY c.id;
	END §	
DELIMITER ;


	