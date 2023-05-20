import os
import sys

LOCALAPPDATA = os.getenv("LOCALAPPDATA")
BOOKMARK_DIR = LOCALAPPDATA + "\\lf\\lf_scripts\\bookmarks"


def bookmark(path, name):
    path = os.path.dirname(path)

    with open(os.path.join(BOOKMARK_DIR, name), "w") as f:
        f.write(path)


if __name__ == "__main__":
    bookmark(sys.argv[1], sys.argv[2])
