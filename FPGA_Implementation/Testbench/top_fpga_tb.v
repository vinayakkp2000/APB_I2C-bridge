`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   20:44:19 12/13/2022
// Design Name:   top_fpga
// Module Name:   G:/final_apb_i2c/final_fpga/final_fpga/top_fpga_tb.v
// Project Name:  final_fpga
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: top_fpga
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module top_fpga_tb;

	// Inputs
	reg PCLK;
	reg PRESETn;
	reg PSEL;
	reg PENABLE;
	reg PWrite;
	reg [1:0] I;

	// Outputs
	wire PREADY;
	wire [2:0] ADDRE;
	wire [7:0] DATA;

	// Bidirs
	wire i2c_sda;
	wire i2c_scl;
	
	pullup(i2c_sda);
	pullup(i2c_scl);
	
	// Instantiate the Unit Under Test (UUT)
	top_fpga uut (
		.PCLK(PCLK), 
		.PRESETn(PRESETn), 
		.PSEL(PSEL), 
		.PENABLE(PENABLE), 
		.PWrite(PWrite), 
		.i2c_sda(i2c_sda), 
		.i2c_scl(i2c_scl), 
		.PREADY(PREADY), 
		.ADDRE(ADDRE), 
		.DATA(DATA)
	);
	
	always #5 PCLK <= ~PCLK;
	
	initial begin
		// Initialize Inputs
		PCLK = 1;
		PRESETn = 0;
		PSEL = 0;
		PENABLE = 0;
		PWrite = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		PRESETn = 1;
		PSEL = 1;
		PENABLE = 1;
		PWrite = 1;
        
	end
	
	reg sl_sda = 1'bz;
	reg sl_scl = 1'bz;
	assign i2c_sda = sl_sda;
	assign i2c_scl = sl_scl;
	
	initial begin
		I = 0;
		#6010 I = 0;
		#3040 I = 1;
		#2900 I = 2;
		#2900 I = 3;
	end
	
	initial begin
		sl_sda = 1'bz;
		#3050 sl_sda = 1'b0;
		#240 sl_sda = 1'bz;
		
		#2720 sl_sda = 1'b0;
		#160 sl_sda = 1'bz;
		
		#2720 sl_sda = 1'b0;
		#160 sl_sda = 1'bz;
		
		#2720 sl_sda = 1'b0;
		#160 sl_sda = 1'bz;
		
		#2720 sl_sda = 1'b0;
		#160 sl_sda = 1'bz;
	end
	
//	initial begin
//		#6170 sl_scl = 1'b0;
//		#400 sl_scl = 1'bz;
//	end
      
endmodule

