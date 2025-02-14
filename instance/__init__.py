import mariadb
from mariadb.constants import ERR
from getpass import getpass

while True:
    dbpass = getpass("Database password: ")
    try:
        mydb = mariadb.connect(
            host = "localhost",
            port = 3306,
            user = "root",
            password = dbpass,
            database = "sinkingsql"
        )
    except mariadb.Error as e:
        if e.errno == ERR.ER_ACCESS_DENIED_ERROR:
            print("Authentication failure")
        else:
            print(f"MariaDB Error: {e}")
    else:
        mycursor = mydb.cursor()
        break