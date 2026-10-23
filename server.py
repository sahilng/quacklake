import os
import re
import signal
import socket
import subprocess
import time


token = os.environ.get("QUACK_TOKEN", "")
if not re.fullmatch(r"[0-9a-f]{64}", token):
    raise ValueError("QUACK_TOKEN must contain 64 lowercase hexadecimal characters")

db = subprocess.Popen(
    ["duckdb", ":memory:", "-init", "init.sql", "-bail"],
    stdin=subprocess.PIPE,
)

for _ in range(120):
    if db.poll() is not None:
        raise SystemExit(db.returncode)
    try:
        with socket.create_connection(("127.0.0.1", 9494), timeout=0.25):
            break
    except OSError:
        time.sleep(0.5)
else:
    raise TimeoutError("Quack did not start within 60 seconds")


def stop(_signum, _frame):
    if db.poll() is None:
        db.terminate()
    db.wait(timeout=10)
    raise SystemExit(0)


signal.signal(signal.SIGTERM, stop)
signal.signal(signal.SIGINT, stop)

raise SystemExit(db.wait())
