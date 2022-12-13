`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: VINAYAK K P
//
// Create Date:   11:27:53 10/31/2022
// Design Name:   i2c_ic
// Module Name:   
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
	
	localparam T = 10;
	
	always #(T/2) PCLK <= ~PCLK;
	
	pullup(i2c_sda);
	pullup(i2c_scl);
	
	initial begin
		// Initialize Inputs
		PCLK = 1;
		PRESETn = 0;
		PSEL = 0;
		PENABLE = 0;
		
////////////////// status read ////////////		
		PWrite = 0;
		PADDR = 32'h0000_0000;
	   PWDATA = 32'h0000_0000;
		
		#T
		PRESETn = 1;
		#T
		PSEL = 1;
		#T
		PENABLE = 1;
		#T
		PENABLE = 0;
		
//////uncomment from here for i2c_write 
		
/////////////////// config write for i2c_write/////////////
//		#(T/2)
//		PWrite = 1;
//		PADDR = 32'h0000_0000;		
//						          //con2        con1 
//					            //addr 0-6 R/W ff R D/A cc e r
//		PWDATA = 32'b0000_0000_1100_011__0__11_0__1__00_1_1;
//		
//		#(T/2)
//		PENABLE = 1;
//		#T
//		PENABLE = 0;
//		
///////////////////// data write/////////////
//		#(T/2)
//		PWrite = 1;
//		PADDR = 32'hffff_0000;		
//		PWDATA = 32'h1234_abcd;
//		
//		#(T/2)
//		PENABLE = 1;
//		#T
//		PRESETn = 0;
//		PSEL = 0;
//		PENABLE = 0;
//		
//		
//////////////////// status read for i2c write completion////////////
//		#(630*T)
//		PWrite = 0;
//		PADDR = 32'h0000_0000;
//	   PWDATA = 32'h0000_0000;
//		
//		#T
//		PRESETn = 1;
//		#T
//		PSEL = 1;
//		#T
//		PENABLE = 1;
//		#T
//		PENABLE = 0;
//		PSEL = 0;
//		PRESETn = 0;

///////uncomment till here for i2c_write




///////uncomment from here for i2c_read 		
///////////////// config write for i2c_read/////////////
		#(T/2)
		PWrite = 1;
		PADDR = 32'h0000_0000;		
						          //con2        con1 
					            //addr 0-6 R/W ff R D/A cc e r
		PWDATA = 32'b0000_0000_1100_011__1__11_0__1__00_1_1;
		
		#(T/2)
		PENABLE = 1;
		#T
		PENABLE = 0;
		PSEL = 0;
		PRESETn = 0;
			

	

///////////////// data read (after some wait time)/////////////

		/////status read for checking completion of i2c read cycle//////
		#(640*T)
		PWrite = 0;
		PADDR = 32'h0000_0000;
	   PWDATA = 32'h0000_0000;
		
		#T
		PRESETn = 1;
		#T
		PSEL = 1;
		#T
		PENABLE = 1;
		#T
		PENABLE = 0;
		
		/////actual data read////////////
		#(T/2)
		PWrite = 1;
		PADDR = 32'hffff_0000;		
		PWDATA = 32'h0000_0000;
		
		#(T/2)
		PENABLE = 1;
		#T
		PRESETn = 0;
		PSEL = 0;
		PENABLE = 0;
		
///////uncomment till here for i2c_read		
		
	end

endmodule

