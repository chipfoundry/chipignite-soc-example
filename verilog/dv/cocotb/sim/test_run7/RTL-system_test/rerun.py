
import os
import shutil
import argparse

parser = argparse.ArgumentParser(description="Run cocotb tests")
parser.add_argument("-extend", help="extend the command")
args = parser.parse_args()

os.environ["CARAVEL_ROOT"] = "/nc/templates/caravel"
os.environ["MCW_ROOT"] = "/nc/templates/mgmt_core_wrapper"

os.chdir("/workspace/peripheral-example/verilog/dv/cocotb")

command = "python3 /usr/local/bin/caravel_cocotb -test system_test -tag test_run7/RTL-system_test/rerun   -sim RTL -corner nom-t  -seed 1761598289 "
if args.extend is not None:
    command += f" {args.extend}"
os.system(command)

shutil.copyfile("/workspace/peripheral-example/verilog/dv/cocotb/sim/test_run7/RTL-system_test/rerun.py", "/workspace/peripheral-example/verilog/dv/cocotb/sim/test_run7/RTL-system_test/rerun/RTL-system_test/rerun.py")
