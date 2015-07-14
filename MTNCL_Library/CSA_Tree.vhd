use work.ncl_signals.all;
use work.MTNCL_gates.all;
use work.FIR_pack.all;
library ieee;
use ieee.std_logic_1164.all;

-- MTNCL Full Adder
entity CSA_Tree is
	port(
		X   : IN  X16type;
		sleep : in  std_logic;
		COUT  : OUT dual_rail_logic_vector(15 downto 0);
		S     : OUT dual_rail_logic_vector(15 downto 0));
end CSA_Tree;

architecture arch of CSA_Tree is
	
	component CSA_genm is
		generic(width : integer := 16);
		port(A, B, C : in dual_rail_logic_vector(width - 1 downto 0);
			sleep : in std_logic;
			Cout, S : out dual_rail_logic_vector(width - 1 downto 0));
	end component;
	
	type XarrayType is array(natural range <>) of dual_rail_logic_vector(15 downto 0);
	
	signal L0 : XarrayType(10 downto 0);
	signal L1 : XarrayType(7 downto 0);
	signal L2 : XarrayType(5 downto 0);
	signal L3 : XarrayType(3 downto 0);
	signal L4 : XarrayType(2 downto 0);

begin
	L0Gen: for i in 0 to 4 generate
		CSA0 : CSA_genm
			generic map(16)
			port map(X(3 * i), X(3 * i + 1), X(3 * i + 2), sleep, L0(2 * i), L0(2 * i + 1));
	end generate;
	L0(10) <= X(15);
	
	L1Gen: for i in 0 to 2 generate
		CSA1 : CSA_genm
			generic map(16)
			port map(L0(3 * i), L0(3 * i + 1), L0(3 * i + 2), sleep, L1(2 * i), L1(2 * i + 1));
	end generate;
	L1(6) <= L0(9);
	L1(7) <= L0(10);
	
	L2Gen: for i in 0 to 1 generate
		CSA2 : CSA_genm
			generic map(16)
			port map(L1(3 * i), L1(3 * i + 1), L1(3 * i + 2), sleep, L2(2 * i), L2(2 * i + 1));
	end generate;
	L2(4) <= L1(6);
	L2(5) <= L1(7);
	
	L3Gen: for i in 0 to 1 generate
		CSA3 : CSA_genm
			generic map(16)
			port map(L2(3 * i), L2(3 * i + 1), L2(3 * i + 2), sleep, L3(2 * i), L3(2 * i + 1));
	end generate;
	
	CSA4 : CSA_genm
		generic map(16)
		port map(L3(0), L3(1), L3(2), sleep, L4(0), L4(1));
	L4(2) <= L3(3);
	
	CSA5 : CSA_genm
		generic map(16)
		port map(L4(0), L4(1), L4(2), sleep, COUT, S);

end arch;