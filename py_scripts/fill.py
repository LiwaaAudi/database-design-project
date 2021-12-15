from db import PostgreSQL
from fake_data import RandData

psql = PostgreSQL()

rand = RandData()
dct1 = rand.get_products()

payment_type = rand.get_payment_type()
psql.insert(payment_type, 'payment_type')

categories = dct1['categories']
psql.insert(categories, 'categories')

products = dct1['products']
psql.insert(products, 'products')

stock = dct1['stock']
psql.insert(stock, 'stock')

dct2 = rand.get_customers()

customers = dct2['customers']
psql.insert(customers, 'customers')

billing_address = dct2['billing_address']
psql.insert(billing_address, 'billing_address')

orders = rand.get_orders()
psql.insert(orders, 'orders')

shipping_address = rand.get_shipping_address()
psql.insert(shipping_address, 'shipping_address')

lineitems = rand.get_lineitems()
psql.insert(lineitems, 'lineitems')

