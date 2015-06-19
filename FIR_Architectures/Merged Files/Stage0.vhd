Library IEEE;
use IEEE.std_logic_1164.all;
use work.ncl_signals.all;
entity Merged_S0 is
	port(X0, X15     : in  dual_rail_logic_vector(15 downto 0);
		X1, X14 : in dual_rail_logic_vector(31 downto 0);
		X2     : in  dual_rail_logic_vector(47 downto 0);
		X3, X12 : in dual_rail_logic_vector(63 downto 0);
		X4, X11     : in  dual_rail_logic_vector(79 downto 0);
		X5 : in dual_rail_logic_vector(95 downto 0);
		X10 : in dual_rail_logic_vector(96 downto 0);
		X6, X7, X8, X9     : in  dual_rail_logic_vector(111 downto 0);
		X13 : in dual_rail_logic_vector(48 downto 0);
		
		sleep : in  std_logic;
		
		Z0, Z15     : out  dual_rail_logic_vector(15 downto 0);
		Z1, Z14 : out dual_rail_logic_vector(31 downto 0);
		Z2     : out  dual_rail_logic_vector(47 downto 0);
		Z3, Z12 : out dual_rail_logic_vector(63 downto 0);
		Z4    : out  dual_rail_logic_vector(79 downto 0);
		Z5, Z6, Z7, Z8, Z9, Z10 : out dual_rail_logic_vector(93 downto 0);
		Z11    : out  dual_rail_logic_vector(89 downto 0);
		Z13     : out  dual_rail_logic_vector(48 downto 0));
end;

architecture struct of Merged_S0 is

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

	component HAm1 is
		port(
			X    : IN  dual_rail_logic;
			COUT : OUT dual_rail_logic;
			S    : OUT dual_rail_logic);
	end component;

	component FAm1 is
		port(X     : dual_rail_logic;
			 Y     : in  dual_rail_logic;
			 sleep : in  std_logic;
			 COUT  : out dual_rail_logic;
			 S     : out dual_rail_logic);
	end component;
begin
	Z0 <= X0;
	Z1 <= X1;
	Z2 <= X2;
	Z3 <= X3;
	Z4 <= X4;
	Z12 <= X12;
	Z13 <= X13;
	Z14 <= X14;
	Z15 <= X15;
	
	Z5a: for i in 0 to 92 generate
		Z5(i) <= X5(i + 3);
	end generate;
	Z6a: for i in 0 to 82 generate
		Z6(i) <= X6(i + 29);
	end generate;
	Z7a: for i in 0 to 69 generate
		Z7(i) <= X7(i + 42);
	end generate;
	Z8a: for i in 0 to 63 generate
		Z8(i) <= X8(i + 48);
	end generate;
	Z9a: for i in 0 to 60 generate
		Z9(i) <= X9(i + 51);
	end generate;
	Z10a: for i in 0 to 66 generate
		Z10(i) <= X10(i + 30);
	end generate;
	Z11a: for i in 0 to 79 generate
		Z11(i) <= X11(i);
	end generate;
		
	
	FA5: FAm
		port map(X5(0), X5(1), X5(2), sleep, Z6(83), Z5(93));
	FA6Gen: for i in 0 to 8 generate
		FA6: FAm
			port map(X6(3*i), X6(3*i + 1), X6(3*i + 2), sleep, Z7(70 + i), Z6(84 + i));
	end generate;
	HA6: HAm
		port map(X6(27), X6(28), sleep, Z7(79), Z6(93));
	FA7Gen: for i in 0 to 13 generate
		FA7: FAm
			port map(X7(3*i), X7(3*i + 1), X7(3*i + 2), sleep, Z8(64 + i), Z7(80 + i));
	end generate;
	FA8Gen: for i in 0 to 15 generate
		FA8: FAm
			port map(X8(3*i), X8(3*i + 1), X8(3*i + 2), sleep, Z9(61 + i), Z8(78 + i));
	end generate;
	FA9Gen: for i in 0 to 16 generate
		FA9: FAm
			port map(X9(3*i), X9(3*i + 1), X9(3*i + 2), sleep, Z10(67 + i), Z9(77 + i));
	end generate;
	FA10Gen: for i in 0 to 9 generate
		FA10: FAm
			port map(X10(3*i), X10(3*i + 1), X10(3*i + 2), sleep, Z11(80 + i), Z10(84 + i));
	end generate;
	
end;