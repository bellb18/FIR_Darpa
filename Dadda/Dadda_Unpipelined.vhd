Library IEEE;
use IEEE.std_logic_1164.all;
use work.ncl_signals.all;
entity Dadda_Unpipelined is
	port(x     : in  dual_rail_logic_vector(9 downto 0);
		 y     : in  dual_rail_logic_vector(5 downto 0);
		 sleep : in  std_logic;
		 p     : out dual_rail_logic_vector(15 downto 0));
end;

architecture arch of Dadda_Unpipelined is
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

	component and2im is
		port(a     : IN  dual_rail_logic;
			 b     : IN  dual_rail_logic;
			 sleep : in  std_logic;
			 z     : OUT dual_rail_logic);
	end component;

	type Ctype is array (4 downto 0) of dual_rail_logic_vector(15 downto 0);
	type InType is array (9 downto 0) of dual_rail_logic_vector(5 downto 0);

	signal carry_array1, carry_array2, sum_array1, sum_array2 : Ctype;
	signal discard_carry                                      : dual_rail_logic;
	signal temp_input_array, input_array                      : InType;

begin

	-- Generate partial products
	AndGenx : for i in 0 to 9 generate
		AndGeny : for j in 0 to 5 generate
			AndGen : and2im
				port map(x(i), y(j), sleep, temp_input_array(i)(j));
		end generate;
	end generate;

	-- Fix inverted inputs
	NotInvGena : for i in 0 to 8 generate
		NotInvGenb : for j in 0 to 4 generate
			input_array(i)(j) <= temp_input_array(i)(j);
		end generate;
	end generate;
	InvGena : for i in 0 to 8 generate
		input_array(i)(5).RAIL0 <= temp_input_array(i)(5).RAIL1;
		input_array(i)(5).RAIL1 <= temp_input_array(i)(5).RAIL0;
	end generate;
	InvGenb : for i in 0 to 4 generate
		input_array(9)(i).RAIL0 <= temp_input_array(9)(i).RAIL1;
		input_array(9)(i).RAIL1 <= temp_input_array(9)(i).RAIL0;
	end generate;

	-- First Stage - All columns will have 6pp or less
	HA05a : HAm1                        --P5
		port map(input_array(5)(0), carry_array1(0)(6), sum_array1(0)(5));
	HaGen0a : for i in 1 to 3 generate  --P6-P8
		Ha0a : HAm
			port map(input_array(i + 5)(0), input_array(i + 4)(1), sleep, carry_array1(0)(i + 6), sum_array1(0)(i + 5));
	end generate;
	FA09a : FAm1                       --P9
		port map(input_array(9)(0), input_array(8)(1), sleep, carry_array1(0)(10), sum_array1(0)(9));

	-- Second Stage - All columns will have 4pp or less
	HA14a : HAm                         --P4
		port map(input_array(4)(0), input_array(3)(1), sleep, carry_array1(1)(5), sum_array1(1)(4));
	HA15a : HAm                         --P5
		port map(input_array(2)(3), input_array(1)(4), sleep, carry_array1(1)(6), sum_array1(1)(5));
	FA15a : FAm                         --P5
		port map(input_array(4)(1), input_array(3)(2), sum_array1(0)(5), sleep, carry_array2(1)(6), sum_array2(1)(5));

	FaGen1a : for i in 1 to 4 generate  --P6-P9
		FA1a : FAm
			port map(input_array(i + 3)(2), sum_array1(0)(i + 5), carry_array1(0)(i + 5), sleep, carry_array1(1)(i + 6), sum_array1(1)(i + 5));
		FA1b : FAm
			port map(input_array(i + 2)(3), input_array(i + 1)(4), input_array(i)(5), sleep, carry_array2(1)(i + 6), sum_array2(1)(i + 5));
	end generate;

	FA110a : FAm                        --P10
		port map(carry_array1(0)(10), input_array(9)(1), input_array(8)(2), sleep, carry_array1(1)(11), sum_array1(1)(10));
	FA110b : FAm                        --P10
		port map(input_array(7)(3), input_array(6)(4), input_array(5)(5), sleep, carry_array2(1)(11), sum_array2(1)(10));
	FA111a : FAm                        --P11
		port map(input_array(9)(2), input_array(8)(3), input_array(7)(4), sleep, carry_array1(1)(12), sum_array2(1)(11));

	-- Third Stage - All columns will have 3pp or less
	HA23a : HAm                         -- P3
		port map(input_array(3)(0), input_array(2)(1), sleep, carry_array1(2)(4), sum_array1(2)(3));
	Fa24a : FAm                         -- P4
		port map(input_array(2)(2), input_array(1)(3), sum_array1(1)(4), sleep, carry_array1(2)(5), sum_array1(2)(4));
	Fa25a : FAm                         -- P5
		port map(input_array(0)(5), sum_array1(1)(5), carry_array1(1)(5), sleep, carry_array1(2)(6), sum_array1(2)(5));

	FaGen2a : for i in 1 to 6 generate  -- P6-P11
		FA2a : FAm
			port map(carry_array1(1)(i + 5), carry_array2(1)(i + 5), sum_array1(1)(i + 5), sleep, carry_array1(2)(i + 6), sum_array1(2)(i + 5));
	end generate;

	FA212 : FAm                         -- P12
		port map(carry_array1(1)(12), carry_array2(1)(12), input_array(7)(5), sleep, carry_array1(2)(13), sum_array1(2)(12));
	FA213 : FAm                         -- P13
		port map(input_array(10)(3), input_array(9)(4), input_array(8)(5), sleep, carry_array1(2)(14), sum_array1(2)(13));
		
	-- Fourth Stage - All columns will have 2pp or less
	HA32 : HAm                          -- P2
		port map(input_array(2)(0), input_array(1)(1), sleep, carry_array1(3)(3), sum_array1(3)(2));
	FA33 : FAm                          -- P3
		port map(sum_array1(2)(3), input_array(1)(2), input_array(0)(3), sleep, carry_array1(3)(4), sum_array1(3)(3));
	FA34 : FAm
		port map(carry_array1(2)(4), sum_array1(2)(4), input_array(0)(4), sleep, carry_array1(3)(5), sum_array1(3)(4));
	FaGen3a : for i in 1 to 8 generate  -- P5-P12
		FA3a : FAm
			port map(sum_array1(2)(i + 4), sum_array2(1)(i + 4), carry_array1(2)(i + 4), sleep, carry_array1(3)(i + 5), sum_array1(3)(i + 4));
	end generate;

	FA313 : FAm                         -- P13
		port map(sum_array1(2)(13), carry_array1(2)(13), carry_array1(1)(13), sleep, carry_array1(3)(14), sum_array1(3)(13));
	FA314 : FAm                         -- P14
		port map(carry_array1(2)(14), input_array(10)(4), input_array(9)(5), sleep, carry_array1(3)(15), sum_array1(3)(14));

	-- Final Adder (Carry Propagate)
	p(0) <= input_array(0)(0);
	HA51a : HAm                         --P1
		port map(input_array(1)(0), input_array(0)(1), sleep, carry_array1(4)(2), p(1));
	FA52a : FAm                         --P2
		port map(input_array(0)(2), sum_array1(3)(2), carry_array1(4)(2), sleep, carry_array1(4)(3), p(2));
	FaGen5a : for i in 3 to 13 generate -- P3-P13
		FA5a : FAm
			port map(sum_array1(3)(i), carry_array1(3)(i), carry_array1(4)(i), sleep, carry_array1(4)(i + 1), p(i));
	end generate;
	FA514a : FAm                        --P14
		port map(input_array(9)(5), carry_array1(3)(14), carry_array1(4)(14), sleep, carry_array1(4)(15), p(14));
	HA515a : HAm1                       --P15
		port map(carry_array1(4)(15), discard_carry, p(15));

end arch;