-----------------------------------------
-- Definition of MUXm
-----------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use work.ncl_signals.all;
use work.functions.all;
use work.MTNCL_gates.all;

entity MUXm is
	port(A     : in  dual_rail_logic;
		 B     : in  dual_rail_logic;
		 S     : in  dual_rail_logic;
		 sleep : in  std_logic;
		 Z     : out dual_rail_logic);
end MUXm;

architecture arch of MUXm is
begin
	MUXG1 : thxor0m_a
		port map(A.rail0, S.rail0, S.rail1, B.rail0, sleep, Z.rail0);
	MUXG2 : thxor0m_a
		port map(S.rail0, A.rail1, S.rail1, B.rail1, sleep, Z.rail1);

end arch;

-----------------------------------------
-- Definition of MUXm
-----------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use work.ncl_signals.all;
use work.functions.all;
use work.MTNCL_gates.all;

entity MUX_genm is
	generic(width : in integer := 8);
	port(A     : in  dual_rail_logic_vector(width - 1 downto 0);
		 B     : in  dual_rail_logic_vector(width - 1 downto 0);
		 S     : in  dual_rail_logic;
		 sleep : in  std_logic;
		 Z     : out dual_rail_logic_vector(width - 1 downto 0));
end MUX_genm;

architecture arch of MUX_genm is
	component MUXm is
		port(A     : in  dual_rail_logic;
			 B     : in  dual_rail_logic;
			 S     : in  dual_rail_logic;
			 sleep : in  std_logic;
			 Z     : out dual_rail_logic);
	end component;

begin
	Gen1 : for i in 0 to width - 1 generate
		GenMux : MUXm
			port map(A(i), B(i), S, sleep, Z(i));
	end generate;

end arch;