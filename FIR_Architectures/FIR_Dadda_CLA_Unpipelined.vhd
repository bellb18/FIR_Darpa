Library IEEE;
use IEEE.std_logic_1164.all;
use work.ncl_signals.all;
use work.FIR_pack.all;
entity FIR_Dadda_CLA_Unpipelined is
	port(x     : in  dual_rail_logic_vector(9 downto 0);
		 c     : in  Ctype;
		 ki    : in  std_logic;
		 rst   : in  std_logic;
		 sleep : in  std_logic;
		 ko    : out std_logic;
		 sleepout : out std_logic;
		 y     : out dual_rail_logic_vector(10 downto 0));
end;

architecture arch of FIR_Dadda_CLA_Unpipelined is
	component Dadda_Unpipelined is
	port(x             : in  dual_rail_logic_vector(9 downto 0);
		 y             : in  dual_rail_logic_vector(6 downto 0);
		 sleep 		   : in  std_logic;
		 p        : out dual_rail_logic_vector(15 downto 0));
	end component;

	component CLA_16m is
	port(
		X    : in  dual_rail_logic_vector(15 downto 0);
		Y    : in  dual_rail_logic_vector(15 downto 0);
		sleep : in  std_logic;
		S   : out dual_rail_logic_vector(15 downto 0)
	);
	end component;

	component ShiftRegMTNCL is
		generic(width : in integer    := 4;
			    value : in bit_vector := "0110");
		port(wrapin   : in  dual_rail_logic_vector(width - 1 downto 0);
			 ki       : in  std_logic;
			 rst      : in  std_logic;
			 sleep    : in  std_logic;
			 wrapout  : out dual_rail_logic_vector(width - 1 downto 0);
			 sleepout : out std_logic;
			 ko       : out std_logic);
	end component;
	
	component compm is
    generic(width: in integer := 4);
    port(a: IN dual_rail_logic_vector(width-1 downto 0);
        ki, rst, sleep: in std_logic;
        ko: OUT std_logic);
	end component;
	
	type Ktype is array (15 downto 0) of std_logic;
	type Stage1 is array (15 downto 0) of dual_rail_logic_vector(15 downto 0);
	type Stage2 is array (7 downto 0) of dual_rail_logic_vector(15 downto 0);
	type Stage3 is array (3 downto 0) of dual_rail_logic_vector(15 downto 0);
	type Stage4 is array (1 downto 0) of dual_rail_logic_vector(15 downto 0);
	
	signal Xarray : Xtype;
	signal karray, Sarray : Ktype;
	signal S1: Stage1;
	signal S2: Stage2;
	signal S3: Stage3;
	signal S4: Stage4;
	signal S5: dual_rail_logic_vector(15 downto 0);
	signal ko_temp: std_logic;

begin

	Xarray(0) <= x;
	karray(15) <= ki;
	Sarray(0) <= sleep;
	sleepout <= Sarray(15);
	ko_temp <= karray(0);
	ko <= ko_temp;
	
	GenShiftReg: for i in 1 to 15 generate
		Rega: ShiftRegMTNCL
			generic map(
				width => 10,
				value => "0000000000"
			)
			port map(
				wrapin   => Xarray(i - 1),
				ki       => karray(i),
				rst      => rst,
				sleep    => Sarray(i - 1),
				wrapout  => Xarray(i),
				sleepout => Sarray(i),
				ko       => karray(i - 1)
			);
	end generate;
	
	GenMult: for i in 0 to 15 generate 
		Multa: Dadda_Unpipelined
			port map(Xarray(i), c(i), sleep, S1(i));
	end generate;
	
	GenAdd1: for i in 0 to 7 generate 
		Adda: CLA_16m
		port map(S1(2*i), S1(2*i + 1), sleep, S2(i));
	end generate;
	
	GenAdd2: for i in 0 to 3 generate
		Adda: CLA_16m
		port map(S2(2*i), S2(2*i + 1), sleep, S3(i));
	end generate;
	
	GenAdd3: for i in 0 to 1 generate
		Adda: CLA_16m
		port map(S3(2*i), S3(2*i + 1), sleep, S4(i));
	end generate;
	
	FinalAdd: CLA_16m 
		port map(S4(0), S4(1), sleep, S5);
	
	y <= S5(15 downto 5);
	
	
end arch;