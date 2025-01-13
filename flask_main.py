from flask import Flask, request, render_template
import mariadb
from getpass import getpass
from instance.sqlquery import get_ship_info
from ship_form import ShipIDForm
from os import urandom
from json import dumps
from datetime import datetime
from immunidock import eval_query


app = Flask(__name__)


def stringify(obj):
    if isinstance(obj, datetime):
        return obj.isoformat()
    try:
        return str(obj)
    except TypeError:
        raise TypeError(f"Object of type {type(obj)} is not JSON serializable")


@app.route("/")
def rootpath():
    return app.redirect("/index.html")


@app.route("/index.html")
def index_page():
    return render_template("/index.html", form=ShipIDForm())


@app.route("/api/shipinfo", methods=["GET", "POST"])
def ship_info_api():
    ship_id_queried = request.args.get("ship_id")
    if ship_id_queried is None:
        ship_id_queried = request.form.get("ship_id")
    print("Queried ship ID:", ship_id_queried)
    if ship_id_queried is not None:
        if str(ship_id_queried).isalnum() or eval_query.eval_query(ship_id_queried):
            ret_data = get_ship_info(ship_id_queried)
            print(ret_data)
            if ret_data.get("error") is None:
                return dumps(ret_data, default=stringify), 200
            else:
                return dumps(ret_data), 404
        else:
            print("Attempted attack on shipping database detected; report to authorities")
            return "{\"error\": \"Invalid ship ID\"}", 500
    else:
        return "{\"error\": \"Missing ship ID\"}", 400


"""# Debug code
print("Hello World!")
try:
   conn = mariadb.connect(
      host= "localhost",
      port=3306,
      user="root",
      password=getpass("Enter database user password: "))
except mariadb.Error as e:
   print(f"Error connecting to the database: {e}")
   sys.exit(1)
"""


app.config["SECRET_KEY"] = urandom(32)
app.run(host="0.0.0.0")