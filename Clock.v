/*	Clock.v
	Top Module for Clock Project
	
	Copyright 2017 Patrick Cland */
`timescale 1ns/1ps
module Clock(CLK, RST, ButtonMode, ButtonDigit, ButtonValue, DigitEnable, DigitValue);
	input CLK;
	input RST;
	input ButtonMode, ButtonDigit, ButtonValue;
	output[5:0] DigitEnable;
	output[6:0] DigitValue;
	
	//Pulsed every second
	wire SecondTick;
	wire MinuteTick;
	wire HourTick;
	
	wire[3:0] SecMSD, SecLSD, MinMSD, MinLSD, HourMSD, HourLSD;
	wire[2:0] ActiveDigit;
	wire IncrementDigit;
	
	wire GlobalPause;
	wire[2:0] EnableEdit;
	
	
	SecondTick T1(	.CLK(CLK),
					.RST(RST),
					.Tick(SecondTick));
					
	Adjust A1(	.CLK(CLK),
				.RST(RST),
				.ButtonMode(ButtonMode),
				.ButtonDigit(ButtonDigit),
				.ButtonValue(ButtonValue),
				.Editing(GlobalPause),
				.Digit(ActiveDigit),
				.IncrementDigit(IncrementDigit));
				
	SecondsMinutesDigits S1(	.CLK(CLK),
								.RST(RST),
								.InTick(SecondTick & ~GlobalPause),
								.EditEnable(ActiveDigit[0] & GlobalPause),
								.Increment(IncrementDigit),
								.OutTick(MinuteTick),
								.MSD(SecMSD),
								.LSD(SecLSD));
				
	SecondsMinutesDigits S2(	.CLK(CLK),
								.RST(RST),
								.InTick(MinuteTick & ~GlobalPause),
								.EditEnable(ActiveDigit[1] & GlobalPause),
								.Increment(IncrementDigit),
								.OutTick(HourTick),
								.MSD(MinMSD),
								.LSD(MinLSD));
							
	HoursDigits H1(	.CLK(CLK),
					.RST(RST),
					.InTick(HourTick & ~GlobalPause),
					.EditEnable(ActiveDigit[2] & GlobalPause),
					.Increment(IncrementDigit),
					.MSD(HourMSD),
					.LSD(HourLSD));
		
	SevenSegmentDriver S3(	.CLK(CLK),
							.RST(RST),
							.HourMSD(HourMSD),
							.HourLSD(HourLSD),
							.MinMSD(MinMSD),
							.MinLSD(MinLSD),
							.SecMSD(SecMSD),
							.SecLSD(SecLSD),
							.DigitEnable(DigitEnable),
							.DigitValue(DigitValue));
endmodule