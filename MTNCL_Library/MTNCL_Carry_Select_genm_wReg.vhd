
-----------------------------------------
-- Definition of Hybrid Carry Look Ahead(CLA)
-- and Ripple Carry Adder(RCA) 4 Bits
-----------------------------------------

Library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.MTNCL_gates.all;
use work.ncl_signals.all;
entity Carry_Select_16bm is
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

architecture arch of Carry_Select_16bm is
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
	
	component FAm1 is
	port(X     : dual_rail_logic;
		 Y     : in  dual_rail_logic;
		 sleep : in  std_logic;
		 COUT  : out dual_rail_logic;
		 S     : out dual_rail_logic);
	end component;
	
	component MUXm is
  port(A: in dual_rail_logic;
       B: in dual_rail_logic;
       S: in dual_rail_logic;
       sleep: in std_logic;
       Z   : out dual_rail_logic);
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

	component th22d_a is
	port(a   : in  std_logic;
		 b   : in  std_logic;
		 rst : in  std_logic;
		 z   : out std_logic);
	end component;

	signal carryA, carry1, carry0 : dual_rail_logic_vector(7 downto 0);
	signal inputXReg, inputYReg, sReg : dual_rail_logic_vector(15 downto 0);
	signal sReg0, sReg1 : dual_rail_logic_vector(7 downto 0);
	signal ko_OutReg, koX, koY, koSig : std_logic;

begin
	
	-- Input Registers
	inRegX : genregm 
		generic map(16)
		port map(X, koSig, inputXReg);
	inRegY : genregm 
		generic map(16)
		port map(Y, koSig, inputYReg);
	inCompX : compm
		generic map(16)
		port map(X, ko_OutReg, rst, sleep, koX);
	inCompY : compm
		generic map(16)
		port map(Y, ko_OutReg, rst, sleep, koY);
	andKO : th22d_a
		port map(koX, koY, rst, koSig);
		
	sleepOut <= ko_OutReg;
	ko <= koSig;
	
	HAa : HAm
		port map(inputXReg(0), inputYReg(0), koSig, carryA(0), sReg(0));
	FAGen1m : for i in 1 to 7 generate
		FAa : FAm
			port map(inputXReg(i), inputYReg(i), carryA(i - 1), koSig, carryA(i), sReg(i));
	end generate;
	
	-- Carry = 0
	HAb : HAm
		port map(inputXReg(8), inputYReg(8), koSig, carry0(0), sReg0(0));
	FAGen2m : for i in 1 to 7 generate
		FAa : FAm
			port map(inputXReg(i + 8), inputYReg(i + 8), carry0(i - 1), koSig, carry0(i), sReg0(i));
	end generate;
	
	-- Carry = 1
	FAa : FAm1
		port map(inputXReg(8), inputYReg(8), koSig, carry1(0), sReg1(0));
	FAGen3m : for i in 1 to 7 generate
		FAa : FAm
			port map(inputXReg(i + 8), inputYReg(i + 8), carry1(i - 1), koSig, carry1(i), sReg1(i));
	end generate;
	
	-- Multiplex
	MUXmA : for i in 0 to 7 generate
		MUXa : MUXm
			port map(sReg0(i), sReg1(i), carryA(7), koSig, sReg(i + 8));
	end generate;
	
	-- Output Register
	outReg : genregm 
		generic map(16)
		port map(sReg, ko_OutReg, S);
	outComp : compm
		generic map(16)
		port map(sReg, ki, rst, koSig, ko_OutReg);
	

end arch;