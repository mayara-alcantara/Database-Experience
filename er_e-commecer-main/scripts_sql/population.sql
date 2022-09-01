-- *********************************************************************
-- *                        REQUIRED FOR SISTEM                        *
-- *********************************************************************

USE e_commerce;

-- *********************************************************************
-- *                             TRIGGERS                              *
-- *********************************************************************
-- IMPORTANTE: EXECUTAR OS TRIGGERS ANTES DE INSERIR OS DADOS NO BANCO.
-- AFIM DE VISUALIZAR POSTERIORES QUERIES COM O DESEMPENHO PROPOSTO.

-- Definindo a tabela auxíliar a ser usada para controle de estoque
-- Pretendo refletir um view pra ela

DELIMITER §
	CREATE TRIGGER care_storage_qty AFTER INSERT
	ON storage_in
    FOR EACH ROW
    BEGIN
		IF NEW.product_id = (SELECT product_id FROM control as c WHERE c.product_id = NEW.product_id) THEN
			SET SQL_SAFE_UPDATES=0;
			UPDATE control
			SET qty = NEW.qty + qty WHERE control.product_id = NEW.product_id;
		ELSE 
			INSERT INTO control(product_id, qty, name, type, description, category, brand, supplier_cnpj, seller_cnpj, supplier_name, seller_name) VALUES 
			(NEW.product_id, NEW.qty,
			(SELECT name FROM product as p WHERE p.id= NEW.product_id),
			(SELECT tp.description FROM type_product as tp INNER JOIN product as p ON tp.id = p.type_id WHERE p.id= NEW.product_id),
			(SELECT p.description FROM product as p WHERE p.id= NEW.product_id),
			(SELECT c.name FROM category as c INNER JOIN product as p ON p.category_id = c.id  WHERE p.id = NEW.product_id),
			(SELECT b.name FROM brand as b INNER JOIN product as p ON b.id = p.brand_id WHERE p.id = NEW.product_id),
			(SELECT s.cnpj FROM supplier as s INNER JOIN product as p ON p.supplier_id = s.id WHERE p.id = NEW.product_id),
			(SELECT sl.cnpj FROM seller as sl INNER JOIN product as p ON p.sold_by_id = sl.id WHERE p.id = NEW.product_id),
			(SELECT s.name FROM supplier as s INNER JOIN product as p ON p.supplier_id = s.id WHERE p.id = NEW.product_id),
			(SELECT sl.name FROM seller as sl INNER JOIN product as p ON p.sold_by_id = sl.id WHERE p.id = NEW.product_id));
        END IF;
	END §
DELIMITER ;


-- *******************************************************************

-- Definindo 0 para pessoa física e 1 pessoa juridica, levendo em consideração o input do usúario.
DELIMITER §
	CREATE TRIGGER care_cliente_pf_or_pj BEFORE INSERT
    ON customer
    FOR EACH ROW
    BEGIN
		IF CHAR_LENGTH(NEW.cpf_or_cnpj) <= 11 THEN
        SET NEW.pf_or_pj = 0;
        ELSE
        SET NEW.pf_or_pj =1;
		END IF;
    END§
DELIMITER ;

-- *******************************************************************

-- Definindo estoque após a compra

DELIMITER §
	CREATE TRIGGER care_storage_qty_after_purchase AFTER INSERT
    ON product_purchase 
    FOR EACH ROW
    BEGIN
		IF NEW.product_id = (SELECT product_id FROM control as c WHERE c.product_id = NEW.product_id) THEN
        SET SQL_SAFE_UPDATES=0;
        UPDATE control
        SET qty = qty - NEW.qty WHERE control.product_id = NEW.product_id;
        END IF;
	END §
DELIMITER ;

-- *********************************************************************
-- *                             POPULATION                            *
-- *********************************************************************


INSERT INTO brand (name) VALUE ('Samsung');
INSERT INTO brand (name) VALUE ('Sony');
INSERT INTO brand (name) VALUE ('Onix');
INSERT INTO brand (name) VALUE ('Artex');
INSERT INTO brand (name) VALUE ('Bratemp');

INSERT INTO type_product (description) VALUE('Uteis');
INSERT INTO type_product (description) VALUE('Infantil');
INSERT INTO type_product (description) VALUE('Games/Informatica');
INSERT INTO type_product (description) VALUE('Cozinha');
INSERT INTO type_product (description) VALUE('Academia');


INSERT INTO supplier (cnpj, name) VALUES ('12345678910124','Fornecedor1');
INSERT INTO supplier (cnpj, name) VALUES ('12456658452145','Fornecedor2');
INSERT INTO supplier (cnpj, name) VALUES ('12456658452114','Fornecedor3');
INSERT INTO supplier (cnpj, name) VALUES ('12456658415145','Fornecedor4');
INSERT INTO supplier (cnpj, name) VALUES ('12456654452145','Fornecedor5');


INSERT INTO seller (cnpj,name) VALUES ('23414521452156','Vendedor1');
INSERT INTO seller (cnpj,name) VALUES ('14147521452156','Vendedor2');
INSERT INTO seller (cnpj,name) VALUES ('14525481452156','Vendedor3');
INSERT INTO seller (cnpj,name) VALUES ('14521415452156','Vendedor4');
INSERT INTO seller (cnpj,name) VALUES ('14521456872156','Vendedor5');

INSERT INTO category(name) VALUE ('Eletronico');
INSERT INTO category(name) VALUE ('Cama/Mesa/Banho');
INSERT INTO category(name) VALUE ('Movéis');
INSERT INTO category(name) VALUE ('Eletrodomestico');
INSERT INTO category(name) VALUE ('Outros');

INSERT INTO product (name, description, value, supplier_id, category_id, brand_id, sold_by_id,type_id) values 
('Celular','Preto',2500,1,1,1,1,3),
('Cama','King',2750,2,2,5,2,1),
('Geladeira','Conjunto 4',4600,5,4,5,3,4),
('Refrigerador','Preto',3550,5,4,5,4,4),
('Esteira','Eletronica Motor 5.0',1800,5,5,2,5,5),
('Patins','4 rodas Semi-Profissional',500,5,5,1,5,2),
('Computador','Dell ssd',6999,1,1,1,1,3),
('Boneco Ben10','Linha 10cm',200,5,5,3,2,2),
('Tapete','Pelucia',750,4,5,3,3,1),
('Panela','Anti aderente de alumínio',250,2,2,3,4,4)
;

INSERT INTO type_customer(type) values('REGULAR'),('PREMIUM');

INSERT INTO storage (location, name) VALUES ('Unidade 1','Gualpão1');
INSERT INTO storage (location, name) VALUES ('Unidade 2','Gualpão2');
INSERT INTO storage (location, name) VALUES ('Unidade 3','Gualpão3');
INSERT INTO storage (location, name) VALUES ('Unidade 4','Gualpão4');
INSERT INTO storage (location, name) VALUES ('Unidade 5','Gualpão5');

INSERT INTO storage_in (qty, storage_id, product_id) VALUES (5,1,1);

INSERT INTO address (country, state, city, patio, number, complement, cep) VALUES
('Brasil','MG','cidadeMinas','Rua','1251','Casa','38361100'),
('Brasil','SP','cidadeSaoPaulo','Rua','1252','Casa','35566000'),
('Brasil','RJ','cidadeRio','Rua','1253','Apartamento','35566000'),
('Brasil','PA','cidadePara','Rua','1254','Casa','38366550'),
('Brasil','PE','cidadePernanbuco','Rua','1255','Casa','35566000'),
('Brasil','MT','cidadeMato','Rua','1256','Casa','38366011'),
('Brasil','AC','cidadeAcre','Rua','1257','Casa','38366220'),
('Brasil','RO','cidadeRo','Rua','1258','Casa','38366066'),
('Brasil','RE','cidadeRec','Rua','1259','Casa','38366088'),
('Brasil','SC','CidadeSan','Rua','12510','Casa','38366099')
;

INSERT INTO type_phone(type) VALUES('CELULAR'), ('FIXO');

INSERT INTO phone(type_phone_id, ddi,ddd,number) VALUES
(2,'55','11','32111236'),
(1,'55','10','999999999'),
(1,'55','09','999998888'),
(1,'55','08','999992233'),
(1,'55','07','999449999'),
(1,'55','06','99999898'),
(2,'55','05','2145224565'),
(2,'55','04','12555486'),
(1,'55','03','988774455'),
(1,'55','02','999885522'),
(1,'55','01','999887745')
;

INSERT INTO status_purchase(type) VALUES ('Aguardando Envio'), ('Enviado'), ('Entregue'), ('Devolução');

INSERT INTO customer(name, cpf_or_cnpj, birth_date, type_customer, rg, ur, email) VALUES 
('Claudia Cunha','24545489651','2002-07-01',1,'123456789','RE','clau@email.com'),
('Pedro Libra','12455124562','2001-09-05',1,'987456321','AC','pedro@email.com'),
('Carlos Genuino','15458865212','2000-08-05',1,'147852369','PA','carlos@email.com'),
('Perla Carla','54125468842','2005-04-01',1,'147852369','SC','perla@email.com'),
('Damião Golzales','21458712145821','1998-11-21',1,'45213678','SP','damiao@email.com'),
('Endria Costa','12454565785','1998-07-15',1,'210023214','MT','endria@email.com'),
('Fernanda Crismo','21458712145822','1987-05-09',1,'745896548','PE','fe@email.com'),
('Ernaldo Carmo','12454885215','1980-01-25',1,'213540548','PA','ernal@email.com'),
('Fabiola Vilarinho','21458712145823','2002-04-01',1,'244536852','SC','fabio@email.com'),
('Gertudres Manuela','12334564786','1992-07-20',1,'124558905','MT','tudes@email.com');

INSERT INTO storage_in (storage_id, product_id, qty) VALUES
(1,1,15),
(2,2,14),
(3,3,15),
(4,4,6),
(5,5,7),
(1,6,14),
(2,7,13),
(3,8,17),
(5,9,20),
(4,10,25),
(1,9,25),
(2,8,6),
(3,7,12),
(4,6,20),
(5,5,15),
(1,4,25),
(2,3,30),
(3,2,11),
(4,1,24),
(5,2,14),
(1,3,14),
(2,4,15),
(3,5,18),
(4,6,9),
(5,7,6),
(1,8,7),
(2,9,18),
(3,10,5)
;

INSERT INTO purchase (date,customer_id, value_to_send, address_id, status_purchase_id) VALUES
('2022-01-07',1,25.00,1,1),
('2022-02-04',2,25.00,2,2),
('2022-02-11',3,25.00,3,3),
('2022-03-01',4,25.00,4,4),
('2022-04-14',5,25.00,5,1),
('2022-05-10',6,25.00,6,2),
('2022-06-15',7,25.00,7,3),
('2022-07-11',8,25.00,8,4),
('2022-08-19',9,25.00,9,1),
('2022-08-20',10,25.00,10,2);

INSERT INTO product_purchase (product_id, purchase_id, qty) VALUES 
(1,9,1),
(2,1,2),
(3,2,3),
(4,3,4),
(5,4,5),
(6,5,6),
(7,6,7),
(8,7,6),
(9,8,5),
(10,9,4),
(9,10,3),
(8,9,2),
(7,8,1),
(6,7,2),
(5,6,3),
(4,5,4),
(3,4,5),
(5,3,6),
(1,2,7),
(2,1,8)
;

INSERT INTO seller_phone (phone_id, seller_id) VALUES 
(1,1),
(2,2),
(3,3),
(4,4),
(5,5);

INSERT INTO seller_address (address_id, seller_id) VALUES 
(1,1),
(2,2),
(3,3),
(4,4),
(5,5);

INSERT INTO  supplier_address(address_id, supplier_id) VALUES 
(1,1),
(2,2),
(3,3),
(4,4),
(5,5);

INSERT INTO  supplier_phone(id_phone, id_supplier) VALUES 
(1,1),
(2,2),
(3,3),
(4,4),
(5,5);

INSERT INTO type_payment (type) VALUES
('Cartão de Credito'),
('Cartão de Debito'),
('Pix'),
('Boleto');

INSERT INTO payment (purchase_id, type_id, value, date) VALUES 
(1,3,27525,'2022-08-19 08:00:00'),
(2,4,31325,'2022-02-04 14:45:00'),
(3,3,25025.00,'2022-02-11 12:14:00'),
(4,3,32025.00,'2022-03-01 16:15:00'),
(5,3,17225.00,'2022-04-14 09:14:00'),
(6,4,54418.00,'2022-05-10 13:14:00'),
(7,4,2225.00,'2022-06-15 16:45:00'),
(8,3,10774.00,'2022-07-11 10:17:30'),
(9,4,3925.00,'2022-08-19 17:17:00'),
(10,4,2275.00,'2022-08-20 15:13:00');

INSERT INTO status_purchase(type) VALUES('CONFIRMADA'),('AGUARDANDO PAGAMENTO'),('CANCELADA');
INSERT INTO status_to_send(status) VALUES('AGUARDANDO ENVIO DO VENDEDOR'), ('ENVIADO'),('ENTREGUE'),('DEVOLUÇÃO/REENBOLSO');

INSERT INTO order_number (responsible_id, payment_id) VALUES 
(1,1);
INSERT INTO order_number (responsible_id, payment_id) VALUES 
(2,2),
(3,3),
(4,4),
(5,5),
(1,6),
(2,7),
(3,8),
(4,9),
(5,10)
;

INSERT INTO product_to_send (product_id, order_number_id,qty, tracking, status_id, send_date) VALUES 
(2,1,2,'ASMKAS15125',1,'2022-01-09 08:00:00');
INSERT INTO product_to_send (product_id, order_number_id,qty, tracking, status_id, send_date) VALUES 
(2,1,8,'ASMKAS15225',1,'2022-01-09 08:00:00');
INSERT INTO product_to_send (product_id, order_number_id,qty, tracking, status_id, send_date) VALUES 
(3,2,3,'OIHHhOH21455',2,'2022-02-06 08:00:00'),
(1,2,8,'KNNKNL262',3,'2022-02-15 08:00:00'),
(4,3,4,'KSAKSAKL5151',1,'2022-03-01 08:00:00'),
(5,3,6,'LKNNLNLA51515',2,'2022-04-17 08:00:00'),
(5,4,5,'KSA21AKL51441',1,'2022-03-04 08:00:00'),
(3,4,5,'LKNNLNLA25615',2,'2022-03-17 08:00:00'),
(6,5,6,'dsdgSAKL5DS151',1,'2022-04-15 08:00:00'),
(4,5,4,'LgfgNLNLdasA515',2,'2022-04-17 08:00:00'),
(7,6,7,'KSAKS15545151',1,'2022-05-10 08:00:00'),
(5,6,3,'L344LNLA51512',2,'2022-05-11 08:00:00'),
(8,7,6,'KSA1FD4FW2H11',1,'2022-06-17 08:00:00'),
(6,7,2,'LFIDSJH244552',2,'2022-04-17 08:00:00'),
(9,8,5,'DJSDJS4DAS1514',3,'2022-07-13 08:00:00'),
(7,8,1,'FOKJPDSDASFJ162',4,'2022-07-13 08:00:00'),
(1,9,1,'SLMFMS12DDASDFDS',4,'2022-08-20 08:00:00'),
(10,9,4,'FKDSKDDASDAS611',3,'2022-08-20 08:00:00'),
(8,9,2,'FDSFDLDASDÇML11',1,'2022-08-21 08:00:00'),
(9,10,3,'FGRJN1514SDÇML11',1,'2022-08-21 08:00:00')
;

-- *********************************************************************
-- *********************************************************************