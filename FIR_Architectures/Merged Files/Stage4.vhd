library ieee;
use ieee.std_logic_1164.all;
use work.ncl_signals.all;

entity Merged_S4 is
	port(X0   					  						 : in  dual_rail_logic_vector(15 downto 0);
		 X1, X2, X3, X4, X5, X6, X7, X8, X9, X10, X11, X12, X13, X14, X15 : in dual_rail_logic_vector(27 downto 0);
		
		sleep : in  std_logic;
		
		Z0    											 : out  dual_rail_logic_vector(15 downto 0);
		Z1, Z2, Z3, Z4, Z5, Z6, Z7, Z8, Z9, Z10, Z11, Z12, Z13, Z14, Z15 : out dual_rail_logic_vector(18 downto 0));
end;

architecture arch of Merged_S4 is
	
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
	
	signal temp_carry : dual_rail_logic_vector(8 downto 0);
	
begin
	--Inputs to outputs directly
	Z0 <= X0;
	Z4(0) <= X4(26);
	Z4(1) <= X4(27);
	Z5(0) <= X5(27);
	Z6(0) <= X6(27);
	Z7(0) <= X7(27);
	Z8(0) <= X8(27);
	Z9(0) <= X9(27);
	Z10(0) <= X10(27);
	Z11(0) <= X11(27);
	Z12(0) <= X12(27);
	Z13(0) <= X13(27);
	Z14(0) <= X14(27);
	Z15(0) <= X15(27);
	
	Z1a: for i in 0 to 13 generate
		Z1(i) <= X1(i + 14);
	end generate;
	Z2a: for i in 0 to 6 generate
		Z2(i) <= X2(i + 21);
	end generate;
	Z3a: for i in 0 to 3 generate
		Z3(i) <= X3(i + 24);
	end generate;
	
	-- Adder logic
	FA1Gen : for i in 0 to 3 generate
		FA1 : FAm	
			port map(X1(3 * i), X1(3 * i + 1), X1(3 * i + 2), sleep, Z2(8 + i), Z1(15 + i));
	end generate;
	HA1 : HAm
		port map(X1(12), X1(13), sleep, Z2(7), Z1(14));
	FA2Gen : for i in 0 to 6 generate
		FA2 : FAm
			port map(X2(3 * i), X2(3 * i + 1), X2(3 * i + 2), sleep, Z3(4 + i), Z2(12 + i));
	end generate;
	FA3Gen : for i in 0 to 7 generate
		FA3 : FAm
			port map(X3(3 * i), X3(3 * i + 1), X3(3 * i + 2), sleep, Z4(2 + i), Z3(11 + i));
	end generate;
	FA4Gen : for i in 0 to 7 generate
		FA4 : FAm
			port map(X4(3 * i), X4(3 * i + 1), X4(3 * i + 2), sleep, Z5(2 + i), Z4(11 + i));
	end generate;
	HA4 : HAm
		port map(X4(24), X4(25), sleep, Z5(1), Z4(10));
	FA5Gen : for i in 0 to 8 generate
		FA5 : FAm
			port map(X5(3 * i), X5(3 * i + 1), X5(3 * i + 2), sleep, Z6(1 + i), Z5(10 + i));
	end generate;
	FA6Gen : for i in 0 to 8 generate
		FA6 : FAm
			port map(X6(3 * i), X6(3 * i + 1), X6(3 * i + 2), sleep, Z7(1 + i), Z6(10 + i));
	end generate;
	FA7Gen : for i in 0 to 8 generate
		FA7 : FAm
			port map(X7(3 * i), X7(3 * i + 1), X7(3 * i + 2), sleep, Z8(1 + i), Z7(10 + i));
	end generate;
	FA8Gen : for i in 0 to 8 generate
		FA8 : FAm
			port map(X8(3 * i), X8(3 * i + 1), X8(3 * i + 2), sleep, Z9(1 + i), Z8(10 + i));
	end generate;
	FA9Gen : for i in 0 to 8 generate
		FA9 : FAm
			port map(X9(3 * i), X9(3 * i + 1), X9(3 * i + 2), sleep, Z10(1 + i), Z9(10 + i));
	end generate;
	FA10Gen : for i in 0 to 8 generate
		FA10 : FAm
			port map(X10(3 * i), X10(3 * i + 1), X10(3 * i + 2), sleep, Z11(1 + i), Z10(10 + i));
	end generate;
	FA11Gen : for i in 0 to 8 generate
		FA11 : FAm
			port map(X11(3 * i), X11(3 * i + 1), X11(3 * i + 2), sleep, Z12(1 + i), Z11(10 + i));
	end generate;
	FA12Gen : for i in 0 to 8 generate
		FA12 : FAm
			port map(X12(3 * i), X12(3 * i + 1), X12(3 * i + 2), sleep, Z13(1 + i), Z12(10 + i));
	end generate;
	FA13Gen : for i in 0 to 8 generate
		FA13 : FAm
			port map(X13(3 * i), X13(3 * i + 1), X13(3 * i + 2), sleep, Z14(1 + i), Z13(10 + i));
	end generate;
	FA14Gen : for i in 0 to 8 generate
		FA14 : FAm
			port map(X14(3 * i), X14(3 * i + 1), X14(3 * i + 2), sleep, Z15(1 + i), Z14(10 + i));
	end generate;
	FA15Gen : for i in 0 to 8 generate
		FA15 : FAm
			port map(X15(3 * i), X15(3 * i + 1), X15(3 * i + 2), sleep, temp_carry(i), Z15(10 + i));
	end generate;
	
end arch;