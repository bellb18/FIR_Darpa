Library IEEE;
use IEEE.std_logic_1164.all;
use work.ncl_signals.all;
entity FIR_Dadda_Unpipelined is
	port(x     : in  dual_rail_logic_vector(9 downto 0);
		 c     : in  dual_rail_logic_vector(6 downto 0);
		 ki    : in  std_logic;
		 rst   : in  std_logic;
		 sleep : in  std_logic;
		 ko    : out std_logic;
		 sleepout : out std_logic;
		 y     : out dual_rail_logic_vector(10 downto 0));
end;

architecture arch of FIR_Dadda_Unpipelined is
	component Dadda_Unpipelined is
		port(x     : in  dual_rail_logic_vector(9 downto 0);
			 y     : in  dual_rail_logic_vector(6 downto 0);
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
	
	type Xtype is array (15 downto 0) of dual_rail_logic_vector(9 downto 0);
	type Ktype is array (15 downto 0) of std_logic;
	signal Xarray : Xtype;
	signal karray, Sarray : Ktype;

begin

	Xarray(0) <= x;
	karray(15) <= ki;
	Sarray(0) <= sleep;
	sleepout <= Sarray(15);
	ko <= karray(0);
	y <= Xarray(15) & Xarray(15)(0);
	
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
	
end arch;