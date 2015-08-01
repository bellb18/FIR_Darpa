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

