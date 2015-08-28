-- Note that the mulipilers and adders have registers on the input and output of them in this design
library IEEE;
use IEEE.std_logic_1164.all;
use work.Sync_gates.all;
entity FIR_Liang_Sync_Sleep is
	port(x                                                                                                                    : in  std_logic_vector(9 downto 0);
		 cin_0, cin_1, cin_2, cin_3, cin_4, cin_5, cin_6, cin_7, cin_8, cin_9, cin_10, cin_11, cin_12, cin_13, cin_14, cin_15 : in  std_logic_vector(6 downto 0);
		 clk                                                                                                                  : in  std_logic;
		 rst                                                                                                                  : in  std_logic;
		 --sleep                                                                                                                : in  std_logic;
		 y                                                                                                                    : out std_logic_vector(10 downto 0));
end;

architecture arch of FIR_Liang_Sync_Sleep is
	component Dadda_Pipelined_Sync_Sleep is
		port(x   : in  std_logic_vector(9 downto 0);
			 y   : in  std_logic_vector(6 downto 0);
			 clk : in  std_logic;
			 rst : in  std_logic;
			 sleep : in std_logic;
			 p   : out std_logic_vector(15 downto 0));
	end component;

	component Carry_Select_16b_Sleep is
		port(
			X   : in  std_logic_vector(15 downto 0);
			Y   : in  std_logic_vector(15 downto 0);
			clk : in  std_logic;
			rst : in  std_logic;
			sleep : in std_logic;
			S   : out std_logic_vector(15 downto 0)
		);
	end component;

	component reg_gen_sleep is
		generic(width : integer := 16);
		port(
			D   : in  std_logic_vector(width - 1 downto 0);
			clk : in  std_logic;
			rst : in  std_logic;
			sleep : in std_logic;
			Q   : out std_logic_vector(width - 1 downto 0));
	end component;
	
	component sleep_detector is
   		port (
			clk      : in   std_logic;
			x    	   : in   std_logic_vector(9 downto 0);
			reset    : in   std_logic;
			output   : out  std_logic);
	end component;
	

	type Ytype is array (1 to 15) of STD_LOGIC_VECTOR(15 downto 0);
	signal Xarray : XtypeSync;
	signal A      : Ytype;
	signal B      : Ytype;
	signal output : std_logic_vector(15 downto 0);
	signal c	  : CtypeSync;
	signal sleep : std_logic;

begin
	detector : sleep_detector
		port map(clk, x, rst, sleep);
	
	ADDER15 : Carry_Select_16b_Sleep
		port map(A(15), B(15), clk, rst, sleep, output);

	GenAdder : for i in 14 downto 1 generate
		ADDER : Carry_Select_16b_Sleep
			port map(A(i), B(i), clk, rst, sleep, A(i + 1));
	end generate GenAdder;

	GenMult : for i in 15 downto 1 generate
		Mult : Dadda_Pipelined_Sync_Sleep
			port map(Xarray(i), c(i), clk, rst, sleep, B(i));
	end generate GenMult;

	Mult0 : Dadda_Pipelined_Sync_Sleep
		port map(X, c(0), clk, rst, sleep, A(1));

	ShiftReg0 : reg_gen_sleep
		generic map(10)
		port map(x, clk, rst, sleep, Xarray(1));

	GenReg : for i in 13 downto 1 generate
		ShiftReg : reg_gen_sleep
			generic map(10)
			port map(Xarray(i), clk, rst, sleep, Xarray(i + 1));
	end generate GenReg;

	ShiftReglast : reg_gen_sleep
		generic map(10)
		port map(Xarray(14), clk, rst, sleep, Xarray(15));

	y <= output(15 downto 5);
	
	c(0) <= cin_0;
	c(1) <= cin_1;
	c(2) <= cin_2;
	c(3) <= cin_3;
	c(4) <= cin_4;
	c(5) <= cin_5;
	c(6) <= cin_6;
	c(7) <= cin_7;
	c(8) <= cin_8;
	c(9) <= cin_9;
	c(10) <= cin_10;
	c(11) <= cin_11;
	c(12) <= cin_12;
	c(13) <= cin_13;
	c(14) <= cin_14;
	c(15) <= cin_15;
	

end arch;