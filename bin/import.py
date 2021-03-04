#! /usr/bin/env python

import os
import argparse as ap
import os.path as path
import subprocess as sub

from shlex import split
from glob import iglob

home = path.expanduser("~")


def next_img_idx(imgs):
    if len(imgs) == 0:
        last = 0
    else:
        num = path.splitext(path.basename(imgs[-1]))[0].split("_")[1]
        
        if num == "000":
            num = 0
        else:
            num = int(num.lstrip("0"))

        last = int(num) + 1

    return last


def select(out):
    return "import %s" % out


def screen(out):
    return (
        "import -window root -colorspace RGB -quality 120 %s"
        % out
    )


cmds = {
    "select": select,
    "screen": screen,
}


def main():
    cmd = ap.ArgumentParser()

    cmd.add_argument(
        "mode", choices=frozenset(cmds.keys())
    )

    args = cmd.parse_args()

    root = path.join(home, "screencaps")
    os.makedirs(root, exist_ok=True)

    imgs = sorted(
        iglob(path.join(root, "img_*.png"))
    )

    last = next_img_idx(imgs)
    out = path.join(root, "img_{:0>3d}.png".format(last))

    cmd = cmds[args.mode](out)
    sub.check_output(split(cmd))


if __name__ == "__main__":
    main()

