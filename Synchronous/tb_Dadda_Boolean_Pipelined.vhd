Library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;
use work.Sync_gates.all;
use ieee.math_real.all;
use std.textio.all;
use ieee.std_logic_textio.all;

entity tb_Dadda_Boolean_Pipelined is
end;

architecture arch of tb_Dadda_Boolean_Pipelined is
	signal X                            : std_LOGIC_VECTOR(9 downto 0);
	signal C                            : std_LOGIC_VECTOR(6 downto 0);
	signal Y                            : std_LOGIC_VECTOR(15 downto 0);
	signal clk, rst : std_logic;

	component Dadda_Pipelined_Sync is
	port(x   : in  std_logic_vector(9 downto 0);
		 y   : in  std_logic_vector(6 downto 0);
		 clk : in  std_logic;
		 rst : in  std_logic;
		 p   : out std_logic_vector(15 downto 0));
	end component;

begin
	CUT : Dadda_Pipelined_Sync
		port map(X, C, clk, rst, Y);

	inputs : process

	begin
		-- Set Constant Coefficients
 		C <= "0000000";
		X <= "0000000000";
		rst   <= '1';
		clk <= '0';
		--sleep <= '0';
		wait for 2 ns;
		clk <= '1';
		wait for 2 ns;
		rst <= '0';
		wait for 10 ns;

		for i in 0 to 299 loop
			clk <= '0';
			X(0) <= not X(0);
			 --X <= "1000000000";
			wait for 100 ns;
			clk <= '1';
			wait for 100 ns;
		end loop;

		
	end process;
end arch;