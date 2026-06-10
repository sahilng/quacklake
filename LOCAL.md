-- LOCAL

curl install.duckdb.org | bash

duckdb

CREATE SECRET (
    TYPE quack,
    TOKEN '8C429BEEB58E83ADBD3F575C433650A5',
    SCOPE 'quack:localhost:9494'
);

ATTACH 'quack:localhost:9494' AS remote_db (TYPE quack);

from remote_db.query('use my_ducklake');

from remote_db.query('from test');
