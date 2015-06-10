Library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;
use ieee.std_logic_arith.all;
use work.ncl_signals.all;
use work.functions.all;

use ieee.math_real.all;

entity tb_Dadda_Unpipelined_noReg is
end;

architecture arch of tb_Dadda_Unpipelined_noReg is
	signal X : DUAL_RAIL_LOGIC_VECTOR(10 downto 0);
	signal Y : DUAL_RAIL_LOGIC_VECTOR(5 downto 0);
	signal P    : DUAL_RAIL_LOGIC_VECTOR(16 downto 0);
	signal s : std_logic;
	
	component Dadda_Unpipelined is
    port(x     : in  dual_rail_logic_vector(10 downto 0);
         y     : in  dual_rail_logic_vector(5 downto 0);
         sleep : in  std_logic;
         p     : out dual_rail_logic_vector(16 downto 0));
	end component;

begin
	CUT : Dadda_Unpipelined
		port map(X, Y, s, P);

	inputs : process
		variable Xin       : STD_LOGIC_VECTOR(7 downto 0);
		variable Yin       : STD_LOGIC_VECTOR(7 downto 0);

	begin
		for i in 0 to 10 loop
			X(i).rail1 <= '0';
			X(i).rail0 <= '0';
		end loop;
		for i in 0 to 5 loop
			Y(i).rail1 <= '0';
			Y(i).rail0 <= '0';
		end loop;

		s <= '1';
		wait for 50 ns;

		for j in 0 to 63 loop
			for i in 0 to 2047 loop
				s <= '0';
				wait for 10 ns;

				X   <= Int_to_DR(i, 8);
				Y   <= Int_to_DR(j, 8);
				Xin := conv_std_logic_vector(i, 8);
				Yin := conv_std_logic_vector(j, 8);

				wait for 50 ns;
				s <= '1';
				wait for 10 ns;
				
				for i in 0 to 10 loop
					X(i).rail1 <= '0';
					X(i).rail0 <= '0';
				end loop;
				for i in 0 to 5 loop
					Y(i).rail1 <= '0';
					Y(i).rail0 <= '0';
				end loop;
				wait for 10 ns;

			end loop;
		end loop;

		for i in 0 to 10 loop
			X(i).rail1 <= '1';
			X(i).rail0 <= '0';
		end loop;
		for i in 0 to 5 loop
			Y(i).rail1 <= '1';
			Y(i).rail0 <= '0';
		end loop;
		wait;

	end process;

	outputs : process(P)
		variable Pout : STD_LOGIC_VECTOR(16 downto 0);

	begin
		if is_data(P) then
			Pout := to_SL(P);
		end if;

	end process;
	
end arch;