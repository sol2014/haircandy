insert into supplier (address_no,supplier_name,description,phone_number,enabled)
values (6,'Goofy','supply the product of shampoo, hairconditioner and coloring','3324493333', true);
insert into supplier (address_no,supplier_name,description,phone_number,enabled)
values (7,'Beauty Co.','supply the product of skin care','6633332233', true);
insert into supplier (address_no,supplier_name,description,phone_number,enabled)
values (6,'Shiny Co.','supply the product for perm','4035491303',true);

INSERT INTO 
  `supplierproduct`
(
  `supplier_no`,
  `product_no`
) 
VALUE (
  1,
  1
);
INSERT INTO 
  `supplierproduct`
(
  `supplier_no`,
  `product_no`
) 
VALUE (
  1,
  2
);
