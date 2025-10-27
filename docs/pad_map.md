# Pad Map

## Overview

This document defines the GPIO pad assignments for all peripherals in the user project. The Caravel chip provides 38 user GPIO pins (`mprj_io[37:0]`), with `mprj_io[4:0]` reserved by Caravel.

**Important**: Pads 0-4 are reserved by Caravel and must not be used by the user project.

## GPIO Allocation Summary

| GPIO Range  | Peripheral | Signals                | Count |
|-------------|------------|------------------------|-------|
| mprj_io[5]  | UART       | TX (Transmit)          | 1     |
| mprj_io[6]  | UART       | RX (Receive)           | 1     |
| mprj_io[7]  | PWM        | PWM Output             | 1     |
| mprj_io[8]  | Reserved   | Future use             | 1     |
| mprj_io[37:9] | Unused   | Available for expansion| 29    |

**Total Used**: 3 pins  
**Total Available**: 33 pins (mprj_io[37:5])

## Detailed Pin Assignments

### UART (CF_UART) - GPIO 5-6

| GPIO      | Signal Name | Direction | Type      | Description                    |
|-----------|-------------|-----------|-----------|--------------------------------|
| mprj_io[5]| uart_tx     | Output    | Push-Pull | UART transmit data             |
| mprj_io[6]| uart_rx     | Input     | Input     | UART receive data              |

**Configuration**:
- **uart_tx (mprj_io[5])**:
  - `io_oeb[5] = 0` (output enable)
  - `io_out[5]` = UART TX data
  - Mode: Push-pull output
  
- **uart_rx (mprj_io[6])**:
  - `io_oeb[6] = 1` (input enable)
  - `io_in[6]` = UART RX data
  - Mode: Input

**Important**: TX and RX must be on different GPIO pins. Never use the same pin for both.

---

### PWM (CF_TMR32) - GPIO 7

| GPIO      | Signal Name | Direction | Type      | Description                    |
|-----------|-------------|-----------|-----------|--------------------------------|
| mprj_io[7]| pwm_out     | Output    | Push-Pull | PWM output signal              |

**Configuration**:
- **pwm_out (mprj_io[7])**:
  - `io_oeb[7] = 0` (output enable)
  - `io_out[7]` = PWM output
  - Mode: Push-pull output

---

### SRAM (CF_SRAM_1024x32) - No External Pins

The SRAM is entirely internal and requires no external GPIO pins. All access is through the Wishbone bus interface.

---

## GPIO Configuration in user_project_wrapper

The `user_project_wrapper.v` module connects user_project signals to Caravel's `mprj_io[]` pads:

```verilog
// UART connections
assign io_out[5] = uart_tx;     // UART TX output
assign uart_rx = io_in[6];      // UART RX input
assign io_oeb[5] = 1'b0;        // TX is output
assign io_oeb[6] = 1'b1;        // RX is input

// PWM connection
assign io_out[7] = pwm_out;     // PWM output
assign io_oeb[7] = 1'b0;        // PWM is output

// Unused pins - set to safe defaults
assign io_out[37:8] = 30'b0;    // Drive unused outputs low
assign io_oeb[37:8] = 30'b1;    // Set unused as inputs (high-Z)
```

## Pad Modes

Caravel GPIOs support multiple modes configured through the management SoC:

1. **Input Mode**: `io_oeb = 1`, pin is input, reads from `io_in`
2. **Output Mode**: `io_oeb = 0`, pin is output, drives `io_out`
3. **Bidirectional**: Dynamic control of `io_oeb` for both input and output

### Push-Pull vs Open-Drain

- **Push-Pull** (default): Used for standard digital outputs (UART TX, PWM)
  - Drives both high and low actively
  - Set `io_oeb = 0` and control `io_out`

- **Open-Drain**: Used for I²C and similar protocols
  - Drive low or release (high-Z)
  - Drive 0: `io_oeb = 0`, `io_out = 0`
  - Release: `io_oeb = 1`
  - Requires external pull-up resistor

**This project uses push-pull mode for all outputs.**

---

## Changing Pin Assignments

To modify the default pin assignments:

1. **Update this document** (`docs/pad_map.md`) with new assignments
2. **Update user_project_wrapper.v**:
   - Modify the `io_out[]`, `io_in[]`, `io_oeb[]` assignments
3. **Update firmware** (`fw/` directory):
   - Change GPIO configuration code
   - Update `GPIO_MODE_*` settings if needed
4. **Update verification tests** (`verilog/dv/cocotb/`):
   - Modify pin monitoring in Python tests
   - Update expected pin states

### Example: Moving UART TX from GPIO 5 to GPIO 10

**In user_project_wrapper.v**:
```verilog
// Old:
// assign io_out[5] = uart_tx;
// assign io_oeb[5] = 1'b0;

// New:
assign io_out[10] = uart_tx;
assign io_oeb[10] = 1'b0;
```

**In firmware**:
Update GPIO mode configuration for pin 10 instead of pin 5.

---

## Reserved and Restricted Pins

### Caravel Reserved Pins (Do Not Use)
- `mprj_io[0]` - JTAG or user flash CSB
- `mprj_io[1]` - SDO (serial data out)  
- `mprj_io[2]` - SDI (serial data in)
- `mprj_io[3]` - CSB (chip select)
- `mprj_io[4]` - SCK (serial clock)

### Available for User Project
- `mprj_io[37:5]` - 33 pins available

---

## Analog Pads

Caravel also provides analog pads `analog_io[28:0]` for analog signals. This project does not use analog pads as all peripherals are digital.

If analog functionality is needed in the future:
- Use `analog_io[]` for true analog signals
- Configure appropriate analog mode
- Ensure proper ESD protection

---

## Testing Pin Assignments

During verification, the cocotb tests will:
1. Configure GPIO modes through the management SoC
2. Monitor pin states using `caravelEnv.monitor_gpio()`
3. Drive input pins and read output pins
4. Verify correct signal routing

See `verilog/dv/cocotb/` for test implementations.

---

## References

- [Caravel Pinout Documentation](https://caravel-harness.readthedocs.io/en/latest/pinout.html)
- [Caravel GPIO Configuration](https://caravel-harness.readthedocs.io/en/latest/gpio.html)
- User Project Wrapper: `verilog/rtl/user_project_wrapper.v`

---

**Last Updated**: 2025-10-27
