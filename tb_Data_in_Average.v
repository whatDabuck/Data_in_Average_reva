`timescale 1ns / 1ps

`define DATA_IN_WIDTH 12
`define DATA_OUT_WIDTH 21
`define SAMPLING_RATE 512
`define REPEAT_TIMES	4
module tb_Data_in_Average;

// port
reg                             clk, rst    ;
reg                             i_valid     ;
reg     [`DATA_OUT_WIDTH-1:0]     data_in     ;
wire    [`DATA_OUT_WIDTH-1:0]    o_average  ;
wire							 o_cnt_flag ;
// tb_signal
reg     [`DATA_IN_WIDTH-1:0]     fdata_in    ;

integer i, fp_in, fp_out, result;

always #5 clk = ~clk;

initial begin
//initialize value
$display("initialize value [%d]", $time);
   	  rst     <= 0;
   	  clk 	  <= 0;
	  i_valid <= 0;
	  data_in <= 0;
	  fp_in   <= $fopen("./test_c/ref_c_input.txt","rb");
	  fp_out  <= $fopen("./rtl_v_result.txt","wb");
// reset_n gen
$display("Reset! [%d]", $time);
# 100
    rst     <= 1;
# 10
    rst     <= 0;
# 10
@(negedge clk);
$display("Start! [%d]", $time);
	for(i=0 ; i<`SAMPLING_RATE*`REPEAT_TIMES ; i = i+1) begin
		@(posedge clk);
		i_valid <= 1;
		result  <= $fscanf(fp_in,"%d \n",fdata_in);
		data_in <= fdata_in;
		@(negedge clk);
	end
	  @(negedge clk);
	   i_valid <= 0;
	   data_in <= 0;
# 100


$fclose(fp_in);
$fclose(fp_out);

$display("Finish! [%d]", $time);
$finish;
end

always @ (*) begin
			if (o_cnt_flag) begin		
				$fwrite(fp_out, "result = %d\n", o_average);
			end
end

// Call DUT
Data_in_Average #
(
	.DATA_IN_WIDTH(`DATA_IN_WIDTH),
	.DATA_OUT_WIDTH(`DATA_OUT_WIDTH),
	.SAMPLING_RATE(`SAMPLING_RATE)
)
u_Data_in_Average(
	.clk(clk),
	.rst(rst),
	.i_valid(i_valid),
	.data_in(data_in),
	.o_cnt_flag(o_cnt_flag),
	.o_average(o_average)
);
endmodule

