import sys
import pandas.io.sql as psql
import psycopg2
from psycopg2 import OperationalError
from sqlalchemy import create_engine


db_config = {
    "host": "localhost",
    "database": "database-design-psql",
    "user": "postgres",
    "password": "docker",
    "port": "5555"
}


class PostgreSQL:
    def __init__(self, config=None):
        """
        :param config: dict with next fields
            1.host - host of database
            2.database - name of database
            3.user - login of user
            4.password - password of user
            5.port - port of database
        """
        if config is None:
            config = db_config
        self.config = config

    def engine(self):
        """
        Creates SQLalchemy engine to fill tables
        :return: connection
        """
        conn_str = (
            'postgresql://{0}:{1}@{2}:{3}/{4}'.format(self.config['user'], self.config['password'], self.config['host'],
                                                      self.config['port'], self.config['database']))
        engine = create_engine(conn_str)
        return engine

    def insert(self, df, table):
        """
        :param df: dataframe
        :param table: sql schema table
        :return: insert function
        """
        return df.to_sql(table, self.engine(), if_exists='append', index=False)


    def show_psycopg2_exception(self, err):
        """
        Handles and parses psycopg2 exceptions
        :param err: error
        :return: error information
        """
        # exception details
        err_type, err_obj, traceback = sys.exc_info()
        # line where exception occurred
        line_n = traceback.tb_lineno
        print("\npsycopg2 ERROR: {}, on line number: {}".format(err, line_n))
        print("\npsycopg2 traceback: {}, --type: {}".format(traceback, err_type))
        # psycopg2 extension.Diagnostics
        print("\nextensions.Diagnostics: ", err.diag)
        # pg code and exception
        print("pg_error: ", err.pgerror)
        print("pg_code: ", err.pgcode, "\n")

    def connect(self):
        try:
            conn = psycopg2.connect(**self.config)
        except OperationalError as err:
            self.show_psycopg2_exception(err)
            conn = None
        return conn

    def read(self, x):
        conn = self.connect()
        return psql.read_sql(x, conn)

    def load(self, table, fields, condition=None):
        """
        :param table: (string) table name
        :param fields: (list) desired fields
        :param condition: sql condition
        :return: database table
        """

        if condition is not None:
            query = """select {} from {} where {}""".format(fields, table, condition)
        else:
            query = """select {} from {}""".format(fields, table)

        return self.read(query)
