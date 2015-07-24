`timescale 1 ns/1 ns

module fir_sync_tb;

reg	rst = 1'b1;
reg	clk = 1'b1;

always begin
  #10  clk = ~clk;
end

initial begin
	#50 rst = 1'b0;
end

reg	[9:0] data_in;
wire	[10:0] data_out;
wire  [9:0] x [0:99];

assign x[0] = -36;
assign x[1] = -480;
assign x[2] = 486;
assign x[3] = 294;
assign x[4] = -49;
assign x[5] = -243;
assign x[6] = -162;
assign x[7] = -424;
assign x[8] = -58;
assign x[9] = -253; 
assign x[10] = 283;
assign x[11] = -235; 
assign x[12] = 501; 
assign x[13] = 104; 
assign x[14] = 352; 
assign x[15] = -337; 
assign x[16] = 474; 
assign x[17] = -60; 
assign x[18] = 84; 
assign x[19] = -25; 
assign x[20] = 140; 
assign x[21] = -481; 
assign x[22] = 211; 
assign x[23] = 178; 
assign x[24] = -289; 
assign x[25] = 491; 
assign x[26] = -386; 
assign x[27] = 90; 
assign x[28] = -511; 
assign x[29] = -283; 
assign x[30] = -41; 
assign x[31] = 437; 
assign x[32] = 107; 
assign x[33] = -423; 
assign x[34] = -118; 
assign x[35] = -52; 
assign x[36] = 510; 
assign x[37] = -84;
assign x[38] = 329;
assign x[39] = -223; 
assign x[40] = -244; 
assign x[41] = 145; 
assign x[42] = 369; 
assign x[43] = -115; 
assign x[44] = 486; 
assign x[45] = 354; 
assign x[46] = -218; 
assign x[47] = -106; 
assign x[48] = -185; 
assign x[49] = -107; 
assign x[50] = 92; 
assign x[51] = -37; 
assign x[52] = -62; 
assign x[53] = -509; 
assign x[54] = 395; 
assign x[55] = -425; 
assign x[56] = -509; 
assign x[57] = 157; 
assign x[58] = -466; 
assign x[59] = 49; 
assign x[60] = 508; 
assign x[61] = -305; 
assign x[62] = -205; 
assign x[63] = -325; 
assign x[64] = -153; 
assign x[65] = -108; 
assign x[66] = -286; 
assign x[67] = 409; 
assign x[68] = 420; 
assign x[69] = 440; 
assign x[70] = -263; 
assign x[71] = 465; 
assign x[72] = 281; 
assign x[73] = -120; 
assign x[74] = 416; 
assign x[75] = -92; 
assign x[76] = 380; 
assign x[77] = 10; 
assign x[78] = 365; 
assign x[79] = 471; 
assign x[80] = 382; 
assign x[81] = 338; 
assign x[82] = -164; 
assign x[83] = 200; 
assign x[84] = 298; 
assign x[85] = -390; 
assign x[86] = -324; 
assign x[87] = 448; 
assign x[88] = -422; 
assign x[89] = -138; 
assign x[90] = -482; 
assign x[91] = 511; 
assign x[92] = -457; 
assign x[93] = 424; 
assign x[94] = 89; 
assign x[95] = -227; 
assign x[96] = 210; 
assign x[97] = -156; 
assign x[98] = 320; 
assign x[99] = -127;

integer i = 0;

always @(posedge clk) begin
	i <= (i + 1) % 100;
end

always @(posedge clk) begin
	data_in <= x[i];
end


fir_sync #(0, 0, 1, -2, 2, 0, -7, 38, 38, -7, 0, 2, -2, 1, 0, 0)
  dut(
  .clk(clk),
  .rst(rst),
  .din(data_in),
  .dout(data_out)
);

endmodule
