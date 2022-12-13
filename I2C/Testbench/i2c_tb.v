`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: VINAYAK K P
//
// Create Date:   10:46:18 10/29/2022
// Design Name:   i2c
// Module Name:   
// Project Name:  IC
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: i2c
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module i2c_tb;

	// Inputs
	reg PCLK;
	reg [7:0] i2c_con1;
	reg [7:0] i2c_con2;
	reg [31:0] Din;

	// Outputs
	wire [31:0] Dout;
	wire [7:0] i2c_stat;
	wire ready;

	// Bidirs
	wire i2c_sda;
	wire i2c_scl;
	

	// Instantiate the Unit Under Test (UUT)
	i2c_bridge uut (
		.PCLK(PCLK), 
		.i2c_con1(i2c_con1), 
		.i2c_con2(i2c_con2), 
		.Din(Din), 
		.Dout(Dout), 
		.i2c_stat(i2c_stat), 
		.ready(ready),
		.i2c_scl(i2c_scl), 
		.i2c_sda(i2c_sda)
	);

	always #5 PCLK <= ~PCLK;
	
	pullup(i2c_sda);
	pullup(i2c_scl);

	initial begin
		// Initialize Inputs
		PCLK = 1;
		i2c_con1 = 0;
		i2c_con2 = 0;
		Din = 0;

		#40;
		//            ff R D/A cc e r
		i2c_con1 = 8'b11_1__0__11_1_1;
		
		//            addr 0-6 r/w
		i2c_con2 = 8'b1100101__1;
		Din = 32'hfeab;
        

	end
      
endmodule

