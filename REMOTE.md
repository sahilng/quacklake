# Remote setup

Use a Linux host with Python 3 and SSH access. Clone this repository on the host and enter its directory:

```sh
git clone https://github.com/sahilng/quacklake.git
cd quacklake
```

Prepare the DuckLake data directory and a private `.env` file:

```sh
mkdir -p data/first
if [ ! -e .env ]; then cp .env.example .env; fi
chmod 600 .env
```

Edit `.env` and replace the example value with your 64-character lowercase hexadecimal token. Give local clients this same token through a secure channel. `.env` is excluded from Git.

Install DuckDB 2.0.0 and its required extensions, then start the server from the repository directory:

```sh
curl -fsSL https://install.duckdb.org | DUCKDB_VERSION=2.0.0 bash
export PATH="$HOME/.duckdb/cli/2.0.0:$PATH"
duckdb :memory: -c "INSTALL ducklake; INSTALL httpfs; INSTALL quack;"
set -a
. ./.env
set +a
python3 server.py
```

Leave the process running while connecting from [LOCAL.md](LOCAL.md). [init.sql](init.sql) attaches `my_ducklake`, creates a test table with value `42`, and starts token-authenticated Quack on `127.0.0.1:9494`. `server.py` reads the exported `QUACK_TOKEN` and keeps the DuckDB session alive. The server must be started from this repository directory so the relative paths in `init.sql` resolve to `data/`.

## Optional Docker setup

On a Linux host with Docker, use the same `.env` and data directory setup above, then run this from the repository directory instead of installing DuckDB or starting `server.py` on the host:

```sh
docker build -t quacklake:local .
docker run -d --name quacklake --restart unless-stopped \
    --network host \
    --user "$(id -u):$(id -g)" \
    --mount "type=bind,source=$PWD/data,target=/app/data" \
    --env-file .env \
    quacklake:local
docker logs quacklake
```

The image pins DuckDB 2.0.0 and installs the extensions. The container runs as your host user so it can write to `data/`. Docker reads `QUACK_TOKEN` from `.env` without copying the file into the image. It uses the same [init.sql](init.sql) and data directory as the direct process. Linux host networking lets Quack bind the host's `127.0.0.1:9494`. Run either the host process or the container at a time because both use port `9494`. Use `docker stop quacklake` and `docker start quacklake` to switch it off and on.

## GitHub Codespaces option

Create a Codespace from your local checkout, then enter it:

```sh
gh cs create -R sahilng/quacklake -b main -m basicLinux32gb --default-permissions
CODESPACE=your-codespace-name
gh cs ssh -c "$CODESPACE"
```

Inside the Codespace, enter `/workspaces/quacklake` and follow either setup above. Keep Codespace port `9494` private. [LOCAL.md](LOCAL.md) shows the corresponding port forwarding command. GitHub's [private port tunnel](https://docs.github.com/en/codespaces/reference/security-in-github-codespaces) encrypts the connection and requires Codespaces authentication.
