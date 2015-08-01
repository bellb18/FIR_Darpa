Library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;
use work.Sync_gates.all;
use ieee.math_real.all;
use std.textio.all;
use ieee.std_logic_textio.all;

entity tb_FIR_Timing_Synchronous is
end;

architecture arch of tb_FIR_Timing_Synchronous is
	signal X                            : std_LOGIC_VECTOR(9 downto 0);
	signal C                            : CTypeSync;
	signal Y                            : std_LOGIC_VECTOR(10 downto 0);
	signal clk, rst : std_logic;

	component FIR_Liang_Sync is
	port(x                                                                                                                    : in  std_logic_vector(9 downto 0);
		 cin_0, cin_1, cin_2, cin_3, cin_4, cin_5, cin_6, cin_7, cin_8, cin_9, cin_10, cin_11, cin_12, cin_13, cin_14, cin_15 : in  std_logic_vector(6 downto 0);
		 clk                                                                                                                  : in  std_logic;
		 rst                                                                                                                  : in  std_logic;
		 y                                                                                                                    : out std_logic_vector(10 downto 0));
	end component;

begin
	CUT : FIR_Liang_Sync
		port map(X, C(0), C(1), C(2), C(3), C(4), C(5), C(6), C(7), C(8), C(9), C(10), C(11), C(12), C(13), C(14), C(15), clk, rst, Y);

	inputs : process

	begin
		-- Set Constant Coefficients
		C(0)  <= std_logic_vector(to_signed(0, 7));
		C(1)  <= std_logic_vector(to_signed(0, 7));
		C(2)  <= std_logic_vector(to_signed(1, 7));
		C(3)  <= std_logic_vector(to_signed(-2, 7));
		C(4)  <= std_logic_vector(to_signed(2, 7));
		C(5)  <= std_logic_vector(to_signed(0, 7));
		C(6)  <= std_logic_vector(to_signed(-7, 7));
		C(7)  <= std_logic_vector(to_signed(38, 7));
		C(8)  <= std_logic_vector(to_signed(38, 7));
		C(9)  <= std_logic_vector(to_signed(-7, 7));
		C(10) <= std_logic_vector(to_signed(0, 7));
		C(11) <= std_logic_vector(to_signed(2, 7));
		C(12) <= std_logic_vector(to_signed(-2, 7));
		C(13) <= std_logic_vector(to_signed(1, 7));
		C(14) <= std_logic_vector(to_signed(0, 7));
		C(15) <= std_logic_vector(to_signed(0, 7));

		for i in 0 to 9 loop
			X(i) <= '0';
		end loop;

		rst   <= '1';
		clk <= '0';
		wait for 2 ns;
		clk <= '1';
		wait for 10 ns;
		clk <= '0';
		rst <= '0';
		wait for 10 ns;

		for i in 0 to 99 loop
			clk <= '0';
			X <= std_logic_vector(to_signed(Xarray(i), 10));
			wait for 1322 ps;
			clk <= '1';
			wait for 1322 ps;
		end loop;
		wait;

	end process;
end arch;