-- Not Generic Yet

Library IEEE;
use IEEE.std_logic_1164.all;
use work.ncl_signals.all;
entity CTD_genm is
	port(X        : in  dual_rail_logic_vector(10 downto 0);
		 skip     : in  std_logic_vector(3 downto 0);
		 ki       : in  std_logic;
		 sleep    : in  std_logic;
		 rst      : in  std_logic;
		 sleepOut : out std_logic;
		 ko       : out std_logic;
		 Z        : out dual_rail_logic_vector(10 downto 0));
end;

architecture arch of CTD_genm is
	component CTD_Stages_genm is
	generic(size : in integer := 4);
	port(X        : in  dual_rail_logic_vector(10 downto 0);
		 skip     : in  std_logic;
		 ki       : in  std_logic;
		 sleep    : in  std_logic;
		 rst      : in  std_logic;
		 sleepout : out std_logic;
		 ko       : out std_logic;
		 Z        : out dual_rail_logic_vector(10 downto 0));
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

	-- Signal Declarations
	type CTDXtype is array (0 to 3) of DUAL_RAIL_LOGIC_VECTOR(10 downto 0);
	signal sleepout_0, sleepout_1, sleepout_2, sleepout_3 : std_logic;
	signal ko_0, ko_1, ko_2, ko_3 : std_logic;
	signal Xarray : CTDXtype;

begin
	
	CTD_0 : CTD_Stages_genm
		generic map(1)
		port map(X, skip(0), ko_3, sleep, rst, sleepout_0, ko, Xarray(0));

	CTD_1 : CTD_Stages_genm
		generic map(2)
		port map(Xarray(0), skip(1), ko_2, sleepout_0, rst, sleepout_1, ko_3, Xarray(1));
		
	CTD_2 : CTD_Stages_genm
		generic map(4)
		port map(Xarray(1), skip(2), ko_1, sleepout_1, rst, sleepout_2, ko_2, Xarray(2));
		
	CTD_3 : CTD_Stages_genm
		generic map(8)
		port map(Xarray(2), skip(3), ko_0, sleepout_2, rst, sleepout_3, ko_1, Xarray(3));
	
	Reg1 : ShiftRegMTNCL
		generic map(11, "00000000000")
		port map(Xarray(3), ki, rst, sleepout_3, Z, sleepOut, ko_0);

end arch;