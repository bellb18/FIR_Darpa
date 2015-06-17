Library IEEE;
use IEEE.std_logic_1164.all;

-- Boolean Full Adder
entity FA is
	port(
		CIN   : IN  std_logic;
		X     : IN  std_logic;
		Y     : IN  std_logic;
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