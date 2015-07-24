module fir_sync (
	clk,
	rst,
	din,
	dout
);

input		clk;
input		rst;
input	[9:0]	din;

parameter c_0  = 1;
parameter c_1  = 1;
parameter c_2  = 1;
parameter c_3  = 1;
parameter c_4  = 11;
parameter c_5  = 1;
parameter c_6  = 1;
parameter c_7  = 1;
parameter c_8  = 1;
parameter c_9  = 1;
parameter c_10 = 1;
parameter c_11 = 1;
parameter c_12 = 1;
parameter c_13 = 1;
parameter c_14 = 1;
parameter c_15 = 1;

output	[10:0]	dout;

reg	[9:0]	din_reg [0:15];
reg	[16:0]	dout_reg;

parameter size = 16;

integer  i;
assign dout[10:0] = dout_reg[15:5];

always @(posedge clk) begin
	if (rst) begin
		for (i = 0; i < size; i = i + 1) begin
			din_reg[i] <= 0;
		end
	end
	else begin
		din_reg[0] <= din;
		for (i = 1; i < size; i= i + 1) begin
			din_reg[i] <= din_reg[i-1];
		end
	end
end

always @(posedge clk) begin
	if (rst) begin
		dout_reg <= 0;
	end
	else begin
		dout_reg <= din_reg[0] * c_0 + din_reg[1] * c_1 + din_reg[2] * c_2 + din_reg[3] * c_3 
			+ din_reg[4] * c_4 + din_reg[5] * c_5 + din_reg[6] * c_6 + din_reg[7] * c_7 
			+ din_reg[8] * c_8 + din_reg[9] * c_9 + din_reg[10] * c_10 + din_reg[11] * c_11
			+ din_reg[12] * c_12 + din_reg[13] * c_13 + din_reg[14] * c_14 + din_reg[15] * c_15;
	end
end

endmodule
