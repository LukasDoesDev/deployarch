import yaml, json

def get_config():
    with open('./config.yaml', 'r') as f:
        try:
            return yaml.safe_load(f)
        except yaml.YAMLError as exc:
            print(exc)
            import sys
            sys.exit(1)

import subprocess

def run_cmds(array):
    return subprocess.run('\n'.join(array),shell=True, check=True,executable='/bin/bash')

from subprocess import Popen, PIPE
from collections import namedtuple
from typing import Iterable, Optional, List
import sys

Result = namedtuple("Result", ["index", "output"])
ENC = sys.getdefaultencoding()


def fzf(
    iterable: Iterable,
    options: Optional[str] = None,
) -> List[Result]:
    cmd = ["fzf", "--with-nth=2.."]
    if options:
        cmd += options.split(" ")

    proc = Popen(cmd, stdin=PIPE, stdout=PIPE, stderr=None)
    stdin = proc.stdin
    stdout = proc.stdout

    for i, el in enumerate(iterable):
        line = f"{i} {el}"
        stdin.write(line.encode(ENC) + b"\n")

    stdin.flush()
    stdin.close()
    proc.wait()

    results = []
    for ln in stdout.readlines():
        sel = str(ln.strip(), encoding=ENC).split(" ", 1)
        results.append(Result(int(sel[0]), sel[1]))

    return results

def select_packages(packages_raw):
    packages_selected_names = list(map(
        lambda n: n.output,
        fzf(
            map(
                lambda p: p["name"],
                packages_raw
            ),
            '--multi'
        )
    ))
    return list(filter(lambda p: p["name"] in packages_selected_names, packages_raw))
