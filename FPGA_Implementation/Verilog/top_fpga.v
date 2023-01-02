`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: VINAYAK K P
// 
// Create Date:    20:18:07 12/13/2022 
// Design Name: 
// Module Name:    top_fpga 
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
module top_fpga(
	input wire PCLK,
	input wire PRESETn,
	input wire PSEL,
	input wire PENABLE,
	input wire PWrite,
	input wire [3:0] button,
	
	inout i2c_sda,
	inout i2c_scl,
	
	output PREADY,
	
	output [2:0] ADDRE,
	output [7:0] DATA
    );
	
	//////change PADDR,PWDATA,length,frequency  here //////
	localparam [15:0] FREQ = 15'd24999;//7;//24999;
	localparam [6:0] slave_address = 7'b101_0111; //7'd87;
	localparam [31:0] data_sent = 32'habcd_ef98;
	localparam [1:0] length = 3;
	///////////////////////////////////////
	
	wire rw;
	wire ready;
	wire enable;
	
	reg clk = 1;
	reg [1:0] bytcount = 0;
	
	reg [6:0] PADDR = 0;
	reg [31:0] PWDATA = 0;
	
	reg [15:0] ccount = 0;
	reg [1:0] I = 0;
	
	assign rw = ~PWrite;
	assign PREADY = ready;
	assign enable = PSEL & PENABLE;
	
	always @(*) begin
		case(button)
			4'b0000: I <= 2'b00;
			4'b0001: I <= 2'b00;
			4'b0010: I <= 2'b01;
			4'b0100: I <= 2'b10;
			4'b1000: I <= 2'b11;
			default: I <= 2'b00;
		endcase
	end
	
	
	always @(posedge PCLK) begin
		if (PRESETn) begin
			PADDR <= slave_address;
			PWDATA <= data_sent;
			bytcount <= length;
		end
	end
	
	always @(posedge PCLK) begin
		if (PRESETn) begin
			if (ccount == FREQ) begin
				clk <= ~clk;
				ccount <= 0;
			end
			else ccount <= ccount + 1'b1;
		end
		else begin
			ccount <= 0;
			clk <= 1;
		end
		
	end
	
	i2c_mast mast (
		//from apb
		.clk(clk), 
		.rst(PRESETn), 
		.enable(enable), 
		.rw(rw),  
		.bytcount(bytcount),
		.addr(PADDR), 
		.Din(PWDATA),
		//to apb
		.ready(ready),
		//.rdata(PRDATA),
		//to slave
		.i2c_sda(i2c_sda),
		.i2c_scl(i2c_scl),
		//top
		.DATA(DATA),
		.ADDRE(ADDRE),
		.I(I)
	);

	
	
	
endmodule
