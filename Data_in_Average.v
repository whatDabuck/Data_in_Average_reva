`timescale 1ns / 1ps
module Data_in_Average #
(
	parameter DATA_IN_WIDTH = 12,
	parameter SAMPLING_RATE = 512,
	parameter DATA_OUT_WIDTH = DATA_IN_WIDTH + $clog2(SAMPLING_RATE)
)

(
    input 							clk,
    input 							rst,
    input							i_valid,
    input	[DATA_OUT_WIDTH-1:0] 	data_in,
	output	[DATA_OUT_WIDTH-1:0]	o_average,
	output							o_cnt_flag
);
	
	/////// reg ////////
	reg			[$clog2(SAMPLING_RATE):0]					cnt_signal_i;
	reg			[DATA_IN_WIDTH-1:0]							r_average;
	
	reg			[DATA_OUT_WIDTH-1:0]						r_data_in_stx;
	reg														r_valid;
	wire		[DATA_OUT_WIDTH-1:0]						w_data_in_stx;

	// Cnt Gen
	always @(posedge clk or posedge rst)
	begin
		if (rst) begin
			cnt_signal_i 	<= 'd0	;
			r_data_in_stx	<= 'd0	;
		end else if (cnt_signal_i == SAMPLING_RATE-1) begin
			cnt_signal_i	<= 'd0	;
			r_data_in_stx	<= 'd0	;
		end else if (i_valid) begin
			cnt_signal_i	<= cnt_signal_i + 1;
			r_data_in_stx	<= w_data_in_stx;
		end
	end

	// Gen Data_in_Average_nd
	always @ (posedge clk or posedge rst) begin
		if (rst) begin
			r_valid					<=		1'b0;
		end else begin
			r_valid					<=		i_valid;

		end
	end

	// Data_in_Average
	always @(posedge clk or posedge rst) begin
		if (rst) begin
			 r_average			<=	'd0;
		end else if (cnt_signal_i == SAMPLING_RATE-1)	 begin
			 r_average			<=	w_data_in_stx[DATA_OUT_WIDTH-1 : $clog2(SAMPLING_RATE)];
		end
	end

	// Restore stx value
	// always @ (posedge clk or posedge rst) begin
	// 	if (rst) begin
	// 		r_data_in_stx	<= 'd0;
	// 	end else begin
	// 		r_data_in_stx	<= w_data_in_stx;
	// 	end
	// end

	assign o_cnt_flag	= (i_valid == 1) && (cnt_signal_i == 0);
	assign w_data_in_stx = data_in + r_data_in_stx ;	
	assign o_average =  r_average;

endmodule