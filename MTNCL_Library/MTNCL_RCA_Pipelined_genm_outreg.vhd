
-----------------------------------------
-- Definition of Hybrid Carry Look Ahead(CLA)
-- and Ripple Carry Adder(RCA) 4 Bits
-----------------------------------------

Library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.MTNCL_gates.all;
use work.ncl_signals.all;
entity RCA_Pipelined_genm_outreg is
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

architecture arch of RCA_Pipelined_genm_outreg is
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

	signal carry : dual_rail_logic_vector(width downto 0);
	signal ko_OutReg : std_logic;
	signal sReg : dual_rail_logic_vector(width - 1 downto 0);
	
begin
	
	ko <= ko_OutReg;
	
	HAa : HAm
		port map(X(0), Y(0), sleepIn, carry(0), sReg(0));
	FAGenm : for i in 1 to width - 1 generate
		FAa : FAm
			port map(X(i), Y(i), carry(i - 1), sleepIn, carry(i), sReg(i));
	end generate;
	
	-- Output Register
	outReg : genregm 
		generic map(16)
		port map(sReg, ko_OutReg, S);
	outComp : compm
		generic map(16)
		port map(sReg, ki, rst, sleepIn, ko_OutReg);

	sleepOut <= ko_OutReg;	

end arch;