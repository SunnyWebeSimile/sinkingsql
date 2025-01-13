from json import dumps
from mariadb import Error as mariadb_error
if __name__ != "__main__":
    from instance import mydb, mycursor
else:
    from __init__ import mydb, mycursor

debug_mode = True

def commit_if_prod():
    if not debug_mode:
        mydb.commit()

def get_ship_info(ship_id):  # Someone tells me this is vulnerable but idc it works
    ship_query = f"SELECT * FROM ships WHERE ship_id = '{ship_id}'"
    try:
        mycursor.execute(ship_query)
    except mariadb_error as e:
        print(f"MariaDB error: {e}")
        return {"error": f"MariaDB error: {e}"}
    else:
        return {"result": mycursor.fetchall()}