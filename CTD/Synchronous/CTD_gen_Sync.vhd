-- Not Generic Yet

Library IEEE;
use IEEE.std_logic_1164.all;
use work.ncl_signals.all;
entity CTD_gen_Sync is
	port(X        : in  std_logic_vector(10 downto 0);
		 skip     : in  std_logic_vector(3 downto 0);
		 clk       : in  std_logic;
		 rst      : in  std_logic;
		 Z        : out std_logic_vector(10 downto 0));
end;

architecture arch of CTD_gen_Sync is
	component CTD_Stages_gen_Sync is
	generic(size : in integer := 4);
	port(X        : in  std_logic_vector(10 downto 0);
		 skip     : in  std_logic;
		 clk  : in  std_logic;
		 rst      : in  std_logic;
		 Z        : out std_logic_vector(10 downto 0));
	end component;

	component reg_gen is
		generic(width : integer := 16);
		port(
			D   : in  std_logic_vector(width - 1 downto 0);
			clk : in  std_logic;
			rst : in  std_logic;
			Q   : out std_logic_vector(width - 1 downto 0));
	end component;

	-- Signal Declarations
	type CTDXtype is array (0 to 3) of STD_LOGIC_VECTOR(10 downto 0);
	signal Xarray : CTDXtype;

begin
	
	CTD_0 : CTD_Stages_gen_Sync
		generic map(1)
		port map(X, skip(0), clk, rst, Xarray(0));

	CTD_1 : CTD_Stages_gen_Sync
		generic map(2)
		port map(Xarray(0), skip(1), clk, rst, Xarray(1));
		
	CTD_2 : CTD_Stages_gen_Sync
		generic map(4)
		port map(Xarray(1), skip(2), clk, rst, Xarray(2));
		
	CTD_3 : CTD_Stages_gen_Sync
		generic map(8)
		port map(Xarray(2), skip(3), clk, rst, Xarray(3));
	
	Reg1 : reg_gen
		generic map(11)
		port map(Xarray(3), clk, rst, Z);

end arch;