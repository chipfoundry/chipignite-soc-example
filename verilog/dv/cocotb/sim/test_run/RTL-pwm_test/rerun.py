
import os
import shutil
import argparse

parser = argparse.ArgumentParser(description="Run cocotb tests")
parser.add_argument("-extend", help="extend the command")
args = parser.parse_args()

os.environ["CARAVEL_ROOT"] = "/nc/templates/caravel"
os.environ["MCW_ROOT"] = "/nc/templates/mgmt_core_wrapper"

os.chdir("/workspace/peripheral-example/verilog/dv/cocotb")

command = "python3 /usr/local/bin/caravel_cocotb -test pwm_test -tag test_run/RTL-pwm_test/rerun   -sim RTL -corner nom-t "
if args.extend is not None:
    command += f" {args.extend}"
os.system(command)

shutil.copyfile("/workspace/peripheral-example/verilog/dv/cocotb/sim/test_run/RTL-pwm_test/rerun.py", "/workspace/peripheral-example/verilog/dv/cocotb/sim/test_run/RTL-pwm_test/rerun/RTL-pwm_test/rerun.py")
