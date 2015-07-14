Library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;
use work.ncl_signals.all;
use work.functions.all;
use work.FIR_pack.all;
use ieee.math_real.all;
use std.textio.all;
use ieee.std_logic_textio.all;

entity tb_State_Machine is
end;

architecture arch of tb_State_Machine is
	
	signal ki, rst, s1, s2, s3, ko                    : std_logic;

	component FastShiftReg_StateMachine is
	port(ki, rst   : in  std_logic;
		 ko, s1, s2, s3 : out std_logic);
	end component;

begin
	CUT : FastShiftReg_StateMachine
		port map(ki, rst, ko, s1, s2, s3);

	inputs : process

	begin
		-- Set Constant Coefficients
		ki <= '1';
		rst <= '1';
		wait for 100 ns;
		rst <= '0';
		wait for 100 ns;
		ki <= '0';
		wait for 100 ns;
		ki <= '1';
		wait for 100 ns;
		rst <= '1';
		wait for 100 ns;
		rst <= '0';
		wait;
	end process;
end arch;