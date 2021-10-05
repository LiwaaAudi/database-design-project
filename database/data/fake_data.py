import requests
import pandas as pd
import numpy as np


class LoadFake:
    """
    load Fake Data from https://fakestoreapi.com to fill the database
    """

    def __init__(self, start_date='2020-01-01', end_date='2021-09-01'):
        """
        Dates for random filling
        :param start_date: min date
        :param end_date: max date
        """
        self.min_date = start_date
        self.max_date = end_date

    def load_fake(self, x):
        """
        :param x: (string) data needed(users, carts, products)
        :return: json response with fake data
        """
        url = 'https://fakestoreapi.com/{}'.format(x)
        return requests.get(url).json()

    def products(self):
        fake_products = self.load_fake('products')
        return pd.DataFrame(fake_products).drop(['id', 'rating'], axis=1)

    def users(self):
        fake_users = self.load_fake('users')
        li = []
        for user in fake_users:
            di = {
                'first_name': user['name']['firstname'],
                'last_name': user['name']['lastname'],
                'username': user['username'],
                'password': user['password'],
                'email': user['email'],
                'phone': user['phone']
            }
            li.append(di)
        return pd.DataFrame(li)

    def random_date_generator(self, df, column_name):
        """
        Generates random dates
        :param df: dataframe
        :param column_name: (string) date column name
        :return: random dates
        """
        df[column_name] = np.random.choice(pd.date_range(self.min_date, self.max_date), len(df))

    def random_numbers_generator(self, df, column_name, x, y):
        df[column_name] = np.random.randint(x, y, df.shape[0])

    def orders(self):
        fake_orders = self.load_fake('carts')
        li = []
        for order in fake_orders:
            for product in order['products']:
                di = {
                    'customer_id': order['userId'],
                    'product_id': product['productId'],
                    'quantity': product['quantity']
                }
                li.append(di)
        return pd.DataFrame(li)
