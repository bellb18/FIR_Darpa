Library IEEE;
use IEEE.std_logic_1164.all;
use work.ncl_signals.all;
entity Merged_S6 is
	port(X0, X1, X2, X3, X4, X5, X6, X7, X8, X9, X10, X11, X12, X13, X14, X15 : in  dual_rail_logic_vector(12 downto 0);
		 sleep                                                                : in  std_logic;
		 Z0, Z1, Z2, Z3, Z4, Z5, Z6, Z7, Z8, Z9, Z10, Z11, Z12, Z13, Z14, Z15 : out dual_rail_logic_vector(8 downto 0));
end;

architecture struct of Merged_S6 is
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
	Z0a : for i in 0 to 6 generate
		Z0(i) <= X0(i + 6);
	end generate;
	Z1a : for i in 0 to 3 generate
		Z1(i) <= X1(i + 9);
	end generate;
	Z2a : for i in 0 to 1 generate
		Z2(i) <= X2(i + 11);
	end generate;

	Z3(0)  <= X3(12);
	Z4(0)  <= X4(12);
	Z5(0)  <= X5(12);
	Z6(0)  <= X6(12);
	Z7(0)  <= X7(12);
	Z8(0)  <= X8(12);
	Z9(0)  <= X9(12);
	Z10(0) <= X10(12);
	Z11(0) <= X11(12);
	Z12(0) <= X12(12);
	Z13(0) <= X13(12);
	Z14(0) <= X14(12);
	Z15(0) <= X15(12);

	FA0Gen : for i in 0 to 1 generate
		FA0 : FAm
			port map(X0(3 * i), X0(3 * i + 1), X0(3 * i + 2), sleep, Z1(i + 4), Z0(i + 7));
	end generate;
	FA1Gen : for i in 0 to 2 generate
		FA1 : FAm
			port map(X1(3 * i), X1(3 * i + 1), X1(3 * i + 2), sleep, Z2(i + 2), Z1(i + 6));
	end generate;
	FA2Gen : for i in 0 to 2 generate
		FA2 : FAm
			port map(X2(3 * i), X2(3 * i + 1), X2(3 * i + 2), sleep, Z3(1 + i), Z2(5 + i));
	end generate;
	HA2 : HAm
		port map(X2(9), X2(10), sleep, Z3(4), Z2(8));
	FA3to15Gen : for i in 0 to 3 generate
		FA3 : FAm
			port map(X3(3 * i), X3(3 * i + 1), X3(3 * i + 2), sleep, Z4(i + 1), Z3(5 + i));
		FA4 : FAm
			port map(X4(3 * i), X4(3 * i + 1), X4(3 * i + 2), sleep, Z5(i + 1), Z4(5 + i));
		FA5 : FAm
			port map(X5(3 * i), X5(3 * i + 1), X5(3 * i + 2), sleep, Z6(i + 1), Z5(5 + i));
		FA6 : FAm
			port map(X6(3 * i), X6(3 * i + 1), X6(3 * i + 2), sleep, Z7(i + 1), Z6(5 + i));
		FA7 : FAm
			port map(X7(3 * i), X7(3 * i + 1), X7(3 * i + 2), sleep, Z8(i + 1), Z7(5 + i));
		FA8 : FAm
			port map(X8(3 * i), X8(3 * i + 1), X8(3 * i + 2), sleep, Z9(i + 1), Z8(5 + i));
		FA9 : FAm
			port map(X9(3 * i), X9(3 * i + 1), X9(3 * i + 2), sleep, Z10(i + 1), Z9(5 + i));
		FA10 : FAm
			port map(X10(3 * i), X10(3 * i + 1), X10(3 * i + 2), sleep, Z11(i + 1), Z10(5 + i));
		FA11 : FAm
			port map(X11(3 * i), X11(3 * i + 1), X11(3 * i + 2), sleep, Z12(i + 1), Z11(5 + i));
		FA12 : FAm
			port map(X12(3 * i), X12(3 * i + 1), X12(3 * i + 2), sleep, Z13(i + 1), Z12(5 + i));
		FA13 : FAm
			port map(X13(3 * i), X13(3 * i + 1), X13(3 * i + 2), sleep, Z14(i + 1), Z13(5 + i));
		FA14 : FAm
			port map(X14(3 * i), X14(3 * i + 1), X14(3 * i + 2), sleep, Z15(i + 1), Z14(5 + i));
		FA15 : FAm
			port map(X15(3 * i), X15(3 * i + 1), X15(3 * i + 2), sleep, temp_carry(i), Z15(5 + i));
	end generate;

end;