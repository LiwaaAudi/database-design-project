--1 Product with maximum quantity sold per order
select product_name, quantity
from lineitems
where quantity = (select max(quantity) from lineitems);

--2. Cheapest product available in stock
select product_name, price
from products
where price = (select min(price) from products);

--3. Average lineitem purchases unique quantity
select avg(distinct quantity)::numeric(10,2)
from lineitems;

--4.List of products Which weren't bought yet
select *
from products p
where p.product_id not in (select product_id from lineitems);

--5. Union products and lineitems
select product_id, product_name, description, price from products
UNION ALL
select product_id, product_name, description, price from lineitems;

-- 6. Get customers that are from Kilcoole city
select distinct first_name, last_name
from customers
where city = 'kilcoole';

--7. List of customers who bought Fjallraven - Foldsack No. 1 Backpack, Fits 15 Laptops
select distinct first_name , last_name
from customers
	join orders on customers.customer_id = orders.customer_id
	join lineitems on lineitems.order_id = orders.order_id
where lineitems.product_name = 'Fjallraven - Foldsack No. 1 Backpack, Fits 15 Laptops';


--8.