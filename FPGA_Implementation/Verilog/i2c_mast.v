`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:34:13 12/13/2022 
// Design Name: 
// Module Name:    i2c_mast 
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
module i2c_mast(
	input wire clk,
	input wire rst,
	input wire enable,
	input rw,
	
	inout i2c_sda,
	inout i2c_scl,
	
	input wire [1:0] I,
	input wire [1:0] bytcount,
	input wire [6:0] addr,
	input wire [31:0] Din,
	
	//output [31:0] Dout,
	output ready,
	output [2:0] ADDRE,
	output [7:0] DATA
	
    );
	 
	 reg [7:0] rdata [3:0];
	 reg [7:0] wdata [3:0];
	 reg scl = 1;
	 reg sda = 1;
	 reg [7:0] sav_addr = 0;
	 reg [3:0] state = 0;
	 reg [3:0] nxt_state = 0;
	 reg [3:0] count = 0;
	 reg en = 0;
	 reg [1:0] scount = 0;
	 
	supply0 gnd; 
	assign i2c_scl = (scl) ? 1'bz : gnd;
	assign i2c_sda = (state == WACK || state == RDATA || state == WWACK || nxt_state == WACK || nxt_state == WWACK) ? 1'bz : ( (sda)? 1'bz : gnd );
	
	assign ready = (state == IDLE || (state == STOP)) ? 1'b1 : 1'b0;
	
	assign DATA = (rw) ? rdata[I][7:0] : wdata[I][7:0];
	assign ADDRE = addr[6:4];
	
//	assign Dout[7:0]   = rdata[3][7:0];
//	assign Dout[15:8]  = rdata[2][7:0];
//	assign Dout[23:16] = rdata[1][7:0];
//	assign Dout[31:24] = rdata[0][7:0];
	 
	 localparam 
		IDLE = 0,
		START = 1,
		ADDR = 2,
		WACK = 3,
		WDATA = 4,
		RDATA = 5,
		WWACK = 6,
		RACK = 7,
		STOP = 8;
		
	 
	 always @(posedge clk) begin
		if (en) scl <= ~scl;
		else scl <= 1;
	 end
	 
	 always @(posedge clk) begin
		if (!rst) begin
			state <= IDLE;
		end
		
		else begin
			state <= nxt_state;
		end
	 end
	 
	 
	 always @(negedge clk) begin
	 
		case (state) 
			IDLE: begin
				sda <= 1;
				en <= 0;
				count <= 1'b0;
				
				scount <= 2'b0;
//				rdata[0][7:0] <= 8'h00;
//				rdata[1][7:0] <= 8'h00;
//				rdata[2][7:0] <= 8'h00;
//				rdata[3][7:0] <= 8'h00;
				
				if (enable) nxt_state <= START;
				else nxt_state <= IDLE;
			end
			
			START: begin 
				sda <= 0;
				en <= 1;
				nxt_state <= ADDR;
				sav_addr[7:1] <= addr;
				sav_addr[0] <= rw;
				
//				rdata[0][7:0] <= 8'h00;
//				rdata[1][7:0] <= 8'h00;
//				rdata[2][7:0] <= 8'h00;
//				rdata[3][7:0] <= 8'h00;
				
				wdata[0][7:0] <= Din[31:24];
				wdata[1][7:0] <= Din[23:16];
				wdata[2][7:0] <= Din[15:8];
				wdata[3][7:0] <= Din[7:0];

				
			end
			
			ADDR: begin
				if (i2c_scl == 0) begin
					if (count < 8) begin
						sda <= sav_addr[4'h7-count];
						count <= count + 1'b1;
						nxt_state <= ADDR;
					end
					else if (count == 8) begin
						nxt_state <= WACK;
					end
				end
				else nxt_state <= ADDR;
			end
			
			WACK: begin
				sda <= i2c_sda;
				if (i2c_sda == 1) nxt_state <= STOP;
				else begin
					if (rw == 0)begin
						nxt_state <= WDATA;
					end
					else begin
						nxt_state <= RDATA;
					end
				end
				count <= 1'b0;
			end
			
			WDATA: begin
				if (i2c_scl == 0) begin
					if (count < 8) begin
						sda <= wdata[scount][4'h7-count];
						count <= count + 1'b1;
						nxt_state <= WDATA;
					end
					else if (count == 8) begin
						nxt_state <= WWACK;
					end
				end
				else nxt_state <= WDATA;
			end
			
			WWACK: begin
				sda <= i2c_sda;
				if (i2c_sda == 1) begin
					nxt_state <= WDATA;
					count <= 1'b0;
				end
				else begin
					if (scount != bytcount) begin
						nxt_state <= WDATA;
						scount <= scount + 1'b1;
						count <= 1'b0;
					end
					else
						nxt_state <= STOP;
				end			
			end
			
			RDATA: begin
				if (i2c_scl == 1) begin
					if (count < 7) begin
						rdata[scount][count] <= i2c_sda;
						count <= count + 1'b1;
						nxt_state <= RDATA;
					end
					else if (count == 7) begin
						nxt_state <= RACK;
						rdata[scount][count] <= i2c_sda;
					end
				end
				else nxt_state <= RDATA;
			end
			
			RACK: begin 
				if (i2c_scl == 0) begin
					sda <= 0;
					nxt_state <= RACK;
				end
				else if (i2c_scl == 1) begin
					sda <= 0;
					if (scount != bytcount) begin
						nxt_state <= RDATA;
						scount <= scount + 1'b1;
						count <= 0;
					end
					else
						nxt_state <= STOP;
				end
				else 
					nxt_state <= RACK;
			end
			
			STOP: begin
				scount <= 2'b0;
				count <= 2'b0;
				en <= 0;
				sda <= 0;
				if (i2c_scl == 1) begin
					sda <= 1;
					nxt_state <= IDLE;
				end
				else nxt_state <= STOP;
			end
			
			default: begin
				nxt_state <= IDLE;
				sda <= 1;
				count <= 1'b0;
				scount <= 2'b0;
				en <= 0;
				rdata[0][7:0] <= 8'h00;
				rdata[1][7:0] <= 8'h00;
				rdata[2][7:0] <= 8'h00;
				rdata[3][7:0] <= 8'h00;
				
				wdata[0][7:0] <= 8'h00;
				wdata[1][7:0] <= 8'h00;
				wdata[2][7:0] <= 8'h00;
				wdata[3][7:0] <= 8'h00;
			end
		endcase
	end

endmodule
