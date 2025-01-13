# sinkingsql

This is a Flask web application that serves as a front-end for a MariaDB database. It demonstrates a product of a school project this year; SQL query parameters received are first used in a simulated query of a dummy database within a Docker container, and its results compared to expected output to detect possible SQL injection.

I would name that technology `immunidock`, but it requires manual configuration of the dummy database according to the schema used in production, as well as stored procedures to insert and delete rows before and after evaluating query parameters. These statements should be in a SQL script at `immunidock/sqlexec`, with a name lexicographically larger than `accinit`; i.e. anything that starts with the letter *b*, or the letters *ad*, or the letters *acd*, or *accj* etc. 

The `dbinit.sql` here is themed after the Port of Singapore authority.

If I ever turn this into a module that can be applied to any MariaDB, or any SQL for that matter, for any production app, my past self will be very proud.