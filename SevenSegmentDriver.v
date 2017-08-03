/*	SevenSegmentDriver.v
	Controls BCD to Seven Segment conversion and display multiplexing.
	
	Copyright 2017 Patrick Cland */
module SevenSegmentDriver(CLK, RST, HourMSD, HourLSD, MinMSD, MinLSD, SecMSD, SecLSD, DigitEnable, DigitValue);
	input CLK;
	input RST;
	input[3:0] HourMSD, HourLSD, MinMSD, MinLSD, SecMSD, SecLSD;
	output reg[5:0] DigitEnable;
	output[6:0] DigitValue;
	
	wire Pulse;
	
	reg[3:0] BCDValue;
	
	//When pulse is received, change digit to output
	Pulse333Hz P1(.CLK(CLK), .RST(RST), .PulseOut(Pulse));
	SevenSegmentROM S1(.Address(BCDValue), .Data(DigitValue));
	
	reg[2:0] Count;
	
	always @ (posedge CLK or posedge RST) begin
		if(RST) begin
			Count <= 3'b000;
		end else begin
			if(Pulse) begin
				Count <= Count + 1'b1;
				if(Count == 3'b101) begin
					Count <= 3'b000;
				end
			end
		end
	end
	
	always @ (Count or SecLSD or SecMSD or MinLSD or MinMSD or HourLSD or HourMSD) begin
		case(Count)
			3'b000: begin DigitEnable = 6'b000001; BCDValue = SecLSD; end
			3'b001: begin DigitEnable = 6'b000010; BCDValue = SecMSD; end
			3'b010: begin DigitEnable = 6'b000100; BCDValue = MinLSD; end
			3'b011: begin DigitEnable = 6'b001000; BCDValue = MinMSD; end
			3'b100: begin DigitEnable = 6'b010000; BCDValue = HourLSD; end
			3'b101: begin DigitEnable = 6'b100000; BCDValue = HourMSD; end
			3'b110: begin DigitEnable = 6'b000000; BCDValue = SecLSD; end
			3'b111: begin DigitEnable = 6'b000000; BCDValue = SecLSD; end
		endcase
	end
endmodule

module Pulse333Hz(CLK, RST, PulseOut);
	input CLK;
	input RST;
	output reg PulseOut;
	
	//19 bits to count to 300,000
	reg[18:0] Count;
	
	always @ (posedge CLK or posedge RST) begin
		if(RST) begin
			Count <= 18'd0;
			PulseOut <= 1'b0;
		end else begin
			Count <= Count + 1'b1;
			if(Count == 30000) begin
				Count <= 18'd0;
				PulseOut <= 1'b1;
			end else begin
				PulseOut <= 1'b0;
			end
		end
	end
endmodule

module SevenSegmentROM(Address, Data);
	input[3:0] Address;
	output reg [6:0] Data;
	always @ (Address) begin
		//Active Low!
		case(Address)
			4'b0000: Data = 7'b0000001;
			4'b0001: Data = 7'b1001111;
			4'b0010: Data = 7'b0010010;
			4'b0011: Data = 7'b0000110;
			4'b0100: Data = 7'b1001100;
			4'b0101: Data = 7'b0100100;
			4'b0110: Data = 7'b0100000;
			4'b0111: Data = 7'b0001111;
			4'b1000: Data = 7'b0000000;
			4'b1001: Data = 7'b0000100;
			default: Data = 7'b1111111;
		endcase
	end
endmodule