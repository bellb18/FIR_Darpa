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