# Caravel User Project: PWM, UART, and SRAM Integration

## Project Overview

This project integrates a custom user project into the Caravel SoC with three peripherals:
1. **PWM (Pulse Width Modulation)** - Using CF_TMR32 IP with PWM functionality
2. **UART (Universal Asynchronous Receiver/Transmitter)** - Using CF_UART IP  
3. **SRAM (Static Random Access Memory)** - Using CF_SRAM_1024x32 IP (4KB)

## Initial User Prompt

> Integrate a custom user project into the Caravel SoC with the following peripherals: 1 PWM, 1 UART, 1 SRAM.

## Project Objectives

1. Integrate three verified IP cores (CF_TMR32, CF_UART, CF_SRAM_1024x32) into a Caravel user project
2. Implement proper Wishbone B4 (classic) bus interface and address decoding
3. Create comprehensive cocotb verification tests for each peripheral
4. Ensure all tests pass before proceeding to physical design
5. Harden the design using OpenLane/LibreLane targeting SKY130A PDK
6. Meet all Caravel acceptance criteria for both RTL and PnR

## Address Map

| Peripheral | Base Address  | Size   | Description                    |
|------------|---------------|--------|--------------------------------|
| PWM        | 0x3000_0000   | 64 KB  | CF_TMR32 with PWM capability   |
| UART       | 0x3001_0000   | 64 KB  | CF_UART serial communication   |
| SRAM       | 0x3002_0000   | 64 KB  | 4KB SRAM with WB controller    |

## Technology Stack

- **PDK**: SKY130A (Google/Skywater 130nm)
- **Standard Cells**: sky130_fd_sc_hd
- **Bus Protocol**: Wishbone B4 (classic) 32-bit
- **Verification**: cocotb + caravel-cocotb framework
- **Physical Design**: OpenLane/LibreLane
- **Language**: Verilog-2005

## Project Structure

```
peripheral-example/
├── docs/                       # Documentation
│   ├── README.md              # This file
│   ├── register_map.md        # Register definitions
│   ├── pad_map.md             # GPIO/pad assignments
│   └── integration_notes.md   # Integration details
├── rtl/                       # RTL source files
│   ├── user_project.v         # Main user project
│   └── user_project_wrapper.v # Caravel wrapper
├── ip/                        # Linked IP cores
├── verilog/                   # Caravel-standard structure
│   ├── rtl/                   # RTL files
│   ├── gl/                    # Gate-level netlists
│   └── dv/                    # Design verification
│       └── cocotb/            # Cocotb tests
├── openlane/                  # OpenLane configurations
│   ├── user_project/          # User project config
│   └── user_project_wrapper/  # Wrapper config
└── fw/                        # Firmware files
```

## Design Approach

### 1. IP Integration Strategy
- Use pre-verified NativeChips IPs from `/nc/ip/`
- Link IPs using ipm_linker tool
- Each IP comes with existing Wishbone wrappers (where applicable)
- SRAM IP is delivered as a hard macro with integrated WB controller

### 2. Wishbone Bus Architecture
- Implement address decoder to select peripherals based on address bits [19:16]
- Route `wbs_cyc_i` unmodified to all peripherals (Golden Rule)
- Gate `wbs_stb_i` for peripheral selection (one-hot)
- Combine `wbs_ack_o` responses with OR logic
- Multiplex `wbs_dat_o` based on active peripheral

### 3. Verification Methodology
- Create separate integration test for each peripheral
- Use firmware APIs provided with each IP
- Implement management GPIO handshake for synchronization
- Create system-level integration test
- All tests must be self-checking and pass before PnR

### 4. Physical Design Flow
- First harden user_project as a macro
- Then harden user_project_wrapper with embedded macro
- Ensure proper power planning (vccd1/vssd1 for logic, vccd2/vssd2 for macro)
- Meet timing, DRC, LVS requirements

## Current Status

- [x] Repository setup
- [x] Caravel template copied
- [x] Initial documentation created
- [ ] IP cores linked
- [ ] RTL development
- [ ] Verification tests created
- [ ] Verification passing
- [ ] Physical design
- [ ] Final documentation

## Next Steps

1. Link IP cores using ipm_linker
2. Create register map documentation
3. Develop user_project with Wishbone decoder
4. Create user_project_wrapper
5. Develop cocotb verification tests
6. Run and pass all verification tests
7. Configure and run OpenLane hardening
8. Generate final documentation

## References

- [Caravel Documentation](https://caravel-harness.readthedocs.io/)
- [Wishbone B4 Specification](https://cdn.opencores.org/downloads/wbspec_b4.pdf)
- [OpenLane Documentation](https://openlane2.readthedocs.io/)
- NativeChips IP Library: `/nc/ip/`

## Revision History

| Date       | Version | Description                          |
|------------|---------|--------------------------------------|
| 2025-10-27 | 0.1     | Initial project setup and planning   |

---

**Status**: Project Setup Phase  
**Last Updated**: 2025-10-27
