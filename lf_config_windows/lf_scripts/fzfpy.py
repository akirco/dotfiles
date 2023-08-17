import os
import sys
import subprocess

LOCALAPPDATA = os.getenv("LOCALAPPDATA")

if __name__ == "__main__":
    output = subprocess.run(
        [LOCALAPPDATA + "\\lf\\lf_scripts\\findfzf.bat"], capture_output=True
    )
    selected = output.stdout.decode("utf8").split("\n")[-2]

    command = "cd"
    if not os.path.isdir(selected):
        command = "select"

    # check if path is a file
    subprocess.run(
        [
            "lf",
            "-remote",
            'send {id} {command} "{selected}"'.format(
                id=sys.argv[1], selected=selected, command=command
            ),
        ]
    )
