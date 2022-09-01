# ER E-commerce
## Contextualizando
*O esquema apresenta a relação de venda/produto.* <br>

### **Persistindo no banco os dados:**<br>

**Informações do  cliente**<br>
 Cliente pode ser definido como pessoa física ou jurídica, utilizei um TYNYINT, que pode ser manipulado por meio de um TRIGGER no momento do cadastro, de maneira que por meio do uso da mesma, seja setado automaticamente no campo pf_or_pj, valor 1 caso o input do usuário contenha 11 caracteres e 0 caso seja 14 caracteres, valor 1 para pessoa física e 0 pessoa jurídica respectivamente.<br>

**Informações do produto**<br>
Já o produto se difere quando a marca, categoria e tipo, além do vendedor e fornecedor que disponibilizam o mesmo.<br>

**Informações da venda**<br>
As vendas, por sua vez, podem conter mais de um produto, e com base no endereço de entrega é calculado a taxa de entrega, o pagamento pode ser realizado por diversas formas, inclusive cartão.<br>

**Ordem de serviço**<br>
Com base nas informações de compra e pagamento é gerado a ordem de serviço, que acompanha a continuidade das transações cliente e e-commerce, que por sua vez possíbilita o cancelamento, tendo o campo status, para acompanhar o envio, entrega ou possível cancelamento da mesma.

**Informações adicionais (endereço e telefone)** <br>
O esquema está disposto de maneira que um cliente possa cadastrar um ou mais endereços e telefones.

**Geral** <br>
Alguns dados de valor, por exemplo: valor do produto e taxa de envio, estão restritas as respectivas tabelas, evitando redundância de dados.





