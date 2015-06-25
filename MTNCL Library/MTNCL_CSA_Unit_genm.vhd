----------------------------------------------
-- Definition of Carry Save Adder (CSA) Unit
----------------------------------------------
Library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.MTNCL_gates.all;
use work.ncl_signals.all;

entity CSA_Unit is
	generic(width : integer := 16);
	port(
		xi    : in  dual_rail_logic_vector(width - 1 downto 0);
		yi    : in  dual_rail_logic_vector(width - 1 downto 0);
		zi    : in  dual_rail_logic_vector(width - 1 downto 0);
		sleep : in  std_logic;
		carry : out dual_rail_logic_vector(width downto 0);
		sum   : out dual_rail_logic_vector(width - 1 downto 0)		
	);
end;

architecture arch of CSA_Unit is
	component FAm is
		port(
			CIN   : IN  dual_rail_logic;
			X     : IN  dual_rail_logic;
			Y     : IN  dual_rail_logic;
			sleep : in  std_logic;
			COUT  : OUT dual_rail_logic;
			S     : OUT dual_rail_logic);
	end component;
begin
	carry(0).RAIL1 <= '0';
	carry(0).RAIL0 <= '1';
	FA : for i in 0 to width - 1 generate
		FAa : FAm
			port map(xi(i), yi(i), zi(i), sleep, carry(i+1), sum(i));
	end generate;
end arch;
	