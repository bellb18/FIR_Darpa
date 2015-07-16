
-----------------------------------------
-- Definition of Hybrid Carry Look Ahead(CLA)
-- and Ripple Carry Adder(RCA) 4 Bits
-----------------------------------------

Library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.MTNCL_gates.all;
use work.ncl_signals.all;
entity RCA_Pipelined_genm is
	generic(width : integer := 16);
	port(
		X    : in  dual_rail_logic_vector(width - 1 downto 0);
		Y    : in  dual_rail_logic_vector(width - 1 downto 0);
		ki	 : in std_logic;
		sleepIn : in  std_logic;
		rst  : in std_logic;
		sleepOut : out std_logic;
		ko 	     : out std_logic;
		S   : out dual_rail_logic_vector(width - 1 downto 0)
	);
end;

architecture arch of RCA_Pipelined_genm is
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

	component th22d_a is
	port(a   : in  std_logic;
		 b   : in  std_logic;
		 rst : in  std_logic;
		 z   : out std_logic);
	end component;

	signal carry : dual_rail_logic_vector(width downto 0);
	signal inputXReg, inputYReg, sReg : dual_rail_logic_vector(width - 1 downto 0);
	signal ko_OutReg, koX, koY, koSig : std_logic;

begin
	
	-- Input Registers
	inRegX : genregm 
		generic map(width)
		port map(X, koSig, inputXReg);
	inRegY : genregm 
		generic map(width)
		port map(Y, koSig, inputYReg);
	inCompX : compm
		generic map(width)
		port map(X, ko_OutReg, rst, sleepIn, koX);
	inCompY : compm
		generic map(width)
		port map(Y, ko_OutReg, rst, sleepIn, koY);
	andKO : th22d_a
		port map(koX, koY, rst, koSig);
	sleepOut <= ko_OutReg;
	ko <= koSig;
	
	HAa : HAm
		port map(inputXReg(0), inputYReg(0), koSig, carry(0), sReg(0));
	FAGenm : for i in 1 to width - 1 generate
		FAa : FAm
			port map(inputXReg(i), inputYReg(i), carry(i - 1), koSig, carry(i), sReg(i));
	end generate;
	
	-- Output Register
	outReg : genregm 
		generic map(16)
		port map(sReg, ko_OutReg, S);
	outComp : compm
		generic map(16)
		port map(sReg, ki, rst, koSig, ko_OutReg);
	

end arch;