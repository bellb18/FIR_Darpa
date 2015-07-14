
-----------------------------------------
-- Definition of Hybrid Carry Look Ahead(CLA)
-- and Ripple Carry Adder(RCA) 4 Bits
-----------------------------------------

Library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.MTNCL_gates.all;
use work.ncl_signals.all;
entity RCA_genm is
	generic(width : integer := 16);
	port(
		X    : in  dual_rail_logic_vector(width - 1 downto 0);
		Y    : in  dual_rail_logic_vector(width - 1 downto 0);
		sleep : in  std_logic;
		S   : out dual_rail_logic_vector(width - 1 downto 0)
	);
end;

architecture arch of RCA_genm is
	component HAm
		port(X, Y    : in  dual_rail_logic;
			 sleep   : in  std_logic;
			 COUT, S : out dual_rail_logic);
	end component;
	component FAm is
		port(
			CIN   : IN  dual_rail_logic;
			X     : IN  dual_rail_logic;
			Y     : IN  dual_rail_logic;
			sleep : in  std_logic;
			COUT  : OUT dual_rail_logic;
			S     : OUT dual_rail_logic);
	end component;

	signal carry : dual_rail_logic_vector(width downto 0);

begin
	
	HAa : HAm
		port map(X(0), Y(0), sleep, carry(0), S(0));
	FAGenm : for i in 1 to width - 1 generate
		FAa : FAm
			port map(X(i), Y(i), carry(i - 1), sleep, carry(i), S(i));
	end generate;

end arch;