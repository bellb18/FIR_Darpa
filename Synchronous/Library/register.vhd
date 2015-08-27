library IEEE;
use IEEE.std_logic_1164.all;
-- Boolean DFF
entity reg is
	port(
		D   : in  std_logic;
		clk : in  std_logic;
		rst : in  std_logic;
		Q   : out std_logic);
end reg;

architecture arch of reg is
begin
	P1 : process(clk, rst)
	begin
		if (rst = '1') then
			Q <= '0' after 1 ns;
		elsif (clk'event and clk = '1') then
			Q <= D after 2 ns;
		end if;
	end process;
end arch;

----------------------------------------------------------- 
-- Reg with Sleep Input
----------------------------------------------------------- 
library IEEE;
use IEEE.std_logic_1164.all;

entity reg_sleep is
	port(
		D   : in  std_logic;
		clk : in  std_logic;
		rst : in  std_logic;
		Q   : out std_logic);
end reg_sleep;

architecture arch of reg_sleep is
	component INV_A_Sleep is
	port(a : in  std_logic;
		 sleep : in std_logic;
		 z : out std_logic);
	end component;
	
	component NAND2_Sleep is
		port(a, b  : in std_logic;
			 sleep : in std_logic;
			 z : out std_logic);
	end component;

	signal na0, na1, na2, na3 : std_logic;
	signal n0 : std_logic;
	
begin
	inv_0  : INV_A_Sleep
		port map(D, rst, n0);
	nand_0 : NAND2_Sleep
		port map(D, clk, rst, na0);
	nand_1 : NAND2_Sleep
		port map(n0, clk, rst, na1);
	nand_2 : NAND2_Sleep
		port map(na0, na3, rst, Q);
	nand_3 : NAND2_Sleep
		port map(na1, na2, rst, na3);
end arch;


library IEEE;
use IEEE.std_logic_1164.all;
-- Boolean Generic Register
entity reg_gen is
	generic(width : integer := 16);
	port(
		D   : in  std_logic_vector(width - 1 downto 0);
		clk : in  std_logic;
		rst : in  std_logic;
		Q   : out std_logic_vector(width - 1 downto 0));
end reg_gen;

architecture arch of reg_gen is
	component reg is
		port(
			D   : in  std_logic;
			clk : in  std_logic;
			rst : in  std_logic;
			Q   : out std_logic);
	end component;

begin
	Gen1 : for i in 0 to width - 1 generate
		RegA : reg
			port map(D(i), clk, rst, Q(i));
	end generate;
end arch;

library IEEE;
use IEEE.std_logic_1164.all;
-- Boolean Generic Register with Sleep Input
entity reg_gen_sleep is
	generic(width : integer := 16);
	port(
		D   : in  std_logic_vector(width - 1 downto 0);
		clk : in  std_logic;
		rst : in  std_logic;
		sleep : in std_logic;
		Q   : out std_logic_vector(width - 1 downto 0));
end reg_gen_sleep;

architecture arch of reg_gen_sleep is
	component reg_sleep is
		port(
			D   : in  std_logic;
			clk : in  std_logic;
			rst : in  std_logic;
			sleep : in std_logic;
			Q   : out std_logic);
	end component;

begin
	Gen1 : for i in 0 to width - 1 generate
		RegA : reg_sleep
			port map(D(i), clk, rst, sleep, Q(i));
	end generate;
end arch;
