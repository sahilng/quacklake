FROM duckdb/duckdb:2.0.0 AS duckdb_cli

FROM python:3.12-slim-bookworm

RUN useradd --create-home --uid 10001 quacklake \
    && mkdir -p /app/data \
    && chown -R quacklake:quacklake /app

COPY --from=duckdb_cli /duckdb /usr/local/bin/duckdb

USER quacklake
ENV HOME=/home/quacklake
WORKDIR /app

RUN duckdb :memory: -c "INSTALL ducklake; INSTALL httpfs; INSTALL postgres; INSTALL quack;"

COPY server.py /app/server.py
COPY init.sql /app/init.sql

CMD ["python", "/app/server.py"]
