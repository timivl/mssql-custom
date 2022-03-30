import os
import pymssql

server = 'localhost'
user = 'sa'
password = os.environ.get('SA_PASSWORD')

conn = pymssql.connect(server, user, password, 'tempdb')
cursor = conn.cursor()
cursor.execute('SELECT 1 AS count')
for row in cursor:
    print(row)

conn.close()
