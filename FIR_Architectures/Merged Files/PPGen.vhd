Library IEEE;
use IEEE.std_logic_1164.all;
use work.ncl_signals.all;
use IEEE.numeric_std.all;
use work.FIR_pack.all;
entity Merged_PPGen is
	port(X              : in  XType;
		 C              : in  CType;
		 sleep          : in  std_logic;
		 Z0             : out dual_rail_logic_vector(15 downto 0);
		 Z1             : out dual_rail_logic_vector(31 downto 0);
		 Z2             : out dual_rail_logic_vector(47 downto 0);
		 Z3             : out dual_rail_logic_vector(63 downto 0);
		 Z4             : out dual_rail_logic_vector(79 downto 0);
		 Z5             : out dual_rail_logic_vector(95 downto 0);
		 Z6, Z7, Z8, Z9 : out dual_rail_logic_vector(111 downto 0);
		 Z10            : out dual_rail_logic_vector(96 downto 0);
		 Z11            : out dual_rail_logic_vector(79 downto 0);
		 Z12            : out dual_rail_logic_vector(63 downto 0);
		 Z13            : out dual_rail_logic_vector(48 downto 0);
		 Z14            : out dual_rail_logic_vector(31 downto 0);
		 Z15            : out dual_rail_logic_vector(15 downto 0));
end;

architecture struct of Merged_PPGen is
	component and2im is
		port(a     : IN  dual_rail_logic;
			 b     : IN  dual_rail_logic;
			 sleep : in  std_logic;
			 z     : OUT dual_rail_logic);
	end component;

	signal Z6_temp, Z7_temp, Z8_temp, Z9_temp : dual_rail_logic_vector(111 downto 0);
	signal Z10_temp                           : dual_rail_logic_vector(96 downto 0);
	signal Z11_temp                           : dual_rail_logic_vector(79 downto 0);
	signal Z12_temp                           : dual_rail_logic_vector(63 downto 0);
	signal Z13_temp                           : dual_rail_logic_vector(48 downto 0);
	signal Z14_temp                           : dual_rail_logic_vector(31 downto 0);

begin
	Z10(96).rail1 <= '1';
	Z10(96).rail0 <= '0';
	Z13(48).rail1 <= '1';
	Z13(48).rail0 <= '0';
	ZGen : for i in 0 to 15 generate
		Z0ANDa : and2im
			port map(X(i)(0), C(i)(0), sleep, Z0(i));

		Z1ANDa : and2im
			port map(X(i)(1), C(i)(0), sleep, Z1(i));
		Z1ANDb : and2im
			port map(X(i)(0), C(i)(1), sleep, Z1(i + 16));

		Z2ANDa : and2im
			port map(X(i)(2), C(i)(0), sleep, Z2(i));
		Z2ANDb : and2im
			port map(X(i)(1), C(i)(1), sleep, Z2(i + 16));
		Z2ANDc : and2im
			port map(X(i)(0), C(i)(2), sleep, Z2(i + 32));

		Z3ANDa : and2im
			port map(X(i)(3), C(i)(0), sleep, Z3(i));
		Z3ANDb : and2im
			port map(X(i)(2), C(i)(1), sleep, Z3(i + 16));
		Z3ANDc : and2im
			port map(X(i)(1), C(i)(2), sleep, Z3(i + 32));
		Z3ANDd : and2im
			port map(X(i)(0), C(i)(3), sleep, Z3(i + 48));

		Z4ANDa : and2im
			port map(X(i)(4), C(i)(0), sleep, Z4(i));
		Z4ANDb : and2im
			port map(X(i)(3), C(i)(1), sleep, Z4(i + 16));
		Z4ANDc : and2im
			port map(X(i)(2), C(i)(2), sleep, Z4(i + 32));
		Z4ANDd : and2im
			port map(X(i)(1), C(i)(3), sleep, Z4(i + 48));
		Z4ANDe : and2im
			port map(X(i)(0), C(i)(4), sleep, Z4(i + 64));

		Z5ANDa : and2im
			port map(X(i)(5), C(i)(0), sleep, Z5(i));
		Z5ANDb : and2im
			port map(X(i)(4), C(i)(1), sleep, Z5(i + 16));
		Z5ANDc : and2im
			port map(X(i)(3), C(i)(2), sleep, Z5(i + 32));
		Z5ANDd : and2im
			port map(X(i)(2), C(i)(3), sleep, Z5(i + 48));
		Z5ANDe : and2im
			port map(X(i)(1), C(i)(4), sleep, Z5(i + 64));
		Z5ANDf : and2im
			port map(X(i)(0), C(i)(5), sleep, Z5(i + 80));

		Z6ANDa : and2im
			port map(X(i)(6), C(i)(0), sleep, Z6_temp(i));
		Z6ANDb : and2im
			port map(X(i)(5), C(i)(1), sleep, Z6_temp(i + 16));
		Z6ANDc : and2im
			port map(X(i)(4), C(i)(2), sleep, Z6_temp(i + 32));
		Z6ANDd : and2im
			port map(X(i)(3), C(i)(3), sleep, Z6_temp(i + 48));
		Z6ANDe : and2im
			port map(X(i)(2), C(i)(4), sleep, Z6_temp(i + 64));
		Z6ANDf : and2im
			port map(X(i)(1), C(i)(5), sleep, Z6_temp(i + 80));
		Z6ANDg : and2im
			port map(X(i)(0), C(i)(6), sleep, Z6_temp(i + 96));

		Z7ANDa : and2im
			port map(X(i)(7), C(i)(0), sleep, Z7_temp(i));
		Z7ANDb : and2im
			port map(X(i)(6), C(i)(1), sleep, Z7_temp(i + 16));
		Z7ANDc : and2im
			port map(X(i)(5), C(i)(2), sleep, Z7_temp(i + 32));
		Z7ANDd : and2im
			port map(X(i)(4), C(i)(3), sleep, Z7_temp(i + 48));
		Z7ANDe : and2im
			port map(X(i)(3), C(i)(4), sleep, Z7_temp(i + 64));
		Z7ANDf : and2im
			port map(X(i)(2), C(i)(5), sleep, Z7_temp(i + 80));
		Z7ANDg : and2im
			port map(X(i)(1), C(i)(6), sleep, Z7_temp(i + 96));

		Z8ANDa : and2im
			port map(X(i)(8), C(i)(0), sleep, Z8_temp(i));
		Z8ANDb : and2im
			port map(X(i)(7), C(i)(1), sleep, Z8_temp(i + 16));
		Z8ANDc : and2im
			port map(X(i)(6), C(i)(2), sleep, Z8_temp(i + 32));
		Z8ANDd : and2im
			port map(X(i)(5), C(i)(3), sleep, Z8_temp(i + 48));
		Z8ANDe : and2im
			port map(X(i)(4), C(i)(4), sleep, Z8_temp(i + 64));
		Z8ANDf : and2im
			port map(X(i)(3), C(i)(5), sleep, Z8_temp(i + 80));
		Z8ANDg : and2im
			port map(X(i)(2), C(i)(6), sleep, Z8_temp(i + 96));

		Z9ANDa : and2im
			port map(X(i)(9), C(i)(0), sleep, Z9_temp(i));
		Z9ANDb : and2im
			port map(X(i)(8), C(i)(1), sleep, Z9_temp(i + 16));
		Z9ANDc : and2im
			port map(X(i)(7), C(i)(2), sleep, Z9_temp(i + 32));
		Z9ANDd : and2im
			port map(X(i)(6), C(i)(3), sleep, Z9_temp(i + 48));
		Z9ANDe : and2im
			port map(X(i)(5), C(i)(4), sleep, Z9_temp(i + 64));
		Z9ANDf : and2im
			port map(X(i)(4), C(i)(5), sleep, Z9_temp(i + 80));
		Z9ANDg : and2im
			port map(X(i)(3), C(i)(6), sleep, Z9_temp(i + 96));

		Z10ANDa : and2im
			port map(X(i)(9), C(i)(1), sleep, Z10_temp(i));
		Z10ANDb : and2im
			port map(X(i)(8), C(i)(2), sleep, Z10_temp(i + 16));
		Z10ANDc : and2im
			port map(X(i)(7), C(i)(3), sleep, Z10_temp(i + 32));
		Z10ANDd : and2im
			port map(X(i)(6), C(i)(4), sleep, Z10_temp(i + 48));
		Z10ANDe : and2im
			port map(X(i)(5), C(i)(5), sleep, Z10_temp(i + 64));
		Z10ANDf : and2im
			port map(X(i)(4), C(i)(6), sleep, Z10_temp(i + 80));

		Z11ANDa : and2im
			port map(X(i)(9), C(i)(2), sleep, Z11_temp(i));
		Z11ANDb : and2im
			port map(X(i)(8), C(i)(3), sleep, Z11_temp(i + 16));
		Z11ANDc : and2im
			port map(X(i)(7), C(i)(4), sleep, Z11_temp(i + 32));
		Z11ANDd : and2im
			port map(X(i)(6), C(i)(5), sleep, Z11_temp(i + 48));
		Z11ANDe : and2im
			port map(X(i)(5), C(i)(6), sleep, Z11_temp(i + 64));

		Z12ANDa : and2im
			port map(X(i)(9), C(i)(3), sleep, Z12_temp(i));
		Z12ANDb : and2im
			port map(X(i)(8), C(i)(4), sleep, Z12_temp(i + 16));
		Z12ANDc : and2im
			port map(X(i)(7), C(i)(5), sleep, Z12_temp(i + 32));
		Z12ANDd : and2im
			port map(X(i)(6), C(i)(6), sleep, Z12_temp(i + 48));

		Z13ANDa : and2im
			port map(X(i)(9), C(i)(4), sleep, Z13_temp(i));
		Z13ANDb : and2im
			port map(X(i)(8), C(i)(5), sleep, Z13_temp(i + 16));
		Z13ANDc : and2im
			port map(X(i)(7), C(i)(6), sleep, Z13_temp(i + 32));

		Z14ANDa : and2im
			port map(X(i)(9), C(i)(5), sleep, Z14_temp(i));
		Z14ANDb : and2im
			port map(X(i)(8), C(i)(6), sleep, Z14_temp(i + 16));

		Z15ANDa : and2im
			port map(X(i)(9), C(i)(6), sleep, Z15(i));
	end generate;
	Gen6to8: for i in 0 to 95 generate
		Z6(i) <= Z6_temp(i);
		Z7(i) <= Z7_temp(i);
		Z8(i) <= Z8_temp(i);
	end generate;
	Inv6to9: for i in 96 to 111 generate
		Z6(i).rail1 <= Z6_temp(i).rail0;
		Z6(i).rail0 <= Z6_temp(i).rail1;
		Z7(i).rail1 <= Z7_temp(i).rail0;
		Z7(i).rail0 <= Z7_temp(i).rail1;
		Z8(i).rail1 <= Z8_temp(i).rail0;
		Z8(i).rail0 <= Z8_temp(i).rail1;
		Z9(i).rail1 <= Z9_temp(i).rail0;
		Z9(i).rail0 <= Z9_temp(i).rail1;
	end generate;
	Inv9t14a: for i in 0 to 15 generate
		Z9(i).rail1 <= Z9_temp(i).rail0;
		Z9(i).rail0 <= Z9_temp(i).rail1;
		Z10(i).rail1 <= Z10_temp(i).rail0;
		Z10(i).rail0 <= Z10_temp(i).rail1;
		Z11(i).rail1 <= Z11_temp(i).rail0;
		Z11(i).rail0 <= Z11_temp(i).rail1;
		Z12(i).rail1 <= Z12_temp(i).rail0;
		Z12(i).rail0 <= Z12_temp(i).rail1;
		Z13(i).rail1 <= Z13_temp(i).rail0;
		Z13(i).rail0 <= Z13_temp(i).rail1;
		Z14(i).rail1 <= Z14_temp(i).rail0;
		Z14(i).rail0 <= Z14_temp(i).rail1;
	end generate;
	Inv10to14: for i in 0 to 15 generate
		Z10(i + 80).rail1 <= Z10_temp(i + 80).rail0;
		Z10(i + 80).rail0 <= Z10_temp(i + 80).rail1;
		Z11(i + 64).rail1 <= Z11_temp(i + 64).rail0;
		Z11(i + 64).rail0 <= Z11_temp(i + 64).rail1;
		Z12(i + 48).rail1 <= Z12_temp(i + 48).rail0;
		Z12(i + 48).rail0 <= Z12_temp(i + 48).rail1;
		Z13(i + 32).rail1 <= Z13_temp(i + 32).rail0;
		Z13(i + 32).rail0 <= Z13_temp(i + 32).rail1;
		Z14(i + 16).rail1 <= Z14_temp(i + 16).rail0;
		Z14(i + 16).rail0 <= Z14_temp(i + 16).rail1;
	end generate;
	Gen9: for i in 16 to 95 generate
		Z9(i) <= Z9_temp(i);
	end generate;
	Gen10: for i in 16 to 79 generate
		Z10(i) <= Z10_temp(i);
	end generate;
	Gen11: for i in 16 to 63 generate
		Z11(i) <= Z11_temp(i);
	end generate;
	Gen12: for i in 16 to 47 generate
		Z12(i) <= Z12_temp(i);
	end generate;
	Gen13: for i in 16 to 31 generate
		Z13(i) <= Z13_temp(i);
	end generate;
	
		

end;