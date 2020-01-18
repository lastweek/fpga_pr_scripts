# Vivado Partial Reconfiguration Script Template

Jan 17, 2020  Yizhou Shan <syzwhat@gmail.com>

The scripts are adopted from Xilinx open-source scripts.
I made few changes for my own research needs.
The scripts will make the PR flow super easy.
It can also be used for non-PR flow.

Everything is script-based here, which is useful if you are using remote servers.
It is also faster. However, you can always open GUI within vivado shell.

A nice thing is that all vivado commands will be saved to log files,
thus you can learn and mimic the general build flow.

The whole thing is like vivado-build framework,
where you express your needs in the top `run_vivado.sh` file.
The majority of the magic happens within `scripts/*` files.
Happy hacking!

## Run

Check the Makefile and bash script first.

You can do `make`, `make clean`.

I have tested with 2019.1, should work on other versions.
