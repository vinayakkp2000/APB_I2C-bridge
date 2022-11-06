`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   11:27:53 10/31/2022
// Design Name:   i2c_ic
// Module Name:   G:/APB_I2C/apb/top_tb.v
// Project Name:  apb
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: i2c_ic
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module apb_i2c_tb;

	// Inputs
	reg PCLK;
	reg CLK;
	reg PRESETn;
	reg PSEL;
	reg PENABLE;
	reg PWrite;
	reg [31:0] PADDR;
	reg [31:0] PWDATA;

	// Outputs
	wire [31:0] PRDATA;
	wire PREADY;
	wire PSLVERR;

	// Bidirs
	wire i2c_scl;
	wire i2c_sda;

	// Instantiate the Unit Under Test (UUT)
	apb_i2c_ic uut (
		.PCLK(PCLK), 
		.CLK(CLK), 
		.PRESETn(PRESETn), 
		.PSEL(PSEL), 
		.PENABLE(PENABLE), 
		.PWrite(PWrite), 
		.PADDR(PADDR), 
		.PWDATA(PWDATA), 
		.PRDATA(PRDATA), 
		.PREADY(PREADY), 
		.PSLVERR(PSLVERR), 
		.i2c_scl(i2c_scl), 
		.i2c_sda(i2c_sda)
	);
	
	localparam T = 33.3333;
	
	always #(T/2) PCLK = ~PCLK;
	always #5 CLK = ~CLK;
	
	initial begin
		// Initialize Inputs
		PCLK = 1;
		CLK = 1;
		PRESETn = 0;
		PSEL = 0;
		PENABLE = 0;
		
		
		/////////////////////////////////////////////
		//write-32
		
		PWrite = 1;
		PADDR = 32'h0000_0000;
						         //con2          con1 
					           // r/w  addr 0-6  ff R D/A cc e r
		PWDATA = 32'b0000_0000__0___1100_011__10_0__1__11_1_1;
		
		#T
		PRESETn = 1;
		#T
		PSEL = 1;
		#T
		PENABLE = 1;
		#T
		PENABLE = 0;
		PADDR = 32'hff00_0000;
		PWDATA = 32'hf23b_1a85;
		#T
		PENABLE = 1;
		#T
		PRESETn = 0;
		PSEL = 0;
		PENABLE = 0;
		
//		///////////////////////////////////////
//		//read-32 bit
//		PWrite = 1;
//		PADDR = 32'h0000_0000;
//						         //con2          con1 
//					           // r/w  addr 0-6  ff R D/A cc e r
//		PWDATA = 32'b0000_0000__1___1100_011__10_0__1__11_1_1;
//		
//		#T
//		PRESETn = 1;
//		#T
//		PSEL = 1;
//		#T
//		PENABLE = 1;
//		#T
//		PENABLE = 0;
//		PRESETn = 0;
//		PSEL = 0;
//		PENABLE = 0;
//		PWrite = 0;
//		PADDR = 32'hff00_0000;
//		//PWDATA = 32'hf23b_1a85;
//		#(1430*T)
//		PRESETn = 1;
//		#T
//		PSEL = 1;
//		#T
//		PENABLE = 1;
//		#T
//		PRESETn = 0;
//		PSEL = 0;
//		PENABLE = 0;
        
		
		////////////////////////////////////////////////////
		//status read
						            //con2         con1 
					              //r/w  addr 0-6 ff R D/A cc e r
		//PWDATA = 32'b0000_0000_0___1100_011__11_0_1___11_1_1;
		
		#T
		PRESETn = 1;
		#T
		PSEL = 1;
		#T
		PENABLE = 1;
		#T
		PENABLE = 0;
		//PADDR = 32'hff00_0000;
		//PWDATA = 32'hf03b_0000;
		#T
		PENABLE = 1;
		#T
		PRESETn = 0;
		PSEL = 0;
		PENABLE = 0;

	end
      
endmodule

