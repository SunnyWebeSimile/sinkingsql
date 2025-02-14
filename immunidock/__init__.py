import docker
from os.path import dirname
from random import choices
from time import sleep


module_location = dirname(__file__)
sqlevalpass = ''.join(choices("1234567890qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM_-", k=32))
with open(module_location+"/sqlexec/accinit.sql", "w") as authinit:
    authinit.write(f"CREATE USER evaluator@'localhost' IDENTIFIED BY '{sqlevalpass}';\n")
with open(module_location+"/sqlexec/evaluator-client.cnf", "w") as mariadb_client_options:
    mariadb_client_options.writelines(line+"\n" for line in (
        "[client]",
        "host=localhost",
        "user=evaluator",
        f"password={sqlevalpass}",
        "protocol=SOCKET",
        "socket=/run/mariadb/mariadb.sock",
        "database=sinkingsql"
    ))



docker_client = docker.from_env()
try:
    existing_container = docker_client.containers.get("sql_eval_container1")
except docker.errors.NotFound:
    pass
else:
    existing_container.remove(force=True)
    del existing_container

print("Sleeping before detection of existing mariadb:lts-ubi image...")
sleep(2)
try:
    print(docker_client.images.get("mariadb:lts-ubi"))
except docker.errors.ImageNotFound:
    print("No mariadb:lts-ubi image; attempting to pull from repository")
    try:
        docker_client.images.pull("mariadb:lts-ubi")
    except docker.errors.APIError:
        print("Network failure; cannot get a mariadb:lts-ubi image")
        exit()

sql_eval_container = docker_client.containers.run("mariadb:lts-ubi", 
detach=True, network_disabled=True, auto_remove=True, volumes={
    module_location+"/sqlexec": {
        "bind": "/docker-entrypoint-initdb.d",
        "mode": "ro"}
    },
    environment={
        "MARIADB_RANDOM_ROOT_PASSWORD": 1,
    },
    name="sql_eval_container1")


print("Sleeping for immunidock initialisation")
while True:
    socket_existence = sql_eval_container.exec_run("ls /run/mariadb")
    if b"mariadb.sock\n" in socket_existence.output:
        sleep(4)
        break
    sleep(1)