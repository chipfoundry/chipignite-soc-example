set ::env(CLOCK_NET) wb_clk_i
set ::env(RSZ_CORNER_0) "nom_tt_025C_1v80 /nc/apps/pdk/ciel/sky130/versions/0fe599b2afb6708d281543108caf8310912f54af/sky130A/libs.ref/sky130_fd_sc_hd/lib/sky130_fd_sc_hd__tt_025C_1v80.lib /workspace/peripheral-example/ip/CF_SRAM_1024x32/lib/CF_SRAM_1024x32_wb_wrapper.lib"
set ::env(RSZ_CORNER_1) "nom_ss_100C_1v60 /nc/apps/pdk/ciel/sky130/versions/0fe599b2afb6708d281543108caf8310912f54af/sky130A/libs.ref/sky130_fd_sc_hd/lib/sky130_fd_sc_hd__ss_100C_1v60.lib /workspace/peripheral-example/ip/CF_SRAM_1024x32/lib/CF_SRAM_1024x32_wb_wrapper.lib"
set ::env(RSZ_CORNER_2) "nom_ff_n40C_1v95 /nc/apps/pdk/ciel/sky130/versions/0fe599b2afb6708d281543108caf8310912f54af/sky130A/libs.ref/sky130_fd_sc_hd/lib/sky130_fd_sc_hd__ff_n40C_1v95.lib /workspace/peripheral-example/ip/CF_SRAM_1024x32/lib/CF_SRAM_1024x32_wb_wrapper.lib"
set ::env(STEP_ID) OpenROAD.CTS
set ::env(TECH_LEF) /nc/apps/pdk/ciel/sky130/versions/0fe599b2afb6708d281543108caf8310912f54af/sky130A/libs.ref/sky130_fd_sc_hd/techlef/sky130_fd_sc_hd__nom.tlef
set ::env(MACRO_LEFS) /workspace/peripheral-example/ip/CF_SRAM_1024x32/lef/CF_SRAM_1024x32_wb_wrapper.lef
set ::env(STD_CELL_LIBRARY) sky130_fd_sc_hd
set ::env(VDD_PIN) VPWR
set ::env(VDD_PIN_VOLTAGE) 1.80
set ::env(GND_PIN) VGND
set ::env(TECH_LEFS) "\"nom_*\" /nc/apps/pdk/ciel/sky130/versions/0fe599b2afb6708d281543108caf8310912f54af/sky130A/libs.ref/sky130_fd_sc_hd/techlef/sky130_fd_sc_hd__nom.tlef \"min_*\" /nc/apps/pdk/ciel/sky130/versions/0fe599b2afb6708d281543108caf8310912f54af/sky130A/libs.ref/sky130_fd_sc_hd/techlef/sky130_fd_sc_hd__min.tlef \"max_*\" /nc/apps/pdk/ciel/sky130/versions/0fe599b2afb6708d281543108caf8310912f54af/sky130A/libs.ref/sky130_fd_sc_hd/techlef/sky130_fd_sc_hd__max.tlef"
set ::env(GPIO_PADS_LEF) "/nc/apps/pdk/ciel/sky130/versions/0fe599b2afb6708d281543108caf8310912f54af/sky130A/libs.ref/sky130_fd_io/lef/sky130_fd_io.lef /nc/apps/pdk/ciel/sky130/versions/0fe599b2afb6708d281543108caf8310912f54af/sky130A/libs.ref/sky130_fd_io/lef/sky130_ef_io.lef"
set ::env(GPIO_PADS_LEF_CORE_SIDE) "/nc/apps/pdk/ciel/sky130/versions/0fe599b2afb6708d281543108caf8310912f54af/sky130A/libs.tech/openlane/custom_cells/lef/sky130_fd_io_core.lef /nc/apps/pdk/ciel/sky130/versions/0fe599b2afb6708d281543108caf8310912f54af/sky130A/libs.tech/openlane/custom_cells/lef/sky130_ef_io_core.lef"
set ::env(GPIO_PADS_VERILOG) /nc/apps/pdk/ciel/sky130/versions/0fe599b2afb6708d281543108caf8310912f54af/sky130A/libs.ref/sky130_fd_io/verilog/sky130_ef_io.v
set ::env(GPIO_PAD_CELLS) "\"sky130_fd_io*\" \"sky130_ef_io*\""
set ::env(PRIMARY_GDSII_STREAMOUT_TOOL) magic
set ::env(DEFAULT_CORNER) nom_tt_025C_1v80
set ::env(STA_CORNERS) "nom_tt_025C_1v80 nom_ss_100C_1v60 nom_ff_n40C_1v95 min_tt_025C_1v80 min_ss_100C_1v60 min_ff_n40C_1v95 max_tt_025C_1v80 max_ss_100C_1v60 max_ff_n40C_1v95"
set ::env(FP_TRACKS_INFO) /nc/apps/pdk/ciel/sky130/versions/0fe599b2afb6708d281543108caf8310912f54af/sky130A/libs.tech/openlane/sky130_fd_sc_hd/tracks.info
set ::env(FP_TAPCELL_DIST) 13
set ::env(FP_IO_HLAYER) met3
set ::env(FP_IO_VLAYER) met2
set ::env(RT_MIN_LAYER) met1
set ::env(RT_MAX_LAYER) met5
set ::env(SCL_GROUND_PINS) "VGND VNB"
set ::env(SCL_POWER_PINS) "VPWR VPB"
set ::env(TRISTATE_CELLS) "\"sky130_fd_sc_hd__ebuf*\""
set ::env(FILL_CELL) "\"sky130_fd_sc_hd__fill*\""
set ::env(DECAP_CELL) "sky130_ef_sc_hd__decap_12 sky130_fd_sc_hd__decap_8 sky130_fd_sc_hd__decap_6 sky130_fd_sc_hd__decap_4 sky130_fd_sc_hd__decap_3"
set ::env(LIB) "\"*_tt_025C_1v80\" /nc/apps/pdk/ciel/sky130/versions/0fe599b2afb6708d281543108caf8310912f54af/sky130A/libs.ref/sky130_fd_sc_hd/lib/sky130_fd_sc_hd__tt_025C_1v80.lib \"*_ss_100C_1v60\" /nc/apps/pdk/ciel/sky130/versions/0fe599b2afb6708d281543108caf8310912f54af/sky130A/libs.ref/sky130_fd_sc_hd/lib/sky130_fd_sc_hd__ss_100C_1v60.lib \"*_ff_n40C_1v95\" /nc/apps/pdk/ciel/sky130/versions/0fe599b2afb6708d281543108caf8310912f54af/sky130A/libs.ref/sky130_fd_sc_hd/lib/sky130_fd_sc_hd__ff_n40C_1v95.lib"
set ::env(CELL_LEFS) "/nc/apps/pdk/ciel/sky130/versions/0fe599b2afb6708d281543108caf8310912f54af/sky130A/libs.ref/sky130_fd_sc_hd/lef/sky130_ef_sc_hd.lef /nc/apps/pdk/ciel/sky130/versions/0fe599b2afb6708d281543108caf8310912f54af/sky130A/libs.ref/sky130_fd_sc_hd/lef/sky130_fd_sc_hd.lef"
set ::env(CELL_GDS) /nc/apps/pdk/ciel/sky130/versions/0fe599b2afb6708d281543108caf8310912f54af/sky130A/libs.ref/sky130_fd_sc_hd/gds/sky130_fd_sc_hd.gds
set ::env(CELL_VERILOG_MODELS) "/nc/apps/pdk/ciel/sky130/versions/0fe599b2afb6708d281543108caf8310912f54af/sky130A/libs.ref/sky130_fd_sc_hd/verilog/primitives.v /nc/apps/pdk/ciel/sky130/versions/0fe599b2afb6708d281543108caf8310912f54af/sky130A/libs.ref/sky130_fd_sc_hd/verilog/sky130_fd_sc_hd.v"
set ::env(CELL_BB_VERILOG_MODELS) "/nc/apps/pdk/ciel/sky130/versions/0fe599b2afb6708d281543108caf8310912f54af/sky130A/libs.ref/sky130_fd_sc_hd/verilog/sky130_fd_sc_hd__blackbox.v /nc/apps/pdk/ciel/sky130/versions/0fe599b2afb6708d281543108caf8310912f54af/sky130A/libs.ref/sky130_fd_sc_hd/verilog/sky130_fd_sc_hd__blackbox_pp.v"
set ::env(CELL_SPICE_MODELS) "/nc/apps/pdk/ciel/sky130/versions/0fe599b2afb6708d281543108caf8310912f54af/sky130A/libs.ref/sky130_fd_sc_hd/spice/sky130_ef_sc_hd__decap_12.spice /nc/apps/pdk/ciel/sky130/versions/0fe599b2afb6708d281543108caf8310912f54af/sky130A/libs.ref/sky130_fd_sc_hd/spice/sky130_ef_sc_hd__fill_12.spice /nc/apps/pdk/ciel/sky130/versions/0fe599b2afb6708d281543108caf8310912f54af/sky130A/libs.ref/sky130_fd_sc_hd/spice/sky130_ef_sc_hd__fill_4.spice /nc/apps/pdk/ciel/sky130/versions/0fe599b2afb6708d281543108caf8310912f54af/sky130A/libs.ref/sky130_fd_sc_hd/spice/sky130_ef_sc_hd__fill_8.spice /nc/apps/pdk/ciel/sky130/versions/0fe599b2afb6708d281543108caf8310912f54af/sky130A/libs.ref/sky130_fd_sc_hd/spice/sky130_fd_sc_hd.spice"
set ::env(SYNTH_EXCLUDED_CELL_FILE) /nc/apps/pdk/ciel/sky130/versions/0fe599b2afb6708d281543108caf8310912f54af/sky130A/libs.tech/openlane/sky130_fd_sc_hd/no_synth.cells
set ::env(PNR_EXCLUDED_CELL_FILE) /nc/apps/pdk/ciel/sky130/versions/0fe599b2afb6708d281543108caf8310912f54af/sky130A/libs.tech/openlane/sky130_fd_sc_hd/drc_exclude.cells
set ::env(OUTPUT_CAP_LOAD) 33.442
set ::env(MAX_FANOUT_CONSTRAINT) 10
set ::env(MAX_TRANSITION_CONSTRAINT) 0.75
set ::env(MAX_CAPACITANCE_CONSTRAINT) 0.2
set ::env(CLOCK_UNCERTAINTY_CONSTRAINT) 0.25
set ::env(CLOCK_TRANSITION_CONSTRAINT) 0.1499999999999999944488848768742172978818416595458984375
set ::env(TIME_DERATING_CONSTRAINT) 5
set ::env(IO_DELAY_CONSTRAINT) 20
set ::env(SYNTH_DRIVING_CELL) sky130_fd_sc_hd__inv_2/Y
set ::env(SYNTH_TIEHI_CELL) sky130_fd_sc_hd__conb_1/HI
set ::env(SYNTH_TIELO_CELL) sky130_fd_sc_hd__conb_1/LO
set ::env(SYNTH_BUFFER_CELL) sky130_fd_sc_hd__buf_2/A/X
set ::env(WELLTAP_CELL) sky130_fd_sc_hd__tapvpwrvgnd_1
set ::env(ENDCAP_CELL) sky130_fd_sc_hd__decap_3
set ::env(PLACE_SITE) unithd
set ::env(CELL_PAD_EXCLUDE) "\"sky130_fd_sc_hd__tap*\" \"sky130_fd_sc_hd__decap*\" \"sky130_ef_sc_hd__decap*\" \"sky130_fd_sc_hd__fill*\""
set ::env(DIODE_CELL) sky130_fd_sc_hd__diode_2/DIODE
set ::env(DESIGN_NAME) user_project
set ::env(CLOCK_PERIOD) 25
set ::env(CLOCK_PORT) wb_clk_i
set ::env(DIE_AREA) "0 0 900 900"
set ::env(MACROS) "CF_SRAM_1024x32_wb_wrapper \"gds /workspace/peripheral-example/ip/CF_SRAM_1024x32/gds/CF_SRAM_1024x32_wb_wrapper.gds lef /workspace/peripheral-example/ip/CF_SRAM_1024x32/lef/CF_SRAM_1024x32_wb_wrapper.lef instances \\\"sram_inst \\\\\\\"location \\\\\\\\\\\\\\\"200 200\\\\\\\\\\\\\\\" orientation N\\\\\\\"\\\" vh \\\"\\\" nl \\\"\\\" pnl \\\"\\\" spef \\\"\\\" lib \\\"\\\\\\\"*\\\\\\\" /workspace/peripheral-example/ip/CF_SRAM_1024x32/lib/CF_SRAM_1024x32_wb_wrapper.lib\\\" spice \\\"\\\" sdf \\\"\\\" json_h None\""
set ::env(EXTRA_VERILOG_MODELS) /workspace/peripheral-example/ip/CF_SRAM_1024x32/hdl/gl/CF_SRAM_1024x32_wb_wrapper.v
set ::env(FALLBACK_SDC_FILE) /nix/store/z6z1ia207zpd43ka6vqnxgghfxfr26h6-python3-3.11.9-env/lib/python3.11/site-packages/librelane/scripts/base.sdc
set ::env(PDN_CONNECT_MACROS_TO_GRID) 1
set ::env(PDN_MACRO_CONNECTIONS) "\"sram_inst vccd1 vssd1 VPWR VGND\""
set ::env(PDN_ENABLE_GLOBAL_CONNECTIONS) 1
set ::env(PNR_SDC_FILE) /workspace/peripheral-example/openlane/user_project/signoff.sdc
set ::env(PL_OPTIMIZE_MIRRORING) 1
set ::env(PL_MAX_DISPLACEMENT_X) 500
set ::env(PL_MAX_DISPLACEMENT_Y) 100
set ::env(DPL_CELL_PADDING) 0
set ::env(CTS_SINK_CLUSTERING_SIZE) 25
set ::env(CTS_SINK_CLUSTERING_MAX_DIAMETER) 50
set ::env(CTS_CLK_MAX_WIRE_LENGTH) 0
set ::env(CTS_DISABLE_POST_PROCESSING) 0
set ::env(CTS_DISTANCE_BETWEEN_BUFFERS) 0
set ::env(CTS_ROOT_BUFFER) sky130_fd_sc_hd__clkbuf_16
set ::env(CTS_CLK_BUFFERS) "sky130_fd_sc_hd__clkbuf_8 sky130_fd_sc_hd__clkbuf_4 sky130_fd_sc_hd__clkbuf_2"
set ::env(CURRENT_ODB) /workspace/peripheral-example/openlane/user_project/runs/RUN_2025-10-27_22-48-06/33-openroad-detailedplacement/user_project.odb
set ::env(SAVE_ODB) /workspace/peripheral-example/openlane/user_project/runs/RUN_2025-10-27_22-48-06/34-openroad-cts/user_project.odb
set ::env(SAVE_DEF) /workspace/peripheral-example/openlane/user_project/runs/RUN_2025-10-27_22-48-06/34-openroad-cts/user_project.def
set ::env(SAVE_SDC) /workspace/peripheral-example/openlane/user_project/runs/RUN_2025-10-27_22-48-06/34-openroad-cts/user_project.sdc
set ::env(SAVE_NETLIST) /workspace/peripheral-example/openlane/user_project/runs/RUN_2025-10-27_22-48-06/34-openroad-cts/user_project.nl.v
set ::env(SAVE_POWERED_NETLIST) /workspace/peripheral-example/openlane/user_project/runs/RUN_2025-10-27_22-48-06/34-openroad-cts/user_project.pnl.v
