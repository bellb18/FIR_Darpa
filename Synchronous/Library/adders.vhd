Library IEEE;
use IEEE.std_logic_1164.all;
-- Boolean Full Adder
entity FA is
	port(
		X     : IN  std_logic;
		Y     : IN  std_logic;
		CIN   : IN  std_logic;
		COUT  : OUT std_logic;
		S     : OUT std_logic);
  end FA;

architecture arch of FA is
begin
	fadder : process(CIN, X, Y)
	begin
	  S <= X xor Y xor CIN;
	  COUT <= (X and Y) or ((X or Y) and CIN);
	end process;
end arch;

Library IEEE;
use IEEE.std_logic_1164.all;
-- Boolean Full Adder with Sleep Input
entity FA_Sleep is
	port(
		X     : IN  std_logic;
		Y     : IN  std_logic;
		CIN   : IN  std_logic;
		SLEEP : IN	std_logic;
		COUT  : OUT std_logic;
		S     : OUT std_logic);
  end FA_Sleep;

architecture arch of FA_Sleep is
	component XOR2_Sleep is
		port(a, b  : in  std_logic;
			 sleep : in std_logic;
			 z : out std_logic);
	end component;
	
	component NAND2_Sleep is
	port(a, b: in  std_logic;
		 sleep : in std_logic;
		 z : out std_logic);
	end component;

	signal S1 : std_logic;
	signal C1, C2, C3 : std_logic;
	
begin
		xor_0 : XOR2_Sleep
			port map(X, Y, SLEEP, S1);
		xor_1 : XOR2_Sleep
			port map(S1, CIN, SLEEP, S);
		nand_0 : NAND2_Sleep
			port map(X, Y, SLEEP, C1);
		nand_1 : NAND2_Sleep
			port map(S1, CIN, SLEEP, C2);
		nand_2  : NAND2_Sleep
			port map(C1, C2, SLEEP, COUT);	
end arch;

-- Boolean Half Adder
Library IEEE;
use IEEE.std_logic_1164.all;
entity HA is
  port(
    X       : IN std_logic;
    Y       : IN std_logic;
    COUT    : OUT std_logic;
    S       : OUT std_logic);
  end HA;

architecture arch of HA is
begin
  hadder  : process(X, Y)
  begin
    COUT <= X and Y;
    S <= X xor Y;
  end process;
end arch;

-- Boolean Half Adder with Sleep Input
Library IEEE;
use IEEE.std_logic_1164.all;
entity HA_Sleep is
  port(
    X       : IN std_logic;
    Y       : IN std_logic;
    SLEEP	: IN std_logic;
    COUT    : OUT std_logic;
    S       : OUT std_logic);
  end HA_Sleep;

architecture arch of HA_Sleep is
	component XOR2_Sleep is
		port(a, b  : in std_logic;
			 sleep : in std_logic;
			 z : out std_logic);
	end component;
	
	component AND2_Sleep is
		port(a, b  : in std_logic;
			 sleep : in std_logic;
			 z : out std_logic);
	end component;
begin
	and_0 : AND2_Sleep
		port map(X, Y, SLEEP, COUT);
    xor_0 : XOR2_Sleep
    	port map(X, Y, SLEEP, S);
end arch;

-- Boolean Full Adder with 1
Library IEEE;
use IEEE.std_logic_1164.all;
entity FA1 is
  port(
    X       : IN  std_logic;
    Y       : IN  std_logic;
    COUT    : OUT std_logic;
    S       : OUT std_logic);
  end FA1;

architecture arch of FA1 is
begin
  fadder1  : process(X,Y)
  begin
    S     <= not (X xor Y);
    COUT  <= X or Y;
  end process;
end arch;

-- Boolean Full Adder with 1 and Sleep Input
Library IEEE;
use IEEE.std_logic_1164.all;
entity FA1_Sleep is
  port(
    X       : IN  std_logic;
    Y       : IN  std_logic;
    SLEEP	: IN  std_logic;
    COUT    : OUT std_logic;
    S       : OUT std_logic);
  end FA1_Sleep;

architecture arch of FA1_Sleep is
	component XOR2_Sleep is
		port(a, b  : in std_logic;
			 sleep : in std_logic;
			 z : out std_logic);
	end component;
	
	component INV_A_Sleep is
		port(a : in std_logic;
			 sleep : in std_logic; 
			 z : out std_logic);
	end component;
		
	component OR2_Sleep is
		port(a, b  : in std_logic;
			 sleep : in std_logic;
			 z : out std_logic);
	end component;

	signal S0	: std_logic;
	
begin
	xor_0 : XOR2_Sleep
		port map(X, Y, SLEEP, S0);
	inv_1 : INV_A_Sleep
		port map(S0, SLEEP, S);
    or_0  : OR2_Sleep
    	port map(X, Y, SLEEP, COUT);
end arch;

-- Boolean Half Adder with 1
Library IEEE;
use IEEE.std_logic_1164.all;
entity HA1 is
  port(
    X       : IN  std_logic;
    COUT    : OUT std_logic;
    S       : OUT std_logic);
  end HA1;
architecture arch of HA1 is
begin
  hadder1   : process(X)
  begin
    S     <= not X;
    COUT  <= X;
  end process;
end arch;

-- Carry save adder
library ieee;
use ieee.std_logic_1164.all;
entity CSA is 
	port(
	X : IN std_logic;
	Y : IN std_logic;
	CIN   : IN std_logic;
	SIN: IN std_logic;
	COUT : OUT std_logic;
	SOUT : OUT std_logic);
end CSA;

architecture arch of CSA is
	
component FA is
port(
	X     : IN  std_logic;
	Y     : IN  std_logic;
	CIN   : IN  std_logic;	
	COUT  : OUT std_logic;
	S     : OUT std_logic);
end component;

signal anded: std_logic;
	
begin	
	anded <= X and Y;
	fullAdder: FA port map(CIN, anded, SIN, COUT, SOUT);
end arch;

-- Inverted carry save adder
library ieee;
use ieee.std_logic_1164.all;
entity CSA_inv is 
port(
	X : IN std_logic;
	Y : IN std_logic;
	CIN   : IN std_logic;
	SIN   : IN std_logic;
	COUT : OUT std_logic;
	SOUT : OUT std_logic);
end CSA_inv;

architecture arch of CSA_inv is
	
component FA is
port(
	X     : IN  std_logic;
	Y     : IN  std_logic;
	CIN   : IN  std_logic;
	COUT  : OUT std_logic;
	S     : OUT std_logic);
end component;

signal anded: std_logic;

begin	
	anded <= X nand Y;
	fullAdder: FA port map(CIN, anded, SIN, COUT, SOUT);
end arch;