from caravel_cocotb.caravel_interfaces import test_configure, report_test
import cocotb
from cocotb.triggers import ClockCycles

@cocotb.test()
@report_test
async def pwm_test(dut):
  caravelEnv = await test_configure(dut, timeout_cycles=500000)

  cocotb.log.info("[TEST] Starting pwm_test")

  await caravelEnv.release_csb()
  await caravelEnv.wait_mgmt_gpio(1)

  cocotb.log.info("[TEST] Firmware configuration complete")

  await ClockCycles(caravelEnv.clk, 10000)

  pwm_high = 0
  pwm_low = 0

  for i in range(4000):
    await ClockCycles(caravelEnv.clk, 1)

    pwm_val = caravelEnv.monitor_gpio(7, 7).integer

    if pwm_val == 1:
      pwm_high += 1
    else:
      pwm_low += 1

  duty = (pwm_high / (pwm_high + pwm_low)) * 100

  cocotb.log.info(f"[TEST] PWM: {pwm_high} high, {pwm_low} low, duty={duty:.2f}%")

  if pwm_high > 100 and pwm_low > 100:
    cocotb.log.info("[TEST] PWM is toggling - PASS")
  else:
    cocotb.log.error("[TEST] PWM is NOT toggling - FAIL")

  cocotb.log.info("[TEST] pwm_test complete")
