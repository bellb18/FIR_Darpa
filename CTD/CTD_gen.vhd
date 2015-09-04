-- Not Generic Yet

Library IEEE;
use IEEE.std_logic_1164.all;
use work.ncl_signals.all;
entity CTD_genm is
	port(X        : in  dual_rail_logic_vector(10 downto 0);
		 skip     : in  dual_rail_logic_vector(3 downto 0);
		 ki       : in  std_logic;
		 sleepIn  : in  std_logic;
		 rst      : in  std_logic;
		 sleepOut : out std_logic;
		 ko       : out std_logic;
		 Z        : out dual_rail_logic_vector(10 downto 0));
end;

architecture arch of CTD_genm is
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
		generic(width : in integer := 4);
		port(a              : in  dual_rail_logic_vector(width - 1 downto 0);
			 ki, rst, sleep : in  std_logic;
			 ko             : out std_logic);
	end component;

	component MUX_genm is
		generic(width : in integer := 8);
		port(A     : in  dual_rail_logic_vector(width - 1 downto 0);
			 B     : in  dual_rail_logic_vector(width - 1 downto 0);
			 S     : in  dual_rail_logic;
			 sleep : in  std_logic;
			 Z     : out dual_rail_logic_vector(width - 1 downto 0));
	end component;

	-- Signal Declarations
	type CTDXtype is array (0 to 15) of DUAL_RAIL_LOGIC_VECTOR(10 downto 0);
	signal Xarray : CTDXtype;
	signal karray, sarray : std_logic_vector(14 downto 0);

begin
	-- 8 set
	Xarray(15) <= X;
	GenReg8 : for i in 15 downto 8 generate
		ShiftReg : ShiftRegMTNCL
			generic map(11, "0000000000")
			port map(Xarray(i), karray(i - 1), rst, sarray(i), Xarray(i - 1), sarray(i - 1), karray(i));
	end generate;
	
	MuxA : MUX_genm
			generic map(11)
			port map(Xarray(7), Xarray(15), skip(3), );
	
	-- 4 set
	GenReg4 : for i in 7 downto 4 generate
		ShiftReg : ShiftRegMTNCL
			generic map(11, "0000000000")
			port map(Xarray(i), karray(i - 1), rst, sarray(i), Xarray(i - 1), sarray(i - 1), karray(i));
	end generate;
	
	-- 2 set
	GenReg2 : for i in 3 downto 2 generate
		ShiftReg : ShiftRegMTNCL
			generic map(11, "0000000000")
			port map(Xarray(i), karray(i - 1), rst, sarray(i), Xarray(i - 1), sarray(i - 1), karray(i));
	end generate;
	
	-- 1 set
	ShiftReg : ShiftRegMTNCL
		generic map(11, "0000000000")
		port map(Xarray(1), karray(0), rst, sarray(1), Xarray(0), sarray(0), karray(1));

	-- Output Register
	outReg : genregm
		generic map(16)
		port map(pReg, ko_OutReg, p);
	outComp : compm
		generic map(16)
		port map(pReg, ki, rst, ko_pipe1, ko_OutReg);

end arch;