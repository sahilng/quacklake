# Local connection

Complete [REMOTE.md](REMOTE.md) first. Copy the token from the Linux host to your computer. Set `REMOTE` to your SSH destination and `REMOTE_DIR` to the repository's absolute path on that host:

```sh
REMOTE=user@example.com
REMOTE_DIR=/home/user/quacklake
mkdir -p "$HOME/.config/quacklake"
chmod 700 "$HOME/.config/quacklake"
scp "$REMOTE:$REMOTE_DIR/.secrets/quack_token" "$HOME/.config/quacklake/token"
chmod 600 "$HOME/.config/quacklake/token"
IFS= read -r QUACK_TOKEN < "$HOME/.config/quacklake/token"
export QUACK_TOKEN
```

In another local terminal, open an SSH tunnel and leave it running:

```sh
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

For a Codespace, replace the `scp` command above with this command after setting `CODESPACE` to its name:

```sh
CODESPACE=your-codespace-name
gh cs cp -e -c "$CODESPACE" \
    remote:/workspaces/quacklake/.secrets/quack_token \
    "$HOME/.config/quacklake/token"
```

Keep the `chmod`, `read`, and `export` commands above. Replace the SSH tunnel command with this private Codespaces port forward:

```sh
gh cs ports forward 9494:9494 -c "$CODESPACE"
```
