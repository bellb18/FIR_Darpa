Library IEEE;
use IEEE.std_logic_1164.all;
use work.ncl_signals.all;
entity Merged_S9 is
	port(X0, X1, X2, X3, X4, X5, X6, X7, X8, X9, X10, X11, X12, X13, X14, X15 : in  dual_rail_logic_vector(3 downto 0);
		 sleep                   : in  std_logic;
		 Z0, Z1, Z2, Z3, Z4, Z5, Z6, Z7, Z8, Z9, Z10, Z11, Z12, Z13, Z14, Z15 : out dual_rail_logic_vector(2 downto 0));
end;

architecture struct of Merged_S9 is
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
	signal  temp_carry : dual_rail_logic;
begin
	Z0a : for i in 0 to 1 generate
		Z0(i) <= X0(i);
	end generate;
	Z1(0) <= X1(3);
	Z2(0) <= X2(3);
	Z3(0) <= X3(3);
	Z4(0) <= X4(3);
	Z5(0) <= X5(3);
	Z6(0) <= X6(3);
	Z7(0) <= X7(3);
	Z8(0) <= X8(3);
	Z9(0) <= X9(3);
	Z10(0) <= X10(3);
	Z11(0) <= X11(3);
	Z12(0) <= X12(3);
	Z13(0) <= X13(3);
	Z14(0) <= X14(3);
	Z15(0) <= X15(3);
	
	HA0 : HAm
		port map(X0(2), X0(3), sleep, Z1(1), Z0(2));
	FA1 : FAm
		port map(X1(0), X1(1), X1(2), sleep, Z2(1), Z1(2));
	FA2 : FAm
		port map(X2(0), X2(1), X2(2), sleep, Z3(1), Z2(2));
	FA3 : FAm
		port map(X3(0), X3(1), X3(2), sleep, Z4(1), Z3(2));
	FA4 : FAm
		port map(X4(0), X4(1), X4(2), sleep, Z5(1), Z4(2));
	FA5 : FAm
		port map(X5(0), X5(1), X5(2), sleep, Z6(1), Z5(2));
	FA6 : FAm
		port map(X6(0), X6(1), X6(2), sleep, Z7(1), Z6(2));
	FA7 : FAm
		port map(X7(0), X7(1), X7(2), sleep, Z8(1), Z7(2));
	FA8 : FAm
		port map(X8(0), X8(1), X8(2), sleep, Z9(1), Z8(2));
	FA9 : FAm
		port map(X9(0), X9(1), X9(2), sleep, Z10(1), Z9(2));
	FA10 : FAm
		port map(X10(0), X10(1), X10(2), sleep, Z11(1), Z10(2));
	FA11 : FAm
		port map(X11(0), X11(1), X11(2), sleep, Z12(1), Z11(2));
	FA12 : FAm
		port map(X12(0), X12(1), X12(2), sleep, Z13(1), Z12(2));
	FA13 : FAm
		port map(X13(0), X13(1), X13(2), sleep, Z14(1), Z13(2));
	FA14 : FAm
		port map(X14(0), X14(1), X14(2), sleep, Z15(1), Z14(2));
	FA15 : FAm
		port map(X15(0), X15(1), X15(2), sleep, temp_carry, Z15(2));
end;