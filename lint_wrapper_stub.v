`timescale 1ns / 1ps

module CF_SRAM_1024x32 (
    output [31:0] DO,
    output ScanOutCC,
    input [31:0] DI,
    input [31:0] BEN,
    input [9:0] AD,
    input EN,
    input R_WB,
    input CLKin,
    input WLBI,
    input WLOFF,
    input TM,
    input SM,
    input ScanInCC,
    input ScanInDL,
    input ScanInDR,
    input vpwrac,
    input vpwrpc,
`ifdef USE_PG_PIN
    input vgnd,
    input vpwrm,
    input vpwra,
    input vpwrp,
    input vnb,
    input vpb
`else
    input vgnd,
    input vpwrm,
    input vpwra,
    input vpwrp,
    input vnb,
    input vpb
`endif
);

  assign DO = 32'h0;
  assign ScanOutCC = 1'b0;

endmodule
