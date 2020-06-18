/*	HoursDigits.v - Modified
	Module for behavior of hours counter.
	
	Copyright 2017 Patrick Cland */
`timescale 1ns/1ps
module HoursDigits(CLK, RST, InTick, EditEnable, Increment, MSD, LSD);
	input CLK;
	input RST;
	input InTick;
	input EditEnable;
	input Increment;
	output reg[3:0] MSD;
	output reg[3:0] LSD;
	
	always @ (posedge CLK or posedge RST) begin
		if(RST) begin
			MSD <= 4'b0000;
			LSD <= 4'b0000;
		end else if(InTick || (EditEnable && Increment)) begin
			LSD <= LSD + 1'b1;
			//if 24 hours have passed, reset
			if(MSD == 4'b0010 && LSD == 4'b0011) begin
				MSD <= 4'b0000;
				LSD <= 4'b0000;
			end
			//When LSD reaches 10, set to 0 and increment MSD
			if(LSD == 4'b1001) begin
				LSD <= 4'b0000;
				MSD <= MSD + 1'b1;
			end
		end else begin
		end
	end
endmodule