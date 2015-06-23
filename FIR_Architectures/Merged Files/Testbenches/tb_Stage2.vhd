Library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;
use ieee.std_logic_arith.all;
use work.ncl_signals.all;
use work.functions.all;

use ieee.math_real.all;

entity tb_Stage2 is
end;

architecture arch of tb_Stage2 is
	signal   X0   					  						 : dual_rail_logic_vector(15 downto 0);
	signal	 X1 					  						 : dual_rail_logic_vector(31 downto 0);
	signal	 X2    										     : dual_rail_logic_vector(47 downto 0);
	signal	 X3, X4, X5, X6, X7, X8, X9, X10, X11, X12, X13  : dual_rail_logic_vector(62 downto 0);
	signal	 X14 					 						 : dual_rail_logic_vector(31 downto 0);
	signal	 X15   					  						 : dual_rail_logic_vector(15 downto 0);
		
	signal	s : std_logic;
		
	signal	Z0    											 : dual_rail_logic_vector(15 downto 0);
	signal	Z1    											 : dual_rail_logic_vector(31 downto 0);
	signal	Z2, Z3, Z4, Z5, Z6, Z7, Z8, Z9, Z10, Z11, Z12, Z13, Z14   : dual_rail_logic_vector(41 downto 0);
	signal	Z15     										 : dual_rail_logic_vector(15 downto 0);
	
	component Merged_S1 is
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
	end component;

begin
	CUT : Merged_S1
		port map(X0, X1, X2, X3, X4, X5, X6, X7, X8, X9, X10, X11, X12, X13, X14, X15, s,
			Z0, Z1, Z2, Z3, Z4, Z5, Z6, Z7, Z8, Z9, Z10, Z11, Z12, Z13, Z14, Z15
		);

	inputs : process

	begin
		
		-- NULL Cycle
		for i in 0 to 15 loop
			X0(i).rail1 <= '0';
			X0(i).rail0 <= '0';
			X15(i).rail1 <= '0';
			X15(i).rail0 <= '0';
		end loop;
		
		for i in 0 to 31 loop
			X1(i).rail1 <= '0';
			X1(i).rail0 <= '0';
			X14(i).rail1 <= '0';
			X14(i).rail0 <= '0';
		end loop;
		
		for i in 0 to 47 loop
			X2(i).rail1 <= '0';
			X2(i).rail0 <= '0';
		end loop;
		
		for i in 0 to 48 loop
			X13(i).rail1 <= '0';
			X13(i).rail0 <= '0';
		end loop;
		
		for i in 0 to 63 loop
			X3(i).rail1 <= '0';
			X3(i).rail0 <= '0';
			X12(i).rail1 <= '0';
			X12(i).rail0 <= '0';
		end loop;
		
		for i in 0 to 79 loop
			X4(i).rail1 <= '0';
			X4(i).rail0 <= '0';
		end loop;
		
		for i in 0 to 89 loop
			X11(i).rail1 <= '0';
			X11(i).rail0 <= '0';
		end loop;
		
		for i in 0 to 93 loop
			X5(i).rail1 <= '0';
			X5(i).rail0 <= '0';
			X6(i).rail1 <= '0';
			X6(i).rail0 <= '0';
			X7(i).rail1 <= '0';
			X7(i).rail0 <= '0';
			X8(i).rail1 <= '0';
			X8(i).rail0 <= '0';
			X9(i).rail1 <= '0';
			X9(i).rail0 <= '0';
			X10(i).rail1 <= '0';
			X10(i).rail0 <= '0';
		end loop;
	

		s <= '1';
		wait for 50 ns;
		
		s <= '0';
		wait for 1 ns;
		
		-- Data 1
		for i in 0 to 15 loop
			X0(i).rail1 <= '1';
			X0(i).rail0 <= '0';
			X15(i).rail1 <= '1';
			X15(i).rail0 <= '0';
		end loop;
		
		for i in 0 to 31 loop
			X1(i).rail1 <= '1';
			X1(i).rail0 <= '0';
			X14(i).rail1 <= '1';
			X14(i).rail0 <= '0';
		end loop;
		
		for i in 0 to 47 loop
			X2(i).rail1 <= '1';
			X2(i).rail0 <= '0';
		end loop;
		
		for i in 0 to 48 loop
			X13(i).rail1 <= '1';
			X13(i).rail0 <= '0';
		end loop;
		
		for i in 0 to 63 loop
			X3(i).rail1 <= '1';
			X3(i).rail0 <= '0';
			X12(i).rail1 <= '1';
			X12(i).rail0 <= '0';
		end loop;
		
		for i in 0 to 79 loop
			X4(i).rail1 <= '1';
			X4(i).rail0 <= '0';
		end loop;
		
		for i in 0 to 89 loop
			X11(i).rail1 <= '1';
			X11(i).rail0 <= '0';
		end loop;
		
		for i in 0 to 93 loop
			X5(i).rail1 <= '1';
			X5(i).rail0 <= '0';
			X6(i).rail1 <= '1';
			X6(i).rail0 <= '0';
			X7(i).rail1 <= '1';
			X7(i).rail0 <= '0';
			X8(i).rail1 <= '1';
			X8(i).rail0 <= '0';
			X9(i).rail1 <= '1';
			X9(i).rail0 <= '0';
			X10(i).rail1 <= '1';
			X10(i).rail0 <= '0';
		end loop;
		
		wait for 100 ns;
		s <= '1';
		wait for 2 ns;
		
		-- NULL Cycle
		for i in 0 to 15 loop
			X0(i).rail1 <= '0';
			X0(i).rail0 <= '0';
			X15(i).rail1 <= '0';
			X15(i).rail0 <= '0';
		end loop;
		
		for i in 0 to 31 loop
			X1(i).rail1 <= '0';
			X1(i).rail0 <= '0';
			X14(i).rail1 <= '0';
			X14(i).rail0 <= '0';
		end loop;
		
		for i in 0 to 47 loop
			X2(i).rail1 <= '0';
			X2(i).rail0 <= '0';
		end loop;
		
		for i in 0 to 48 loop
			X13(i).rail1 <= '0';
			X13(i).rail0 <= '0';
		end loop;
		
		for i in 0 to 63 loop
			X3(i).rail1 <= '0';
			X3(i).rail0 <= '0';
			X12(i).rail1 <= '0';
			X12(i).rail0 <= '0';
		end loop;
		
		for i in 0 to 79 loop
			X4(i).rail1 <= '0';
			X4(i).rail0 <= '0';
		end loop;
		
		for i in 0 to 89 loop
			X11(i).rail1 <= '0';
			X11(i).rail0 <= '0';
		end loop;
		
		for i in 0 to 93 loop
			X5(i).rail1 <= '0';
			X5(i).rail0 <= '0';
			X6(i).rail1 <= '0';
			X6(i).rail0 <= '0';
			X7(i).rail1 <= '0';
			X7(i).rail0 <= '0';
			X8(i).rail1 <= '0';
			X8(i).rail0 <= '0';
			X9(i).rail1 <= '0';
			X9(i).rail0 <= '0';
			X10(i).rail1 <= '0';
			X10(i).rail0 <= '0';
		end loop;
		wait;

	end process;
	
end arch;