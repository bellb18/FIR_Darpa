`timescale 100 ps/100 ps

module fir_sync_tb;

reg	rst = 1'b1;
reg	clk = 1'b1;

always begin
  #50  clk = ~clk;
end

initial begin
	#40 rst = 1'b0;
end

integer data_in;
wire	[10:0] data_out;
integer x [0:99];

initial begin
x[0] = -36;
x[1] = -480;
x[2] = 486;
x[3] = 294;
x[4] = -49;
x[5] = -243;
x[6] = -162;
x[7] = -424;
x[8] = -58;
x[9] = -253; 
x[10] = 283;
x[11] = -235; 
x[12] = 501; 
x[13] = 104; 
x[14] = 352; 
x[15] = -337; 
x[16] = 474; 
x[17] = -60; 
x[18] = 84; 
x[19] = -25; 
x[20] = 140; 
x[21] = -481; 
x[22] = 211; 
x[23] = 178; 
x[24] = -289; 
x[25] = 491; 
x[26] = -386; 
x[27] = 90; 
x[28] = -511; 
x[29] = -283; 
x[30] = -41; 
x[31] = 437; 
x[32] = 107; 
x[33] = -423; 
x[34] = -118; 
x[35] = -52; 
x[36] = 510; 
x[37] = -84;
x[38] = 329;
x[39] = -223; 
x[40] = -244; 
x[41] = 145; 
x[42] = 369; 
x[43] = -115; 
x[44] = 486; 
x[45] = 354; 
x[46] = -218; 
x[47] = -106; 
x[48] = -185; 
x[49] = -107; 
x[50] = 92; 
x[51] = -37; 
x[52] = -62; 
x[53] = -509; 
x[54] = 395; 
x[55] = -425; 
x[56] = -509; 
x[57] = 157; 
x[58] = -466; 
x[59] = 49; 
x[60] = 508; 
x[61] = -305; 
x[62] = -205; 
x[63] = -325; 
x[64] = -153; 
x[65] = -108; 
x[66] = -286; 
x[67] = 409; 
x[68] = 420; 
x[69] = 440; 
x[70] = -263; 
x[71] = 465; 
x[72] = 281; 
x[73] = -120; 
x[74] = 416; 
x[75] = -92; 
x[76] = 380; 
x[77] = 10; 
x[78] = 365; 
x[79] = 471; 
x[80] = 382; 
x[81] = 338; 
x[82] = -164; 
x[83] = 200; 
x[84] = 298; 
x[85] = -390; 
x[86] = -324; 
x[87] = 448; 
x[88] = -422; 
x[89] = -138; 
x[90] = -482; 
x[91] = 511; 
x[92] = -457; 
x[93] = 424; 
x[94] = 89; 
x[95] = -227; 
x[96] = 210; 
x[97] = -156; 
x[98] = 320; 
x[99] = -127;
end

integer c_0 = 0;
integer c_1 = 0;
integer c_2 = 1;
integer c_3 = -2;
integer c_4 = 2;
integer c_5 = 0;
integer c_6 = 7;
integer c_7 = 38;
integer c_8 = 38;
integer c_9 = -7;
integer c_10 = 0;
integer c_11 = 2;
integer c_12 = -2;
integer c_13 = 1;
integer c_14 = 0;
integer c_15 = 0;

reg	[16:0]	dout_reg;
wire	[10:0]  dout_test;

integer i = 0;
assign dout_test[10:0] = dout_reg[15:5];
reg signed [9:0]	din_reg [15:0];

always @(posedge clk) begin
	if (rst) begin
		for (i = 0; i < 16; i = i + 1) begin
			din_reg[i] <= 0;
		end
	end
	else begin
		din_reg[0] <= data_in[9:0];
		din_reg[1] <= din_reg[0];
		din_reg[2] <= din_reg[1];
		din_reg[3] <= din_reg[2];
		din_reg[4] <= din_reg[3];
		din_reg[5] <= din_reg[4];
		din_reg[6] <= din_reg[5];
		din_reg[7] <= din_reg[6];
		din_reg[8] <= din_reg[7];
		din_reg[9] <= din_reg[8];
		din_reg[10] <= din_reg[9];
		din_reg[11] <= din_reg[10];
		din_reg[12] <= din_reg[11];
		din_reg[13] <= din_reg[12];
		din_reg[14] <= din_reg[13];
		din_reg[15] <= din_reg[14];
	end
end

always @(posedge clk) begin

	              dout_reg <= din_reg[0] * c_0 + din_reg[1] * c_1 + din_reg[2] * c_2 + din_reg[3] * c_3 
			+ din_reg[4] * c_4 + din_reg[5] * c_5 + din_reg[6] * c_6 + din_reg[7] * c_7 
			+ din_reg[8] * c_8 + din_reg[9] * c_9 + din_reg[10] * c_10 + din_reg[11] * c_11
			+ din_reg[12] * c_12 + din_reg[13] * c_13 + din_reg[14] * c_14 + din_reg[15] * c_15;
end

integer j = 0;
always @(posedge clk) begin
	if (rst) begin
		j <= 0;
	end
	else begin
		j <= (j + 1) % 100;
	end
end

always @(negedge clk) begin
	data_in <= x[j];
end


fir_sync #(0, 0, 1, -2, 2, 0, -7, 38, 38, -7, 0, 2, -2, 1, 0, 0)
  dut(
  .clk(clk),
  .rst(rst),
  .din(data_in),
  .dout(data_out)
);

endmodule
