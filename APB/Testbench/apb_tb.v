`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Vinayak K P
//
// Create Date:   13/12/2022
// Design Name:   apb_slave
// Module Name:   apb_tb
// Project Name:  apb_i2c_bridge
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: apb_slave
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module apb_tb;

	// Inputs
	reg PCLK;
	reg PRESETn;
	reg PSEL;
	reg PENABLE;
	reg PWrite;
	reg [31:0] PADDR;
	reg [31:0] PWDATA;
	reg [31:0] Dout;
	reg ready;
	reg [7:0] i2c_stat;
	//reg slverr;

	// Outputs
	wire [7:0] i2c_con1;
	wire [7:0] i2c_con2;
	wire [31:0] PRDATA;
	wire [31:0] Din;
	wire PREADY;
	wire PSLVERR;

	// Instantiate the Unit Under Test (UUT)
	apb_slave uut (
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
	
	localparam T = 33.3333;
	
	always #(T/2) PCLK = ~PCLK;
	
	initial begin
		// Initialize Inputs
		PCLK = 1;
		PRESETn = 0;
		PSEL = 0;
		PENABLE = 0;
		PWrite = 1;
		PADDR = 32'h0000_0000;
						//con2         con1 
					  //r/w  addr 0-6 ff R D/A cc e r
		PWDATA = 32'b0___1100_011__00_0_1___11_1_1;
		Dout = 0;
		ready = 1;
		i2c_stat = 8'b0000_0000;
		//slverr = 0;

		// Wait 100 ns for global reset to finish
		#T
		PRESETn = 1;
		#T
		PSEL = 1;
		#T
		PENABLE = 1;
		#T
		PENABLE = 0;
		PADDR = 32'hff00_0000;
		PWDATA = 32'hf03b_0000;
		#T
		PENABLE = 1;
		#T
		PRESETn = 0;
		PSEL = 0;
		PENABLE = 0;
		
		// Add stimulus here

	end
      
endmodule

