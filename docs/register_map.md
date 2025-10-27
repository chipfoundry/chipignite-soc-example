# Register Map

## Overview

This document defines the register map for all peripherals in the user project. Each peripheral occupies a 64 KB address window starting from the user project base address `0x3000_0000`.

## Address Allocation

| Peripheral | Base Address  | End Address   | Size   |
|------------|---------------|---------------|--------|
| PWM        | 0x3000_0000   | 0x3000_FFFF   | 64 KB  |
| UART       | 0x3001_0000   | 0x3001_FFFF   | 64 KB  |
| SRAM       | 0x3002_0000   | 0x3002_FFFF   | 64 KB  |

## Peripheral 0: PWM (CF_TMR32)

**Base Address**: `0x3000_0000`  
**IP Core**: CF_TMR32 v1.1.0  
**Description**: 32-bit timer/counter with PWM capability

### PWM Registers

Refer to CF_TMR32 IP documentation at `/nc/ip/CF_TMR32/` for complete register definitions.

Key registers include:
- Timer control and configuration
- PWM period and duty cycle
- Interrupt control and status
- Prescaler configuration

**Note**: The complete register map is defined in the CF_TMR32 IP documentation. All registers are 32-bit, word-aligned, and support byte-lane writes via `wbs_sel_i`.

---

## Peripheral 1: UART (CF_UART)

**Base Address**: `0x3001_0000`  
**IP Core**: CF_UART v2.0.1  
**Description**: Universal Asynchronous Receiver/Transmitter with configurable baud rate

### UART Registers

Refer to CF_UART IP documentation at `/nc/ip/CF_UART/` for complete register definitions.

Key registers include:
- TX/RX data buffers
- Baud rate configuration
- Control and status
- FIFO control (if applicable)
- Interrupt enable/status

**Note**: The complete register map is defined in the CF_UART IP documentation. All registers are 32-bit, word-aligned, and support byte-lane writes via `wbs_sel_i`.

---

## Peripheral 2: SRAM (CF_SRAM_1024x32)

**Base Address**: `0x3002_0000`  
**IP Core**: CF_SRAM_1024x32 v1.2.0  
**Description**: 4 KB (1024 x 32-bit) SRAM with integrated Wishbone controller

### SRAM Access

The SRAM is accessed directly through the Wishbone interface. The IP includes an integrated Wishbone controller, so memory access follows standard Wishbone read/write cycles.

**Memory Organization**:
- Size: 4096 bytes (1024 words × 4 bytes)
- Word size: 32 bits
- Address range: 0x3002_0000 to 0x3002_0FFF (4 KB)
- Access: Word-aligned, supports byte-lane writes via `wbs_sel_i`

**Access Method**:
```
Address = Base_Address + (Word_Offset × 4)
Word_Offset range: 0 to 1023
```

**Example Addresses**:
- First word: 0x3002_0000
- Second word: 0x3002_0004
- Last word: 0x3002_0FFC

**Note**: The SRAM IP is delivered as a hard macro with integrated Wishbone controller. No additional control registers are needed - memory is accessed directly via standard Wishbone transactions.

---

## Register Access Rules

### Read Operations
1. Assert `wbs_cyc_i` and `wbs_stb_i`
2. Set `wbs_we_i = 0` (read)
3. Provide address on `wbs_adr_i`
4. Wait for `wbs_ack_o = 1`
5. Read data from `wbs_dat_o`
6. De-assert signals

### Write Operations
1. Assert `wbs_cyc_i` and `wbs_stb_i`
2. Set `wbs_we_i = 1` (write)
3. Provide address on `wbs_adr_i`
4. Provide data on `wbs_dat_i`
5. Set byte lanes on `wbs_sel_i` (0xF for full word)
6. Wait for `wbs_ack_o = 1`
7. De-assert signals

### Byte Lane Selection (`wbs_sel_i`)
- `wbs_sel_i[0]` = 1: Write byte 0 (bits 7:0)
- `wbs_sel_i[1]` = 1: Write byte 1 (bits 15:8)
- `wbs_sel_i[2]` = 1: Write byte 2 (bits 23:16)
- `wbs_sel_i[3]` = 1: Write byte 3 (bits 31:24)

### Error Handling
- **Invalid Address (out of range)**: Returns `0xDEADBEEF` on read, ACK asserted but write ignored
- **Invalid Access**: All slaves must ACK every transaction to prevent bus hangs

---

## Interrupt Mapping

The user project provides 3 interrupt lines to Caravel: `user_irq[2:0]`

| IRQ Line     | Source         | Description                          |
|--------------|----------------|--------------------------------------|
| user_irq[0]  | PWM (CF_TMR32) | Timer overflow, compare match, etc.  |
| user_irq[1]  | UART (CF_UART) | TX/RX interrupts, errors             |
| user_irq[2]  | SRAM           | Not used (SRAM has no interrupts)    |

**Note**: Each IP core provides its own interrupt enable/mask/status registers. Consult the individual IP documentation for interrupt configuration details.

---

## Firmware API

Each IP core is packaged with firmware APIs:
- **PWM**: `/workspace/peripheral-example/ip/CF_TMR32/fw/`
- **UART**: `/workspace/peripheral-example/ip/CF_UART/fw/`
- **SRAM**: Custom firmware driver required (no packaged driver)

The firmware APIs provide high-level functions for configuring and controlling each peripheral.

---

## Wishbone Timing

All peripherals follow standard Wishbone B4 (classic) timing:
1. Address/data/control valid with `wbs_stb_i` and `wbs_cyc_i` asserted
2. Peripheral asserts `wbs_ack_o` for exactly one cycle
3. Read data valid on same cycle as `wbs_ack_o`
4. One-cycle read latency from request to acknowledgment

---

## References

- CF_TMR32 IP Documentation: `/nc/ip/CF_TMR32/`
- CF_UART IP Documentation: `/nc/ip/CF_UART/`
- CF_SRAM_1024x32 IP Documentation: `/nc/ip/CF_SRAM_1024x32/`
- Wishbone B4 Specification: [https://cdn.opencores.org/downloads/wbspec_b4.pdf](https://cdn.opencores.org/downloads/wbspec_b4.pdf)

---

**Last Updated**: 2025-10-27
