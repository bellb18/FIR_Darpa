-- Note that the mulipilers and adders have registers on the input and output of them in this design
library IEEE;
use IEEE.std_logic_1164.all;
use work.Sync_gates.all;
entity FIR_Liang_Sync_Sleep is
	port(x                                                                                                                    : in  std_logic_vector(9 downto 0);
		 cin_0, cin_1, cin_2, cin_3, cin_4, cin_5, cin_6, cin_7, cin_8, cin_9, cin_10, cin_11, cin_12, cin_13, cin_14, cin_15 : in  std_logic_vector(6 downto 0);
		 clk                                                                                                                  : in  std_logic;
		 rst                                                                                                                  : in  std_logic;
		 sleep                                                                                                                : in  std_logic;
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
	
	type Stage1 is array (15 downto 0) of STD_LOGIC_VECTOR(15 downto 0);
	type Stage2 is array (7 downto 0) of STD_LOGIC_VECTOR(15 downto 0);
	type Stage3 is array (3 downto 0) of STD_LOGIC_VECTOR(15 downto 0);
	type Stage4 is array (1 downto 0) of STD_LOGIC_VECTOR(15 downto 0);
	type Ytype is array (1 to 15) of STD_LOGIC_VECTOR(15 downto 0);
	signal Xarray : XtypeSync;
	signal output : std_logic_vector(15 downto 0);
	signal c	  : CtypeSync;
	--signal sleep : std_logic;
	-- Stages for the different adders
	signal S1	  : Stage1;
	signal S2     : Stage2;
	signal S3     : Stage3;
	signal S4     : Stage4;

begin
	--detector : sleep_detector
		--port map(clk, x, rst, sleep);
	
	Xarray(0) <= x;
	
	GenAdd1: for i in 0 to 7 generate 
		Adder: Carry_Select_16b_sleep
		port map(S1(2*i), S1(2*i + 1), clk, rst, sleep, S2(i));
	end generate;
	
	GenAdd2: for i in 0 to 3 generate
		Adder: Carry_Select_16b_sleep
		port map(S2(2*i), S2(2*i + 1), clk, rst, sleep, S3(i));
	end generate;

	GenAdd3: for i in 0 to 1 generate
		Adder: Carry_Select_16b_sleep
		port map(S3(2*i), S3(2*i + 1), clk, rst, sleep, S4(i));
	end generate;
	
	FinalAdder: Carry_Select_16b_sleep
		port map(S4(0), S4(1), clk, rst, sleep, output);

	GenMult : for i in 15 downto 0 generate
		Mult : Dadda_Pipelined_Sync_Sleep
			port map(Xarray(i), c(i), clk, rst, sleep, S1(i));
	end generate GenMult;

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