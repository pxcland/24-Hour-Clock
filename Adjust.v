/*	Adjust.v
	Controls operation mode and allows changing of time.
	
	Copyright 2017 Patrick Cland */
`timescale 1ns / 1ps
module Adjust(CLK, RST, ButtonMode, ButtonDigit, ButtonValue, Editing, Digit, IncrementDigit);
	input CLK, RST;
	input ButtonMode; 
	input ButtonDigit;
	input ButtonValue;
	output reg Editing;
	output reg[2:0] Digit;
	output wire IncrementDigit;

	wire ButtonModePressed, ButtonDigitPressed, ButtonValuePressed;
	
	ButtonHandler B1(.CLK(CLK), .Button(ButtonMode), .Pulse(ButtonModePressed));
	ButtonHandler B2(.CLK(CLK), .Button(ButtonDigit), .Pulse(ButtonDigitPressed));																		   
	ButtonHandler B3(.CLK(CLK), .Button(ButtonValue), .Pulse(IncrementDigit));
	
	always @ (posedge CLK or posedge RST) begin
		if(RST) begin
			Editing <= 1'b0;
			Digit <= 3'b001;
		end else begin
			if(ButtonModePressed) begin
				Editing <= ~Editing;
				Digit <= 3'b001;
			end
			if(ButtonDigitPressed) begin
				Digit <= {Digit[1:0], Digit[2]};
			end
		end
	end
endmodule
	
module ButtonHandler(CLK, Button, Pulse);
	input CLK;
	input Button;
	output Pulse;
	
	reg SyncPress;
	reg Latch;
	//18 bit counter, requires button to be pressed for 10ms to be registered as press
	reg[17:0] Count;
	
	wire Max;
	
	assign Max = &Count;

	always @ (posedge CLK) begin
		SyncPress <= Button;
	end
	
	always @ (posedge CLK) begin
		if(~SyncPress) begin
			Latch <= 1'b0;
		end else begin
			if(Pulse) begin
				Latch <= 1'b1;
			end else begin
				Latch <= Latch;
			end
		end
	end
	
	always @ (posedge CLK) begin
		if(~SyncPress) begin
			Count <= 0;
		end else begin
			Count <= Count + 1'b1;
		end
	end
	assign Pulse = ~Latch & SyncPress & Max;
endmodule