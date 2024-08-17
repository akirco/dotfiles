function pyc() {
    param(
        [Parameter(Mandatory = $false, Position = 0)][string]$name,
        [Parameter(Mandatory = $false, Position = 1)][string]$pyversion 
    )
    conda create -n $name python=$pyversion
}

# create venv
function pycv() {
    python -m venv .venv
}
# install package
function pyi() {
    param(
        [Parameter(Mandatory = $false, Position = 0)][string]$package
    )
    python -m pip install --use-pep517 $package
}

function pyir(){
    python -m pip freeze > requirements.txt
}

function pyifr(){
    python -m pip install -r requirements.txt
}