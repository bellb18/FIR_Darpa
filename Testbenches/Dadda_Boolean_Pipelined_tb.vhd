Library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;
--use work.functions.all;
use ieee.math_real.all;
use ieee.std_logic_arith.all;


entity tb_Dadda_Boolean_Pipelined is
end;

architecture arch of tb_Dadda_Boolean_Pipelined is
	signal X : std_logic_vector(9 downto 0);
	signal Y : std_logic_vector(6 downto 0);
	signal P : std_logic_vector(15 downto 0);
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
		port map(X, Y, clk, rst, P);

	inputs : process

	begin
		clk <= '0';
		rst <= '1';
		wait for 100 ns;
		clk <= '1';
		wait for 100 ns;
		rst <= '0';
		clk <= '0';
		
		-- 101 * -50 = -5050 (1110 1100 0100 0110)
		X <= conv_std_logic_vector(101, 10);
		Y <= conv_std_logic_vector(-50, 7);
		wait for 100 ns;
		clk <= '1';
		wait for 100 ns;
		clk <= '0';
		
		-- -281 * 51 = -14331 (1100 1000 0000 0101)
		X <= conv_std_logic_vector(-281, 10);
		Y <= conv_std_logic_vector(51, 7);
		wait for 100 ns;
		clk <= '1';
		wait for 100 ns;
		clk <= '0';
		
		-- -372 * 31 = -11532 (1101 0010 1111 0100)
		X <= conv_std_logic_vector(-372, 10);
		Y <= conv_std_logic_vector(31, 7);
		wait for 100 ns;
		clk <= '1';
		wait for 100 ns;
		clk <= '0';

		-- 383 * 55 = 21065 (0101 0010 0100 1001)
		X <= conv_std_logic_vector(383, 10);
		Y <= conv_std_logic_vector(55, 7);
		wait for 100 ns;
		clk <= '1';
		wait for 100 ns;
		clk <= '0';
		
		--428 * 60 = 25380 (0110 0100 0101 0000)
		X <= conv_std_logic_vector(428, 10);
		Y <= conv_std_logic_vector(60, 7);
		wait for 100 ns;
		clk <= '1';
		wait for 100 ns;
		clk <= '0';
	
		-- -438 * 52 = -22776 (1010 0111 0000 1000)
		X <= conv_std_logic_vector(-438, 10);
		Y <= conv_std_logic_vector(52, 7);
		wait for 100 ns;
		clk <= '1';
		wait for 100 ns;
		clk <= '0';
		
		-- 463 * 22 = (0010 0111 1100 1010) 
		X <= conv_std_logic_vector(463, 10);
		Y <= conv_std_logic_vector(22, 7);
		wait for 100 ns;
		clk <= '1';
		wait for 100 ns;
		clk <= '0';
		
		-- 227 * 31 = 7037 (0001 1011 0111 1101)
		X <= conv_std_logic_vector(227, 10);
		Y <= conv_std_logic_vector(31, 7);
		wait for 100 ns;
		clk <= '1';
		wait for 100 ns;
		clk <= '0';
		
		-- 284 * 60 = 17040 (0100 0010 1001 0000)
		X <= conv_std_logic_vector(284, 10);
		Y <= conv_std_logic_vector(60, 7);
		wait for 100 ns;
		clk <= '1';
		wait for 100 ns;
		clk <= '0';
		
		-- 339 * -31 = -10509 (1101 0110 1111 0011)
		X <= conv_std_logic_vector(339, 10);
		Y <= conv_std_logic_vector(-31, 7);
		wait for 100 ns;
		clk <= '1';
		wait for 100 ns;
		clk <= '0';
		wait for 100 ns;
		
		wait;

	end process;
	
end arch;