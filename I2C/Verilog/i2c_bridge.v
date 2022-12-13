`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: VINAYAK K P
// 
// Create Date:    11:22:32 10/28/2022 
// Design Name: 
// Module Name:    I2C 
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
module i2c_bridge (
	input wire PCLK, 
	input wire [7:0] i2c_con1,
	input wire [7:0] i2c_con2,
	input wire [31:0] Din,
	
	output     [31:0] Dout,
	output reg [7:0] i2c_stat = 0,
	output ready,
	
	inout i2c_scl,
	inout i2c_sda
	
    );
	 
	 localparam
		f100 = 249,
		f400 = 62,
		f1mhz = 24,
		f3mhz = 7;
	 
	 reg clk = 1;
	 reg [7:0] ccount = 0;
	 reg [10:0] DIV = 0;
	 
	 wire [1:0] iscount;
	 wire [3:0] istate;
	 wire enable;
	 wire [1:0] bytcount;
	 wire [6:0] addr;
	 wire rw;
	 wire rep;
	 wire DA;
	 
	 assign ready = !i2c_stat[0];
	 assign rst = i2c_con1[0];
	 assign enable = i2c_con1[1];
	 assign bytcount = i2c_con1[3:2];
	 assign DA = i2c_con1[4];
	 assign rep =i2c_con1[5];
	 
	 assign addr = i2c_con2[7:1];
	 assign rw = i2c_con2[0];
	 
	 always @(posedge PCLK) begin
		i2c_stat[1] <= rw;
		i2c_stat[3:2] <= iscount;
		case(istate)
			0:i2c_stat[0] <= 1'b0;
			1:begin 
				i2c_stat[7:4] <= 4'b0001;
				i2c_stat[0] <= 1'b1;
			end
			2:i2c_stat[7:4] <= 4'b0010;
			3:i2c_stat[7:4] <= 4'b0100;
			4:i2c_stat[7:4] <= 4'b0010;
			5:i2c_stat[7:4] <= 4'b0010;
			6:i2c_stat[7:4] <= 4'b0100;
			7:i2c_stat[7:4] <= 4'b0100;
			8:i2c_stat[7:4] <= 4'b1000;
			9:i2c_stat[7:4] <= 4'b0001;
			default: i2c_stat <= 8'b0;
		endcase
	 end

	
	always @(*) begin
		case(i2c_con1[7:6])
			2'b00:DIV <= f100;
			2'b01:DIV <= f400;
			2'b10:DIV <= f1mhz;
			2'b11:DIV <= f3mhz;
			default:DIV <= f100;
		endcase
	end
	
	always @(posedge PCLK) begin
		if (ccount < DIV) begin
			ccount <= ccount + 1'b1;
		end
		else begin
			clk <= ~clk ;
			ccount <= 8'b0;
		end
	end

	i2c_master controller (
		.clk(clk), 
		.rst(rst), 
		.enable(enable), 
		.rw(rw),
		.addr(addr), 
		.Din(Din), 
		.i2c_scl(i2c_scl), 
		.i2c_sda(i2c_sda), 
		.Dout(Dout),
		.istate(istate),
		.bytcount(bytcount),
		.iscount(iscount),
		.DA(DA),
		.rep(rep)
	);
	 


endmodule
