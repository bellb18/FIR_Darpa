Library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;
use work.ncl_signals.all;
use work.functions.all;
use work.FIR_pack.all;
use ieee.math_real.all;
use std.textio.all;
use ieee.std_logic_textio.all;

entity tb_Shift_Reg is
end;

architecture arch of tb_Shift_Reg is
	
	signal X, Y : dual_rail_logic_vector(9 downto 0);
	signal ki, rst, sleepin, sleepout, ko                    : std_logic;

component FastShiftReg is
	port(X   : in  dual_rail_logic_vector(9 downto 0);
		 ki       : in  std_logic;
		 rst      : in  std_logic;
		 Y  : out dual_rail_logic_vector(9 downto 0);
		 sleepout : out std_logic;
		 ko       : out std_logic);
end component;

begin
	CUT : FastShiftReg
		port map(X, ki, rst, Y, sleepout, ko);

	inputs : process

	begin
		-- Set Constant Coefficients
		for i in 0 to 9 loop
			X(i).rail0 <= '0';
			X(i).rail1 <= '0';
		end loop;
		
		
		rst   <= '1';
		sleepin <= '1';
		wait for 10 ns;
		rst <= '0';

		for i in 0 to 99 loop
			sleepin <= '0';
			wait for 1 ns;

			X   <= Int_to_DR(Xarray(i), 10);

			wait until ko = '0';
			sleepin <= '1';
			wait for 1 ns;

			for i in 0 to 9 loop
				X(i).rail1 <= '0';
				X(i).rail0 <= '0';
			end loop;
			wait until ko = '1';
			wait for 1 ns;
		end loop;
		wait;
	end process;
	
	
	outputs : process(X, Y)
		variable temp : dual_rail_logic_vector(19 downto 0);
	begin
		temp := X & Y;
		if is_data(Y) then
			ki   <= '0';
		end if;
		if is_null(Y) then
			ki <= '1';
		end if;
	end process;
end arch;