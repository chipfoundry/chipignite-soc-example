# Verification Plan for Peripheral Integration Project

## Overview
This document outlines the verification strategy for the Caravel user project integrating:
- **PWM peripheral** (CF_TMR32 configured for PWM mode)
- **UART peripheral** (CF_UART with TX/RX)
- **SRAM peripheral** (CF_SRAM_1024x32 - 4KB memory with WB controller)

**Target Frequency**: 40 MHz (25 ns clock period)

## Verification Strategy

### Approach
We will use a **firmware-driven** verification methodology where:
1. C firmware running on the management SoC configures and exercises each peripheral
2. Python cocotb testbenches verify the expected behavior by monitoring GPIOs and internal signals
3. Each peripheral gets an individual test + a system integration test

### Test Structure
Each test follows this pattern:
1. **Configuration Phase**: Firmware configures GPIOs and enables user interface
2. **Signal Ready**: Firmware signals `ManagmentGpio_write(1)` when ready
3. **Stimulus/Exercise**: Firmware writes to peripheral registers via Wishbone
4. **Verification**: Python testbench checks outputs (GPIO pins, waveforms)

## Address Map Verification
| Peripheral | Base Address  | Size  | Offset Bits |
|------------|---------------|-------|-------------|
| PWM        | 0x3000_0000   | 64 KB | [19:16]=0   |
| UART       | 0x3001_0000   | 64 KB | [19:16]=1   |
| SRAM       | 0x3002_0000   | 64 KB | [19:16]=2   |

## GPIO Pin Assignments
| Pin      | Function  | Direction | Config Mode                    |
|----------|-----------|-----------|--------------------------------|
| io[5]    | UART TX   | Output    | GPIO_MODE_USER_STD_OUTPUT      |
| io[6]    | UART RX   | Input     | GPIO_MODE_USER_STD_INPUT_PULLUP|
| io[7]    | PWM OUT   | Output    | GPIO_MODE_USER_STD_OUTPUT      |

## Test Plan

### Test 1: PWM Basic Test (`pwm_test`)
**Objective**: Verify PWM peripheral integration and GPIO connectivity

**Test Steps**:
1. Configure GPIO[7] as user output (PWM output)
2. Enable user Wishbone interface
3. Configure CF_TMR32 in PWM mode:
   - Set prescaler for visible frequency
   - Set PWM duty cycle (e.g., 50%)
   - Enable PWM output on pwm0
4. Verify GPIO[7] toggles with expected duty cycle

**Success Criteria**:
- PWM signal observed on GPIO[7]
- Duty cycle within 5% of expected value
- No bus errors or timeouts

**IP Verification Requirements**: Will trigger `wakeup_tmr32_verification` microagent

### Test 2: UART Basic Test (`uart_test`)
**Objective**: Verify UART peripheral integration and communication

**Test Steps**:
1. Configure GPIO[5] as UART TX (output), GPIO[6] as UART RX (input)
2. Enable user Wishbone interface
3. Configure CF_UART:
   - Set baud rate (115200)
   - Enable TX and RX
   - Configure FIFO thresholds
4. Transmit "Hello UART\n" message
5. Python testbench receives and verifies message

**Success Criteria**:
- Correct baud rate achieved
- Message transmitted successfully
- No framing or parity errors

**IP Verification Requirements**: Will trigger `wakeup_uart_verification` microagent

### Test 3: SRAM Basic Test (`sram_test`)
**Objective**: Verify SRAM peripheral integration and memory operations

**Test Steps**:
1. Enable user Wishbone interface
2. Write test patterns to SRAM at various addresses:
   - Sequential addresses: 0x0000, 0x0004, 0x0008, etc.
   - Test patterns: 0xDEADBEEF, 0xCAFEBABE, 0x12345678, etc.
3. Read back and verify all written data
4. Test address boundaries (first and last word)

**Success Criteria**:
- All write operations complete without errors
- All read operations return correct data
- No data corruption
- Address decode working correctly

**IP Verification Requirements**: Will trigger `wakeup_sram_verification` microagent

**Note**: CF_SRAM_1024x32 does not have a pre-packaged firmware driver, so we will create a custom firmware driver for this test.

### Test 4: System Integration Test (`system_test`)
**Objective**: Verify all three peripherals working together

**Test Steps**:
1. Configure all GPIOs for all peripherals
2. Enable user Wishbone interface
3. **SRAM Exercise**:
   - Write/read test pattern to SRAM
   - Verify data integrity
4. **UART Exercise**:
   - Configure UART
   - Send identification message
   - Verify transmission
5. **PWM Exercise**:
   - Configure PWM
   - Enable PWM output
   - Verify signal on GPIO[7]

**Success Criteria**:
- All peripherals operate without interference
- No bus contention or conflicts
- All individual peripheral tests pass in sequence

## Coverage Goals

### Functional Coverage
- [ ] Wishbone address decoder (all 3 peripherals selected)
- [ ] Wishbone read/write cycles
- [ ] Wishbone ACK generation
- [ ] Invalid address handling (return 0xDEADBEEF)
- [ ] IRQ generation (PWM and UART)
- [ ] GPIO configuration and connectivity
- [ ] All peripheral registers accessible

### Code Coverage
- RTL simulation will exercise:
  - All address decode paths
  - All peripheral instantiations
  - Response multiplexer logic
  - Power pin connections

## Test Execution Plan

### Phase 1: Individual Peripheral Tests
1. Run `pwm_test` - verify PWM integration
2. Run `uart_test` - verify UART integration
3. Run `sram_test` - verify SRAM integration

### Phase 2: System Integration
4. Run `system_test` - verify all peripherals together

### Phase 3: Regression
- Re-run all tests to ensure stability
- Archive waveforms and logs

## Success Metrics
- **Pass Rate**: 100% of all tests must pass
- **Timeout Rate**: 0% - no test timeouts
- **Coverage**: All address decode paths exercised, all peripherals accessed
- **Simulation Time**: Each test should complete within 5 minutes

## Known Issues & Mitigations
1. **Long simulation times**: Use timeout parameter in `test_configure()` with appropriate cycles
2. **SRAM hard macro**: Ensure proper power pin connections (`vccd1/vssd1`)
3. **Clock gating**: Disabled per project requirements

## Verification Environment
- **Framework**: Caravel-Cocotb
- **Simulator**: Icarus Verilog
- **Clock**: 40 MHz (25 ns period)
- **Timeout**: Per-test basis, typically 1M cycles
- **Waveforms**: VCD format for debugging

## Post-Verification Checklist
- [ ] All tests pass
- [ ] Waveforms reviewed
- [ ] Coverage goals met
- [ ] No warnings in simulation logs
- [ ] Verification report generated
- [ ] Handoff document prepared
