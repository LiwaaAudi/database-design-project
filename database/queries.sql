-- 1. Product with maximum quantity sold per order
select
       product_name,
       quantity
from lineitems
where quantity = (
    select
           max(quantity)
    from lineitems
    );

-- 2. Cheapest product available in stock
select
       product_name,
       price
from products
where price = (
    select
           min(price)
    from products
    );

-- 3. Average lineitem purchases unique quantity
select
       avg(distinct quantity)::numeric(10,2)
from lineitems;

-- 4.List of products Which weren't bought yet
select *
from products p
where
      p.product_id not in (
          select product_id
          from lineitems
          );

-- 5. Union products and lineitems
select
       product_id,
       product_name,
       description,
       price
from products
union all
select
       product_id,
       product_name,
       description,
       price
from lineitems;

-- 6. Get customers that are from Kilcoole city
select distinct
                first_name,
                last_name
from customers
where
      city = 'kilcoole';

-- 7. List of customers who bought Fjallraven - Foldsack No. 1 Backpack, Fits 15 Laptops
select distinct
                first_name,
                last_name
from customers
	join orders on customers.customer_id = orders.customer_id
	join lineitems on lineitems.order_id = orders.order_id
where
      lineitems.product_name = 'Fjallraven - Foldsack No. 1 Backpack, Fits 15 Laptops';


-- 8. Who bought products that have a price more than 100
select distinct
                customer_id
from lineitems
    left join orders on lineitems.order_id = orders.order_id
where
      price > 100

-- 9. Total Store revenue
select
       sum(l.price * l.quantity) as total
from lineitems l
    inner join orders o
    on l.order_id = o.order_id

-- 10. Customers who spent more than 150
select
       customer_id,
       sum(l.price*l.quantity)
from lineitems l
    inner join orders o
    on l.order_id = o.order_id
group by
         customer_id
having
       sum (l.price*l.quantity) > 150;

-- 11. Create customer master view
create view customer_master as
    select c.customer_id as id,
        c.first_name || ' ' || c.last_name AS name,
        b.billing_address,
        b.billing_country,
        b.billing_city,
        b.payment_type_id,
            case
                when c.active then 'active'
                else ''
            end as notes,
        c.email
        from customers c
             inner join billing_address b on c.customer_id = b.customer_id;

-- 12. shipping address and billing address intersection
select
       customer_id,
       country,
       city,
       address,
       zip
from shipping_address
intersect
select
       customer_id,
       billing_country,
       billing_city,
       billing_address,
       zip
from billing_address;

-- 13. all customers that have made an order in the past 30 days
select
       c.first_name || ' ' || c.last_name as name
from customers c
    full outer join orders o on c.customer_id = o.customer_id
where
      purchased_at >= now() - interval '30 days';

-- 14. Orders with more than 2 products
select
       order_id,
       count (product_id)
from lineitems
group by
         order_id
having
       count (product_id) > 2;

-- 15. Customers who bought products from category men's clothing Except(MINUS) the products that are cheaper than 10
select distinct
                first_name,
                last_name
from customers c
	inner join orders o on c.customer_id = o.customer_id
	inner join lineitems l on o.order_id = l.order_id
	left join products p on l.product_id = p.product_id
where
      p.category_id = (
	select
	       category_id
	from categories c2
	where
	      category_id = 3
)
except
select
       first_name,
       last_name
from customers c
	inner join orders o on c.customer_id = o.customer_id
	inner join lineitems l on o.order_id = l.order_id
	left join products p on l.product_id = p.product_id
where
      p.price < 10;

-- 16. Orders analysis
select
    product_id,
    count (order_id)  orders,
    sum (price * quantity)  revenue,
    sum (price) margin,
    avg (revenue) average_order_value
from lineitems
where
    order_id between 1 and 10
group by
    1
order by
    2 desc;

-- 17. cross-sell products
select
	lineitems.product_id,
	count (distinct orders.order_id) orders,
	count (distinct case when lineitems.product_id = 1 then orders.order_id else null end) cross_sell_product_1,
	count (distinct case when lineitems.product_id = 2 then orders.order_id else null end) cross_sell_product_2,
	count (distinct case when lineitems.product_id = 3 then orders.order_id else null end) cross_sell_product_3
from orders
	left join lineitems on lineitems.order_id = orders.order_id
group by 1;

-- 18. Products completed orders analysis
select
	extract (year from orders.purchased_at) as year,
	extract (month from orders.purchased_at) as  month,
	count ( distinct case when product_id = 1 then lineitems.lineitem_id else null end) product_1_orders
from lineitems
	join orders on lineitems.order_id = orders.order_id
where orders.order_status = 'completed'
group by 1,2;

-- 19. Add a new column containing the number of orders for each customer
alter table orders
    add order_number varchar;

update orders
SET order_number = CASE WHEN LEFT(order_id, 3) <> 'gid' THEN order_id ELSE '' END;


