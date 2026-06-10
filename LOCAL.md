# LOCAL

Forward remote port 9494 to local, for example if the remote is a GitHub Codespace:
```sh
gh cs ports forward 9494:9494
```

Then:
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
