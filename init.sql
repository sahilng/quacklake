LOAD ducklake;
LOAD httpfs;
LOAD quack;

ATTACH 'ducklake:' || getenv('CATALOG_SERVER') AS my_ducklake
    (DATA_PATH getenv('DATA_PATH'));

CREATE TABLE IF NOT EXISTS my_ducklake.main.test AS SELECT 42 AS value;

SELECT count(*) AS servers
FROM quack_serve('quack:127.0.0.1', token = getenv('QUACK_TOKEN'));
