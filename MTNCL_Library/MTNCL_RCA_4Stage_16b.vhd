-----------------------------------------
-- Definition of Hybrid Carry Look Ahead(CLA)
-- and Ripple Carry Adder(RCA) 4 Bits
-----------------------------------------

Library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.MTNCL_gates.all;
use work.ncl_signals.all;
entity RCA_4Stage_16b is
	port(
		X    : in  dual_rail_logic_vector(15 downto 0);
		Y    : in  dual_rail_logic_vector(15 downto 0);
		ki	 : in std_logic;
		sleepIn : in  std_logic;
		rst  : in std_logic;
		sleepOut : out std_logic;
		ko 	     : out std_logic;
		S   : out dual_rail_logic_vector(15 downto 0)
	);
end;

architecture arch of RCA_4Stage_16b is
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
	port(a     : IN  dual_rail_logic_vector(15 downto 0);
		 sleep : in  std_logic;
		 z     : out dual_rail_logic_vector(15 downto 0));
	end component;

	component PipeRegm is
	generic(width : in integer := 4);
	port(a     : IN  dual_rail_logic_vector(width - 1 downto 0);
		 ki, rst, sleep : in std_logic;
		 sleepout, ko : out  std_logic;
		 z     : out dual_rail_logic_vector(width - 1 downto 0));
	end component;
	

	component compm is
		generic(width : in integer := 4);
		port(a              : IN  dual_rail_logic_vector(15 downto 0);
			 ki, rst, sleep : in  std_logic;
			 ko             : OUT std_logic);
	end component;

	component th22d_a is
	port(a   : in  std_logic;
		 b   : in  std_logic;
		 rst : in  std_logic;
		 z   : out std_logic);
	end component;

	signal carry : dual_rail_logic_vector(16 downto 0);
	signal inputXReg, inputYReg, sReg : dual_rail_logic_vector(15 downto 0);
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
		port map(X, ko_OutReg, rst, sleepIn, koX);
	inCompY : compm
		generic map(16)
		port map(Y, ko_OutReg, rst, sleepIn, koY);
	andKO : th22d_a
		port map(koX, koY, rst, koSig);
	sleepOut <= ko_OutReg;
	ko <= koSig;
	
	HAa : HAm
		port map(inputXReg(0), inputYReg(0), koSig, carry(0), sReg(0));
	FAGenmA : for i in 1 to 7 generate
		FAa : FAm
			port map(inputXReg(i), inputYReg(i), carry(i - 1), koSig, carry(i), sReg(i));
	end generate;
	
	FAGenmB : for i in 8 to 15 generate
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

-- Stage 1
Library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.MTNCL_gates.all;
use work.ncl_signals.all;
entity RCA_4Stage_16b_Stage1 is
	port(
		X    : in  dual_rail_logic_vector(15 downto 0);
		Y    : in  dual_rail_logic_vector(15 downto 0);
		ki	 : in std_logic;
		sleep : in  std_logic;
		rst  : in std_logic;
		sleepout : out std_logic;
		ko 	     : out std_logic;
		S   : out dual_rail_logic_vector(28 downto 0)
	);
end;

architecture arch of RCA_4Stage_16b_Stage1 is
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

	component PipeRegm is
	generic(width : in integer := 4);
	port(a     : IN  dual_rail_logic_vector(width - 1 downto 0);
		 ki, rst, sleep : in std_logic;
		 sleepout, ko : out  std_logic;
		 z     : out dual_rail_logic_vector(width - 1 downto 0));
	end component;

	signal carry : dual_rail_logic_vector(3 downto 0);
	signal sReg : dual_rail_logic_vector(27 downto 0);

begin
	
	sReg(27 downto 4) <= X(15 downto 4) & Y(15 downto 4);
	
	HAa : HAm
		port map(X(0), Y(0), sleep, carry(0), sReg(0));
	FAGenmA : for i in 1 to 3 generate
		FAa : FAm
			port map(X(i), Y(i), carry(i - 1), sleep, carry(i), sReg(i));
	end generate;
	
	sReg(28) <= carry(3);
	
	Reg1 : PipeRegm
	generic map(29)
	port map(sReg, ki, rst, sleep, sleepout, ko, S);
	

end arch;


-- Stage 2
Library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.MTNCL_gates.all;
use work.ncl_signals.all;
entity RCA_4Stage_16b_Stage2 is
	port(
		X    : in  dual_rail_logic_vector(28 downto 0);
		ki	 : in std_logic;
		sleep : in  std_logic;
		rst  : in std_logic;
		sleepout : out std_logic;
		ko 	     : out std_logic;
		S   : out dual_rail_logic_vector(24 downto 0)
	);
end;

architecture arch of RCA_4Stage_16b_Stage2 is

	component FAm is
		port(
			CIN   : IN  dual_rail_logic;
			X     : IN  dual_rail_logic;
			Y     : IN  dual_rail_logic;
			sleep : in  std_logic;
			COUT  : OUT dual_rail_logic;
			S     : OUT dual_rail_logic);
	end component;

	component PipeRegm is
	generic(width : in integer := 4);
	port(a     : IN  dual_rail_logic_vector(width - 1 downto 0);
		 ki, rst, sleep : in std_logic;
		 sleepout, ko : out  std_logic;
		 z     : out dual_rail_logic_vector(width - 1 downto 0));
	end component;

	signal carry : dual_rail_logic_vector(3 downto 0);
	signal sReg : dual_rail_logic_vector(24 downto 0);

begin
	
	sReg(23 downto 16) <= X(27 downto 20);
	sReg(15 downto 8) <= X(15 downto 8);
	sReg(3 downto 0) <= X(3 downto 0);
	sReg(24) <= carry(3);
	
	FAa : FAm
		port map(X(4), X(16), X(28), sleep, carry(0), sReg(4));
	FAGenmA : for i in 1 to 3 generate
		FAa : FAm
			port map(X(i + 4), X(i + 16), carry(i - 1), sleep, carry(i), sReg(i + 4));
	end generate;
	
	Reg1 : PipeRegm
	generic map(24)
	port map(sReg, ki, rst, sleep, sleepout, ko, S);
	

end arch;

-- Stage 3
Library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.MTNCL_gates.all;
use work.ncl_signals.all;
entity RCA_4Stage_16b_Stage3 is
	port(
		X    : in  dual_rail_logic_vector(24 downto 0);
		ki	 : in std_logic;
		sleep : in  std_logic;
		rst  : in std_logic;
		sleepout : out std_logic;
		ko 	     : out std_logic;
		S   : out dual_rail_logic_vector(20 downto 0)
	);
end;

architecture arch of RCA_4Stage_16b_Stage3 is

	component FAm is
		port(
			CIN   : IN  dual_rail_logic;
			X     : IN  dual_rail_logic;
			Y     : IN  dual_rail_logic;
			sleep : in  std_logic;
			COUT  : OUT dual_rail_logic;
			S     : OUT dual_rail_logic);
	end component;

	component PipeRegm is
	generic(width : in integer := 4);
	port(a     : IN  dual_rail_logic_vector(width - 1 downto 0);
		 ki, rst, sleep : in std_logic;
		 sleepout, ko : out  std_logic;
		 z     : out dual_rail_logic_vector(width - 1 downto 0));
	end component;

	signal carry : dual_rail_logic_vector(3 downto 0);
	signal sReg : dual_rail_logic_vector(20 downto 0);

begin
	
	sReg(19 downto 16) <= X(23 downto 20);
	sReg(15 downto 12) <= X(23 downto 16);
	sReg(7 downto 0) <= X(7 downto 0);
	sReg(20) <= carry(3);
	
	FAa : FAm
		port map(X(4), X(16), X(28), sleep, carry(0), sReg(8));
	FAGenmA : for i in 1 to 3 generate
		FAa : FAm
			port map(X(i + 4), X(i + 16), carry(i - 1), sleep, carry(i), sReg(i + 8));
	end generate;
	
	Reg1 : PipeRegm
	generic map(24)
	port map(sReg, ki, rst, sleep, sleepout, ko, S);
	

end arch;