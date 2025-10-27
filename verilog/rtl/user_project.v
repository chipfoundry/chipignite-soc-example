`timescale 1ns / 1ps
`default_nettype none

module user_project (
`ifdef USE_POWER_PINS
    inout vccd1,
    inout vssd1,
`endif
    input wire wb_clk_i,
    input wire wb_rst_i,
    input wire wbs_cyc_i,
    input wire wbs_stb_i,
    input wire wbs_we_i,
    input wire [3:0] wbs_sel_i,
    input wire [31:0] wbs_adr_i,
    input wire [31:0] wbs_dat_i,
    output wire wbs_ack_o,
    output wire [31:0] wbs_dat_o,

    output wire [2:0] user_irq,

    input wire uart_rx,
    output wire uart_tx,
    output wire pwm_out
);

  wire [3:0] peripheral_sel;
  wire [2:0] stb;
  wire [2:0] ack;
  wire [31:0] dat_o[2:0];
  reg [31:0] mux_dat_o;
  wire invalid_addr;

  assign peripheral_sel = wbs_adr_i[19:16];

  assign stb[0] = (peripheral_sel == 4'd0) & wbs_stb_i;
  assign stb[1] = (peripheral_sel == 4'd1) & wbs_stb_i;
  assign stb[2] = (peripheral_sel == 4'd2) & wbs_stb_i;

  assign invalid_addr = (peripheral_sel != 4'd0) && (peripheral_sel != 4'd1) && 
                        (peripheral_sel != 4'd2) && wbs_cyc_i && wbs_stb_i;
  assign wbs_ack_o = ack[0] | ack[1] | ack[2] | invalid_addr;

  always @(*) begin
    case (peripheral_sel)
      4'd0:    mux_dat_o = dat_o[0];
      4'd1:    mux_dat_o = dat_o[1];
      4'd2:    mux_dat_o = dat_o[2];
      default: mux_dat_o = 32'hDEADBEEF;
    endcase
  end

  assign wbs_dat_o = mux_dat_o;

  wire pwm0_unused;

  CF_TMR32_WB #(
    .PRW(16)
  ) pwm_inst (
    .clk_i(wb_clk_i),
    .rst_i(wb_rst_i),
    .adr_i(wbs_adr_i),
    .dat_i(wbs_dat_i),
    .dat_o(dat_o[0]),
    .sel_i(wbs_sel_i),
    .cyc_i(wbs_cyc_i),
    .stb_i(stb[0]),
    .ack_o(ack[0]),
    .we_i(wbs_we_i),
    .IRQ(user_irq[0]),
    .pwm0(pwm_out),
    .pwm1(pwm0_unused),
    .pwm_fault(1'b0)
  );

  CF_UART_WB #(
    .SC(8),
    .MDW(9),
    .GFLEN(8),
    .FAW(4)
  ) uart_inst (
    .clk_i(wb_clk_i),
    .rst_i(wb_rst_i),
    .adr_i(wbs_adr_i),
    .dat_i(wbs_dat_i),
    .dat_o(dat_o[1]),
    .sel_i(wbs_sel_i),
    .cyc_i(wbs_cyc_i),
    .stb_i(stb[1]),
    .ack_o(ack[1]),
    .we_i(wbs_we_i),
    .IRQ(user_irq[1]),
    .rx(uart_rx),
    .tx(uart_tx)
  );

  CF_SRAM_1024x32_wb_wrapper sram_inst (
`ifdef USE_POWER_PINS
    .VPWR(vccd1),
    .VGND(vssd1),
`endif
    .wb_clk_i(wb_clk_i),
    .wb_rst_i(wb_rst_i),
    .wbs_stb_i(stb[2]),
    .wbs_cyc_i(wbs_cyc_i),
    .wbs_we_i(wbs_we_i),
    .wbs_sel_i(wbs_sel_i),
    .wbs_dat_i(wbs_dat_i),
    .wbs_adr_i(wbs_adr_i),
    .wbs_ack_o(ack[2]),
    .wbs_dat_o(dat_o[2])
  );

  assign user_irq[2] = 1'b0;

endmodule

`default_nettype wire
