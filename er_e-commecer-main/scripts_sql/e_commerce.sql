-- *********************************************************************
-- *********************************************************************

CREATE DATABASE e_commerce;
USE e_commerce;

-- *********************************************************************
-- *                           ORDER SERVICE                           *
-- *********************************************************************

CREATE TABLE status_to_send(
id INT NOT NULL AUTO_INCREMENT,
STATUS VARCHAR(45),
PRIMARY KEY (id)
);

CREATE TABLE order_number(
id INT NOT NULL AUTO_INCREMENT,
responsible_id INT NOT NULL,
payment_id INT NOT NULL,
PRIMARY KEY(id)
);

CREATE TABLE product_to_send(
id INT NOT NULL AUTO_INCREMENT,
product_id INT NOT NULL,
order_number_id INT NOT NULL,
qty INT NOT NULL,
tracking VARCHAR(45),
status_id INT NOT NULL,
send_date DATETIME,
date_delivery_confirmation DATETIME,
delivery_confirmation TINYINT DEFAULT 0, 
PRIMARY KEY(id),
CONSTRAINT `fk_order_number_id` FOREIGN KEY (order_number_id) REFERENCES order_number(id),
CONSTRAINT `fk_status_product_to_send_id` FOREIGN KEY (status_id) REFERENCES status_to_send(id)
);

-- *********************************************************************
-- *                        PURCHASE INFORMATION                       *
-- *********************************************************************

CREATE TABLE type_payment(
id INT NOT NULL AUTO_INCREMENT,
type VARCHAR(45) NOT NULL,
PRIMARY KEY (id)
);

CREATE TABLE status_purchase(
id INT NOT NULL AUTO_INCREMENT,
type VARCHAR(45) NOT NULL,
PRIMARY KEY(id)
);

CREATE TABLE payment(
id INT NOT NULL AUTO_INCREMENT,
purchase_id INT NOT NULL,
type_id INT NOT NULL,
value DECIMAL(9,2) NOT NULL,
date DATETIME NOT NULL,
number_card VARCHAR(45),
CONSTRAINT `fk_type_payment` FOREIGN KEY (type_id) REFERENCES type_payment(id),
PRIMARY KEY (id)
);

CREATE TABLE purchase(
id INT NOT NULL AUTO_INCREMENT,
date DATE NOT NULL,
customer_id INT NOT NULL,
value_to_send DECIMAL(9,2) NOT NULL,
address_id INT NOT NULL,
status_purchase_id INT NOT NULL,
PRIMARY KEY (id),
CONSTRAINT `fk_status_purchase`	FOREIGN KEY (status_purchase_id) REFERENCES status_purchase(id)
);

ALTER TABLE payment ADD CONSTRAINT `fk_purchase_id` FOREIGN KEY (purchase_id) REFERENCES purchase(id);

-- *********************************************************************
-- *                        CUSTUMER INFORMATION                       *
-- *********************************************************************

CREATE TABLE type_customer(
id INT NOT NULL AUTO_INCREMENT,
type VARCHAR(45),
PRIMARY KEY(id)
);

CREATE TABLE customer(
id INT NOT NULL AUTO_INCREMENT,
name VARCHAR(45) NOT NULL,
cpf_or_cnpj VARCHAR(45) UNIQUE,
birth_date DATE NOT NULL,
type_customer INT NOT NULL,
ur CHAR(2) NOT NULL,
rg VARCHAR(45) NOT NULL,
pf_or_pj TINYINT,
email VARCHAR(45) NOT NULL UNIQUE,
PRIMARY KEY(id),
CONSTRAINT `fk_type_customer` FOREIGN KEY (type_customer) REFERENCES type_customer(id)
);

ALTER TABLE purchase ADD CONSTRAINT `fk_costomer_id` FOREIGN KEY (customer_id) REFERENCES customer(id);

-- *********************************************************************
-- *                                ADDRESS                            *
-- *********************************************************************

CREATE TABLE address(
id INT NOT NULL AUTO_INCREMENT,
country VARCHAR(45) NOT NULL,
state VARCHAR(45) NOT NULL,
city VARCHAR (45) NOT NULL,
patio VARCHAR(45) NOT NULL, 
number VARCHAR(11) NOT NULL,
complement VARCHAR(45) NOT NULL,
cep VARCHAR(45) NOT NULL,
PRIMARY KEY(id)
);

ALTER TABLE purchase ADD CONSTRAINT `fk_address_to_send` FOREIGN KEY (address_id) REFERENCES address(id); 

CREATE TABLE customer_address(
id INT NOT NULL AUTO_INCREMENT,
address_id INT NOT NULL,
customer_id INT NOT NULL,
PRIMARY KEY (id),
CONSTRAINT `fk_customer_id2adress` FOREIGN KEY (customer_id) REFERENCES customer(id),
CONSTRAINT `fk_address_costumer` FOREIGN KEY (address_id) REFERENCES address(id)
);

-- *********************************************************************
-- *                                 PHONE                             *
-- *********************************************************************

CREATE TABLE type_phone(
id INT NOT NULL AUTO_INCREMENT,
type VARCHAR(45) NOT NULL, 
PRIMARY KEY(id)
);

CREATE TABLE phone(
id INT NOT NULL AUTO_INCREMENT,
type_phone_id INT NOT NULL, 
number VARCHAR(45) NOT NULL,
ddi CHAR(2) NOT NULL,
ddd CHAR(2) NOT NULL,
PRIMARY KEY (id),
CONSTRAINT `fk_type_phone` FOREIGN KEY (type_phone_id) REFERENCES type_phone(id)
);

-- *********************************************************************
-- *                               PRODUCT                             *
-- *********************************************************************

CREATE TABLE brand(
id INT NOT NULL AUTO_INCREMENT,
name VARCHAR(45) NOT NULL,
PRIMARY KEY(id)
);

CREATE TABLE type_product(
id INT NOT NULL AUTO_INCREMENT,
description VARCHAR(45) NOT NULL,
PRIMARY KEY (id)
);

CREATE TABLE category(
id INT NOT NULL AUTO_INCREMENT,
name VARCHAR(45) NOT NULL,
PRIMARY KEY (id)
);

CREATE TABLE storage(
id INT NOT NULL AUTO_INCREMENT,
location VARCHAR(45) NOT NULL,
name VARCHAR(45) NOT NULL,
PRIMARY KEY(id)
);

CREATE TABLE seller(
id INT NOT NULL AUTO_INCREMENT,
cnpj VARCHAR(45) NOT NULL,
name VARCHAR(45) NOT NULL,
PRIMARY KEY(id)
);

CREATE TABLE supplier(
id INT NOT NULL AUTO_INCREMENT,
name VARCHAR(45) NOT NULL,
PRIMARY KEY (id)
);

CREATE TABLE product(
id INT NOT NULL AUTO_INCREMENT,
name VARCHAR(45) NOT NULL,
description VARCHAR(45) NOT NULL,
value DECIMAL(9,2) NOT NULL,
supplier_id INT NOT NULL,
category_id INT NOT NULL,
brand_id INT NOT NULL,
sold_by_id INT NOT NULL,
type_id INT NOT NULL,
PRIMARY KEY(id),
CONSTRAINT `fk_category_id` FOREIGN KEY (category_id) REFERENCES category(id) ,
CONSTRAINT `fk_brand_id` FOREIGN KEY (brand_id) REFERENCES brand(id),
CONSTRAINT `fk_sold_by_id` FOREIGN KEY (sold_by_id) REFERENCES seller(id),
CONSTRAINT `fk_type_id` FOREIGN KEY (type_id) REFERENCES type_product(id)
);

ALTER TABLE product_to_send ADD CONSTRAINT `fk_product_to_send` FOREIGN KEY (product_id) REFERENCES product(id);

CREATE TABLE seller_address(
id INT NOT NULL AUTO_INCREMENT,
seller_id INT NOT NULL,
address_id INT NOT NULL,
PRIMARY KEY (id)
);

ALTER TABLE seller_address ADD CONSTRAINT `fk_seller_id` FOREIGN KEY (seller_id) REFERENCES seller(id);
ALTER TABLE seller_address ADD CONSTRAINT `fk_seller_address_id` FOREIGN KEY (address_id) REFERENCES address(id);

CREATE TABLE supplier_phone(
id INT NOT NULL AUTO_INCREMENT,
id_supplier INT NOT NULL,
id_phone INT NOT NULL,
PRIMARY KEY(id),
CONSTRAINT `fk_supplier` FOREIGN KEY (id_supplier) REFERENCES supplier(id),
CONSTRAINT `fk_id_address` FOREIGN KEY (id_phone) REFERENCES phone(id)
);

-- *********************************************************************
-- *                               STORAGE                             *
-- *********************************************************************

CREATE TABLE storage_in(
storage_id INT NOT NULL,
product_id INT NOT NULL,
qty INT NOT NULL,
CONSTRAINT `fk_storage_id` FOREIGN KEY (storage_id) REFERENCES storage(id),
CONSTRAINT `fk_product` FOREIGN KEY (product_id) REFERENCES product(id)
);

-- *********************************************************************
-- *                               OTHERS                              *
-- *********************************************************************
-- INFORMATION ABOUT SELLER ( PHONE AND ADDRESS )

CREATE TABLE seller_phone(
id INT NOT NULL AUTO_INCREMENT,
phone_id INT NOT NULL,
seller_id INT NOT NULL,
PRIMARY KEY (id),
CONSTRAINT `fk_phone_number`FOREIGN KEY (phone_id) REFERENCES phone(id),
CONSTRAINT `fk_seller` FOREIGN KEY (seller_id) REFERENCES seller(id)
);

CREATE TABLE supplier_address(
id INT NOT NULL AUTO_INCREMENT,
address_id INT NOT NULL,
supplier_id INT NOT NULL,
PRIMARY KEY(id),
CONSTRAINT `fk_supplier_id` FOREIGN KEY (supplier_id) REFERENCES supplier(id),
CONSTRAINT `fk_supplier_address` FOREIGN KEY (address_id) REFERENCES address(id)
);

-- INFORMATION ABOUT PHONE'S CUSTOMER

CREATE TABLE customer_phone(
id INT NOT NULL AUTO_INCREMENT,
customer_id INT NOT NULL,
phone_id INT NOT NULL,
PRIMARY KEY(id),
CONSTRAINT `fk_customer_number_phone` FOREIGN KEY (phone_id) REFERENCES phone(id),
CONSTRAINT `fk_customer_id2` FOREIGN KEY (customer_id) REFERENCES customer(id)
);

-- INFORMATION ABOUT PURCHASE'S PRODUCTS

CREATE TABLE product_purchase(
id INT NOT NULL AUTO_INCREMENT,
product_id INT NOT NULL,
purchase_id INT NOT NULL,
qty INT NOT NULL,
PRIMARY KEY(id),
CONSTRAINT `fk_product_id` FOREIGN KEY (product_id) REFERENCES product(id),
CONSTRAINT `fk_purchase` FOREIGN KEY (purchase_id) REFERENCES purchase(id)
);

-- ALTER TABLES

ALTER TABLE order_number ADD CONSTRAINT `fk_responsible_to_send` FOREIGN KEY (responsible_id) REFERENCES seller(id);
ALTER TABLE order_number ADD CONSTRAINT `fk_payment_id_confirm` FOREIGN KEY (payment_id) REFERENCES payment(id);
ALTER TABLE supplier ADD COLUMN cnpj VARCHAR(45) NOT NULL;

-- *********************************************************************
-- *                           STORAGE CONTROL                         *
-- *********************************************************************

CREATE TABLE control(
product_id INT NOT NULL,
qty INT NOT NULL,
name VARCHAR(45) NOT NULL,
description VARCHAR(45) NOT NULL,
type VARCHAR(45) NOT NULL,
category VARCHAR(45) NOT NULL,
brand VARCHAR(45) NOT NULL,
supplier_name VARCHAR(45) NOT NULL,
supplier_cnpj VARCHAR(45) NOT NULL,
seller_cnpj VARCHAR(45) NOT NULL,
seller_name VARCHAR(45) NOT NULL
);

-- *********************************************************************
-- *********************************************************************
-- DROP DATABASE e_commerce;