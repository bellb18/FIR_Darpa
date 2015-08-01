
-----------------------------------------
-- 16 bit RCA with input/output registers with 2 registers split among the 
-- FA to increase speed
-----------------------------------------
Library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.MTNCL_gates.all;
use work.ncl_signals.all;
entity RCA_Pipelined2_16bit is
	port(
		X    : in  dual_rail_logic_vector(15 downto 0);
		Y    : in  dual_rail_logic_vector(15 downto 0);
		ki	 : in std_logic;
		sleep : in  std_logic;
		rst  : in std_logic;
		sleepOut : out std_logic;
		ko 	     : out std_logic;
		S   : out dual_rail_logic_vector(15 downto 0)
	);
end;

architecture arch of RCA_Pipelined2_16bit is
	component HAm
		port(X, Y    : in  dual_rail_logic;
			 sleep   : in  std_logic;
			 COUT, S : out dual_rail_logic);
	end component;
	component FAm is
		port(
			CIN   : IN  dual_rail_logic;
			X     : IN  dual_rail_logic;
			Y     : IN  dual_rail_logic;
			sleep : in  std_logic;
			COUT  : OUT dual_rail_logic;
			S     : OUT dual_rail_logic);
	end component;
	
	component genregm is
	generic(width : in integer := 4);
	port(a     : IN  dual_rail_logic_vector(width - 1 downto 0);
		 sleep : in  std_logic;
		 z     : out dual_rail_logic_vector(width - 1 downto 0));
	end component;

	component compm is
		generic(width : in integer := 4);
		port(a              : IN  dual_rail_logic_vector(width - 1 downto 0);
			 ki, rst, sleep : in  std_logic;
			 ko             : OUT std_logic);
	end component;

	signal carry : dual_rail_logic_vector(15 downto 0);
	--signal inputXReg, inputYReg, sReg : dual_rail_logic_vector(width - 1 downto 0);
	signal ko_comp0, ko_comp1, ko_comp2, ko_comp3 : std_logic;
	signal reg0_input, reg0_output : dual_rail_logic_vector(31 downto 0);
	signal reg3_input : dual_rail_logic_vector (15 downto 0);
	signal FA_sum0, FA_sum1 : dual_rail_logic_vector (7 downto 0);
	signal reg1_input, reg2_input, reg2_output : dual_rail_logic_vector(24 downto 0);

begin
	
	reg0_input <= X & Y;
	-- Input Register
	reg0 : genregm 
		generic map(32)
		port map(reg0_input, ko_comp0, reg0_output);
	comp0 : compm
		generic map(32)
		port map(reg0_input, ko_comp1, rst, sleep, ko_comp0);
	ko <= ko_comp0;
	
	HAa : HAm
		port map(reg0_output(0), reg0_output(16), ko_comp0, carry(0), FA_sum0(0));
	FAGenm : for i in 1 to 7 generate
		FAa : FAm
			port map(reg0_output(i), reg0_output(i + 16), carry(i - 1), ko_comp0, carry(i), FA_sum0(i));
	end generate;
	
	-- Assign reg1_input bits
	reg1_input(24) <= carry(7);
	reg1_inputGen: for i in 0 to 7 generate
		reg1_input(i) <= reg0_output(i + 8);
		reg1_input(i + 8) <= reg0_output(i + 24);
		reg1_input(i + 16) <= FA_sum0(i);
	end generate;
	
	-- Middle registers
	reg1: genregm
		generic map(25)
		port map(reg1_input, ko_comp1, reg2_input);
	comp1: compm
		generic map(25)
		port map(reg1_input, ko_comp2, rst, ko_comp0, ko_comp1);
	reg2: genregm
		generic map(25)
		port map(reg2_input, ko_comp2, reg2_output);
	comp2: compm
		generic map(25)
		port map(reg2_input, ko_comp3, rst, ko_comp1, ko_comp2);
		
	FAm2: FAm
		 port map(reg2_output(0), reg2_output(8), reg2_output(24), ko_comp2, carry(8), FA_sum1(0));
	FAGenm2: for i in 1 to 7 generate
		FAb: FAm
			port map(reg2_output(i), reg2_output(i + 8), carry(i + 7), ko_comp2, carry(i + 8), FA_sum1(i));
	end generate;	
		
	-- Assign reg3_input bits
	reg3_inputGen: for i in 0 to 7 generate
		reg3_input(i) <= reg2_output(i);
		reg3_input(i + 8) <= FA_sum1(i);
	end generate;
	
	-- Output Register
	reg3 : genregm 
		generic map(16)
		port map(reg3_input, ko_comp3, S);
	outComp : compm
		generic map(16)
		port map(reg3_input, ki, rst, ko_comp2, ko_comp3);
	sleepOut <= ko_comp3;

end arch;