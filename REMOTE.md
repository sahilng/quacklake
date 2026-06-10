-- REMOTE

curl install.duckdb.org | bash

duckdb

INSTALL ducklake; LOAD ducklake;

ATTACH 'ducklake:metadata.ducklake'
    AS my_ducklake
    (DATA_PATH 'data/');

INSTALL quack;
LOAD quack;

call quack_serve('quack:localhost', token:='quacklake');

create table my_ducklake.main.test as select 42 as value;

CALL ducklake_flush_inlined_data('my_ducklake');

-- gh cs ports forward 9494:9494
