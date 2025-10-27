from caravel_cocotb.caravel_interfaces import test_configure, report_test, UART
import cocotb

@cocotb.test()
@report_test
async def uart_test(dut):
  caravelEnv = await test_configure(dut, timeout_cycles=200000)

  await caravelEnv.release_csb()
  await caravelEnv.wait_mgmt_gpio(1)

  uart_pins = {"tx": 5, "rx": 6}
  uart = UART(caravelEnv, uart_pins)

  uart.baud_rate = 115200

  cocotb.log.info(f"[TEST] Start uart_test")

  msg = await uart.get_line()
  cocotb.log.info(f"[TEST] Received message: '{msg}'")

  expected_msg = "Hello UART"
  if expected_msg in msg:
    cocotb.log.info(f"[TEST] PASS - Received expected message: '{msg}'")
  else:
    cocotb.log.error(f"[TEST] FAIL - Expected '{expected_msg}', got '{msg}'")

  cocotb.log.info(f"[TEST] End uart_test")
