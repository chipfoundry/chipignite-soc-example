from caravel_cocotb.caravel_interfaces import test_configure, report_test
import cocotb

@cocotb.test()
@report_test
async def sram_test(dut):
  caravelEnv = await test_configure(dut, timeout_cycles=300000)

  cocotb.log.info(f"[TEST] Start sram_test")

  await caravelEnv.wait_mgmt_gpio(1)
  
  if caravelEnv.monitor_gpio(33, 32).integer == 0b10:
    cocotb.log.info(f"[TEST] PASS - SRAM test passed, gpio value is '{hex(caravelEnv.monitor_gpio(33, 32).integer)}'")
  elif caravelEnv.monitor_gpio(33, 32).integer == 0b01:
    cocotb.log.error(f"[TEST] FAIL - Error in reading memory value")
  else:
    cocotb.log.error(f"[TEST] FAIL - Unknown gpio value: '{bin(caravelEnv.monitor_gpio(33, 32).integer)}' expected {bin(0b10)} or {bin(0b01)}")
  
  cocotb.log.info(f"[TEST] End sram_test")
