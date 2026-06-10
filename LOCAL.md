# LOCAL

```sh
curl install.duckdb.org | bash

duckdb
```

```sql
INSTALL quack; LOAD quack;

CREATE SECRET (
    TYPE quack,
    TOKEN 'quacklake',
    SCOPE 'quack:localhost:9494'
);

ATTACH 'quack:localhost:9494' AS remote_db (TYPE quack);

from remote_db.query('use my_ducklake');

from remote_db.query('from test');
```
