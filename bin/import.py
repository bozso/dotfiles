#! /usr/bin/env python

import os
import os.path as path
import subprocess as sub

from shlex import split
from glob import iglob

home = path.expanduser("~")

def main():
    root = path.join(home, "screencaps")
    os.makedirs(root, exist_ok=True)
    
    imgs = sorted(
        iglob(path.join(root, "img_*.png"))
    )
    
    if len(imgs) == 0:
        last = 0
    else:
        num = path.splitext(path.basename(imgs[-1]))[0].split("_")[1]
        
        if num == "000":
            num = 0
        else:
            num = int(num.lstrip("0"))

        last = int(num) + 1
    
    new = path.join(root, "img_{:0>3d}.png".format(last))
    sub.check_output(split("import %s" % new))
    
if __name__ == "__main__":
    main()

