function pyc() {
    param(
        [Parameter(Mandatory = $false, Position = 0)][string]$name,
        [Parameter(Mandatory = $false, Position = 1)][string]$pyversion 
    )
    conda create -n $name python=$pyversion
}