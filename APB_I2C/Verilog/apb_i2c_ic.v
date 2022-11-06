`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:49:46 10/29/2022 
// Design Name: 
// Module Name:    i2c_ic 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module apb_i2c_ic (
	input wire PCLK,
	input wire CLK,
	input wire PRESETn,
   input wire PSEL,
	input wire PENABLE,
	input wire PWrite,
	input wire [31:0] PADDR,
	input wire [31:0] PWDATA,
	
	output [31:0] PRDATA,
	output PREADY,
	output PSLVERR,
	
	inout i2c_scl,
	inout i2c_sda
	
    );
	
	wire [7:0] i2c_con1;
	wire [7:0] i2c_con2;
	wire [7:0] i2c_stat;
	wire [31:0] Din;
	wire [31:0] Dout;
	
	apb_slave apb (
		.PCLK(PCLK), 
		.PRESETn(PRESETn), 
		.PSEL(PSEL), 
		.PENABLE(PENABLE), 
		.PWrite(PWrite), 
		.PADDR(PADDR), 
		.PWDATA(PWDATA), 
		.Dout(Dout), 
		.ready(ready), 
		.i2c_stat(i2c_stat), 
		//.slverr(slverr), 
		.i2c_con1(i2c_con1), 
		.i2c_con2(i2c_con2), 
		.PRDATA(PRDATA), 
		.Din(Din), 
		.PREADY(PREADY), 
		.PSLVERR(PSLVERR)
	);
	
	i2c_bridge bridge(
		.CLK(CLK), 
		.i2c_con1(i2c_con1), 
		.i2c_con2(i2c_con2), 
		.Din(Din), // from apb
		.Dout(Dout), // to apb
		.i2c_stat(i2c_stat), 
		.i2c_scl(i2c_scl),
		.ready(ready),
		.i2c_sda(i2c_sda)
	);

endmodule
