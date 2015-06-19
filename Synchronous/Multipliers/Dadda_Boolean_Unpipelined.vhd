Library IEEE;
use IEEE.std_logic_1164.all;


entity Dadda_Boolean_Unpipelined is
	port(x     : IN  std_logic_vector(9 downto 0);
		 y     : IN  std_logic_vector(6 downto 0);
		 p     : OUT std_logic_vector(15 downto 0));
end;

architecture arch of Dadda_Boolean_Unpipelined is
	component FA
		port(CIN, X, Y : IN  std_logic;
			 COUT, S   : OUT std_logic);
	end component;

	component HA is
		port(
			X     : IN  std_logic;
			Y     : IN  std_logic;
			COUT  : OUT std_logic;
			S     : OUT std_logic);
	end component;

	component HA1 is
		port(
			X    : IN  std_logic;
			COUT : OUT std_logic;
			S    : OUT std_logic);
	end component;

	component FA1 is
		port(X     : IN  std_logic;
			 Y     : IN  std_logic;
			 COUT  : OUT std_logic;
			 S     : OUT std_logic);
	end component;

	type Ctype is array (4 downto 0) of std_logic_vector(16 downto 0);
	type InType is array (9 downto 0) of std_logic_vector(6 downto 0);

	signal carry_array1, carry_array2, sum_array1, sum_array2 : Ctype;
	signal discard_carry, one                                      : std_logic;
	signal temp_input_array, input_array                      : InType;

begin
	-- Generate partial products
	AndGenx : for i in 0 to 9 generate
		AndGeny : for j in 0 to 6 generate
			temp_input_array(i)(j) <= x(i) and y(j);
		end generate;
	end generate;

	-- Fix inverted inputs
	NotInvGena : for i in 0 to 8 generate
		NotInvGenb : for j in 0 to 5 generate
			input_array(i)(j) <= temp_input_array(i)(j);
		end generate;
	end generate;
	InvGena : for i in 0 to 8 generate
		input_array(i)(6) <= not temp_input_array(i)(6);
	end generate;
	InvGenb : for i in 0 to 5 generate
		input_array(9)(i) <= not temp_input_array(9)(i);
	end generate;
	input_array(9)(6) <= temp_input_array(9)(6);

	-- 0th Stage - All columns will have 6pp or less
	FA06a : FA1                        --P6
		port map(input_array(6)(0), input_array(5)(1), carry_array1(0)(7), sum_array1(0)(6));
	FaGen0a : for i in 1 to 2 generate  --P7-P8
		Fa0a : FA
			port map(input_array(i + 6)(0), input_array(i + 5)(1), input_array(i + 4)(2), carry_array1(0)(i + 7), sum_array1(0)(i + 6));
	end generate;
	FA09a : FA1                        --P9
		port map(input_array(9)(0), input_array(8)(1), carry_array1(0)(10), sum_array1(0)(9));
	HA09a : HA                         --P9
		port map(input_array(7)(2), input_array(6)(3), carry_array2(0)(10), sum_array2(0)(9));
	FA010 : FA                         --P10
		port map(input_array(9)(1), input_array(8)(2), input_array(7)(3), carry_array1(0)(11), sum_array1(0)(10));

	-- 1st Stage - All columns will have 4pp or less
	HA14a : HA                         --P4
		port map(input_array(4)(0), input_array(3)(1), carry_array1(1)(5), sum_array1(1)(4));
	HA15a : HA                         --P5
		port map(input_array(2)(3), input_array(1)(4), carry_array1(1)(6), sum_array1(1)(5));
	FA15a : FA                         --P5
		port map(input_array(5)(0), input_array(4)(1), input_array(3)(2), carry_array2(1)(6), sum_array2(1)(5));
	FA16a : FA                         -- P6
		port map(sum_array1(0)(6), input_array(4)(2), input_array(3)(3), carry_array1(1)(7), sum_array1(1)(6));

	FaGen1a : for i in 1 to 2 generate  --P7-P8 gate 1
		FA1a : FA
			port map(input_array(i + 3)(3), sum_array1(0)(i + 6), carry_array1(0)(i + 6), carry_array1(1)(i + 7), sum_array1(1)(i + 6));
	end generate;

	FA19a : FA                         -- P9 gate 1
		port map(sum_array1(0)(9), sum_array2(0)(9), carry_array1(0)(9), carry_array1(1)(10), sum_array1(1)(9));
	FA110a : FA                        -- P10 gate 1
		port map(sum_array1(0)(10), carry_array2(0)(10), carry_array1(0)(10), carry_array1(1)(11), sum_array1(1)(10));
	FA111a : FA                        -- P11 gate 1
		port map(carry_array1(0)(11), input_array(9)(2), input_array(8)(3), carry_array1(1)(12), sum_array1(1)(11));

	FaGen1b : for i in 1 to 6 generate  --P6-P11 gate 2
		FA1a : FA
			port map(input_array(i + 1)(4), input_array(i)(5), input_array(i - 1)(6), carry_array2(1)(i + 6), sum_array2(1)(i + 5));
	end generate;

	FA112a : FA                        --P12
		port map(input_array(9)(3), input_array(8)(4), input_array(7)(5), carry_array1(1)(13), sum_array1(1)(12));

	-- 2nd Stage - All columns will have 3pp or less
	HA23a : HA                         -- P3
		port map(input_array(3)(0), input_array(2)(1), carry_array1(2)(4), sum_array1(2)(3));
	FA24a : FA                         -- P4
		port map(sum_array1(1)(4), input_array(2)(2), input_array(1)(3), carry_array1(2)(5), sum_array1(2)(4));
	FA25a : FA                         -- P5
		port map(sum_array2(1)(5), sum_array1(1)(5), carry_array1(1)(5), carry_array1(2)(6), sum_array1(2)(5));
	FAGen2a : for i in 1 to 6 generate  -- P6-P11
		FA2a : FA
			port map(sum_array2(1)(i + 5), sum_array1(1)(i + 5), carry_array2(1)(i + 5), carry_array1(2)(i + 6), sum_array1(2)(i + 5));
	end generate;
	FA212a : FA                        -- P12
		port map(sum_array1(1)(12), carry_array2(1)(12), carry_array1(1)(12), carry_array1(2)(13), sum_array1(2)(12));
	FA213a : FA                        -- P13
		port map(carry_array1(1)(13), input_array(9)(4), input_array(8)(5), carry_array1(2)(14), sum_array1(2)(13));
			     
	-- 3rd Stage - All columns will have 2pp or less
	HA32a : HA                         -- P2
		port map(input_array(2)(0), input_array(1)(1), carry_array1(3)(3), sum_array1(3)(2));
	FA33a : FA                         -- P3
		port map(sum_array1(2)(3), input_array(1)(2), input_array(0)(3), carry_array1(3)(4), sum_array1(3)(3));
	FA34a : FA                         -- P4
		port map(sum_array1(2)(4), carry_array1(2)(4), input_array(0)(4), carry_array1(3)(5), sum_array1(3)(4));
	FA35a : FA                         -- P5
		port map(sum_array1(2)(5), carry_array1(2)(5), input_array(0)(5), carry_array1(3)(6), sum_array1(3)(5));
	FAGen3a : for i in 1 to 6 generate  -- P6-P11
		FA3a : FA
			port map(carry_array1(2)(i + 5), carry_array1(1)(i + 5), sum_array1(2)(i + 5), carry_array1(3)(i + 6), sum_array1(3)(i + 5));
	end generate;

	FA312a : FA                        -- P12
		port map(sum_array1(2)(12), carry_array1(2)(12), input_array(6)(6), carry_array1(3)(13), sum_array1(3)(12));
	FA313a : FA                        -- P13
		port map(sum_array1(2)(13), carry_array1(2)(13), input_array(7)(6), carry_array1(3)(14), sum_array1(3)(13));
	FA314a : FA                        -- P14
		port map(carry_array1(2)(14), input_array(9)(5), input_array(8)(6), carry_array1(3)(15), sum_array1(3)(14));

	-- Final Adder (Carry Propagate)
	p(0) <= input_array(0)(0);
	HA51a : HA                         --P1
		port map(input_array(1)(0), input_array(0)(1), carry_array1(4)(2), p(1));
	FA52a : FA                         --P2
		port map(input_array(0)(2), sum_array1(3)(2), carry_array1(4)(2), carry_array1(4)(3), p(2));
	FaGen5a : for i in 3 to 14 generate -- P3-P14
		FA5a : FA
			port map(sum_array1(3)(i), carry_array1(3)(i), carry_array1(4)(i), carry_array1(4)(i + 1), p(i));
	end generate;
	FA515a : FA                        --P15
		port map(input_array(9)(6), carry_array1(3)(15), carry_array1(4)(15), carry_array1(4)(16), p(15));

end arch;