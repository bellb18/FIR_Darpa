Library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;
use ieee.std_logic_arith.all;

use ieee.math_real.all;

entity tb_Merged_Unpipelined_Sync is
end;

architecture arch of tb_Merged_Unpipelined_Sync is
	signal X, A : STD_LOGIC_VECTOR(9 downto 0);
	signal Y, B : STD_LOGIC_VECTOR(6 downto 0);
	signal P    : STD_LOGIC_VECTOR(16 downto 0);
	
	component Merged_Unpipelined_Sync is
		port(x     : in  std_logic_vector(9 downto 0);
			 y     : in  std_logic_vector(6 downto 0);
			 a     : in  std_logic_vector(9 downto 0);
			 b     : in  std_logic_vector(6 downto 0);
			 p     : out std_logic_vector(16 downto 0));
	end component;

begin
	CUT : Merged_Unpipelined_Sync
		port map(X, Y, A, B, P);

	inputs : process

	begin
		for i in 0 to 9 loop
			X(i) <= '0';
		end loop;
		for i in 0 to 6 loop
			Y(i) <= '0';
		end loop;

		wait for 30 ns;
		
		-- (455 * -14) + (-193 * 45) = -15055
		X   <= std_logic_vector(to_signed(455, 10));
		Y   <= std_logic_vector(to_signed(-14, 7));
		A   <= std_logic_vector(to_signed(-193, 10));
		B   <= std_logic_vector(to_signed(45, 7));

		wait for 30 ns;

		
		-- (-233 * -5) + (-158 * 57) = -7841
		X   <= std_logic_vector(to_signed(-233, 10));
		Y   <= std_logic_vector(to_signed(-5, 7));
		A   <= std_logic_vector(to_signed(-158, 10));
		B   <= std_logic_vector(to_signed(57, 7));

		wait for 30 ns;
		
		-- (-405 * -11) + (250 * 58) = 18955
		X   <= std_logic_vector(to_signed(-405, 10));
		Y   <= std_logic_vector(to_signed(-11, 7));
		A   <= std_logic_vector(to_signed(250, 10));
		B   <= std_logic_vector(to_signed(58, 7));

		wait for 30 ns;
		
		-- (-404 * 15) + (47 * 55) = -3475
		X   <= std_logic_vector(to_signed(-404, 10));
		Y   <= std_logic_vector(to_signed(15, 7));
		A   <= std_logic_vector(to_signed(47, 10));
		B   <= std_logic_vector(to_signed(55, 7));

		wait for 30 ns;
		
		-- (300 * -62) + (-166 * 39) = -25074
		X   <= std_logic_vector(to_signed(300, 10));
		Y   <= std_logic_vector(to_signed(-62, 7));
		A   <= std_logic_vector(to_signed(-166, 10));
		B   <= std_logic_vector(to_signed(39, 7));

		wait for 30 ns;
		
		-- (405 * 55) + (445 * 29) = 35180
		X   <= std_logic_vector(to_signed(405, 10));
		Y   <= std_logic_vector(to_signed(55, 7));
		A   <= std_logic_vector(to_signed(445, 10));
		B   <= std_logic_vector(to_signed(29, 7));

		wait for 30 ns;
		
		-- (173 * 27) + (67 * -47) = 1522
		X   <= std_logic_vector(to_signed(173, 10));
		Y   <= std_logic_vector(to_signed(27, 7));
		A   <= std_logic_vector(to_signed(67, 10));
		B   <= std_logic_vector(to_signed(-47, 7));

		wait for 30 ns;
		
		-- (-473 * 48) + (411 * -16) = -29280
		X   <= std_logic_vector(to_signed(-473, 10));
		Y   <= std_logic_vector(to_signed(48, 7));
		A   <= std_logic_vector(to_signed(411, 10));
		B   <= std_logic_vector(to_signed(-16, 7));

		wait for 30 ns;
		
		-- (156 * 27) + (98 * 61) = 10190
		X   <= std_logic_vector(to_signed(156, 10));
		Y   <= std_logic_vector(to_signed(27, 7));
		A   <= std_logic_vector(to_signed(98, 10));
		B   <= std_logic_vector(to_signed(61, 7));

		wait for 30 ns;
		
		-- (126 * -32) + (331 * 41) = 9539
		X   <= std_logic_vector(to_signed(126, 10));
		Y   <= std_logic_vector(to_signed(-32, 7));
		A   <= std_logic_vector(to_signed(331, 10));
		B   <= std_logic_vector(to_signed(41, 7));

		wait;

	end process;
	
end arch;