/*	SecondsMinutesDigits.v - Edited
	Module for behavior of minutes and seconds counters.
	
	Copyright 2017 Patrick Cland */
`timescale 1ns/1ps
module SecondsMinutesDigits(CLK, RST, InTick, EditEnable, Increment, OutTick, MSD, LSD);
	input CLK;
	input RST;
	input InTick;
	input EditEnable;
	input Increment;
	output reg OutTick;
	output reg[3:0] MSD;
	output reg[3:0] LSD;
	
	always @ (posedge CLK or posedge RST) begin
		if(RST) begin
			OutTick <= 1'b0;
			MSD <= 4'b0000;
			LSD <= 4'b0000;
		end else if(InTick || (EditEnable && Increment)) begin
			LSD <= LSD + 1'b1;
			//When LSD reaches 10, set to 0 and increment MSD
			if(LSD == 4'b1001) begin
				LSD <= 4'b0000;
				MSD <= MSD + 1'b1;
				//When MSD reaches 6, 60 seconds have passed. Reset everything to 0 and output a minute tick
				if(MSD == 4'b0101) begin
					LSD <= 4'b0000;
					MSD <= 4'b0000;
					OutTick <= 1'b1;
				end
			end
		end else begin
			OutTick <= 1'b0;
		end
	end
endmodule