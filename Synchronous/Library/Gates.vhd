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
-- INV with Sleep Input
----------------------------------------------------------- 
library ieee;
use ieee.std_logic_1164.all;

entity INV_A_Sleep is
	port(a : in  std_logic;
		 sleep : in std_logic;
		 z : out std_logic);
end INV_A_Sleep;

architecture arch of INV_A_Sleep is
begin
	bufx0 : process(a, Sleep)
	begin
		if sleep = '1' or a = '1' then
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
-- AND with Sleep Input
----------------------------------------------------------- 
library ieee;
use ieee.std_logic_1164.all;

entity AND2_Sleep is
	port(a, b: in  std_logic;
		 sleep : in std_logic;
		 z : out std_logic);
end AND2_Sleep;

architecture arch of AND2_Sleep is
begin
	and2_sleep : Process(a, b, sleep) begin
	if (sleep = '1') then
		z <= '0' after 1 ns;
	else
		z <= a and b after 1 ns;
	end if;
	end Process;
end arch;

----------------------------------------------------------- 
-- OR
----------------------------------------------------------- 
library ieee;
use ieee.std_logic_1164.all;

entity OR2 is
	port(a, b : in  std_logic;
		 z : out std_logic);
end OR2;

architecture arch of OR2 is
begin
	z <= a or b after 1 ns;
end arch;

----------------------------------------------------------- 
-- OR with Sleep Input
----------------------------------------------------------- 
library ieee;
use ieee.std_logic_1164.all;

entity OR2_Sleep is
	port(a, b : in  std_logic;
		 sleep : in std_logic;
		 z : out std_logic);
end OR2_Sleep;

architecture arch of OR2_Sleep is
begin
	z <= (not sleep) and (a or b) after 1 ns;
end arch;

----------------------------------------------------------- 
-- NAND with Sleep Input
----------------------------------------------------------- 
library ieee;
use ieee.std_logic_1164.all;

entity NAND2_Sleep is
	port(a, b: in  std_logic;
		 sleep : in std_logic;
		 z : out std_logic);
end NAND2_Sleep;

architecture arch of NAND2_Sleep is
begin
	nand2_sleep : Process(a, b, sleep) begin
	if (sleep = '1') then
		z <= '0' after 1 ns;
	else
		z <= not (a and b) after 1 ns;
	end if;
	end Process;
end arch;

----------------------------------------------------------- 
-- XOR
----------------------------------------------------------- 
library ieee;
use ieee.std_logic_1164.all;

entity XOR2 is
	port(a, b : in  std_logic;
		 z : out std_logic);
end XOR2;

architecture arch of XOR2 is
begin
	xor2 : Process(a, b) begin
	if (a = b) then
		z <= '0' after 1 ns;
	else
		z <= '1' after 2 ns;
	end if;
	end Process;
end arch;

----------------------------------------------------------- 
-- XOR with Sleep Input
----------------------------------------------------------- 
library ieee;
use ieee.std_logic_1164.all;

entity XOR2_Sleep is
	port(a, b : in  std_logic;
		 sleep : in std_logic;
		 z : out std_logic);
end XOR2_Sleep;

architecture arch of XOR2_Sleep is
begin
	xor2 : Process(a, b, sleep) begin
	if (a = b) or (sleep = '1') then
		z <= '0' after 1 ns;
	else
		z <= '1' after 2 ns;
	end if;
	end Process;
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

----------------------------------------------------------- 
-- MUX with Sleep Input
----------------------------------------------------------- 
library ieee;
use ieee.std_logic_1164.all;

entity MUX_Sleep is
	port(a, b, s : in  std_logic;
		 sleep : in std_logic;
		 z : out std_logic);
end MUX_Sleep;

architecture arch of MUX_Sleep is
begin
	P1 : process(a, b, s, sleep)
	begin
		if (sleep = '1') then
			z <= '0' after 1 ns;
		elsif(s = '1') then
			z <= b after 1 ns;
		else
			z <= a after 1 ns;
		end if;
	end process;
end arch;