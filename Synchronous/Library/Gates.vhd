----------------------------------------------------------- 
-- INV
----------------------------------------------------------- 
library ieee;
use ieee.std_logic_1164.all;

entity INV_A is
	port(a : in  std_logic;
		 z : out std_logic);
end INV_A;

architecture arch of INV_A is
begin
	bufx0 : process(a)
	begin
		if a = '1' then
			z <= '0' after 1 ns;
		else
			z <= '1' after 2 ns;
		end if;
	end process;
end arch;

----------------------------------------------------------- 
-- AND
----------------------------------------------------------- 
library ieee;
use ieee.std_logic_1164.all;

entity AND2 is
	port(a, b : in  std_logic;
		 z : out std_logic);
end AND2;

architecture arch of AND2 is
begin
	z <= a and b after 1 ns;
end arch;

----------------------------------------------------------- 
-- MUX
----------------------------------------------------------- 
library ieee;
use ieee.std_logic_1164.all;

entity MUX is
	port(a, b, s : in  std_logic;
		 z : out std_logic);
end MUX;

architecture arch of MUX is
begin
	P1 : process(a, b, s)
	begin
		if(s = '1') then
			z <= b after 1 ns;
		else
			z <= a after 1 ns;
		end if;
	end process;
end arch;