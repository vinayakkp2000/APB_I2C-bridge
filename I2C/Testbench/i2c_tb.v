`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   10:46:18 10/29/2022
// Design Name:   i2c
// Module Name:   G:/I2C -1/IC/i2c_tb.v
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
	reg CLK;
	reg [7:0] i2c_con1;
	reg [7:0] i2c_con2;
	reg [31:0] Din;

	// Outputs
	wire [31:0] Dout;
	wire [7:0] i2c_stat;

	// Bidirs
	wire i2c_sda;
	wire i2c_scl;
	

	// Instantiate the Unit Under Test (UUT)
	i2c_bridge uut (
		.CLK(CLK), 
		.i2c_con1(i2c_con1), 
		.i2c_con2(i2c_con2), 
		.Din(Din), 
		.Dout(Dout), 
		.i2c_stat(i2c_stat), 
		.i2c_scl(i2c_scl), 
		.i2c_sda(i2c_sda)
	);

	always #5 CLK = ~CLK;

	initial begin
		// Initialize Inputs
		CLK = 1;
		i2c_con1 = 0;
		i2c_con2 = 0;
		Din = 0;

		// Wait 100 ns for global reset to finish
		#40;
		//            ff R D/A cc e r
		i2c_con1 = 8'b11_0__1__11_1_1;
		
		//           r/w  addr 0-6
		i2c_con2 = 8'b1__1100101;
		Din = 32'hfeab;
        
		// Add stimulus here

	end
      
endmodule

