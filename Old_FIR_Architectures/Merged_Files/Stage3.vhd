Library IEEE;
use IEEE.std_logic_1164.all;
use work.ncl_signals.all;
entity Merged_S3 is
	port(X0                                                               : in  dual_rail_logic_vector(15 downto 0);
		 X1                                                               : in  dual_rail_logic_vector(31 downto 0);
		 X2, X3, X4, X5, X6, X7, X8, X9, X10, X11, X12, X13, X14          : in  dual_rail_logic_vector(41 downto 0);
		 X15                                                              : in  dual_rail_logic_vector(21 downto 0);

		 sleep                                                            : in  std_logic;

		 Z0                                                               : out dual_rail_logic_vector(15 downto 0);
		 Z1, Z2, Z3, Z4, Z5, Z6, Z7, Z8, Z9, Z10, Z11, Z12, Z13, Z14, Z15 : out dual_rail_logic_vector(27 downto 0));
end;

architecture struct of Merged_S3 is
	component FAm
		port(CIN, X, Y : in  dual_rail_logic;
			 sleep     : in  std_logic;
			 COUT, S   : out dual_rail_logic);
	end component;

	component HAm is
		port(
			X     : IN  dual_rail_logic;
			Y     : IN  dual_rail_logic;
			sleep : in  std_logic;
			COUT  : OUT dual_rail_logic;
			S     : OUT dual_rail_logic);
	end component;

	signal temp_carry : dual_rail_logic_vector(3 downto 0);

begin
	Z0 <= X0;

	Z1a : for i in 0 to 25 generate
		Z1(i) <= X1(i + 6);
	end generate;
	Z2a : for i in 0 to 17 generate
		Z2(i) <= X2(i + 24);
	end generate;
	Z3a : for i in 0 to 8 generate
		Z3(i) <= X3(i + 33);
	end generate;
	Z4a : for i in 0 to 3 generate
		Z4(i) <= X4(i + 38);
	end generate;
	Z5(0) <= X5(41);
	Z15a : for i in 0 to 9 generate
		Z15(i) <= X15(i + 12);
	end generate;

	FA1Gen : for i in 0 to 1 generate
		FA1 : FAm
			port map(X1(3 * i), X1(3 * i + 1), X1(3 * i + 2), sleep, Z2(i + 18), Z1(i + 26));
	end generate;
	FA2Gen : for i in 0 to 7 generate
		FA2 : FAm
			port map(X2(3 * i), X2(3 * i + 1), X2(3 * i + 2), sleep, Z3(9 + i), Z2(20 + i));
	end generate;
	FA3Gen : for i in 0 to 10 generate
		FA3 : FAm
			port map(X3(3 * i), X3(3 * i + 1), X3(3 * i + 2), sleep, Z4(4 + i), Z3(17 + i));
	end generate;
	FA4Gen : for i in 0 to 11 generate
		FA4 : FAm
			port map(X4(3 * i), X4(3 * i + 1), X4(3 * i + 2), sleep, Z5(1 + i), Z4(15 + i));
	end generate;
	HA4a : HAm
		port map(X4(36), X4(37), sleep, Z5(13), Z4(27));
	FA5Gen : for i in 0 to 12 generate
		FA5 : FAm
			port map(X5(3 * i), X5(3 * i + 1), X5(3 * i + 2), sleep, Z6(i), Z5(14 + i));
	end generate;
	HA5a : HAm
		port map(X5(39), X5(40), sleep, Z6(13), Z5(27));
	FA6to14Gen : for i in 0 to 13 generate
		FA6 : FAm
			port map(X6(3 * i), X6(3 * i + 1), X6(3 * i + 2), sleep, Z7(i), Z6(14 + i));
		FA7 : FAm
			port map(X7(3 * i), X7(3 * i + 1), X7(3 * i + 2), sleep, Z8(i), Z7(14 + i));
		FA8 : FAm
			port map(X8(3 * i), X8(3 * i + 1), X8(3 * i + 2), sleep, Z9(i), Z8(14 + i));
		FA9 : FAm
			port map(X9(3 * i), X9(3 * i + 1), X9(3 * i + 2), sleep, Z10(i), Z9(14 + i));
		FA10 : FAm
			port map(X10(3 * i), X10(3 * i + 1), X10(3 * i + 2), sleep, Z11(i), Z10(14 + i));
		FA11 : FAm
			port map(X11(3 * i), X11(3 * i + 1), X11(3 * i + 2), sleep, Z12(i), Z11(14 + i));
		FA12 : FAm
			port map(X12(3 * i), X12(3 * i + 1), X12(3 * i + 2), sleep, Z13(i), Z12(14 + i));
		FA13 : FAm
			port map(X13(3 * i), X13(3 * i + 1), X13(3 * i + 2), sleep, Z14(i), Z13(14 + i));
		FA14 : FAm
			port map(X14(3 * i), X14(3 * i + 1), X14(3 * i + 2), sleep, Z15(i + 10), Z14(14 + i));
	end generate;
	FA15Gen : for i in 0 to 3 generate
		FA15 : FAm
			port map(X15(3 * i), X15(3 * i + 1), X15(3 * i + 2), sleep, temp_carry(i), Z15(24 + i));
	end generate;

end;