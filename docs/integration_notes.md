# Integration Notes

## Overview

This document provides detailed integration information for the Caravel user project with PWM, UART, and SRAM peripherals. It covers clock/reset architecture, bus timing, interrupt handling, verification procedures, and synthesis/PnR guidelines.

---

## Clock and Reset Architecture

### Clock Domain

**Single Clock Domain Design**

This design uses a single clock domain to avoid clock domain crossing (CDC) complexity:

- **Clock Source**: `wb_clk_i` from Caravel (Wishbone clock)
- **Clock Period**: 25 ns (40 MHz target frequency)
- **All Logic**: Synchronous to `wb_clk_i`

No clock gating or derived clocks are implemented. All peripherals operate on the same clock.

### Reset Strategy

**Asynchronous Active-High Reset**

- **Reset Signal**: `wb_rst_i` from Caravel
- **Type**: Synchronous, active-high
- **Distribution**: Routed to all peripheral blocks
- **Reset Sequence**:
  1. Caravel asserts `wb_rst_i` during power-up and configuration
  2. All registers in user_project reset to known states
  3. Reset de-asserted after system initialization
  4. Normal operation begins

**Reset Values**:
- All control/status registers reset to safe defaults
- FIFOs/buffers cleared
- Output pins driven to known states (as defined by each IP)

---

## Wishbone Bus Integration

### Bus Protocol: Wishbone B4 (Classic)

The user project implements a Wishbone B4 (classic) 32-bit slave interface connecting to the Caravel management SoC.

### Bus Signals

```verilog
input  wire         wb_clk_i      // Wishbone clock
input  wire         wb_rst_i      // Wishbone reset (active-high)
input  wire         wbs_cyc_i     // Bus cycle active
input  wire         wbs_stb_i     // Strobe (data valid)
input  wire         wbs_we_i      // Write enable (1=write, 0=read)
input  wire  [3:0]  wbs_sel_i     // Byte lane select
input  wire [31:0]  wbs_adr_i     // Address bus
input  wire [31:0]  wbs_dat_i     // Data input (for writes)
output reg  [31:0]  wbs_dat_o     // Data output (for reads)
output reg          wbs_ack_o     // Acknowledge
```

### Critical Wishbone Rules

1. **NEVER gate `wbs_cyc_i`** with address decode logic
   - Route `wbs_cyc_i` unmodified to all sub-peripherals
   - This is the Golden Rule of Wishbone integration

2. **Peripheral selection via `wbs_stb_i` gating**
   - Use address decode to generate gated strobe for each peripheral
   - Only one peripheral should be selected at a time (one-hot)

3. **All slaves must acknowledge**
   - Every valid transaction must be acknowledged
   - Prevents bus hangs
   - Invalid addresses return `0xDEADBEEF` but still ACK

4. **One-cycle acknowledgment**
   - `wbs_ack_o` asserted for exactly one clock cycle
   - De-asserted on the next cycle

### Address Decoding

The address decoder uses bits `[19:16]` to select peripherals:

```verilog
wire [2:0] peripheral_sel = wbs_adr_i[19:16];

// Generate gated strobes
wire pwm_stb  = (peripheral_sel == 3'd0) & wbs_stb_i;
wire uart_stb = (peripheral_sel == 3'd1) & wbs_stb_i;
wire sram_stb = (peripheral_sel == 3'd2) & wbs_stb_i;

// Route cyc unmodified (CRITICAL!)
wire pwm_cyc  = wbs_cyc_i;
wire uart_cyc = wbs_cyc_i;
wire sram_cyc = wbs_cyc_i;
```

### Bus Timing

**Read Transaction**:
```
Clock:     __|‾|__|‾|__|‾|__|‾|__
wbs_cyc_i: ____|‾‾‾‾‾‾‾‾|________
wbs_stb_i: ____|‾‾‾‾‾‾‾‾|________
wbs_we_i:  ____|________|________
wbs_adr_i: ====<ADDR>============
wbs_ack_o: ________|‾|__________
wbs_dat_o: ========<DATA>=======
           (one cycle latency)
```

**Write Transaction**:
```
Clock:     __|‾|__|‾|__|‾|__|‾|__
wbs_cyc_i: ____|‾‾‾‾‾‾‾‾|________
wbs_stb_i: ____|‾‾‾‾‾‾‾‾|________
wbs_we_i:  ____|‾‾‾‾‾‾‾‾|________
wbs_adr_i: ====<ADDR>============
wbs_dat_i: ====<DATA>============
wbs_sel_i: ====<SEL>=============
wbs_ack_o: ________|‾|__________
```

### Response Multiplexing

```verilog
// Combine ACKs (OR all peripheral ACKs)
assign wbs_ack_o = pwm_ack | uart_ack | sram_ack;

// Multiplex read data
always @(*) begin
    case (peripheral_sel)
        3'd0:    wbs_dat_o = pwm_dat;
        3'd1:    wbs_dat_o = uart_dat;
        3'd2:    wbs_dat_o = sram_dat;
        default: wbs_dat_o = 32'hDEADBEEF;  // Invalid address
    endcase
end
```

---

## Interrupt Handling

### IRQ Mapping

The user project provides 3 interrupt lines to Caravel:

| Line         | Source | Description                       |
|--------------|--------|-----------------------------------|
| user_irq[0]  | PWM    | Timer/PWM events                  |
| user_irq[1]  | UART   | TX/RX events                      |
| user_irq[2]  | SRAM   | Unused (SRAM has no interrupts)   |

### IRQ Protocol

- **Type**: Level-triggered, active-high
- **Clearing**: Handled by each peripheral's interrupt registers
  - Typically write-one-to-clear (W1C) status bits
  - Firmware must read status and clear flags

### IRQ Connection

```verilog
assign user_irq[0] = pwm_irq;
assign user_irq[1] = uart_irq;
assign user_irq[2] = 1'b0;  // Unused
```

Each peripheral provides its own interrupt enable, mask, and status registers. Consult individual IP documentation for interrupt configuration.

---

## Power Architecture

### Power Domains

The user_project uses Caravel's power domains:

- **Logic Power**: `vccd1` (1.8V digital)
- **Logic Ground**: `vssd1` (digital ground)
- **Macro Power**: `vccd2` (1.8V digital) - for hard macros like SRAM
- **Macro Ground**: `vssd2` (digital ground)

### Power Connections

**user_project module**:
```verilog
`ifdef USE_POWER_PINS
    .vccd1(vccd1),
    .vssd1(vssd1),
`endif
```

**user_project_wrapper**:
- Connects logic to `vccd1/vssd1`
- Connects SRAM hard macro to `vccd2/vssd2`
- Power rings and straps managed by OpenLane

**CRITICAL**: Never connect user logic to `vccd2/vssd2` or analog supplies.

---

## IP Core Integration Details

### CF_TMR32 (PWM)

- **Version**: v1.1.0
- **Location**: `/nc/ip/CF_TMR32/`
- **Wishbone Interface**: Built-in
- **Firmware API**: Available at `ip/CF_TMR32/fw/`
- **Key Features**:
  - 32-bit timer/counter
  - PWM output generation
  - Configurable prescaler
  - Interrupt on overflow, compare match

### CF_UART

- **Version**: v2.0.1
- **Location**: `/nc/ip/CF_UART/`
- **Wishbone Interface**: Built-in
- **Firmware API**: Available at `ip/CF_UART/fw/`
- **Key Features**:
  - Configurable baud rate
  - TX/RX with optional FIFO
  - Interrupt support
  - Error detection

### CF_SRAM_1024x32

- **Version**: v1.2.0
- **Location**: `/nc/ip/CF_SRAM_1024x32/`
- **Type**: Hard macro with integrated Wishbone controller
- **Firmware API**: Not provided - must create custom driver
- **Key Features**:
  - 4 KB (1024 × 32-bit) capacity
  - Wishbone interface included
  - Single-cycle access
  - No interrupts

**Important**: SRAM IP must be treated as read-only. Do not modify, lint, or re-verify.

---

## Verification Strategy

### Test Structure

Tests are located in `verilog/dv/cocotb/` with this structure:

```
verilog/dv/cocotb/
├── test_pwm/
│   ├── test_pwm.py         # Python testbench
│   ├── test_pwm.c          # Firmware
│   └── test_pwm.yaml       # Configuration
├── test_uart/
│   ├── test_uart.py
│   ├── test_uart.c
│   └── test_uart.yaml
├── test_sram/
│   ├── test_sram.py
│   ├── test_sram.c
│   └── test_sram.yaml
├── test_system/
│   ├── test_system.py
│   ├── test_system.c
│   └── test_system.yaml
└── cocotb_tests.py         # Test registry
```

### Verification Methodology

#### Firmware-Testbench Synchronization

All tests use a management GPIO handshake:

**Firmware Side** (`*.c`):
1. Initialize management GPIO
2. Disable housekeeping SPI
3. Configure all GPIOs  
4. Enable user interface
5. Signal ready: `ManagmentGpio_write(1)`
6. Proceed with test logic

**Testbench Side** (`*.py`):
1. Initialize: `caravelEnv = await test_configure(dut)`
2. Release CSB: `await caravelEnv.release_csb()`
3. Wait for firmware: `await caravelEnv.wait_mgmt_gpio(1)`
4. Execute test logic

#### Test Requirements

Each test must:
- Be self-checking (no manual waveform inspection)
- Use provided firmware APIs from IP cores
- Exercise complete peripheral functionality
- Check error conditions
- Pass before proceeding to PnR

### Running Tests

#### Setup Caravel-Cocotb Environment

From project root:
```bash
python verilog/dv/setup-cocotb.py /workspace/peripheral-example
```

This creates `design_info.yaml` and include files.

#### Add RTL Files

Edit `verilog/includes/includes.rtl.caravel_user_project`:
```
-v $(USER_PROJECT_VERILOG)/rtl/user_project.v
-v $(USER_PROJECT_VERILOG)/rtl/user_project_wrapper.v
-v $(USER_PROJECT_VERILOG)/../ip/CF_UART/hdl/rtl/CF_UART.v
-v $(USER_PROJECT_VERILOG)/../ip/CF_TMR32/hdl/rtl/CF_TMR32.v
-v $(USER_PROJECT_VERILOG)/../ip/CF_SRAM_1024x32/hdl/rtl/CF_SRAM_1024x32.v
```

#### Run Individual Test

From `verilog/dv/cocotb/`:
```bash
caravel_cocotb -t test_pwm -tag run1
```

#### Run All Tests

Create `testlist.yaml`:
```yaml
tests:
  - test_pwm
  - test_uart
  - test_sram
  - test_system
```

Run:
```bash
caravel_cocotb -tl testlist.yaml -tag regression
```

#### Check Results

Results in `sim/<tag>/`:
- `<simtype>-<testname>/passed` - Test passed
- `<simtype>-<testname>/failed` - Test failed
- `<simtype>-<testname>/test.log` - Test output
- `<simtype>-<testname>/waves.vcd` - Waveform

---

## Synthesis and Linting

### Linting

Use Verilator for RTL linting:

```bash
verilator --lint-only --Wall --Wno-EOFNEWLINE \
  -I./verilog/rtl \
  -I./ip/CF_UART/hdl/rtl \
  -I./ip/CF_TMR32/hdl/rtl \
  -I./ip/CF_SRAM_1024x32/hdl/rtl \
  ./verilog/rtl/user_project.v
```

**Requirements**:
- Zero errors
- Zero warnings (except allowed exceptions)
- No inferred latches

### Synthesis

Yosys synthesis script (`syn/yosys.ys`):

```tcl
# Read design
read_verilog -sv verilog/rtl/user_project.v
# Add IP cores
read_verilog ip/CF_UART/hdl/rtl/CF_UART.v
# ... more files

# Synthesize
synth -top user_project

# Check for latches
select t:$adff
select t:$dlatch
select -assert-none

# Report
stat
```

Run:
```bash
yosys syn/yosys.ys
```

---

## Physical Design (OpenLane)

### Two-Stage Hardening Process

1. **Stage 1**: Harden `user_project` as a macro
2. **Stage 2**: Harden `user_project_wrapper` with embedded macro

### OpenLane Configuration

#### user_project Config (`openlane/user_project/config.json`)

Key settings:
- `DESIGN_NAME`: "user_project"
- `CLOCK_PORT`: "wb_clk_i"
- `CLOCK_PERIOD`: 25 (40 MHz)
- `VERILOG_FILES`: List all RTL files
- `DIE_AREA`: Start with at least "0 0 400 400"
- Copy timing constraints from wrapper signoff.sdc

#### user_project_wrapper Config (`openlane/user_project_wrapper/config.json`)

Key additions:
- Include user_project macro in `MACROS` section
- Add SRAM macro (hard macro)
- Set `PDN_MACRO_CONNECTIONS` for power routing
- Include pin order configuration

**SRAM Integration**: Use `/nc/templates/caravel_user_sram/openlane/user_project_wrapper/config.json` as reference.

### Running OpenLane

```bash
# Harden user_project
openlane /workspace/peripheral-example/openlane/user_project/config.json \
  --ef-save-views-to /workspace/peripheral-example

# Harden user_project_wrapper
openlane /workspace/peripheral-example/openlane/user_project_wrapper/config.json \
  --ef-save-views-to /workspace/peripheral-example
```

### Quality Gates

Before marking PnR complete:
- [ ] WNS/TNS ≥ 0 (timing clean)
- [ ] Zero DRC violations
- [ ] Zero LVS errors
- [ ] No antenna violations (or fixed with diodes)
- [ ] Correct power connections (vccd1/vssd1 for logic, vccd2/vssd2 for macros)
- [ ] Wrapper bbox/pins match Caravel template

---

## Common Issues and Solutions

### Issue: Bus Hangs

**Symptom**: Simulation stalls during Wishbone access  
**Cause**: Slave not acknowledging transaction  
**Solution**: Ensure all peripherals ACK every valid transaction, even invalid addresses

### Issue: Wrong Data Returned

**Symptom**: Read returns unexpected data  
**Cause**: Address decode or data mux error  
**Solution**: Verify peripheral_sel logic and data multiplexer case statement

### Issue: Interrupts Not Working

**Symptom**: Firmware doesn't receive interrupts  
**Cause**: IRQ not routed or not enabled in peripheral  
**Solution**: Check interrupt enable registers and verify IRQ wire connections

### Issue: Timing Violations

**Symptom**: OpenLane reports negative slack  
**Solutions**:
- Reduce utilization/density
- Adjust placement/routing settings
- Add pipeline stages in critical paths
- Review SDC constraints

### Issue: DRC Violations

**Symptom**: OpenLane reports design rule check errors  
**Solutions**:
- Reduce density
- Add placement blockages
- Adjust metal layer usage
- Review macro placement

---

## Design Checklist

### RTL Checklist

- [ ] All signals use appropriate naming (snake_case, _n for active-low)
- [ ] Single clock domain (wb_clk_i)
- [ ] Synchronous reset (wb_rst_i)
- [ ] No combinational loops
- [ ] No inferred latches
- [ ] Wishbone cyc routed unmodified
- [ ] Wishbone stb gated for selection
- [ ] All slaves ACK transactions
- [ ] Invalid addresses return 0xDEADBEEF
- [ ] Unused wbs_dat_o bits tied to 0
- [ ] IRQs properly connected

### Verification Checklist

- [ ] All tests use mgmt_gpio handshake
- [ ] Tests exercise complete peripheral functionality
- [ ] Error conditions tested
- [ ] All tests self-checking
- [ ] All tests pass at RTL level
- [ ] Waveforms archived

### PnR Checklist

- [ ] Timing clean (WNS/TNS ≥ 0)
- [ ] Zero DRC errors
- [ ] Zero LVS errors
- [ ] Power connections correct
- [ ] Wrapper pins match template
- [ ] GDS/DEF/LEF generated

---

## References

- [Caravel Documentation](https://caravel-harness.readthedocs.io/)
- [Wishbone B4 Specification](https://cdn.opencores.org/downloads/wbspec_b4.pdf)
- [OpenLane Documentation](https://openlane2.readthedocs.io/)
- [Cocotb Documentation](https://docs.cocotb.org/)
- [Caravel-Cocotb Framework](https://github.com/efabless/caravel-cocotb)

---

**Last Updated**: 2025-10-27
