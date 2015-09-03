-- Not Generic Yet

Library IEEE;
use IEEE.std_logic_1164.all;
use work.ncl_signals.all;
entity CTD_Stages_genm is
	generic(size : in integer := 4);
	port(X        : in  dual_rail_logic_vector(10 downto 0);
		 skip     : in  dual_rail_logic;
		 ki       : in  std_logic;
		 sleep  : in  std_logic;
		 rst      : in  std_logic;
		 sleepout : out std_logic;
		 ko       : out std_logic;
		 Z        : out dual_rail_logic_vector(10 downto 0));
end;

architecture arch of CTD_Stages_genm is
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
	
	component MUX is
	port(a, b, s : in  std_logic;
		 z : out std_logic);
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
	type CTDXtype is array (0 to size - 1) of DUAL_RAIL_LOGIC_VECTOR(10 downto 0);
	signal s1_sleepout, s1_ko, s2_sleepout1, s2_sleepout2, s2_ko1, s2_ko2 : std_logic;
	signal s1_out, s2_out, s2_in : dual_rail_logic_vector(10 downto 0);
	signal Xarray : CTDXtype;
	signal karray, sarray : std_logic_vector(size - 1 downto 0);

begin
	Xarray(0) <= X;
	-- For Size 1 (correct)
	S1: if (size = 1) generate
		Reg1 : ShiftRegMTNCL
			generic map(11, "00000000000")
			port map(X, ki, rst, sleep, s1_out, s1_sleepout, s1_ko);
		MData : MUX_genm
			generic map(11)
			port map(s1_out, X, skip, sleep, Z);
		MSleep : MUX
			port map(s1_sleepout, sleep, skip.RAIL1, sleepout);
		Mko : Mux
			port map(s1_ko, ki, skip.RAIL1, ko);
	end generate;
	
	-- For size 2 (correct)
	S2: if (size = 2) generate
		RegFirst : ShiftRegMTNCL
			generic map(11, "00000000000")
			port map(Xarray(0), s2_ko2, rst, sleep, Xarray(1), s2_sleepout1, s2_ko1);
		Mko : Mux
			port map(s2_ko1, ki, skip.RAIL1, ko);
		
		RegLast : ShiftRegMTNCL
			generic map(11, "00000000000")
			port map(Xarray(1), ki, rst, s2_sleepout1, s2_out, s2_sleepout2, s2_ko2);
		MData : MUX_genm
			generic map(11)
			port map(s2_out, X, skip, sleep, Z); -- Is this sleep wrong?
		MSleep : MUX
			port map(s2_sleepout2, sleep, skip.RAIL1, sleepout);
	end generate;
	
	-- For Size > 2  FIX EVERYTHING
--	S3: if (size > 2) generate
--		RegFirst : ShiftRegMTNCL
--			generic map(11, "00000000000")
--			port map(Xarray(0), ki, rst, sleep, Xarray(1), sarray(X'length - 1), karray(0));
--		Mko : Mux
--			port map(s2_ko, ki, skip.RAIL1, ko);
--			
--		RegMidGen : for i in 1 to X'length - 2 generate
--			RegMid: ShiftRegMTNCL
--				generic map(11, "00000000000")
--				port map(Xarray(i), karray(i), rst, sleep, Xarray(i + 1), sarray(i + 1), karray(i));
--		end generate;
--		
--		RegLast : ShiftRegMTNCL
--			generic map(11, "00000000000")
--			port map(Xarray(X'length - 1), ki, rst, sleep, s2_out, s2_sleepout, s2_ko);
--		MData : MUX_genm
--			generic map(11)
--			port map(s2_out, X, skip, sleep, Z); -- Is this sleep wrong?
--		MSleep : MUX
--			port map(s2_sleepout, sleep, skip.RAIL1, sleepout);
--	end generate;
--	
--	
--	Xarray(15) <= X;
--	GenReg8 : for i in 15 downto 8 generate
--		ShiftReg : ShiftRegMTNCL
--			generic map(11, "0000000000")
--			port map(Xarray(i), karray(i - 1), rst, sarray(i), Xarray(i - 1), sarray(i - 1), karray(i));
--	end generate;

end arch;