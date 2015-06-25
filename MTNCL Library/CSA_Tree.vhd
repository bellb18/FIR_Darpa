use work.ncl_signals.all;
use work.MTNCL_gates.all;
use work.FIR_pack.all;
library ieee;
use ieee.std_logic_1164.all;

-- MTNCL Full Adder
entity CSA_Tree is
	port(
		X   : IN  Xtype;
		sleep : in  std_logic;
		COUT  : OUT dual_rail_logic_vector(15 downto 0);
		S     : OUT dual_rail_logic_vector(15 downto 0));
end CSA_Tree;

architecture arch of CSA_Tree is
	
	component CSA_genm is
		generic(width : integer := 16);
		port(A, B, C : in dual_rail_logic_vector(width - 1 downto 0);
			sleep : in std_logic;
			Z0, Z1 : out dual_rail_logic_vector(width - 1 downto 0));
	end component;
	
	type XarrayType is array(natural range <>) of dual_rail_logic_vector(15 downto 0);
	
	signal L0 : XarrayType(11 downto 0);
	signal L1 : XarrayType(7 downto 0);

begin
	L0Gen: for i in 0 to 4 generate
		CSA0 : CSA_genm
			generic map(16)
			port map(X(3 * i), X(3 * i + 1), X(3 * i + 2), sleep, L0(2 * i), L0(2 * i + 1));
	end generate;
	L0(10) <= X(14);
	L0(11) <= X(15);
	
	L1Gen: for i in 0 to 3 generate
		CSA1 : CSA_genm
			generic map(16)
			port map(L0(3 * i), L0(3 * i + 1), L0(3 * i + 2), sleep, L1(2 * i), L1(2 * i + 1));
	

end arch;