UPDATE shipping_address
SET
    country = billing_address.billing_country,
    city = billing_address.billing_city,
    address = billing_address.billing_address,
    zip = billing_address.zip

FROM
    billing_address
WHERE
    shipping_address.customer_id = billing_address.customer_id
RETURNING *;


UPDATE orders
SET
    shipping_id = shipping_address.shipping_id
FROM
    shipping_address
WHERE
    orders.order_id = shipping_address.order_id
RETURNING *;

alter table website_sessions
  add  constraint website_sessions_fk foreign key (customer_id)
        references customers (customer_id);
