# QuackLake

This example serves one DuckLake from DuckDB 2.0 with Quack. Run it directly on a Linux host, or use the optional Docker setup. Quack listens on the remote host's `127.0.0.1:9494` and requires a token.

```text
local DuckDB -> localhost:9494 -> SSH tunnel -> remote 127.0.0.1:9494
                                                   |
                                              DuckDB + Quack
                                                   |
                                               my_ducklake
```

1. Follow [REMOTE.md](REMOTE.md) to configure `.env` and start Quack on a Linux host.
2. Follow [LOCAL.md](LOCAL.md) to set the same token in your local `.env`, open the tunnel, and query the DuckLake.

By default, both run modes store the DuckLake catalog and data in the repository's ignored `data/` directory. On the remote host, set `CATALOG_SERVER` to a DuckDB catalog file or a PostgreSQL connection string, and `DATA_PATH` to a local directory or an S3 URI. [`.env.example`](.env.example) shows the default values. Each machine reads its token from its own gitignored `.env`. Anyone with the token and access to the Quack port can execute SQL in the remote DuckDB session; keep the token private.

GitHub Codespaces can be used as the Linux host. Both guides include optional `gh cs` commands.
