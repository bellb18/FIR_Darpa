Library IEEE;
use IEEE.std_logic_1164.all;
use work.ncl_signals.all;
package arraypack is
	type array16 is array (15 downto 0) of dual_rail_logic_vector(6 downto 0);
end package;

Library IEEE;
use IEEE.std_logic_1164.all;
use work.ncl_signals.all;
use work.arraypack.all;
entity FIR_Partially_Merged_Unpipelined is
	port(x     : in  dual_rail_logic_vector(9 downto 0);
		 c     : in  array16;
		 ki    : in  std_logic;
		 rst   : in  std_logic;
		 sleep : in  std_logic;
		 ko    : out std_logic;
		 sleepout : out std_logic;
		 y     : out dual_rail_logic_vector(10 downto 0));
end;

architecture arch of FIR_Partially_Merged_Unpipelined is
	component Merged_Unpipelined is
	port(x     : in  dual_rail_logic_vector(9 downto 0);
		 y     : in  dual_rail_logic_vector(6 downto 0);
		 a     : in  dual_rail_logic_vector(9 downto 0);
		 b     : in  dual_rail_logic_vector(6 downto 0);
		 sleep : in  std_logic;
		 p     : out dual_rail_logic_vector(16 downto 0));
	end component;

	component CLA_genm is
		generic(width : integer := 8);
		port(
			xi    : in  dual_rail_logic_vector(width - 1 downto 0);
			yi    : in  dual_rail_logic_vector(width - 1 downto 0);
			sleep : in  std_logic;
			sum   : out dual_rail_logic_vector(width downto 0)
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
	
	type Xtype is array (15 downto 0) of dual_rail_logic_vector(9 downto 0);
	type Ktype is array (15 downto 0) of std_logic;
	type Stage1 is array (7 downto 0) of dual_rail_logic_vector(16 downto 0);
	type Stage2 is array (3 downto 0) of dual_rail_logic_vector(17 downto 0);
	type Stage3 is array (1 downto 0) of dual_rail_logic_vector(18 downto 0);
	
	signal Xarray : Xtype;
	signal karray, Sarray : Ktype;
	signal S1: Stage1;
	signal S2: Stage2;
	signal S3: Stage3;
	signal S4: dual_rail_logic_vector(19 downto 0);
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
	
	GenMult: for i in 0 to 7 generate -- 00.0000 0000 0000 001
		Multa: Merged_Unpipelined
			port map(Xarray(2*i), c(2*i), Xarray(2*i + 1), c(2*i + 1), sleep, S1(i));
	end generate;
	
	GenAdd1: for i in 0 to 3 generate -- 000.0000 0000 0000 00
		Adda: CLA_genm
		generic map(17)
		port map(S1(2*i), S1(2*i + 1), sleep, S2(i));
	end generate;
	
	GenAdd2: for i in 0 to 1 generate -- 0000.0000 0000 0000 0
		Adda: CLA_genm
		generic map(18)
		port map(S2(2*i), S2(2*i + 1), sleep, S3(i));
	end generate;
	
	FinalAdd: CLA_genm -- 00000.0000 0000 0000 000
		generic map(19)
		port map(S3(0), S3(1), sleep, S4);
	
	y <= S4(15 downto 5);
	
	
end arch;