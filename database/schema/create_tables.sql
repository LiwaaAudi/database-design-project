create table if not exists customers (
    customer_id serial not null,
    email varchar(255) not null unique,
    first_name varchar(255) not null,
    last_name varchar(255) not null,
    phone varchar not null,
    country varchar not null,
    city varchar not null,
    address varchar not null,
    active bool default true,
    constraint pk_customers primary key (customer_id)
);


create table if not exists categories (
    category_id bigserial not null,
    category varchar(100) not null,
    description varchar(255) not null,
    constraint categories_pk primary key (category_id)
);


create table if not exists products (
    product_id serial not null,
    sku varchar(255) not null,
    product_name varchar(255) not null,
    description text,
    category_id int not null,
    price numeric default 0,
    rate decimal not null,
    rating_count int not null,
    constraint products_pk primary key (product_id),
    constraint products_fk foreign key (category_id)
        references categories(category_id)
);

create table if not exists stock (
    product_id int not null,
    sku varchar(255) not null,
    quantity_available int not null,
    constraint stock_pk primary key (product_id, sku),
    constraint stock_products_fk foreign key (product_id)
        references products(product_id)
);

create table if not exists payment_type (
    payment_type_id serial not null,
    payment_type varchar(255) not null,
    constraint payment_type_pk primary key (payment_type_id)
);

create table orders (
    order_id serial not null,
    customer_id integer not null,
    purchased_at timestamp with time zone not null,
    order_status varchar not null,
    shipping_id int,
    constraint orders_pk primary key (order_id),
    constraint orders_fk foreign key (customer_id)
        references customers(customer_id)
);

create table if not exists shipping_address (
    shipping_id bigserial not null,
    customer_id bigint not null,
    order_id bigint not null,
    country varchar,
    city varchar,
    address text,
    zip varchar(10),
    shipment_price decimal not null default 0,
    status varchar not null,
    constraint shipping_address_pk primary key (shipping_id, customer_id),
    constraint shipping_address_fk foreign key (customer_id)
        references customers(customer_id) on delete cascade,
    constraint shipping_address_orders_fk foreign key (order_id)
        references orders(order_id) on delete cascade
);

create table if not exists billing_address (
    billing_id bigserial not null,
    customer_id bigint not null,
    billing_country varchar not null,
    billing_city varchar not null,
    billing_address varchar not null,
    zip varchar(10) not null,
    payment_type_id int not null,
    constraint billing_address_pk primary key (billing_id, customer_id),
    constraint billing_address_fk foreign key (customer_id)
        references customers (customer_id) on delete cascade,
    constraint billing_address_payment_type_fk foreign key (payment_type_id)
        references payment_type (payment_type_id) on delete cascade
);

create table lineitems (
    lineitem_id serial not null,
    order_id int not null,
    product_id int not null,
    quantity integer not null,
    constraint lineitems_pk primary key (lineitem_id),
    constraint lineitems foreign key (order_id)
        references orders(order_id),
    constraint lineitems_products foreign key (product_id)
        references products(product_id) on delete cascade
);

alter table
    lineitems
add
    product_name varchar not null default '';

UPDATE
    lineitems
SET
    product_name = products.product_name
FROM
    products
WHERE
    lineitems.product_id = products.product_id;

alter table
    lineitems
add
    description text not null default '';

UPDATE
    lineitems
SET
    description = products.description
FROM
    products
WHERE
    lineitems.product_id = products.product_id;

alter table
    lineitems
add
    price numeric not null default 0;

UPDATE
    lineitems
SET
    price = products.price
FROM
    products
WHERE
    lineitems.product_id = products.product_id;


alter table
    products
add
    in_stock boolean not null default true;

UPDATE
    products
SET
    in_stock = true
FROM
    stock
WHERE
    stock.quantity_available > 0;


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

