Library IEEE;
use IEEE.std_logic_1164.all;
use work.ncl_signals.all;
entity Dadda_Pipelined_RCAPiped is
	port(x     : in  dual_rail_logic_vector(9 downto 0);
		 y     : in  dual_rail_logic_vector(6 downto 0);
		 ki    : in std_logic;
		 sleepIn : in  std_logic;
		 rst      : in  std_logic;
		 sleepOut : out std_logic;
		 ko 	  : out std_logic;
		 p     : out dual_rail_logic_vector(15 downto 0));
end;

architecture arch of Dadda_Pipelined_RCAPiped is
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
	
	component genregm is
	generic(width : in integer := 4);
	port(a     : IN  dual_rail_logic_vector(width - 1 downto 0);
		 sleep : in  std_logic;
		 z     : out dual_rail_logic_vector(width - 1 downto 0));
	end component;
	
	component regm is
	port(a     : IN  dual_rail_logic;
		 sleep : in  std_logic;
		 z     : out dual_rail_logic);
	end component;

	component compm is
		generic(width : in integer := 4);
		port(a              : IN  dual_rail_logic_vector(width - 1 downto 0);
			 ki, rst, sleep : in  std_logic;
			 ko             : OUT std_logic);
	end component;

	component th22d_a is
	port(a   : in  std_logic;
		 b   : in  std_logic;
		 rst : in  std_logic;
		 z   : out std_logic);
	end component;
	
	component PipeRegm is
	generic(width : in integer := 4);
	port(a     : IN  dual_rail_logic_vector(width - 1 downto 0);
		 ki, rst, sleep : in std_logic;
		 sleepout, ko : out  std_logic;
		 z     : out dual_rail_logic_vector(width - 1 downto 0));
	end component;
	

	type Ctype is array (4 downto 0) of dual_rail_logic_vector(16 downto 0);
	type InType is array (9 downto 0) of dual_rail_logic_vector(6 downto 0);

	signal carry_array1, carry_array2, sum_array1, sum_array2 : Ctype;
	signal temp_input_array, input_array                      : InType;
	signal inputXReg : dual_rail_logic_vector(9 downto 0);
	signal inputYReg : dual_rail_logic_vector(6 downto 0);
	signal ko_OutReg, koX, koY, koSig, ko_pipe1, ko_pipe2, sleep_RCA, ko_RCA : std_logic;
	signal pReg : dual_rail_logic_vector(15 downto 0);
	signal A, A_reg : dual_rail_logic_vector(15 downto 0);
	signal B, B_reg : dual_rail_logic_vector(14 downto 0);
	signal A_B : dual_rail_logic_vector(30 downto 0);
	signal Pipe_RCA_In, Pipe_RCA_Out  : dual_rail_logic_vector(24 downto 0);
	signal OUTPUT1 : dual_rail_logic_vector(15 downto 0);
	signal E, E_reg : dual_rail_logic_vector(19 downto 0);
	signal F, F_reg : dual_rail_logic_vector(17 downto 0);
	signal G, G_reg : dual_rail_logic_vector(14 downto 0);
	signal E_F_G : dual_rail_logic_vector(52 downto 0);

begin
	--Input registers
	inRegX : genregm 
		generic map(10)
		port map(x, koSig, inputXReg);
	inRegY : genregm 
		generic map(7)
		port map(y, koSig, inputYReg);
	inCompX : compm
		generic map(10)
		port map(x, ko_pipe2, rst, sleepIn, koX);
	inCompY : compm
		generic map(7)
		port map(y, ko_pipe2, rst, sleepIn, koY);
	andKO : th22d_a
		port map(koX, koY, rst, koSig);
	sleepOut <= ko_OutReg;
	ko <= koSig;
	
	
	-- Generate partial products
	AndGenx : for i in 0 to 9 generate
		AndGeny : for j in 0 to 6 generate
			AndGen : and2im
				port map(inputXReg(i), inputYReg(j), koSig, temp_input_array(i)(j));
		end generate;
	end generate;

	-- Fix inverted inputs
	NotInvGena : for i in 0 to 8 generate
		NotInvGenb : for j in 0 to 5 generate
			input_array(i)(j) <= temp_input_array(i)(j);
		end generate;
	end generate;
	InvGena : for i in 0 to 8 generate
		input_array(i)(6).RAIL0 <= temp_input_array(i)(6).RAIL1;
		input_array(i)(6).RAIL1 <= temp_input_array(i)(6).RAIL0;
	end generate;
	InvGenb : for i in 0 to 5 generate
		input_array(9)(i).RAIL0 <= temp_input_array(9)(i).RAIL1;
		input_array(9)(i).RAIL1 <= temp_input_array(9)(i).RAIL0;
	end generate;
	input_array(9)(6) <= temp_input_array(9)(6);

	-- 0th Stage - All columns will have 6pp or less
	FA06a : FAm1                        --P6
		port map(input_array(6)(0), input_array(5)(1), koSig, carry_array1(0)(7), sum_array1(0)(6));
	FaGen0a : for i in 1 to 2 generate  --P7-P8
		Fa0a : FAm
			port map(input_array(i + 6)(0), input_array(i + 5)(1), input_array(i + 4)(2), koSig, carry_array1(0)(i + 7), sum_array1(0)(i + 6));
	end generate;
	FA09a : FAm1                        --P9
		port map(input_array(9)(0), input_array(8)(1), koSig, carry_array1(0)(10), sum_array1(0)(9));
	HA09a : HAm                         --P9
		port map(input_array(7)(2), input_array(6)(3), koSig, carry_array2(0)(10), sum_array2(0)(9));
	FA010 : FAm                         --P10
		port map(input_array(9)(1), input_array(8)(2), input_array(7)(3), koSig, carry_array1(0)(11), sum_array1(0)(10));

	-- 1st Stage - All columns will have 4pp or less
	HA14a : HAm                         --P4
		port map(input_array(4)(0), input_array(3)(1), koSig, carry_array1(1)(5), sum_array1(1)(4));
	HA15a : HAm                         --P5
		port map(input_array(2)(3), input_array(1)(4), koSig, carry_array1(1)(6), sum_array1(1)(5));
	FA15a : FAm                         --P5
		port map(input_array(5)(0), input_array(4)(1), input_array(3)(2), koSig, carry_array2(1)(6), sum_array2(1)(5));
	FA16a : FAm                         -- P6
		port map(sum_array1(0)(6), input_array(4)(2), input_array(3)(3), koSig, carry_array1(1)(7), sum_array1(1)(6));

	FaGen1a : for i in 1 to 2 generate  --P7-P8 gate 1
		FA1a : FAm
			port map(input_array(i + 3)(3), sum_array1(0)(i + 6), carry_array1(0)(i + 6), koSig, carry_array1(1)(i + 7), sum_array1(1)(i + 6));
	end generate;

	FA19a : FAm                         -- P9 gate 1
		port map(sum_array1(0)(9), sum_array2(0)(9), carry_array1(0)(9), koSig, carry_array1(1)(10), sum_array1(1)(9));
	FA110a : FAm                        -- P10 gate 1
		port map(sum_array1(0)(10), carry_array2(0)(10), carry_array1(0)(10), koSig, carry_array1(1)(11), sum_array1(1)(10));
	FA111a : FAm                        -- P11 gate 1
		port map(carry_array1(0)(11), input_array(9)(2), input_array(8)(3), koSig, carry_array1(1)(12), sum_array1(1)(11));

	FaGen1b : for i in 1 to 6 generate  --P6-P11 gate 2
		FA1a : FAm
			port map(input_array(i + 1)(4), input_array(i)(5), input_array(i - 1)(6), koSig, carry_array2(1)(i + 6), sum_array2(1)(i + 5));
	end generate;

	FA112a : FAm                        --P12
		port map(input_array(9)(3), input_array(8)(4), input_array(7)(5), koSig, carry_array1(1)(13), sum_array1(1)(12));


	E <= input_array(9)(5) & carry_array1(1)(11 downto 6) & input_array(0)(3) & input_array(2)(0) & carry_array1(1)(13) & sum_array1(1)(12) & sum_array1(1)(11 downto 6) & sum_array1(1)(5) & input_array(2)(2) & input_array(3)(0);
	F <= input_array(0)(1) & input_array(1)(0) & input_array(9)(6) & input_array(8)(6) & input_array(6)(6) & input_array(0)(4) & input_array(1)(1) & input_array(9)(4) & carry_array2(1)(12) & carry_array2(1)(11 downto 6) & carry_array1(1)(5) & input_array(1)(3) & input_array(2)(1);
	G <= input_array(0)(0) & input_array(0)(2) & input_array(7)(6) & input_array(0)(5) & input_array(1)(2) & input_array(8)(5) & carry_array1(1)(12) & sum_array2(1)(11 downto 6) & sum_array2(1)(5) & sum_array1(1)(4);
	E_F_G <= E & F & G;
	
	-- Pipeline Register
	Pipe2Reg1 : genregm 
		generic map(20)
		port map(E, ko_pipe2, E_reg);
	Pipe2Reg2 : genregm 
		generic map(18)
		port map(F, ko_pipe2, F_reg);
	Pipe2Reg3 : genregm
		generic map (15)
		port map(G, ko_pipe2, G_reg);
	Pipe2Comp1 : compm
		generic map(53)
		port map(E_F_G, ko_Pipe1, rst, koSig, ko_pipe2);


	-- 2nd Stage - All columns will have 3pp or less
	HA23a : HAm                         -- P3
		port map(E_reg(0), F_reg(0), ko_pipe2,
			     carry_array1(2)(4), sum_array1(2)(3));
	FA24a : FAm                         -- P4
		port map(G_reg(0), E_reg(1), F_reg(1),
			     ko_pipe2, carry_array1(2)(5), sum_array1(2)(4));
	FA25a : FAm                         -- P5
		port map(G_reg(1), E_reg(2), F_reg(2),
			     ko_pipe2, carry_array1(2)(6), sum_array1(2)(5));
	FAGen2a : for i in 1 to 6 generate  -- P6-P11
		FA2a : FAm
			port map(G_reg(i + 1), E_reg(i + 2), F_reg(i + 2),
				     ko_pipe2, carry_array1(2)(i + 6), sum_array1(2)(i + 5));
	end generate;
	FA212a : FAm                        -- P12
		port map(E_reg(9), F_reg(9), G_reg(8),
			     ko_pipe2, carry_array1(2)(13), sum_array1(2)(12));
	FA213a : FAm                        -- P13
		port map(E_reg(10), F_reg(10), G_reg(9),
			     ko_pipe2, carry_array1(2)(14), sum_array1(2)(13));
			     
	-- 3rd Stage - All columns will have 2pp or less
	HA32a : HAm                         -- P2
		port map(E_reg(11), F_reg(11), ko_pipe2,
			     carry_array1(3)(3), sum_array1(3)(2));
	FA33a : FAm                         -- P3
		port map(sum_array1(2)(3), G_reg(10), E_reg(12),
			     ko_pipe2, carry_array1(3)(4), sum_array1(3)(3));
	FA34a : FAm                         -- P4
		port map(sum_array1(2)(4), carry_array1(2)(4), F_reg(12),
			     ko_pipe2, carry_array1(3)(5), sum_array1(3)(4));
	FA35a : FAm                         -- P5
		port map(sum_array1(2)(5), carry_array1(2)(5), G_reg(11),
			     ko_pipe2, carry_array1(3)(6), sum_array1(3)(5));
	FAGen3a : for i in 1 to 6 generate  -- P6-P11
		FA3a : FAm
			port map(carry_array1(2)(i + 5), E_reg(i + 12),
				     sum_array1(2)(i + 5), ko_pipe2, carry_array1(3)(i + 6), sum_array1(3)(i + 5));
	end generate;

	FA312a : FAm                        -- P12
		port map(sum_array1(2)(12), carry_array1(2)(12),
			     F_reg(13), ko_pipe2, carry_array1(3)(13), sum_array1(3)(12));
	FA313a : FAm                        -- P13
		port map(sum_array1(2)(13), carry_array1(2)(13),
			     G_reg(12), ko_pipe2, carry_array1(3)(14), sum_array1(3)(13));
	FA314a : FAm                        -- P14
		port map(carry_array1(2)(14), E_reg(19),
			     F_reg(14), ko_pipe2, carry_array1(3)(15), sum_array1(3)(14));
			     
	A <= F_reg(15) & sum_array1(3)(14 downto 3) & G_reg(13) & F_reg(16) & G_reg(14);
	B <= carry_array1(3)(15 downto 3) & sum_array1(3)(2) & F_reg(17);
	A_B <= A & B;
	
	-- Pipeline Register
	Pipe1Reg1 : genregm 
		generic map(16)
		port map(A, ko_pipe1, A_reg);
	Pipe1Reg2 : genregm 
		generic map(15)
		port map(B, ko_pipe1, B_reg);
	PipeComp1 : compm
		generic map(31)
		port map(A_B, ko_RCA, rst, ko_pipe2, ko_pipe1);
		
	Pipe_RCA_In <= A_reg(15 downto 8) & B_reg(14 downto 7) & pReg(7 downto 0) & carry_array1(4)(8);
	
	PipeRCAReg : PipeRegm
		generic map(25)
		port map(Pipe_RCA_In, ko_OutReg, rst, ko_pipe1, sleep_RCA, ko_RCA, Pipe_RCA_Out);
	

	-- Final Adder (Carry Propagate)
	pReg(0) <= A_reg(0);
	HA51a : HAm                         --P1
		port map(A_reg(1), B_reg(0), ko_pipe1, carry_array1(4)(2), pReg(1));
	FA52a : FAm                         --P2
		port map(A_reg(2), B_reg(1), carry_array1(4)(2), ko_pipe1, carry_array1(4)(3), pReg(2));
	FaGen5a : for i in 3 to 7 generate -- P3-P14
		FA5a : FAm
			port map(A_reg(i), B_reg(i - 1), carry_array1(4)(i), ko_pipe1, carry_array1(4)(i + 1), pReg(i));
	end generate;
	
	FA8a : FAm
			port map(Pipe_RCA_Out(17), Pipe_RCA_Out(9), Pipe_RCA_Out(0), sleep_RCA, carry_array1(4)(9), pReg(8));
	
	FaGen6a : for i in 9 to 15 generate -- P8-P14
		FA5a : FAm
			port map(Pipe_RCA_Out(9 + i), Pipe_RCA_Out(i + 1), carry_array1(4)(i), sleep_RCA, carry_array1(4)(i + 1), pReg(i));
	end generate;
	
	OUTPUT1 <= pReg(15 downto 8) & Pipe_RCA_Out(8 downto 1);
		
		
	-- Output Register
	outReg : genregm 
		generic map(16)
		port map(OUTPUT1, ko_OutReg, p);
	outComp : compm
		generic map(16)
		port map(OUTPUT1, ki, rst, sleep_RCA, ko_OutReg);
	

end arch;