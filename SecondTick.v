/*	SecondTick.v
	Generates a pulse every second.
	
	Copyright 2017 Patrick Cland */
`timescale 1ns/1ps
module SecondTick(CLK, RST, Tick);
	input CLK;
	input RST;
	output reg Tick;
	
	//Artix 7 running at 100MHz
	parameter CLOCKSPEED = 100000000;
	
	//27 Bits required to count to 100 million
	reg[26:0] Counter;
	
	always @ (posedge CLK or posedge RST) begin
		if(RST) begin
			Tick <= 1'b0;
			Counter <= 27'd0;
		end else begin
			Counter <= Counter + 1;
			if(Counter == CLOCKSPEED) begin
				Tick <= 1'b1;
				Counter <= 27'd0;
			end else begin
				Tick <= 1'b0;
			end
		end
	end
endmodule