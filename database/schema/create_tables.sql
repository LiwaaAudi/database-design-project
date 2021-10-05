-- location table
CREATE TABLE IF NOT EXISTS locations (
    location_id     bigserial       NOT NULL,
    address         text            NOT NULL,
    city            text,
    postal_code     int,

    CONSTRAINT locations_pk primary key (location_id)
);

-- warehouses table
CREATE TABLE IF NOT EXISTS warehouses (
    warehouse_id    bigserial       NOT NULL,
    warehouse_name  text,
    location_id     int,

    CONSTRAINT warehouses_pk primary key (warehouse_id),

    CONSTRAINT warehouses_locations_fk
      FOREIGN KEY(location_id)
      REFERENCES locations(location_id)
      ON DELETE CASCADE
);

-- products_categories table
CREATE TABLE IF NOT EXISTS product_categories (
    category_id     bigserial       NOT NULL,
    category_name   varchar(100)    NOT NULL,

    CONSTRAINT product_categories_pk primary key (category_id)
);

-- products table
CREATE TABLE IF NOT EXISTS products (

    product_id      bigserial       NOT NULL,
    product_name    text            NOT NULL,
    price           float            NOT NULL,
    description     text            NOT NULL,
    category_id     int             NOT NULL,
    image           text,

    CONSTRAINT products_pk primary key (product_id),
    CONSTRAINT products_categories_fk
      FOREIGN KEY(category_id)
      REFERENCES product_categories(category_id)
      ON DELETE CASCADE
);

-- inventories table
CREATE TABLE IF NOT EXISTS inventories (
    product_id      int             NOT NULL,
    warehouse_id    int             NOT NULL,
    quantity        int             NOT NULL,

    CONSTRAINT inventories_pk primary key (product_id, warehouse_id),
    CONSTRAINT inventories_fk
      FOREIGN KEY(product_id)
      REFERENCES products(product_id)
      ON DELETE CASCADE,
    CONSTRAINT inventories_warehouses_fk
      FOREIGN KEY(warehouse_id)
      REFERENCES warehouses(warehouse_id)
      ON DELETE CASCADE
);

-- customers table
CREATE TABLE IF NOT EXISTS customers (

    customer_id     bigserial       NOT NULL,
    username        varchar(100)    NOT NULL,
    city            text            NOT NULL,
    address         text,

    CONSTRAINT customers_pk primary key (customer_id)
);

-- contacts table
CREATE TABLE IF NOT EXISTS contacts (
    contact_id      bigserial       NOT NULL,
    first_name       varchar(100)    NOT NULL,
    last_name       varchar(100)    NOT NULL,
    email           text            NOT NULL,
    phone           text,
    customer_id     int             NOT NULL,

    CONSTRAINT contacts_pk primary key (contact_id),
    CONSTRAINT contacts_fk
      FOREIGN KEY(customer_id)
      REFERENCES customers(customer_id)
      ON DELETE CASCADE
);

-- shopping_session table
CREATE TABLE IF NOT EXISTS shopping_session (
    session_id      bigserial       NOT NULL,
    customer_id     int             NOT NULL,
    total           decimal         NOT NULL,
    created_at      timestamp       NOT NULL,

    CONSTRAINT shopping_session_pk primary key (session_id),
    CONSTRAINT shopping_session_fk
      FOREIGN KEY(customer_id)
      REFERENCES customers(customer_id)
      ON DELETE CASCADE
);

-- cart_items table
CREATE TABLE IF NOT EXISTS cart_items (
    cart_id         bigserial       NOT NULL,
    session_id      int             NOT NULL,
    product_id      int             NOT NULL,
    quantiy         int             NOT NULL,

    CONSTRAINT cart_items_pk primary key (cart_id, session_id),
    CONSTRAINT cart_items_fk
      FOREIGN KEY(session_id)
      REFERENCES shopping_session(session_id)
      ON DELETE CASCADE
);

-- payments table
CREATE TABLE IF NOT EXISTS payments (
    payment_id      bigserial       NOT NULL,
    customer_id     int             NOT NULL,
    last_name       varchar(100)    NOT NULL,
    payment_type    text            NOT NULL,
    provider        text,

    CONSTRAINT payments_pk primary key (payment_id),
    CONSTRAINT payments_fk
      FOREIGN KEY(customer_id)
      REFERENCES customers(customer_id)
      ON DELETE CASCADE
);

-- orders table
CREATE TABLE IF NOT EXISTS orders (
    order_id            bigserial       NOT NULL,
    customer_id         int             NOT NULL,
    total_price         decimal(20,6)   NOT NULL,
    shipping_id         bigserial       NOT NULL,
    shipping_address    text            NOT NULL,
    payment_id          int             NOT NULL,
    purchased_at        timestamp       NOT NULL,

    CONSTRAINT orders_pk primary key (order_id),
    CONSTRAINT orders_fk
      FOREIGN KEY(customer_id)
      REFERENCES customers(customer_id)
      ON DELETE CASCADE,
    CONSTRAINT orders_payments_fk
      FOREIGN KEY(payment_id)
      REFERENCES payments(payment_id)
      ON DELETE CASCADE
);

