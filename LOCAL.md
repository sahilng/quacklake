# Local connection

Complete [REMOTE.md](REMOTE.md) first. Put the same token used by the remote server in this checkout's `.env` file. You can use the token you chose or one provided by the server operator:

```sh
if [ ! -e .env ]; then cp .env.example .env; fi
chmod 600 .env
```

Edit `.env` and replace the example value with the token. Then export it for the DuckDB CLI:

```sh
set -a
. ./.env
set +a
```

Set `REMOTE` to your SSH destination. In another local terminal, open an SSH tunnel and leave it running:

```sh
REMOTE=user@example.com
ssh -N -L 127.0.0.1:9494:127.0.0.1:9494 "$REMOTE"
```

Install the same DuckDB version as the remote server and start the CLI:

```sh
curl -fsSL https://install.duckdb.org | DUCKDB_VERSION=2.0.0 bash
~/.duckdb/cli/2.0.0/duckdb
```

Connect to the remote session and query the DuckLake. The secret reads the token from `QUACK_TOKEN` without embedding it in the SQL text.

```sql
LOAD quack;

CREATE SECRET (
    TYPE quack,
    TOKEN getenv('QUACK_TOKEN'),
    SCOPE 'quack:localhost:9494'
);

CONNECT 'quack:localhost:9494';

USE my_ducklake;
FROM test;  -- 42

DISCONNECT;
```

`CONNECT` routes the local session to the remote DuckDB session, and `USE my_ducklake` selects its DuckLake catalog. See [DuckDB's `CONNECT` documentation](https://duckdb.org/docs/2.0/sql/statements/connect).

## GitHub Codespaces option

For a Codespace, set `CODESPACE` to its name and use this private port forward instead of the SSH tunnel:

```sh
CODESPACE=your-codespace-name
gh cs ports forward 9494:9494 -c "$CODESPACE"
```
