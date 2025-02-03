from . import sql_eval_container

def eval_query(ship_id: str):
    escaped_ship_id = ship_id.replace("\\", "\\\\").replace("'", "\\'")
    insert_result = sql_eval_container.exec_run("mariadb --defaults-file=/docker-entrypoint-initdb.d/evaluator-client.cnf --batch "
    f"--execute \"CALL insert_dangerous_ship_id('{escaped_ship_id}')\"")
    if insert_result.exit_code != 0:
        return False
    eval_result = sql_eval_container.exec_run("mariadb --defaults-file=/docker-entrypoint-initdb.d/evaluator-client.cnf --batch "
    f"--execute \"SELECT * FROM sinkingsql.ships WHERE ship_id = '{ship_id}';\"")  # Evaluate effects of possible injection
    delete_result = sql_eval_container.exec_run("mariadb --defaults-file=/docker-entrypoint-initdb.d/evaluator-client.cnf --batch "
    f"--execute \"CALL delete_dangerous_ship_id('{escaped_ship_id}')\"")
    return eval_result.exit_code == 0 and eval_result.output == (
        b'ship_id\tship_name\ttonnage\tcargo_type\tscheduled_arrival\tarrived\tarrival_datetime\tarrival_port\n'+
        bytes(escaped_ship_id, encoding="utf_8")+b'\tPotentially dangerous\t420\tNon-alphanumeric ship ID potentially used for SQL injection\t'
        b'9999-12-31 23:59:59\t1\t9999-12-31 23:59:59\tTuas\n'
    )

if __name__ == "__main__":
    print(eval_query("J5"))
    print(eval_query("' UNION SELECT table_schema, table_name, table_rows, create_time, update_time, check_time, table_comment, create_options FROM information_schema.tables WHERE '0'='0"))
