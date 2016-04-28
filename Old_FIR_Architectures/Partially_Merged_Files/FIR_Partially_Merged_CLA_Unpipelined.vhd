Library IEEE;
use IEEE.std_logic_1164.all;
use work.ncl_signals.all;
use work.FIR_pack.all;
entity FIR_Partially_Merged_CLA_Unpipelined is
	port(x     : in  dual_rail_logic_vector(9 downto 0);
		 c     : in  Ctype;
		 ki    : in  std_logic;
		 rst   : in  std_logic;
		 sleep : in  std_logic;
		 ko    : out std_logic;
		 sleepout : out std_logic;
		 y     : out dual_rail_logic_vector(10 downto 0));
end;

architecture arch of FIR_Partially_Merged_CLA_Unpipelined is
	component Merged_Unpipelined is
	port(x     : in  dual_rail_logic_vector(9 downto 0);
		 y     : in  dual_rail_logic_vector(6 downto 0);
		 a     : in  dual_rail_logic_vector(9 downto 0);
		 b     : in  dual_rail_logic_vector(6 downto 0);
		 sleep : in  std_logic;
		 p     : out dual_rail_logic_vector(15 downto 0));
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

	component genregm is
	generic(width : in integer :=4);
	port(a		: IN dual_rail_logic_vector(width - 1 downto 0);
		 sleep	: IN std_logic;
		 z		: out dual_rail_logic_vector(width - 1 downto 0));
	end component;
	
	component compm is
  generic(width: in integer := 4);
   port(a: IN dual_rail_logic_vector(width-1 downto 0);
        ki, rst, sleep: in std_logic;
        ko: OUT std_logic);
	end component;
	
	type Xtype is array (15 downto 0) of dual_rail_logic_vector(9 downto 0);
	type Ktype is array (15 downto 0) of std_logic;
	type Stage1 is array (7 downto 0) of dual_rail_logic_vector(15 downto 0);
	type Stage2 is array (3 downto 0) of dual_rail_logic_vector(15 downto 0);
	type Stage3 is array (1 downto 0) of dual_rail_logic_vector(15 downto 0);
	
	signal Xarray : Xtype;
	signal karray, Sarray : Ktype;
	signal S1: Stage1;
	signal S2: Stage2;
	signal S3: Stage3;
	signal S4: dual_rail_logic_vector(15 downto 0);
	signal ko_temp, ko_OutReg: std_logic;
	signal S4_Z_Reg: dual_rail_logic_vector(15 downto 0);
	signal sleep_shift: std_logic;

begin

	Xarray(0) <= x;
	karray(15) <= ko_OutReg;
	Sarray(0) <= sleep;
	sleep_shift <= Sarray(15);
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
	
	GenMult: for i in 0 to 7 generate
		Multa: Merged_Unpipelined
			port map(Xarray(2*i), c(2*i), Xarray(2*i + 1), c(2*i + 1), sleep_shift, S1(i));
	end generate;
	
	GenAdd1: for i in 0 to 3 generate
		Adda: CLA_16m
		port map(S1(2*i), S1(2*i + 1), sleep_shift, S2(i));
	end generate;
	
	GenAdd2: for i in 0 to 1 generate
		Adda: CLA_16m
		port map(S2(2*i), S2(2*i + 1), sleep_shift, S3(i));
	end generate;
	
	FinalAdd: CLA_16m
		port map(S3(0), S3(1), sleep_shift, S4);
	
	--Output Register
	CompOut: compm
		generic map(16)
		port map(S4, ki, rst, sleep_shift, ko_OutReg);
	OutReg: genregm
		generic map(16)
		port map(S4, ko_OutReg, S4_Z_Reg);	
	
	
	y <= S4_Z_Reg(15 downto 5);
	sleepout <= ko_OutReg;
	
end arch;