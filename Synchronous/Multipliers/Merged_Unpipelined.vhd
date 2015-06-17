Library IEEE;
use IEEE.std_logic_1164.all;

----------------------------------------------------------
--
-- Merged Multiplier and Add Unit
--      without final fast adder
--
-- Inputs: 0.000000000 and 0.000000
-- Output: 00.00000000000000 (discard LSB)
----------------------------------------------------------
entity Merged_Unpipelined_Sync is
	port(x     : in  std_logic_vector(9 downto 0);
		 y     : in  std_logic_vector(6 downto 0);
		 a     : in  std_logic_vector(9 downto 0);
		 b     : in  std_logic_vector(6 downto 0);
		 p     : out std_logic_vector(16 downto 0));
end;

architecture arch of Merged_Unpipelined_Sync is

	component FA
		port(CIN, X, Y : in  std_logic;
			 COUT, S   : out std_logic);
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
		port(X     : std_logic;
			 Y     : in  std_logic;
			 COUT  : out std_logic;
			 S     : out std_logic);
	end component;

	type Ctype is array (6 downto 0) of std_logic_vector(16 downto 0);
	type InType is array (9 downto 0) of std_logic_vector(6 downto 0);

	signal carry_array1, carry_array2, sum_array1, sum_array2 : Ctype;
	signal carry_array3, carry_array4, sum_array3, sum_array4 : Ctype;
	signal discard_carry                                      : std_logic;
	signal temp_input_array1, temp_input_array2               : InType;
	signal input_array1, input_array2                         : InType;

begin
	AndGenx : for i in 0 to 9 generate
		AndGeny : for j in 0 to 6 generate
				temp_input_array1(i)(j) <= x(i) AND y(j);
				temp_input_array2(i)(j) <= a(i) AND b(j);
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
		input_array1(i)(6) <=  NOT temp_input_array1(i)(6);
		input_array2(i)(6) <= NOT temp_input_array2(i)(6);
	end generate;
	InvGenb : for i in 0 to 5 generate
		input_array1(9)(i) <= NOT temp_input_array1(9)(i);
		input_array2(9)(i) <= NOT temp_input_array2(9)(i);
	end generate;
	input_array1(9)(6) <= temp_input_array1(9)(6);
	input_array2(9)(6) <= temp_input_array2(9)(6);

	-- 0th Stage - All columns will have 13pp or less
	HA06a : HA                         --P6
		port map(input_array1(6)(0), input_array1(5)(1), carry_array1(0)(7), sum_array1(0)(6));
	FA07a : FA1                        --P7
		port map(input_array1(7)(0), input_array1(6)(1), carry_array1(0)(8), sum_array1(0)(7));
	HA07b : HA                         -- P7
		port map(input_array1(5)(2), input_array1(4)(3), carry_array2(0)(8), sum_array2(0)(7));
	FaGen0a : for i in 8 to 9 generate  --P8-P9
		FA0a : FA
			port map(input_array1(i)(0), input_array1(i - 1)(1), input_array1(i - 2)(2), carry_array1(0)(i + 1), sum_array1(0)(i));
		HA0b : HA
			port map(input_array1(i - 3)(3), input_array1(i - 4)(4), carry_array2(0)(i + 1), sum_array2(0)(i));
	end generate;
	FA09a : FA1                        --P10
		port map(input_array1(9)(1), input_array1(8)(2), carry_array1(0)(11), sum_array1(0)(10));

	-- 1st Stage - All columns will have 9pp or less
	HA14a : HA                         --P4
		port map(input_array1(4)(0), input_array1(3)(1), carry_array1(1)(5), sum_array1(1)(4));
	FA15a : FA                         --P5
		port map(input_array1(5)(0), input_array1(4)(1), input_array1(3)(2), carry_array1(1)(6), sum_array1(1)(5));
	FA15b : FA                         --P5
		port map(input_array1(2)(3), input_array1(1)(4), input_array1(0)(5), carry_array2(1)(6), sum_array2(1)(5));
	FA16a : FA                         -- P6
		port map(input_array1(4)(2), input_array1(3)(3), input_array1(2)(4), carry_array1(1)(7), sum_array1(1)(6));
	FA16b : FA                         -- P6
		port map(input_array1(1)(5), input_array1(0)(6), input_array2(6)(0), carry_array2(1)(7), sum_array2(1)(6));
	FA16c : FA                         -- P6
		port map(input_array2(5)(1), input_array2(4)(2), input_array2(3)(3), carry_array3(1)(7), sum_array3(1)(6));
	FA17a : FA                         -- P7
		port map(sum_array1(0)(7), sum_array2(0)(7), carry_array1(0)(7), carry_array1(1)(8), sum_array1(1)(7));
	FA17b : FA                         -- P7
		port map(input_array1(3)(4), input_array1(2)(5), input_array1(1)(6), carry_array2(1)(8), sum_array2(1)(7));
	FA17c : FA                         -- P7
		port map(input_array2(7)(0), input_array2(6)(1), input_array2(5)(2), carry_array3(1)(8), sum_array3(1)(7));
	HA17d : HA                         -- P7
		port map(input_array2(4)(3), input_array2(3)(4), carry_array4(1)(8), sum_array4(1)(7));

	FaGen1a : for i in 8 to 9 generate  --P8-P9
		FA1a : FA
			port map(sum_array1(0)(i), sum_array2(0)(i), carry_array2(0)(i), carry_array1(1)(i + 1), sum_array1(1)(i));
		FA1b : FA
			port map(carry_array1(0)(i), input_array1(i - 5)(5), input_array1(i - 6)(6), carry_array2(1)(i + 1), sum_array2(1)(i));
		FA1c : FA
			port map(input_array2(i)(0), input_array2(i - 1)(1), input_array2(i - 2)(2), carry_array3(1)(i + 1), sum_array3(1)(i));
		FA1d : FA
			port map(input_array2(i - 3)(3), input_array2(i - 4)(4), input_array2(i - 5)(5), carry_array4(1)(i + 1), sum_array4(1)(i));
	end generate;

	FA110a : FA                        -- P10
		port map(sum_array1(0)(10), carry_array1(0)(10), carry_array2(0)(10), carry_array1(1)(11), sum_array1(1)(10));
	FA110b : FA                        -- P10
		port map(input_array1(7)(3), input_array1(6)(4), input_array1(5)(5), carry_array2(1)(11), sum_array2(1)(10));
	FA110c : FA                        -- P10
		port map(input_array1(4)(6), input_array2(9)(1), input_array2(8)(2), carry_array3(1)(11), sum_array3(1)(10));
	FA110d : FA                        -- P10
		port map(input_array2(7)(3), input_array2(6)(4), input_array2(5)(5), carry_array4(1)(11), sum_array4(1)(10));
	FA111a : FA                        -- P11
		port map(carry_array1(0)(11), input_array1(9)(2), input_array1(8)(3), carry_array1(1)(12), sum_array1(1)(11));
	FA111b : FA                        -- P11
		port map(input_array1(7)(4), input_array1(6)(5), input_array1(5)(6), carry_array2(1)(12), sum_array2(1)(11));
	FA111c : FA                        -- P11
		port map(input_array2(9)(2), input_array2(8)(3), input_array2(7)(4), carry_array3(1)(12), sum_array3(1)(11));
	FA112a : FA                        -- P12
		port map(input_array1(9)(3), input_array1(8)(4), input_array1(7)(5), carry_array1(1)(13), sum_array1(1)(12));

	-- 2nd Stage - All columns will have 6pp or less
	FA23a : FA                         -- P3
		port map(input_array1(3)(0), input_array1(2)(1), input_array1(1)(2), carry_array1(2)(4), sum_array1(2)(3));
	FA24a : FA                         -- P4
		port map(sum_array1(1)(4), input_array1(2)(2), input_array1(1)(3), carry_array1(2)(5), sum_array1(2)(4));
	FA24b : FA                         -- P4
		port map(input_array1(0)(4), input_array2(4)(0), input_array2(3)(1), carry_array2(2)(5), sum_array2(2)(4));
	FA25a : FA                         -- P5
		port map(sum_array1(1)(5), sum_array2(1)(5), carry_array1(1)(5), carry_array1(2)(6), sum_array1(2)(5));
	FA25b : FA                         -- P5
		port map(input_array2(5)(0), input_array2(4)(1), input_array2(3)(2), carry_array2(2)(6), sum_array2(2)(5));
	HA25c : HA                         -- P5
		port map(input_array2(2)(3), input_array2(1)(4), carry_array3(2)(6), sum_array3(2)(5));
	FA26a : FA                         -- P6
		port map(sum_array1(1)(6), sum_array2(1)(6), sum_array3(1)(6), carry_array1(2)(7), sum_array1(2)(6));
	FA26b : FA                         -- P6
		port map(sum_array1(0)(6), carry_array1(1)(6), carry_array2(1)(6), carry_array2(2)(7), sum_array2(2)(6));
	FA26c : FA                         -- P6
		port map(input_array2(2)(4), input_array2(1)(5), input_array2(0)(6), carry_array3(2)(7), sum_array3(2)(6));
	FA27a : FA                         -- P7
		port map(sum_array3(1)(7), sum_array4(1)(7), carry_array3(1)(7), carry_array1(2)(8), sum_array1(2)(7));
	FA27b : FA                         -- P7
		port map(carry_array2(1)(7), sum_array1(1)(7), sum_array2(1)(7), carry_array2(2)(8), sum_array2(2)(7));
	FA27c : FA                         -- P7
		port map(carry_array1(1)(7), input_array2(2)(5), input_array2(1)(6), carry_array3(2)(8), sum_array3(2)(7));
	FAGen2a : for i in 8 to 10 generate -- P8-P10
		FA2a : FA
			port map(sum_array3(1)(i), sum_array4(1)(i), carry_array4(1)(i), carry_array1(2)(i + 1), sum_array1(2)(i));
		FA2b : FA
			port map(sum_array1(1)(i), sum_array2(1)(i), carry_array3(1)(i), carry_array2(2)(i + 1), sum_array2(2)(i));
		FA2c : FA
			port map(carry_array2(1)(i), carry_array1(1)(i), input_array2(i - 6)(6), carry_array3(2)(i + 1), sum_array3(2)(i));
	end generate;
	FA211a : FA                        -- P11
		port map(sum_array3(1)(11), sum_array2(1)(11), sum_array1(1)(11), carry_array1(2)(12), sum_array1(2)(11));
	FA211b : FA                        -- P11
		port map(carry_array2(1)(11), carry_array3(1)(11), carry_array4(1)(11), carry_array2(2)(12), sum_array2(2)(11));
	FA211c : FA                        -- P11
		port map(carry_array1(1)(11), input_array2(6)(5), input_array2(5)(6), carry_array3(2)(12), sum_array3(2)(11));
	FA212a : FA                        -- P12
		port map(sum_array1(1)(12), carry_array2(1)(12), carry_array3(1)(12), carry_array1(2)(13), sum_array1(2)(12));
	FA212b : FA                        -- P12
		port map(carry_array1(1)(12), input_array1(6)(6), input_array2(9)(3), carry_array2(2)(13), sum_array2(2)(12));
	FA212c : FA                        -- P12
		port map(input_array2(8)(4), input_array2(7)(5), input_array2(6)(6), carry_array3(2)(13), sum_array3(2)(12));
	FA213a : FA                        -- P13
		port map(carry_array1(1)(13), input_array1(9)(4), input_array1(8)(5), carry_array1(2)(14), sum_array1(2)(13));
	FA213b : FA                        -- P13
		port map(input_array1(7)(6), input_array2(9)(4), input_array2(8)(5), carry_array2(2)(14), sum_array2(2)(13));

	-- 3rd Stage - All columns will have 4pp or less
	FA32a : FA                         -- P2
		port map(input_array1(2)(0), input_array1(1)(1), input_array1(0)(2), carry_array1(3)(3), sum_array1(3)(2));
	FA33a : FA                         -- P3
		port map(sum_array1(2)(3), input_array1(0)(3), input_array2(3)(0), carry_array1(3)(4), sum_array1(3)(3));
	HA33b : HA                         -- P3
		port map(input_array2(2)(1), input_array2(1)(2), carry_array2(3)(4), sum_array2(3)(3));
	FA34a : FA                         -- P4
		port map(sum_array1(2)(4), sum_array2(2)(4), carry_array1(2)(4), carry_array1(3)(5), sum_array1(3)(4));
	FA34b : FA                         -- P4
		port map(input_array2(2)(2), input_array2(1)(3), input_array2(0)(4), carry_array2(3)(5), sum_array2(3)(4));
	FA35a : FA                         -- P5
		port map(sum_array1(2)(5), sum_array2(2)(5), sum_array3(2)(5), carry_array1(3)(6), sum_array1(3)(5));
	FA35b : FA                         -- P5
		port map(carry_array1(2)(5), carry_array2(2)(5), input_array2(0)(5), carry_array2(3)(6), sum_array2(3)(5));
	FAGen3a : for i in 6 to 12 generate -- P6-P12
		FA3a : FA
			port map(sum_array1(2)(i), sum_array2(2)(i), sum_array3(2)(i), carry_array1(3)(i + 1), sum_array1(3)(i));
		FA3b : FA
			port map(carry_array1(2)(i), carry_array2(2)(i), carry_array3(2)(i), carry_array2(3)(i + 1), sum_array2(3)(i));
	end generate;
	FA313a : FA                        -- P13
		port map(sum_array1(2)(13), sum_array2(2)(13), carry_array3(2)(13), carry_array1(3)(14), sum_array1(3)(13));
	FA313b : FA                        -- P13
		port map(carry_array1(2)(13), carry_array2(2)(13), input_array2(7)(6), carry_array2(3)(14), sum_array2(3)(13));
	FA314a : FA                        -- P14
		port map(carry_array1(2)(14), carry_array2(2)(14), input_array1(9)(5), carry_array1(3)(15), sum_array1(3)(14));
	FA314b : FA                        -- P14
		port map(input_array1(8)(6), input_array2(9)(5), input_array2(8)(6), carry_array2(3)(15), sum_array2(3)(14));

	-- 4th Stage - All columns will have 3pp or less
	HA41a : HA                         -- P1
		port map(input_array1(1)(0), input_array1(0)(1), carry_array1(4)(2), sum_array1(4)(1));
	FA42a : FA                         -- P2
		port map(sum_array1(3)(2), input_array2(2)(0), input_array2(1)(1), carry_array1(4)(3), sum_array1(4)(2));
	FA43a : FA                         -- P3
		port map(sum_array1(3)(3), sum_array2(3)(3), carry_array1(3)(3), carry_array1(4)(4), sum_array1(4)(3));
	FAGen4a : for i in 4 to 14 generate -- P4-P14
		FA3a : FA
			port map(sum_array1(3)(i), sum_array2(3)(i), carry_array2(3)(i), carry_array1(4)(i + 1), sum_array1(4)(i));
	end generate;
	FA415a : FA                        -- P15
		port map(carry_array1(3)(15), carry_array2(3)(15), input_array1(9)(6), carry_array1(4)(16), sum_array1(4)(15));

	-- 5th Stage - All columns will have 2pp or less
	HA51a : HA                         -- P1
		port map(sum_array1(4)(1), input_array2(1)(0), carry_array1(5)(2), sum_array1(5)(1));
	FA52a : FA                         -- P2
		port map(sum_array1(4)(2), carry_array1(4)(2), input_array2(0)(2), carry_array1(5)(3), sum_array1(5)(2));
	FA53a : FA                         -- P3
		port map(sum_array1(4)(3), carry_array1(4)(3), input_array2(0)(3), carry_array1(5)(4), sum_array1(5)(3));
	FAGen5a : for i in 4 to 14 generate -- P4-P14
		FA3a : FA
			port map(sum_array1(4)(i), carry_array1(4)(i), carry_array1(3)(i), carry_array1(5)(i + 1), sum_array1(5)(i));
	end generate;
	FA515a : FA                        -- P15
		port map(carry_array1(4)(15), sum_array1(4)(15), input_array2(9)(6), carry_array1(5)(16), sum_array1(5)(15));

	-- Final Adder
	HA60a : HA
		port map(input_array1(0)(0), input_array2(0)(0), carry_array1(6)(1), p(0));
	FA61a : FA                         --P1
		port map(sum_array1(5)(1), input_array2(0)(1), carry_array1(6)(1), carry_array1(6)(2), p(1));
	FaGen6a : for i in 2 to 15 generate -- P2-P15
		FA5a : FA
			port map(sum_array1(5)(i), carry_array1(5)(i), carry_array1(6)(i), carry_array1(6)(i + 1), p(i));
	end generate;
	FA60a : FA                         --P16
		port map(carry_array1(4)(16), carry_array1(5)(16), carry_array1(6)(16), discard_carry, p(16));

end arch;