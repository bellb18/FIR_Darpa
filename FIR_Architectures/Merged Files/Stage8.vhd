Library IEEE;
use IEEE.std_logic_1164.all;
use work.ncl_signals.all;
entity Merged_S8 is
	port(X0, X1, X2, X3, X4, X5, X6, X7, X8, X9, X10, X11, X12, X13, X14, X15 : in  dual_rail_logic_vector(5 downto 0);
		 sleep                   : in  std_logic;
		 Z0, Z1, Z2, Z3, Z4, Z5, Z6, Z7, Z8, Z9, Z10, Z11, Z12, Z13, Z14, Z15 : out dual_rail_logic_vector(3 downto 0));
end;

architecture struct of Merged_S8 is
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
	signal  temp_carry : dual_rail_logic_vector (1 downto 0);
begin
	Z0a : for i in 0 to 2 generate
		Z0(i) <= X0(i + 3);
	end generate;
	Z1(0) <= X1(5);
	
	FA0 : FAm
		port map(X0(0), X0(1), X0(2), sleep, Z1(1), Z0(3));
	FA1 : FAm
		port map(X1(1), X1(2), X1(5), sleep, Z2(0), Z1(2));
	HA1 : HAm
		port map(X1(3), X1(4), sleep, Z2(1), Z1(3));
	FA2Gen : for i in 0 to 1 generate
		FA2 : FAm
			port map(X2(3 * i), X2(3 * i + 1), X2(3 * i + 2), sleep, Z3(i), Z2(i + 2));
	end generate;
	FA3Gen : for i in 0 to 1 generate
		FA3 : FAm
			port map(X3(3 * i), X3(3 * i + 1), X3(3 * i + 2), sleep, Z4(i), Z3(i + 2));
	end generate;
	FA4Gen : for i in 0 to 1 generate
		FA4 : FAm
			port map(X4(3 * i), X4(3 * i + 1), X4(3 * i + 2), sleep, Z5(i), Z4(i + 2));
	end generate;
	FA5Gen : for i in 0 to 1 generate
		FA5 : FAm
			port map(X5(3 * i), X5(3 * i + 1), X5(3 * i + 2), sleep, Z6(i), Z5(i + 2));
	end generate;
	FA6Gen : for i in 0 to 1 generate
		FA6 : FAm
			port map(X6(3 * i), X6(3 * i + 1), X6(3 * i + 2), sleep, Z7(i), Z6(i + 2));
	end generate;
	FA7Gen : for i in 0 to 1 generate
		FA7 : FAm
			port map(X7(3 * i), X7(3 * i + 1), X7(3 * i + 2), sleep, Z8(i), Z7(i + 2));
	end generate;
	FA8Gen : for i in 0 to 1 generate
		FA3 : FAm
			port map(X8(3 * i), X8(3 * i + 1), X8(3 * i + 2), sleep, Z9(i), Z8(i + 2));
	end generate;
	FA9Gen : for i in 0 to 1 generate
		FA9 : FAm
			port map(X9(3 * i), X9(3 * i + 1), X9(3 * i + 2), sleep, Z10(i), Z9(i + 2));
	end generate;
	FA10Gen : for i in 0 to 1 generate
		FA10 : FAm
			port map(X10(3 * i), X10(3 * i + 1), X10(3 * i + 2), sleep, Z11(i), Z10(i + 2));
	end generate;
	FA11Gen : for i in 0 to 1 generate
		FA11 : FAm
			port map(X11(3 * i), X11(3 * i + 1), X11(3 * i + 2), sleep, Z12(i), Z11(i + 2));
	end generate;
	FA12Gen : for i in 0 to 1 generate
		FA12 : FAm
			port map(X12(3 * i), X12(3 * i + 1), X12(3 * i + 2), sleep, Z13(i), Z12(i + 2));
	end generate;
	FA13Gen : for i in 0 to 1 generate
		FA13 : FAm
			port map(X13(3 * i), X13(3 * i + 1), X13(3 * i + 2), sleep, Z14(i), Z13(i + 2));
	end generate;
	FA14Gen : for i in 0 to 1 generate
		FA14 : FAm
			port map(X14(3 * i), X14(3 * i + 1), X14(3 * i + 2), sleep, Z15(i), Z14(i + 2));
	end generate;
	FA15Gen : for i in 0 to 1 generate
		FA15 : FAm
			port map(X15(3 * i), X15(3 * i + 1), X15(3 * i + 2), sleep, temp_carry(i), Z15(i + 2));
	end generate;
end;