import pandas as pd
import numpy as np
import requests
import string
import random


class RandData:
    api = 'https://fakestoreapi.com/'
    orders_url = 'https://drive.google.com/file/d/1kzPx1N2c64I4fejcbE-eyylYUb4TNrc2/view?usp=sharing'
    shipping_address_url = 'https://drive.google.com/file/d/1WMWB8cqi9Mh4FhnyVG4qPqA9_MEp5_3j/view?usp=sharing'
    payment_type_url = 'https://drive.google.com/file/d/1TDdFm6_oWC90ei5cdwVw2tkTiv8mHT43/view?usp=sharing'
    lineitems_url = 'https://drive.google.com/file/d/1nx64nc50rSgW2Zg_NP034xTTaWWgMgRl/view?usp=sharing'

    def get_payment_type(self):
        """
        :return: payment type table
        """
        payment_type_url = 'https://drive.google.com/uc?id=' + self.payment_type_url.split('/')[-2]
        return pd.read_csv(payment_type_url)

    def get_lineitems(self):
        """
        :return: lineitems table
        """

        lineitems_url = 'https://drive.google.com/uc?id=' + self.lineitems_url.split('/')[-2]
        return pd.read_csv(lineitems_url)

    def get_orders(self):
        """
        :return: orders table
        """
        orders_url = 'https://drive.google.com/uc?id=' + self.orders_url.split('/')[-2]
        return pd.read_csv(orders_url)

    def get_shipping_address(self):
        """
        :return: shipping address table
        """
        shipping_address_url = 'https://drive.google.com/uc?id=' + self.shipping_address_url.split('/')[-2]
        return pd.read_csv(shipping_address_url)

    def get_products(self):
        """
        :return: products, stocks and categories tables
        """
        res = requests.get(self.api + 'products').json()
        products_list = []
        stock_list = []
        for i in range(len(res)):
            product_id = res[i]['id']
            product_name = res[i]['title']
            description = res[i]['description']
            category = res[i]['category']
            rating = res[i]['rating']
            price = res[i]['price']
            sku = ''.join(random.choice(string.ascii_uppercase +
                                        string.digits) for _ in range(9))
            stock_dict = {'product_id': product_id, 'sku': sku,
                          'quantity_available': np.random.randint(0, 21)}
            products_dict = {'product_id': product_id, 'sku': sku, 'product_name': product_name,
                             'description': description,
                             'category': category, 'price': price, 'rate': rating['rate'],
                             'rating_count': rating['count']}
            products_list.append(products_dict)
            stock_list.append(stock_dict)
        res = requests.get(self.api + 'products/categories').json()
        categories = []
        ids_lst = [1, 2, 3, 4]
        description_lst = ['Common items in the electronics sector include mobile devices, televisions, and circuit '
                           'boards.',
                           'Rings, necklaces, earrings, and bracelets that are made of materials which may or may not '
                           'be precious (such as gold, silver, glass, and plastic)',
                           'Including formal wear, business wear, casual, athletic and outerwear.',
                           'The clothing of women and girls.']
        for i in range(len(res)):
            category_id = ids_lst[i]
            category = res[i]
            description = description_lst[i]
            x = {'category_id': category_id,
                 'category': category, 'description': description}
            categories.append(x)

        c = pd.DataFrame(categories)
        products = pd.DataFrame(products_list).merge(
            c[['category_id', 'category']], on='category').drop('category', axis=1)
        return {
            'products': products,
            'stock': pd.DataFrame(stock_list),
            'categories': c
        }

    def get_customers(self):
        """
        :return: customers and billing_addresses tables
        """
        res = requests.get(self.api + 'users').json()
        customers_lst = []
        billing_lst = []
        for c in res:
            city = c['address']['city']
            address = c['address']['street'] + ' ' + str(c['address']['number'])
            zipcode = c['address']['zipcode']
            customer_id = c['id']
            email = c['email']
            phone = c['phone']
            first_name = c['name']['firstname']
            last_name = c['name']['lastname']
            customers_dict = {
                'customer_id': customer_id,
                'email': email,
                'first_name': first_name,
                'last_name': last_name,
                'phone': phone,
                'country': 'United States',
                'city': city,
                'address': address
            }
            billing_dict = {
                'customer_id': customer_id,
                'billing_country': 'United States',
                'billing_city': city,
                'billing_address': address,
                'zip': zipcode,
                'payment_type_id': np.random.randint(1, 8)
            }
            customers_lst.append(customers_dict)
            billing_lst.append(billing_dict)
        return {
            'customers': pd.DataFrame(customers_lst),
            'billing_address': pd.DataFrame(billing_lst)
        }
