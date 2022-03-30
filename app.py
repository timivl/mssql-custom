import os
import time
import pymssql



def connect():

    server   = os.environ.get('DB_HOST', 'localhost')
    user     = os.environ.get('DB_USER', 'sa')
    password = os.environ.get('SA_PASSWORD')

    try:
        conn = pymssql.connect(server, user, password, 'tempdb')
        return conn
    except:
        time.sleep(3)
        print('retrying connection to database')
        return connect()


conn   = connect()
cursor = conn.cursor()
cursor.execute('SELECT 1 AS count')
for row in cursor:
    print(row)

conn.close()
