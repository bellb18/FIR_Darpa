library ieee;
use ieee.std_logic_1164.all;
use work.ncl_signals.all;

entity Merged_S10 is
	port(X0, X1, X2, X3, X4, X5, X6, X7, X8, X9, X10, X11, X12, X13, X14, X15 : in dual_rail_logic_vector(2 downto 0);
		sleep : in  std_logic;
		Z0, Z1, Z2, Z3, Z4, Z5, Z6, Z7, Z8, Z9, Z10, Z11, Z12, Z13, Z14, Z15 : out dual_rail_logic_vector(1 downto 0));
end;

architecture arch of Merged_S10 is
	
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
	
	signal temp_carry : dual_rail_logic;
	
begin
	--Inputs to outputs directly
	Z0(0) <= X0(2);
	
	-- Adder logic
	HA0 : HAm
		port map(X0(0), X0(1), sleep, Z1(0), Z0(1));
	FA1 : FAm
		port map(X1(0), X1(1), X1(2), sleep, Z2(0), Z1(1));
	FA2 : FAm
		port map(X2(0), X2(1), X2(2), sleep, Z3(0), Z2(1));
	FA3 : FAm
		port map(X3(0), X3(1), X3(2), sleep, Z4(0), Z3(1));
	FA4 : FAm
		port map(X4(0), X4(1), X4(2), sleep, Z5(0), Z4(1));
	FA5 : FAm
		port map(X5(0), X5(1), X5(2), sleep, Z6(0), Z5(1));
	FA6 : FAm
		port map(X6(0), X6(1), X6(2), sleep, Z7(0), Z6(1));
	FA7 : FAm
		port map(X7(0), X7(1), X7(2), sleep, Z8(0), Z7(1));
	FA8 : FAm
		port map(X8(0), X8(1), X8(2), sleep, Z9(0), Z8(1));
	FA9 : FAm
		port map(X9(0), X9(1), X9(2), sleep, Z10(0), Z9(1));
	FA10 : FAm
		port map(X10(0), X10(1), X10(2), sleep, Z11(0), Z10(1));
	FA11 : FAm
		port map(X11(0), X11(1), X11(2), sleep, Z12(0), Z11(1));
	FA12 : FAm
		port map(X12(0), X12(1), X12(2), sleep, Z13(0), Z12(1));
	FA13 : FAm
		port map(X13(0), X13(1), X13(2), sleep, Z14(0), Z13(1));
	FA14 : FAm
		port map(X14(0), X14(1), X14(2), sleep, Z15(0), Z14(1));
	FA15 : FAm
		port map(X15(0), X15(1), X15(2), sleep, temp_carry, Z15(1));
	
end arch;