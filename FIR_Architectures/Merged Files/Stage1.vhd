library ieee;
use ieee.std_logic_1164.all;
use work.ncl_signals.all;

entity Merged_S1 is
	port(X0   					  						 : in  dual_rail_logic_vector(15 downto 0);
		 X1 					  						 : in dual_rail_logic_vector(31 downto 0);
		 X2    										     : in  dual_rail_logic_vector(47 downto 0);
		 X3 										     : in dual_rail_logic_vector(63 downto 0);
		 X4    					 						 : in  dual_rail_logic_vector(79 downto 0);
	     X5, X6, X7, X8, X9, X10  						 : in  dual_rail_logic_vector(93 downto 0);
		 X11    				  						 : in  dual_rail_logic_vector(89 downto 0);
		 X12 					 						 : in dual_rail_logic_vector(63 downto 0);
		 X13 					 						 : in dual_rail_logic_vector(48 downto 0);
		 X14 					 						 : in dual_rail_logic_vector(31 downto 0);
		 X15   					  						 : in  dual_rail_logic_vector(15 downto 0);
		
		sleep : in  std_logic;
		
		Z0    											 : out  dual_rail_logic_vector(15 downto 0);
		Z1    											 : out dual_rail_logic_vector(31 downto 0);
		Z2    											 : out  dual_rail_logic_vector(47 downto 0);
		Z3, Z4, Z5, Z6, Z7, Z8, Z9, Z10, Z11, Z12, Z13   : out dual_rail_logic_vector(62 downto 0);
		Z14    											 : out dual_rail_logic_vector(32 downto 0);
		Z15     										 : out  dual_rail_logic_vector(15 downto 0));
end;

architecture arch of Merged_S1 is
	
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
	
begin
	--Inputs to outputs directly
	Z0 <= X0;
	Z1 <= X1;
	Z2 <= X2;
	Z9(0) <= X9(92);
	Z9(1) <= X9(93);
	Z10(0) <= X10(93);
	Z15 <= X15;
	
	Z3a: for i in 0 to 61 generate
		Z3(i) <= X3(i + 2);
	end generate;
	Z4a: for i in 0 to 52 generate
		Z4(i) <= X4(i + 27);
	end generate;
	Z5a: for i in 0 to 33 generate
		Z5(i) <= X5(i + 60);
	end generate;
	Z6a: for i in 0 to 16 generate
		Z6(i) <= X6(i + 77);
	end generate;
	Z7a: for i in 0 to 7 generate
		Z7(i) <= X7(i + 86);
	end generate;
	Z8a: for i in 0 to 3 generate
		Z8(i) <= X8(i + 90);
	end generate;
	Z11a: for i in 0 to 2 generate
		Z11(i) <= X11(i + 87);
	end generate;
	Z12a: for i in 0 to 18 generate
		Z12(i) <= X12(i + 45);
	end generate;
	Z13a: for i in 0 to 46 generate
		Z13(i) <= X13(i + 2);
	end generate;
	Z14a: for i in 0 to 31 generate
		Z14(i) <= X14(i);
	end generate;
	
	-- Adder logic
	HA3 : HAm
		port map(X3(0), X3(1), sleep, Z4(53), Z3(62));
	FA4Gen : for i in 0 to 8 generate
		FA4 : FAm	
			port map(X4(3 * i), X4(3 * i + 1), X4(3 * i + 2), sleep, Z5(34 + i), Z4(54 + i));
	end generate;
	FA5Gen: for i in 0 to 19 generate
		FA5: FAm
			port map(X5(3 * i ), X5(3 * i + 1), X5(3 * i + 2), sleep, Z6(17 + i), Z5(43 + i));
	end generate;
	FA6Gen: for i in 0 to 24 generate
		FA6: FAm
			port map(X6(3 * i), X6(3 * i + 1), X6(3 * i + 2), sleep, Z7(9 + i), Z6(38 + i));
	end generate;
	HA6 : HAm
		port map(X6(75), X6(76), sleep, Z7(8), Z6(37));
	FA7Gen: for i in 0 to 27 generate
		FA7: FAm
			port map(X7(3 * i), X7(3 * i + 1), X7(3 * i + 2), sleep, Z8(5 + i), Z7(35 + i));
	end generate;
	HA7 : HAm
		port map(X7(84), X7(85), sleep, Z8(4), Z7(34));
	FA8Gen: for i in 0 to 29 generate
		FA8: FAm
			port map(X8(3 * i), X8(3 * i + 1), X8(3 * i + 2), sleep, Z9(2 + i), Z8(33 + i));
	end generate;
	FA9Gen: for i in 0 to 29 generate
		FA9: FAm
			port map(X9(3 * i), X9(3 * i + 1), X9(3 * i + 2), sleep, Z10(2 + i), Z9(33 + i));
	end generate;
	HA9 : HAm
		port map(X9(90), X9(91), sleep, Z10(1), Z9(32));
	FA10Gen: for i in 0 to 30 generate
		FA10: FAm
			port map(X10(3 * i), X10(3 * i + 1), X10(3 * i + 2), sleep, Z11(3 + i), Z10(32 + i));
	end generate;
	FA11Gen: for i in 0 to 28 generate
		FA11: FAm
			port map(X11(3 * i), X11(3 * i + 1), X11(3 * i + 2), sleep, Z12(19 + i), Z11(34 + i));
	end generate;
	FA12Gen: for i in 0 to 14 generate
		FA12: FAm
			port map(X12(3 * i), X12(3 * i + 1), X12(3 * i + 2), sleep, Z13(47 + i), Z12(48 + i));
	end generate;
	HA13 : HAm
		port map(X13(0), X13(1), sleep, Z14(32), Z13(62));
	
end arch;