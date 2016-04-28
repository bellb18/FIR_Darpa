Library IEEE;
use IEEE.std_logic_1164.all;
use work.ncl_signals.all;
----------------------------------------------------------
--
-- Merged Multiplier and Add Unit
--      without final fast adder
--
-- Inputs: 0.000000000 and 0.000000
-- Output: 00.00000000000000 (discard LSB)
----------------------------------------------------------
entity Merged_Unpipelined is
	port(x     : in  dual_rail_logic_vector(9 downto 0);
		 y     : in  dual_rail_logic_vector(6 downto 0);
		 a     : in  dual_rail_logic_vector(9 downto 0);
		 b     : in  dual_rail_logic_vector(6 downto 0);
		 sleep : in  std_logic;
		 p     : out dual_rail_logic_vector(15 downto 0));
end;

architecture arch of Merged_Unpipelined is
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

	type Ctype is array (6 downto 0) of dual_rail_logic_vector(16 downto 0);
	type InType is array (9 downto 0) of dual_rail_logic_vector(6 downto 0);

	signal carry_array1, carry_array2, sum_array1, sum_array2 : Ctype;
	signal carry_array3, carry_array4, sum_array3, sum_array4 : Ctype;
	signal discard_carry                                      : dual_rail_logic;
	signal temp_input_array1, temp_input_array2               : InType;
	signal input_array1, input_array2                         : InType;

begin
	AndGenx : for i in 0 to 9 generate
		AndGeny : for j in 0 to 6 generate
			AndGena : and2im
				port map(x(i), y(j), sleep, temp_input_array1(i)(j));
			AndGenb : and2im
				port map(a(i), b(j), sleep, temp_input_array2(i)(j));
		end generate;
	end generate;

	-- Fix inverted inputs
	NotInvGena : for i in 0 to 8 generate
		NotInvGenb : for j in 0 to 5 generate
			input_array1(i)(j) <= temp_input_array1(i)(j);
			input_array2(i)(j) <= temp_input_array2(i)(j);
		end generate;
	end generate;
	InvGena : for i in 0 to 8 generate
		input_array1(i)(6).RAIL0 <= temp_input_array1(i)(6).RAIL1;
		input_array1(i)(6).RAIL1 <= temp_input_array1(i)(6).RAIL0;
		input_array2(i)(6).RAIL0 <= temp_input_array2(i)(6).RAIL1;
		input_array2(i)(6).RAIL1 <= temp_input_array2(i)(6).RAIL0;
	end generate;
	InvGenb : for i in 0 to 5 generate
		input_array1(9)(i).RAIL0 <= temp_input_array1(9)(i).RAIL1;
		input_array1(9)(i).RAIL1 <= temp_input_array1(9)(i).RAIL0;
		input_array2(9)(i).RAIL0 <= temp_input_array2(9)(i).RAIL1;
		input_array2(9)(i).RAIL1 <= temp_input_array2(9)(i).RAIL0;
	end generate;
	input_array1(9)(6) <= temp_input_array1(9)(6);
	input_array2(9)(6) <= temp_input_array2(9)(6);

	-- 0th Stage - All columns will have 13pp or less
	HA06a : HAm                         --P6
		port map(input_array1(6)(0), input_array1(5)(1), sleep, carry_array1(0)(7), sum_array1(0)(6));
	FA07a : FAm1                        --P7
		port map(input_array1(7)(0), input_array1(6)(1), sleep, carry_array1(0)(8), sum_array1(0)(7));
	HA07b : HAm                         -- P7
		port map(input_array1(5)(2), input_array1(4)(3), sleep, carry_array2(0)(8), sum_array2(0)(7));
	FaGen0a : for i in 8 to 9 generate  --P8-P9
		FA0a : FAm
			port map(input_array1(i)(0), input_array1(i - 1)(1), input_array1(i - 2)(2), sleep, carry_array1(0)(i + 1), sum_array1(0)(i));
		HA0b : HAm
			port map(input_array1(i - 3)(3), input_array1(i - 4)(4), sleep, carry_array2(0)(i + 1), sum_array2(0)(i));
	end generate;
	FA09a : FAm1                        --P10
		port map(input_array1(9)(1), input_array1(8)(2), sleep, carry_array1(0)(11), sum_array1(0)(10));

	-- 1st Stage - All columns will have 9pp or less
	HA14a : HAm                         --P4
		port map(input_array1(4)(0), input_array1(3)(1), sleep, carry_array1(1)(5), sum_array1(1)(4));
	FA15a : FAm                         --P5
		port map(input_array1(5)(0), input_array1(4)(1), input_array1(3)(2), sleep, carry_array1(1)(6), sum_array1(1)(5));
	FA15b : FAm                         --P5
		port map(input_array1(2)(3), input_array1(1)(4), input_array1(0)(5), sleep, carry_array2(1)(6), sum_array2(1)(5));
	FA16a : FAm                         -- P6
		port map(input_array1(4)(2), input_array1(3)(3), input_array1(2)(4), sleep, carry_array1(1)(7), sum_array1(1)(6));
	FA16b : FAm                         -- P6
		port map(input_array1(1)(5), input_array1(0)(6), input_array2(6)(0), sleep, carry_array2(1)(7), sum_array2(1)(6));
	FA16c : FAm                         -- P6
		port map(input_array2(5)(1), input_array2(4)(2), input_array2(3)(3), sleep, carry_array3(1)(7), sum_array3(1)(6));
	FA17a : FAm                         -- P7
		port map(sum_array1(0)(7), sum_array2(0)(7), carry_array1(0)(7), sleep, carry_array1(1)(8), sum_array1(1)(7));
	FA17b : FAm                         -- P7
		port map(input_array1(3)(4), input_array1(2)(5), input_array1(1)(6), sleep, carry_array2(1)(8), sum_array2(1)(7));
	FA17c : FAm                         -- P7
		port map(input_array2(7)(0), input_array2(6)(1), input_array2(5)(2), sleep, carry_array3(1)(8), sum_array3(1)(7));
	HA17d : HAm                         -- P7
		port map(input_array2(4)(3), input_array2(3)(4), sleep, carry_array4(1)(8), sum_array4(1)(7));

	FaGen1a : for i in 8 to 9 generate  --P8-P9
		FA1a : FAm
			port map(sum_array1(0)(i), sum_array2(0)(i), carry_array2(0)(i), sleep, carry_array1(1)(i + 1), sum_array1(1)(i));
		FA1b : FAm
			port map(carry_array1(0)(i), input_array1(i - 5)(5), input_array1(i - 6)(6), sleep, carry_array2(1)(i + 1), sum_array2(1)(i));
		FA1c : FAm
			port map(input_array2(i)(0), input_array2(i - 1)(1), input_array2(i - 2)(2), sleep, carry_array3(1)(i + 1), sum_array3(1)(i));
		FA1d : FAm
			port map(input_array2(i - 3)(3), input_array2(i - 4)(4), input_array2(i - 5)(5), sleep, carry_array4(1)(i + 1), sum_array4(1)(i));
	end generate;

	FA110a : FAm                        -- P10
		port map(sum_array1(0)(10), carry_array1(0)(10), carry_array2(0)(10), sleep, carry_array1(1)(11), sum_array1(1)(10));
	FA110b : FAm                        -- P10
		port map(input_array1(7)(3), input_array1(6)(4), input_array1(5)(5), sleep, carry_array2(1)(11), sum_array2(1)(10));
	FA110c : FAm                        -- P10
		port map(input_array1(4)(6), input_array2(9)(1), input_array2(8)(2), sleep, carry_array3(1)(11), sum_array3(1)(10));
	FA110d : FAm                        -- P10
		port map(input_array2(7)(3), input_array2(6)(4), input_array2(5)(5), sleep, carry_array4(1)(11), sum_array4(1)(10));
	FA111a : FAm                        -- P11
		port map(carry_array1(0)(11), input_array1(9)(2), input_array1(8)(3), sleep, carry_array1(1)(12), sum_array1(1)(11));
	FA111b : FAm                        -- P11
		port map(input_array1(7)(4), input_array1(6)(5), input_array1(5)(6), sleep, carry_array2(1)(12), sum_array2(1)(11));
	FA111c : FAm                        -- P11
		port map(input_array2(9)(2), input_array2(8)(3), input_array2(7)(4), sleep, carry_array3(1)(12), sum_array3(1)(11));
	FA112a : FAm                        -- P12
		port map(input_array1(9)(3), input_array1(8)(4), input_array1(7)(5), sleep, carry_array1(1)(13), sum_array1(1)(12));

	-- 2nd Stage - All columns will have 6pp or less
	FA23a : FAm                         -- P3
		port map(input_array1(3)(0), input_array1(2)(1), input_array1(1)(2), sleep, carry_array1(2)(4), sum_array1(2)(3));
	FA24a : FAm                         -- P4
		port map(sum_array1(1)(4), input_array1(2)(2), input_array1(1)(3), sleep, carry_array1(2)(5), sum_array1(2)(4));
	FA24b : FAm                         -- P4
		port map(input_array1(0)(4), input_array2(4)(0), input_array2(3)(1), sleep, carry_array2(2)(5), sum_array2(2)(4));
	FA25a : FAm                         -- P5
		port map(sum_array1(1)(5), sum_array2(1)(5), carry_array1(1)(5), sleep, carry_array1(2)(6), sum_array1(2)(5));
	FA25b : FAm                         -- P5
		port map(input_array2(5)(0), input_array2(4)(1), input_array2(3)(2), sleep, carry_array2(2)(6), sum_array2(2)(5));
	HA25c : HAm                         -- P5
		port map(input_array2(2)(3), input_array2(1)(4), sleep, carry_array3(2)(6), sum_array3(2)(5));
	FA26a : FAm                         -- P6
		port map(sum_array1(1)(6), sum_array2(1)(6), sum_array3(1)(6), sleep, carry_array1(2)(7), sum_array1(2)(6));
	FA26b : FAm                         -- P6
		port map(sum_array1(0)(6), carry_array1(1)(6), carry_array2(1)(6), sleep, carry_array2(2)(7), sum_array2(2)(6));
	FA26c : FAm                         -- P6
		port map(input_array2(2)(4), input_array2(1)(5), input_array2(0)(6), sleep, carry_array3(2)(7), sum_array3(2)(6));
	FA27a : FAm                         -- P7
		port map(sum_array3(1)(7), sum_array4(1)(7), carry_array3(1)(7), sleep, carry_array1(2)(8), sum_array1(2)(7));
	FA27b : FAm                         -- P7
		port map(carry_array2(1)(7), sum_array1(1)(7), sum_array2(1)(7), sleep, carry_array2(2)(8), sum_array2(2)(7));
	FA27c : FAm                         -- P7
		port map(carry_array1(1)(7), input_array2(2)(5), input_array2(1)(6), sleep, carry_array3(2)(8), sum_array3(2)(7));
	FAGen2a : for i in 8 to 10 generate -- P8-P10
		FA2a : FAm
			port map(sum_array3(1)(i), sum_array4(1)(i), carry_array4(1)(i), sleep, carry_array1(2)(i + 1), sum_array1(2)(i));
		FA2b : FAm
			port map(sum_array1(1)(i), sum_array2(1)(i), carry_array3(1)(i), sleep, carry_array2(2)(i + 1), sum_array2(2)(i));
		FA2c : FAm
			port map(carry_array2(1)(i), carry_array1(1)(i), input_array2(i - 6)(6), sleep, carry_array3(2)(i + 1), sum_array3(2)(i));
	end generate;
	FA211a : FAm                        -- P11
		port map(sum_array3(1)(11), sum_array2(1)(11), sum_array1(1)(11), sleep, carry_array1(2)(12), sum_array1(2)(11));
	FA211b : FAm                        -- P11
		port map(carry_array2(1)(11), carry_array3(1)(11), carry_array4(1)(11), sleep, carry_array2(2)(12), sum_array2(2)(11));
	FA211c : FAm                        -- P11
		port map(carry_array1(1)(11), input_array2(6)(5), input_array2(5)(6), sleep, carry_array3(2)(12), sum_array3(2)(11));
	FA212a : FAm                        -- P12
		port map(sum_array1(1)(12), carry_array2(1)(12), carry_array3(1)(12), sleep, carry_array1(2)(13), sum_array1(2)(12));
	FA212b : FAm                        -- P12
		port map(carry_array1(1)(12), input_array1(6)(6), input_array2(9)(3), sleep, carry_array2(2)(13), sum_array2(2)(12));
	FA212c : FAm                        -- P12
		port map(input_array2(8)(4), input_array2(7)(5), input_array2(6)(6), sleep, carry_array3(2)(13), sum_array3(2)(12));
	FA213a : FAm                        -- P13
		port map(carry_array1(1)(13), input_array1(9)(4), input_array1(8)(5), sleep, carry_array1(2)(14), sum_array1(2)(13));
	FA213b : FAm                        -- P13
		port map(input_array1(7)(6), input_array2(9)(4), input_array2(8)(5), sleep, carry_array2(2)(14), sum_array2(2)(13));

	-- 3rd Stage - All columns will have 4pp or less
	FA32a : FAm                         -- P2
		port map(input_array1(2)(0), input_array1(1)(1), input_array1(0)(2), sleep, carry_array1(3)(3), sum_array1(3)(2));
	FA33a : FAm                         -- P3
		port map(sum_array1(2)(3), input_array1(0)(3), input_array2(3)(0), sleep, carry_array1(3)(4), sum_array1(3)(3));
	HA33b : HAm                         -- P3
		port map(input_array2(2)(1), input_array2(1)(2), sleep, carry_array2(3)(4), sum_array2(3)(3));
	FA34a : FAm                         -- P4
		port map(sum_array1(2)(4), sum_array2(2)(4), carry_array1(2)(4), sleep, carry_array1(3)(5), sum_array1(3)(4));
	FA34b : FAm                         -- P4
		port map(input_array2(2)(2), input_array2(1)(3), input_array2(0)(4), sleep, carry_array2(3)(5), sum_array2(3)(4));
	FA35a : FAm                         -- P5
		port map(sum_array1(2)(5), sum_array2(2)(5), sum_array3(2)(5), sleep, carry_array1(3)(6), sum_array1(3)(5));
	FA35b : FAm                         -- P5
		port map(carry_array1(2)(5), carry_array2(2)(5), input_array2(0)(5), sleep, carry_array2(3)(6), sum_array2(3)(5));
	FAGen3a : for i in 6 to 12 generate -- P6-P12
		FA3a : FAm
			port map(sum_array1(2)(i), sum_array2(2)(i), sum_array3(2)(i), sleep, carry_array1(3)(i + 1), sum_array1(3)(i));
		FA3b : FAm
			port map(carry_array1(2)(i), carry_array2(2)(i), carry_array3(2)(i), sleep, carry_array2(3)(i + 1), sum_array2(3)(i));
	end generate;
	FA313a : FAm                        -- P13
		port map(sum_array1(2)(13), sum_array2(2)(13), carry_array3(2)(13), sleep, carry_array1(3)(14), sum_array1(3)(13));
	FA313b : FAm                        -- P13
		port map(carry_array1(2)(13), carry_array2(2)(13), input_array2(7)(6), sleep, carry_array2(3)(14), sum_array2(3)(13));
	FA314a : FAm                        -- P14
		port map(carry_array1(2)(14), carry_array2(2)(14), input_array1(9)(5), sleep, carry_array1(3)(15), sum_array1(3)(14));
	FA314b : FAm                        -- P14
		port map(input_array1(8)(6), input_array2(9)(5), input_array2(8)(6), sleep, carry_array2(3)(15), sum_array2(3)(14));

	-- 4th Stage - All columns will have 3pp or less
	HA41a : HAm                         -- P1
		port map(input_array1(1)(0), input_array1(0)(1), sleep, carry_array1(4)(2), sum_array1(4)(1));
	FA42a : FAm                         -- P2
		port map(sum_array1(3)(2), input_array2(2)(0), input_array2(1)(1), sleep, carry_array1(4)(3), sum_array1(4)(2));
	FA43a : FAm                         -- P3
		port map(sum_array1(3)(3), sum_array2(3)(3), carry_array1(3)(3), sleep, carry_array1(4)(4), sum_array1(4)(3));
	FAGen4a : for i in 4 to 14 generate -- P4-P14
		FA3a : FAm
			port map(sum_array1(3)(i), sum_array2(3)(i), carry_array2(3)(i), sleep, carry_array1(4)(i + 1), sum_array1(4)(i));
	end generate;
	FA415a : FAm                        -- P15
		port map(carry_array1(3)(15), carry_array2(3)(15), input_array1(9)(6), sleep, carry_array1(4)(16), sum_array1(4)(15));

	-- 5th Stage - All columns will have 2pp or less
	HA51a : HAm                         -- P1
		port map(sum_array1(4)(1), input_array2(1)(0), sleep, carry_array1(5)(2), sum_array1(5)(1));
	FA52a : FAm                         -- P2
		port map(sum_array1(4)(2), carry_array1(4)(2), input_array2(0)(2), sleep, carry_array1(5)(3), sum_array1(5)(2));
	FA53a : FAm                         -- P3
		port map(sum_array1(4)(3), carry_array1(4)(3), input_array2(0)(3), sleep, carry_array1(5)(4), sum_array1(5)(3));
	FAGen5a : for i in 4 to 14 generate -- P4-P14
		FA3a : FAm
			port map(sum_array1(4)(i), carry_array1(4)(i), carry_array1(3)(i), sleep, carry_array1(5)(i + 1), sum_array1(5)(i));
	end generate;
	FA515a : FAm                        -- P15
		port map(carry_array1(4)(15), sum_array1(4)(15), input_array2(9)(6), sleep, carry_array1(5)(16), sum_array1(5)(15));

	-- Final Adder
	HA60a : HAm
		port map(input_array1(0)(0), input_array2(0)(0), sleep, carry_array1(6)(1), p(0));
	FA61a : FAm                         --P1
		port map(sum_array1(5)(1), input_array2(0)(1), carry_array1(6)(1), sleep, carry_array1(6)(2), p(1));
	FaGen6a : for i in 2 to 15 generate -- P2-P15
		FA5a : FAm
			port map(sum_array1(5)(i), carry_array1(5)(i), carry_array1(6)(i), sleep, carry_array1(6)(i + 1), p(i));
	end generate;
	--FA60a : FAm                         --P16
		--port map(carry_array1(4)(16), carry_array1(5)(16), carry_array1(6)(16), sleep, discard_carry, p(16));

end arch;