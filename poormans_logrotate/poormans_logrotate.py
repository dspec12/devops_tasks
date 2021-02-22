#!/usr/bin/python python3

import os
from pathlib import Path
from datetime import datetime
import tarfile

target_dir = "/var/log"


def main():
    """
    Was planning on using os.walk() and os.path.join() to cover string manipulation.
    Ended up using the new pathlib library, which made it dead simple.
    """
    p = Path(target_dir)

    for log in p.rglob("*.log"):
        # Check if file exists: https://stackoverflow.com/questions/237079/how-to-get-file-creation-modification-date-times-in-python
        assert log.exists()
        log_path = str(log.resolve())
        log_size = bytes_to_mb(log.stat().st_size)
        log_age = fileage_delta(log.stat().st_mtime)
        if log_size >= 300 or log_age >= 7:
            print(f"Rotating: {log_path}")
            rotate_log(log_path)

    for tar in p.rglob("*.tar.gz"):
        assert tar.exists()
        tar_path = str(tar.resolve())
        tar_age = fileage_delta(tar.stat().st_mtime)
        if tar_age >= 90:
            print(f"Removing: {tar_path}")
            os.remove(tar_path)


def rotate_log(log_path):
    date = datetime.today()
    date = date.strftime("%m-%d-%Y")
    # First time using the tarfile library: https://docs.python.org/3/library/tarfile.html
    tar = tarfile.open(log_path + "-" + str(date) + ".tar.gz", "w:gz")
    tar.add(log_path)
    tar.close()
    open(log_path, "w").close()


def bytes_to_mb(bytes):
    bytes = int(bytes)
    mbs = bytes / 1024 / 1024
    return int(mbs)


def fileage_delta(mtime):
    mtime = datetime.fromtimestamp(mtime)
    today = datetime.today()
    delta = today - mtime
    return delta.days


if __name__ == "__main__":
    main()
