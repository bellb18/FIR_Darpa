Library IEEE;
use IEEE.std_logic_1164.all;
use work.ncl_signals.all;
entity Merged_S2 is
	port(X0                      : in  dual_rail_logic_vector(15 downto 0);
		 X1                      : in  dual_rail_logic_vector(31 downto 0);
		 X2                      : in  dual_rail_logic_vector(47 downto 0);
		 X3, X4, X5, X6, X7, X8, X9, X10, X11, X12, X13 : in  dual_rail_logic_vector(62 downto 0);
		 X14                     : in  dual_rail_logic_vector(32 downto 0);
		 X15                     : in  dual_rail_logic_vector(15 downto 0);
		 sleep                   : in  std_logic;
		 Z0                      : out dual_rail_logic_vector(15 downto 0);
		 Z1                      : out dual_rail_logic_vector(31 downto 0);
		 Z2, Z3, Z4, Z5, Z6, Z7, Z8, Z9, Z10, Z11, Z12, Z13, Z14 : out dual_rail_logic_vector(41 downto 0);
		 Z15                     : out dual_rail_logic_vector(21 downto 0));
end;

architecture struct of Merged_S2 is
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
	Z0  <= X0;
	Z1	<= X1;

	Z2a : for i in 0 to 38 generate
		Z2(i) <= X2(i + 9);
	end generate;
	Z3a : for i in 0 to 26 generate
		Z3(i) <= X3(i + 36);
	end generate;
	Z4a : for i in 0 to 12 generate
		Z4(i) <= X4(i + 50);
	end generate;
	Z5a : for i in 0 to 5 generate
		Z5(i) <= X5(i + 57);
	end generate;
	Z6a : for i in 0 to 2 generate
		Z6(i) <= X6(i + 60);
	end generate;
	Z7(0) <= X7(62);	
	Z14a : for i in 0 to 14 generate
		Z14(i) <= X14(i + 18);
	end generate;
	Z15a : for i in 0 to 15 generate
		Z15(i) <= X15(i);
	end generate;
	
    FA2Gen : for i in 0 to 2 generate 
    	FA2 : FAm
    		port map(X2(3 * i), X2(3 * i + 1), X2(3 * i + 2), sleep, Z3(i + 27), Z2(i + 39));
    end generate;
    FA3Gen : for i in 0 to 11 generate
    	FA3 : FAm
    		port map(X3(3 * i), X3(3 * i + 1), X3(3 * i + 2), sleep, Z4(i + 13), Z3(i + 30));
    end generate;
    FA4Gen : for i in 0 to 15 generate
    	FA4 : FAm
    		port map(X4(3 * i), X4(3 * i + 1), X4(3 * i + 2), sleep, Z5(i + 6), Z4(i + 25));
    end generate;
    HA4 : HAm
    	port map(X4(48), X4(49), sleep, Z5(22), Z4(41));
    FA5Gen : for i in 0 to 18 generate
    	FA5 : FAm
    		port map(X5(3 * i), X5(3 * i + 1), X5(3 * i + 2), sleep, Z6(i + 3), Z5(i + 23));
    end generate;    	
    FA6Gen : for i in 0 to 19 generate
    	FA6 : FAm
    		port map(X6(3 * i), X6(3 * i + 1), X6(3 * i + 2), sleep, Z7(i + 1), Z6(i + 22));
    end generate;
    FA7Gen : for i in 0 to 19 generate
    	FA7 : FAm
    		port map(X7(3 * i), X7(3 * i + 1), X7(3 * i + 2), sleep, Z8(i), Z7(i + 21));
    end generate;
    HA7 : HAm
    	port map(X7(60), X7(61), sleep, Z8(20), Z7(41));
    FA8Gen : for i in 0 to 20 generate
    	FA8 : FAm
    		port map(X8(3 * i), X8(3 * i + 1), X8(3 * i + 2), sleep, Z9(i), Z8(i + 21));
    end generate;
    FA9Gen : for i in 0 to 20 generate
    	FA9 : FAm
    		port map(X9(3 * i), X9(3 * i + 1), X9(3 * i + 2), sleep, Z10(i), Z9(i + 21));
    end generate;
    FA10Gen : for i in 0 to 20 generate
    	FA10 : FAm
    		port map(X10(3 * i), X10(3 * i + 1), X10(3 * i + 2), sleep, Z11(i), Z10(i + 21));
    end generate;
    FA11Gen : for i in 0 to 20 generate
    	FA11 : FAm
    		port map(X11(3 * i), X11(3 * i + 1), X11(3 * i + 2), sleep, Z12(i), Z11(i + 21));
    end generate;
    FA12Gen : for i in 0 to 20 generate
    	FA12 : FAm
    		port map(X12(3 * i), X12(3 * i + 1), X12(3 * i + 2), sleep, Z13(i), Z12(i + 21));
    end generate;
    FA13Gen : for i in 0 to 20 generate
    	FA13 : FAm
    		port map(X13(3 * i), X13(3 * i + 1), X13(3 * i + 2), sleep, Z14(i + 15), Z13(i + 21));
    end generate; 
    FA14Gen : for i in 0 to 5 generate
    	FA14 : FAm
    		port map(X14(3 * i), X14(3 * i + 1), X14(3 * i + 2), sleep, Z15(i + 16), Z14(i + 36));
    end generate;
    	
end;