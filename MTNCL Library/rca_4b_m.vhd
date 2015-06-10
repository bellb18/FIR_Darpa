
-----------------------------------------
-- Definition of rca_4b(Ripple Carry Adder)
-----------------------------------------

Library IEEE;
use IEEE.std_logic_1164.all;
use work.ncl_signals.all;
use work.MTNCL_gates.all;

entity RCA4bm is
	port(
		x     : in  dual_rail_logic_vector(3 downto 0);
		y     : in  dual_rail_logic_vector(3 downto 0);
		cin   : in  DUAL_RAIL_LOGIC;
		sleep : in  std_logic;
		cout  : out DUAL_RAIL_LOGIC;
		sum   : out dual_rail_logic_vector(3 downto 0)
	);
end;

architecture arch of RCA4bm is
	component FAm
		port(
			CIN, X, Y : in  dual_rail_logic;
			sleep     : in  std_logic;
			COUT, S   : out dual_rail_logic);
	end component;

	signal carry : dual_rail_logic_vector(3 downto 1);

begin

	---Initial Stage---
	GFA0 : FAm
		port map(
			CIN   => cin,
			X     => x(0),
			Y     => y(0),
			sleep => sleep,
			COUT  => carry(1),
			S     => sum(0)
		);

	---Middle Stages---
	GenFA : for i in 1 to 4 - 2 generate
		GFA : FAm
			port map(
				CIN   => carry(i),
				X     => x(i),
				Y     => y(i),
				sleep => sleep,
				COUT  => carry(i + 1),
				S     => sum(i)
			);
	end generate;

	---Last Stage---
	lastFA : FAm
		port map(
			CIN   => carry(4 - 1),
			X     => x(4 - 1),
			Y     => y(4 - 1),
			sleep => sleep,
			COUT  => cout,              ---Note: Result has one bit extra
			S     => sum(4 - 1)
		);

end arch;


