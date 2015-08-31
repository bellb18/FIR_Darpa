library IEEE;
use IEEE.std_logic_1164.all;
entity Dadda_Pipelined_Sync_Sleep is
	port(x   : in  std_logic_vector(9 downto 0);
		 y   : in  std_logic_vector(6 downto 0);
		 clk : in  std_logic;
		 rst : in  std_logic;
		 sleep : in std_logic;
		 p   : out std_logic_vector(15 downto 0));
end;

architecture arch of Dadda_Pipelined_Sync_Sleep is
	component FA_Sleep
		port(CIN, X, Y : in  std_logic;
			 SLEEP     : in  std_logic;
			 COUT, S   : out std_logic);
	end component;
	
	component INV_A_Sleep is
	port(a : in  std_logic;
		 sleep : in std_logic;
		 z : out std_logic);
	end component;

	component HA_Sleep is
		port(
			X     : in  std_logic;
			Y     : in  std_logic;
			SLEEP : in  std_logic;
			COUT  : out std_logic;
			S     : out std_logic);
	end component;

	component FA1_Sleep is
		port(X     : std_logic;
			 Y     : in  std_logic;
			 SLEEP : in  std_logic;
			 COUT  : out std_logic;
			 S     : out std_logic);
	end component;

	component AND2_sleep is
		port(a     : in  std_logic;
			 b     : in  std_logic;
			 sleep : in  std_logic;
			 z     : out std_logic);
	end component;

	component reg_gen_sleep is
		generic(width : integer := 16);
		port(
			D   : in  std_logic_vector(width - 1 downto 0);
			clk : in  std_logic;
			rst : in  std_logic;
			sleep : in std_logic;
			Q   : out std_logic_vector(width - 1 downto 0));
	end component;

	type Ctype is array (4 downto 0) of std_logic_vector(16 downto 0);
	type InType is array (9 downto 0) of std_logic_vector(6 downto 0);

	signal carry_array1, carry_array2, sum_array1, sum_array2 : Ctype;
	signal temp_input_array, input_array                      : InType;
	signal inputXReg                                          : std_logic_vector(9 downto 0);
	signal inputYReg                                          : std_logic_vector(6 downto 0);
	signal pReg                                               : std_logic_vector(15 downto 0);
	signal A, A_reg                                           : std_logic_vector(15 downto 0);
	signal B, B_reg                                           : std_logic_vector(14 downto 0);
	signal E, E_reg                                           : std_logic_vector(19 downto 0);
	signal F, F_reg                                           : std_logic_vector(17 downto 0);
	signal G, G_reg                                           : std_logic_vector(14 downto 0);

begin
	--Input registers
	inRegX : reg_gen_sleep
		generic map(10)
		port map(x, clk, rst, sleep, inputXReg);
	inRegY : reg_gen_sleep
		generic map(7)
		port map(y, clk, rst, sleep, inputYReg);

	-- Generate partial products
	AndGenx : for i in 0 to 9 generate
		AndGeny : for j in 0 to 6 generate
			AndGen : AND2_Sleep
				port map(inputXReg(i), inputYReg(j), sleep, temp_input_array(i)(j));
		end generate;
	end generate;

	-- Fix inverted inputs
	NotInvGena : for i in 0 to 8 generate
		NotInvGenb : for j in 0 to 5 generate
			input_array(i)(j) <= temp_input_array(i)(j);
		end generate;
	end generate;
	InvGena : for i in 0 to 8 generate
		Inv1 : INV_A_Sleep
			port map(temp_input_array(i)(6), sleep, input_array(i)(6));
	end generate;
	InvGenb : for i in 0 to 5 generate
		Inv2 : INV_A_Sleep
			port map(temp_input_array(9)(i), sleep, input_array(9)(i));
	end generate;
	input_array(9)(6) <= temp_input_array(9)(6);

	-- 0th Stage - All columns will have 6pp or less
	FA06a : FA1_Sleep                         --P6
		port map(input_array(6)(0), input_array(5)(1), sleep, carry_array1(0)(7), sum_array1(0)(6));
	FaGen0a : for i in 1 to 2 generate  --P7-P8
		Fa0a : FA_Sleep
			port map(input_array(i + 6)(0), input_array(i + 5)(1), input_array(i + 4)(2), sleep, carry_array1(0)(i + 7), sum_array1(0)(i + 6));
	end generate;
	FA09a : FA1_Sleep                         --P9
		port map(input_array(9)(0), input_array(8)(1), sleep, carry_array1(0)(10), sum_array1(0)(9));
	HA09a : HA_Sleep                          --P9
		port map(input_array(7)(2), input_array(6)(3), sleep, carry_array2(0)(10), sum_array2(0)(9));
	FA010 : FA_Sleep                          --P10
		port map(input_array(9)(1), input_array(8)(2), input_array(7)(3), sleep, carry_array1(0)(11), sum_array1(0)(10));

	-- 1st Stage - All columns will have 4pp or less
	HA14a : HA_Sleep                          --P4
		port map(input_array(4)(0), input_array(3)(1), sleep, carry_array1(1)(5), sum_array1(1)(4));
	HA15a : HA_Sleep                          --P5
		port map(input_array(2)(3), input_array(1)(4), sleep, carry_array1(1)(6), sum_array1(1)(5));
	FA15a : FA_Sleep                          --P5
		port map(input_array(5)(0), input_array(4)(1), input_array(3)(2), sleep, carry_array2(1)(6), sum_array2(1)(5));
	FA16a : FA_Sleep                          -- P6
		port map(sum_array1(0)(6), input_array(4)(2), input_array(3)(3), sleep, carry_array1(1)(7), sum_array1(1)(6));

	FaGen1a : for i in 1 to 2 generate  --P7-P8 gate 1
		FA1a : FA_Sleep
			port map(input_array(i + 3)(3), sum_array1(0)(i + 6), carry_array1(0)(i + 6), sleep, carry_array1(1)(i + 7), sum_array1(1)(i + 6));
	end generate;

	FA19a : FA_Sleep                          -- P9 gate 1
		port map(sum_array1(0)(9), sum_array2(0)(9), carry_array1(0)(9), sleep, carry_array1(1)(10), sum_array1(1)(9));
	FA110a : FA_Sleep                         -- P10 gate 1
		port map(sum_array1(0)(10), carry_array2(0)(10), carry_array1(0)(10), sleep, carry_array1(1)(11), sum_array1(1)(10));
	FA111a : FA_Sleep                         -- P11 gate 1
		port map(carry_array1(0)(11), input_array(9)(2), input_array(8)(3), sleep, carry_array1(1)(12), sum_array1(1)(11));

	FaGen1b : for i in 1 to 6 generate  --P6-P11 gate 2
		FA1a : FA_Sleep
			port map(input_array(i + 1)(4), input_array(i)(5), input_array(i - 1)(6), sleep, carry_array2(1)(i + 6), sum_array2(1)(i + 5));
	end generate;

	FA112a : FA_Sleep                         --P12
		port map(input_array(9)(3), input_array(8)(4), input_array(7)(5), sleep, carry_array1(1)(13), sum_array1(1)(12));

	E <= input_array(9)(5) & carry_array1(1)(11 downto 6) & input_array(0)(3) & input_array(2)(0) & carry_array1(1)(13) & sum_array1(1)(12) & sum_array1(1)(11 downto 6) & sum_array1(1)(5) & input_array(2)(2) & input_array(3)(0);
	F <= input_array(0)(1) & input_array(1)(0) & input_array(9)(6) & input_array(8)(6) & input_array(6)(6) & input_array(0)(4) & input_array(1)(1) & input_array(9)(4) & carry_array2(1)(12) & carry_array2(1)(11 downto 6) & carry_array1(1)(5) & input_array(1)(3) & input_array(2)(1);
	G <= input_array(0)(0) & input_array(0)(2) & input_array(7)(6) & input_array(0)(5) & input_array(1)(2) & input_array(8)(5) & carry_array1(1)(12) & sum_array2(1)(11 downto 6) & sum_array2(1)(5) & sum_array1(1)(4);

	-- Pipeline Register
	Pipe2Reg1 : reg_gen_sleep
		generic map(20)
		port map(E, clk, rst, sleep, E_reg);
	Pipe2Reg2 : reg_gen_sleep
		generic map(18)
		port map(F, clk, rst, sleep, F_reg);
	Pipe2Reg3 : reg_gen_sleep
		generic map(15)
		port map(G, clk, rst, sleep, G_reg);

	-- 2nd Stage - All columns will have 3pp or less
	HA23a : HA_Sleep                          -- P3
		port map(E_reg(0), F_reg(0), sleep, carry_array1(2)(4), sum_array1(2)(3));
	FA24a : FA_Sleep                          -- P4
		port map(G_reg(0), E_reg(1), F_reg(1), sleep, carry_array1(2)(5), sum_array1(2)(4));
	FA25a : FA_Sleep                          -- P5
		port map(G_reg(1), E_reg(2), F_reg(2), sleep, carry_array1(2)(6), sum_array1(2)(5));
	FAGen2a : for i in 1 to 6 generate  -- P6-P11
		FA2a : FA_Sleep
			port map(G_reg(i + 1), E_reg(i + 2), F_reg(i + 2), sleep, carry_array1(2)(i + 6), sum_array1(2)(i + 5));
	end generate;
	FA212a : FA_Sleep                         -- P12
		port map(E_reg(9), F_reg(9), G_reg(8), sleep, carry_array1(2)(13), sum_array1(2)(12));
	FA213a : FA_Sleep                         -- P13
		port map(E_reg(10), F_reg(10), G_reg(9), sleep, carry_array1(2)(14), sum_array1(2)(13));

	-- 3rd Stage - All columns will have 2pp or less
	HA32a : HA_Sleep                          -- P2
		port map(E_reg(11), F_reg(11), sleep,
			     carry_array1(3)(3), sum_array1(3)(2));
	FA33a : FA_Sleep                          -- P3
		port map(sum_array1(2)(3), G_reg(10), E_reg(12), sleep,
			     carry_array1(3)(4), sum_array1(3)(3));
	FA34a : FA_Sleep                          -- P4
		port map(sum_array1(2)(4), carry_array1(2)(4), F_reg(12), sleep,
			     carry_array1(3)(5), sum_array1(3)(4));
	FA35a : FA_Sleep                          -- P5
		port map(sum_array1(2)(5), carry_array1(2)(5), G_reg(11), sleep,
			     carry_array1(3)(6), sum_array1(3)(5));
	FAGen3a : for i in 1 to 6 generate  -- P6-P11
		FA3a : FA_Sleep
			port map(carry_array1(2)(i + 5), E_reg(i + 12),
				     sum_array1(2)(i + 5), sleep, carry_array1(3)(i + 6), sum_array1(3)(i + 5));
	end generate;

	FA312a : FA_Sleep                         -- P12
		port map(sum_array1(2)(12), carry_array1(2)(12),
			     F_reg(13), sleep, carry_array1(3)(13), sum_array1(3)(12));
	FA313a : FA_Sleep                         -- P13
		port map(sum_array1(2)(13), carry_array1(2)(13),
			     G_reg(12), sleep, carry_array1(3)(14), sum_array1(3)(13));
	FA314a : FA_Sleep                         -- P14
		port map(carry_array1(2)(14), E_reg(19),
			     F_reg(14), sleep, carry_array1(3)(15), sum_array1(3)(14));

	A <= F_reg(15) & sum_array1(3)(14 downto 3) & G_reg(13) & F_reg(16) & G_reg(14);
	B <= carry_array1(3)(15 downto 3) & sum_array1(3)(2) & F_reg(17);

	-- Pipeline Register
	Pipe1Reg1 : reg_gen_sleep
		generic map(16)
		port map(A, clk, rst, sleep, A_reg);
	Pipe1Reg2 : reg_gen_sleep
		generic map(15)
		port map(B, clk, rst, sleep, B_reg);

	-- Final Adder (Carry Propagate)
	pReg(0) <= A_reg(0);
	HA51a : HA_Sleep                          --P1
		port map(A_reg(1), B_reg(0), sleep, carry_array1(4)(2), pReg(1));
	FA52a : FA_Sleep                          --P2
		port map(A_reg(2), B_reg(1), carry_array1(4)(2), sleep, carry_array1(4)(3), pReg(2));
	FaGen5a : for i in 3 to 14 generate -- P3-P14
		FA5a : FA_Sleep
			port map(A_reg(i), B_reg(i - 1), carry_array1(4)(i), sleep, carry_array1(4)(i + 1), pReg(i));
	end generate;
	FA515a : FA_Sleep                         --P15
		port map(A_reg(15), B_reg(14), carry_array1(4)(15), sleep, carry_array1(4)(16), pReg(15));

	-- Output Register
	outReg : reg_gen_sleep
		generic map(16)
		port map(pReg, clk, rst, sleep, p);

end arch;