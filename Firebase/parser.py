import json
import pathlib as pl
from datetime import datetime

def parse(file):
    osfile = pl.Path(file).resolve()
    with open(osfile) as json_file:
        return json.load(json_file)

def date(unix_time):
    return datetime.utcfromtimestamp(unix_time).strftime('%Y-%m-%d %H:%M:%S')