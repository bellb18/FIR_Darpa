Library IEEE;
use IEEE.std_logic_1164.all;
use work.ncl_signals.all;
use work.FIR_pack.all;
entity FIR_Partially_Merged_CSA_Tree_Unpipelined is
	port(x     : in  dual_rail_logic_vector(9 downto 0);
		 c     : in  Ctype;
		 ki    : in  std_logic;
		 rst   : in  std_logic;
		 sleep : in  std_logic;
		 ko    : out std_logic;
		 sleepout : out std_logic;
		 y     : out dual_rail_logic_vector(10 downto 0));
end;

architecture arch of FIR_Partially_Merged_CSA_Tree_Unpipelined is
	component Merged_Unpipelined is
	port(x     : in  dual_rail_logic_vector(9 downto 0);
		 y     : in  dual_rail_logic_vector(6 downto 0);
		 a     : in  dual_rail_logic_vector(9 downto 0);
		 b     : in  dual_rail_logic_vector(6 downto 0);
		 sleep : in  std_logic;
		 p     : out dual_rail_logic_vector(15 downto 0));
	end component;

	component RCA_genm is
	generic(width : integer := 16);
	port(
		X    : in  dual_rail_logic_vector(width - 1 downto 0);
		Y    : in  dual_rail_logic_vector(width - 1 downto 0);
		sleep : in  std_logic;
		S   : out dual_rail_logic_vector(width - 1 downto 0)
	);
	end component;

	component CSA_Tree is
	port(
		X   : IN  Xtype;
		sleep : in  std_logic;
		COUT  : OUT dual_rail_logic_vector(15 downto 0);
		S     : OUT dual_rail_logic_vector(15 downto 0));
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
	
	signal Xarray : Xtype;
	signal karray, Sarray : Ktype;
	signal S1: Xtype;
	signal S2_Sums, S2_Cout, S3: dual_rail_logic_vector(15 downto 0);
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
	
	GenMult: for i in 0 to 7 generate 
		Multa: Merged_Unpipelined
			port map(Xarray(2*i), c(2*i), Xarray(2*i + 1), c(2*i + 1), sleep, S1(i));
	end generate;
	
	Tree : CSA_Tree
		port map(S1, sleep, S2_Cout, S2_Sums);
	
	FinalAdd: RCA_genm
		generic map(16) 
		port map(S2_Cout, S2_Sums, sleep, S3);
	
	y <= S3(15 downto 5);
	
	
end arch;