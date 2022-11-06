`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:24:51 10/29/2022 
// Design Name: 
// Module Name:    apb_slave 
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

module apb_slave(
	input wire PCLK,
	input wire PRESETn,
   input wire PSEL,
	input wire PENABLE,
	input wire PWrite,
	input wire [31:0] PADDR,
	input wire [31:0] PWDATA,
	input wire [31:0] Dout, // from i2c
	input wire ready,
	input wire [7:0] i2c_stat,
	//input wire slverr,
	
	output reg [7:0] i2c_con1 = 0,
	output reg [7:0] i2c_con2 = 0,
	output reg [31:0] PRDATA = 0,
	output reg [31:0] Din = 0, // to i2c
	output  PREADY,
	output  reg PSLVERR = 0

	);
	
		
	localparam IDLE = 0;
	localparam SETUP = 1;
	localparam ACCESS = 2;
	
	
	
	reg [1:0] nxt_state;
	reg [1:0] en = 0;
	reg [1:0] state;
	
	//assign PREADY = (((PADDR[31:24] == 8'h00) ) || ready) ? 1'b1 : 1'b0;
	assign PREADY = (state == 2 || ready) ? 1'b1 : 1'b0;
	
	//assign PSLVERR = (PENABLE && ((en == 1) && !ready)) ? 1'b1 : 1'b0;
	
	//assign PSLVERR = (PENABLE && (  (en == 1) && !ready   ) ) ? 1'b1 : 1'b0;
	
	
		always @(posedge PCLK) begin
			if (!PRESETn) begin
				state <= IDLE;
			end
			
			else begin
				state <= nxt_state;
//				PREADY <= ((PADDR[31:24] == 8'h00) || ready) ? 1'b1 : 1'b0;
//				PSLVERR <= ((PADDR[31:24] != 8'h00) || !ready) ? 1'b1 : 1'b0; //slverr;
			end
		end
		
		always @(posedge PCLK or negedge PCLK) begin
			if (en == 1) begin
				if(PADDR[31:24] == 8'h00) begin
					i2c_con1 <= PWDATA[7:0];
					i2c_con2 <= PWDATA[15:8];
					PSLVERR <= (!ready) ? 1'b1 : 1'b0;
				end
				else begin
					Din <= PWDATA;
					PSLVERR <= (!ready) ? 1'b1 : 1'b0;
				end
			end
			else if (en == 2) begin
				if(PADDR[31:24] == 8'h00) begin
					PRDATA[7:0] <= i2c_con1;
					PRDATA[15:8] <= i2c_con2;
					PRDATA[23:16] <= i2c_stat;
					PSLVERR <= 1'b0;
				end
				else begin
					PRDATA <= Dout;
					PSLVERR <= (!ready) ? 1'b1 : 1'b0;
				end
			end
			else begin
				if (i2c_stat[7] == 1 && i2c_stat[0] == 0) begin
					i2c_con1 <= 0;
					//i2c_con2 <= 0;
				end
			end
			
		end
	
		always @(*) begin	
		
			case (state) 
				IDLE: begin
					en <= 0;
					if (PSEL == 1) begin
						nxt_state <= SETUP;
					end
					else begin
						nxt_state <= IDLE;
					end
	
				end
				
				SETUP: begin
					en <= 0;
					if (PENABLE == 1 && PSEL == 1) begin
						nxt_state <= ACCESS;
					end
					
					else if (PSEL == 0) begin
						nxt_state <= IDLE;
						//PSLVERR <= 1;
					end
					
					else begin
						nxt_state <= SETUP;
						//PSLVERR <= 0;
					end
						
				end
				
				ACCESS: begin
					if (PREADY == 1 && PWrite == 1 && PSEL == 1 && PENABLE == 1) begin	// write					
						en <= 1;
						nxt_state <= IDLE;
					end
					
					else if (PREADY == 1 && PWrite == 0 && PSEL == 1 && PENABLE == 1) begin //read
						en <= 2;
						nxt_state <= IDLE;
					end
					
					else if (PSEL == 0) begin
						en <= 0;
						nxt_state <= IDLE;
					end
					
					else if (PENABLE == 0 && PSEL == 1) begin
						en <= 0;
						nxt_state <= SETUP;
					end
					else begin
						en <= 0;
						nxt_state <= ACCESS;
					end
				end

				default: begin
					nxt_state <= IDLE;
					en <= 0;
				end
				
			endcase
		end
		  
endmodule

