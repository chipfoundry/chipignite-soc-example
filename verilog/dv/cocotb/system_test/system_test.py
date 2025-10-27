from caravel_cocotb.caravel_interfaces import test_configure, report_test, UART
import cocotb
from cocotb.triggers import ClockCycles

@cocotb.test()
@report_test
async def system_test(dut):
  caravelEnv = await test_configure(dut, timeout_cycles=300000)

  cocotb.log.info("[TEST] Starting system_test")

  await caravelEnv.release_csb()
  await caravelEnv.wait_mgmt_gpio(1)

  cocotb.log.info("[TEST] Firmware configuration complete")

  await caravelEnv.wait_mgmt_gpio(0)
  
  sram_result = caravelEnv.monitor_gpio(33, 32).integer
  if sram_result == 0b10:
    cocotb.log.info("[TEST] SRAM test PASSED")
  else:
    cocotb.log.error(f"[TEST] SRAM test FAILED with code {bin(sram_result)}")
  
  uart_pins = {"tx": 5, "rx": 6}
  uart = UART(caravelEnv, uart_pins)
  uart.baud_rate = 115200
  
  msg = await uart.get_line()
  cocotb.log.info(f"[TEST] UART received: '{msg}'")
  
  if "SYS" in msg:
    cocotb.log.info("[TEST] UART test PASSED")
  else:
    cocotb.log.error(f"[TEST] UART test FAILED - Expected 'SYS', got '{msg}'")
  
  await caravelEnv.wait_mgmt_gpio(1)
  
  await ClockCycles(caravelEnv.clk, 5000)
  
  pwm_high = 0
  pwm_low = 0
  
  for i in range(2000):
    await ClockCycles(caravelEnv.clk, 1)
    pwm_val = caravelEnv.monitor_gpio(7, 7).integer
    if pwm_val == 1:
      pwm_high += 1
    else:
      pwm_low += 1
  
  if pwm_high > 50 and pwm_low > 50:
    cocotb.log.info(f"[TEST] PWM test PASSED (high:{pwm_high}, low:{pwm_low})")
  else:
    cocotb.log.error(f"[TEST] PWM test FAILED (high:{pwm_high}, low:{pwm_low})")
  
  cocotb.log.info("[TEST] system_test complete")
