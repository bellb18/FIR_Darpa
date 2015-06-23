Library IEEE;
use IEEE.std_logic_1164.all;
use work.ncl_signals.all;
entity Merged_S5 is
	port(X0                      : in  dual_rail_logic_vector(15 downto 0);
		 X1, X2, X3, X4, X5, X6, X7, X8, X9, X10, X11, X12, X13, X14, X15 : in  dual_rail_logic_vector(18 downto 0);
		 sleep                   : in  std_logic;
		 Z0, Z1, Z2, Z3, Z4, Z5, Z6, Z7, Z8, Z9, Z10, Z11, Z12, Z13, Z14, Z15 : out dual_rail_logic_vector(12 downto 0));
end;

architecture struct of Merged_S5 is
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
	signal  temp_carry : dual_rail_logic_vector (5 downto 0);
begin
	Z0a : for i in 0 to 10 generate
		Z0(i) <= X0(i + 5);
	end generate;
	Z1a : for i in 0 to 6 generate
		Z1(i) <= X1(i + 12);
	end generate;
	Z2a : for i in 0 to 3 generate
		Z2(i) <= X2(i + 15);
	end generate;
	Z3a : for i in 0 to 1 generate
		Z3(i) <= X3(i + 17);
	end generate;
	Z4(0) <= X4(18);
	Z5(0) <= X5(18);
	Z6(0) <= X6(18);
	Z7(0) <= X7(18);
	Z8(0) <= X8(18);
	Z9(0) <= X9(18);
	Z10(0) <= X10(18);
	Z11(0) <= X11(18);
	Z12(0) <= X12(18);
	Z13(0) <= X13(18);
	Z14(0) <= X14(18);
	Z15(0) <= X15(18);
	
	FA0 : FAm
		port map(X0(0), X0(1), X0(2), sleep, Z1(7), Z0(11));
	HA0 : HAm
		port map(X0(3), X0(4), sleep, Z1(8), Z0(12));
	FA1Gen : for i in 0 to 3 generate
		FA1 : FAm
			port map(X1(3 * i), X1(3 * i + 1), X1(3 * i + 2), sleep, Z2(i + 4), Z1(i + 9));
	end generate;
	FA2Gen : for i in 0 to 4 generate
		FA2 : FAm
			port map(X2(3 * i), X2(3 * i + 1), X2(3 * i + 2), sleep, Z3(i + 2), Z2(i + 8));
	end generate;
	FA3Gen : for i in 0 to 4 generate
		FA3 : FAm
			port map(X3(3 * i), X3(3 * i + 1), X3(3 * i + 2), sleep, Z4(i + 1), Z3(i + 7));
	end generate;
	HA3 : HAm
		port map(X3(15), X3(16), sleep, Z4(6), Z3(12));
	FA4Gen : for i in 0 to 5 generate
		FA4 : FAm
			port map(X4(3 * i), X4(3 * i + 1), X4(3 * i + 2), sleep, Z5(i + 1), Z4(i + 7));
	end generate;
	FA5Gen : for i in 0 to 5 generate
		FA5 : FAm
			port map(X5(3 * i), X5(3 * i + 1), X5(3 * i + 2), sleep, Z6(i + 1), Z5(i + 7));
	end generate;
	FA6Gen : for i in 0 to 5 generate
		FA6 : FAm
			port map(X6(3 * i), X6(3 * i + 1), X6(3 * i + 2), sleep, Z7(i + 1), Z6(i + 7));
	end generate;
	FA7Gen : for i in 0 to 5 generate
		FA7 : FAm
			port map(X7(3 * i), X7(3 * i + 1), X7(3 * i + 2), sleep, Z8(i + 1), Z7(i + 7));
	end generate;
	FA8Gen : for i in 0 to 5 generate
		FA8 : FAm
			port map(X8(3 * i), X8(3 * i + 1), X8(3 * i + 2), sleep, Z9(i + 1), Z8(i + 7));
	end generate;
	FA9Gen : for i in 0 to 5 generate
		FA9 : FAm
			port map(X9(3 * i), X9(3 * i + 1), X9(3 * i + 2), sleep, Z10(i + 1), Z9(i + 7));
	end generate;
	FA10Gen : for i in 0 to 5 generate
		FA10 : FAm
			port map(X10(3 * i), X10(3 * i + 1), X10(3 * i + 2), sleep, Z11(i + 1), Z10(i + 7));
	end generate;
	FA11Gen : for i in 0 to 5 generate
		FA11 : FAm
			port map(X11(3 * i), X11(3 * i + 1), X11(3 * i + 2), sleep, Z12(i + 1), Z11(i + 7));
	end generate;
	FA12Gen : for i in 0 to 5 generate
		FA12 : FAm
			port map(X12(3 * i), X12(3 * i + 1), X12(3 * i + 2), sleep, Z13(i + 1), Z12(i + 7));
	end generate;
	FA13Gen : for i in 0 to 5 generate
		FA13 : FAm
			port map(X13(3 * i), X13(3 * i + 1), X13(3 * i + 2), sleep, Z14(i + 1), Z13(i + 7));
	end generate;
	FA14Gen : for i in 0 to 5 generate
		FA14 : FAm
			port map(X14(3 * i + 1), X14(3 * i + 2), X14(3 * i + 3), sleep, Z15(i + 1), Z14(i + 7));
	end generate;
	FA15Gen : for i in 0 to 5 generate
		FA15 : FAm
			port map(X15(3 * i + 1), X15(3 * i + 2), X15(3 * i + 3), sleep, temp_carry(i), Z15(i + 7));
	end generate;
end;