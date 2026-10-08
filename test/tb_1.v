`timescale 1ns / 1ps

module tb_tt_repellant;
    reg clk;
    reg rst_n;
    reg [7:0] ui_in;
    wire [7:0] uo_out;
    wire [7:0] uio_in;
    wire [7:0] uio_out;
    wire [7:0] uio_oe;
    wire ena;

    assign ena = 1'b1;
    assign uio_in = 8'b0;

    // Instantiate Unit Under Test
    tt_um_repellant_generator uut (
        .ui_in(ui_in),
        .uo_out(uo_out),
        .uio_in(uio_in),
        .uio_out(uio_out),
        .uio_oe(uio_oe),
        .ena(ena),
        .clk(clk),
        .rst_n(rst_n)
    );

    // 125 MHz clock (8ns period)
    always #4 clk = ~clk;

    initial begin
        clk = 0;
        rst_n = 0;
        ui_in = 8'b1111_1111; // All buttons released (active low)
        
        #50;
        rst_n = 1;
        #100;

        // Press Mode Button (ui_in[1]) to switch modes:
        // Mode 1 (0Hz) -> Mode 2 (100Hz)
        #2000;
        ui_in[1] = 0; // Press Mode
        #5000;
        ui_in[1] = 1; // Release Mode

        // Mode 2 -> Mode 3 (1kHz)
        #5000;
        ui_in[1] = 0; 
        #5000;
        ui_in[1] = 1; 

        // Mode 3 -> Mode 4 (10kHz)
        #5000;
        ui_in[1] = 0; 
        #5000;
        ui_in[1] = 1; 

        #10000;
        $finish;
    end
endmodule
