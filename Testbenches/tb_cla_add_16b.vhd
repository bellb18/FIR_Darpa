Library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;
use ieee.std_logic_arith.all;
use work.ncl_signals.all;
use work.functions.all;

use ieee.math_real.all;

entity tb_CLA_add_16m is
end;

architecture arch of tb_CLA_add_16m is
	signal X, Y : DUAL_RAIL_LOGIC_VECTOR(15 downto 0);
	signal P    : DUAL_RAIL_LOGIC_VECTOR(15 downto 0);

	signal sleep : std_logic;

	component RCA_genm is
	generic(width : integer := 16);
	port(
		X    : in  dual_rail_logic_vector(width - 1 downto 0);
		Y    : in  dual_rail_logic_vector(width - 1 downto 0);
		sleep : in  std_logic;
		S   : out dual_rail_logic_vector(width - 1 downto 0)
	);
	end component;

begin
	DUT : RCA_genm
		generic map(16)
		port map(X, Y, sleep, P);

	inputs : process
		variable Xin       : STD_LOGIC_VECTOR(15 downto 0);
		variable Yin       : STD_LOGIC_VECTOR(15 downto 0);

	begin
		for i in 0 to 15 loop
			X(i).rail1 <= '0';
			X(i).rail0 <= '0';
			Y(i).rail1 <= '0';
			Y(i).rail0 <= '0';
		end loop;

		sleep <= '1';
		wait for 40 ns;

		-- -16847
		sleep <= '0';
		wait for 1 ns;
		X   <= Int_to_DR(1341, 16);
		Y   <= Int_to_DR(-18188, 16);
		Xin := conv_std_logic_vector(1341, 16);
		Yin := conv_std_logic_vector(-18188, 16);
		wait until is_data(P);
		wait for 2 ns;
		sleep <= '1';
		wait for 2 ns;
		for i in 0 to 15 loop
			X(i).rail1 <= '0';
			X(i).rail0 <= '0';
		end loop;
		for i in 0 to 15 loop
			Y(i).rail1 <= '0';
			Y(i).rail0 <= '0';
		end loop;
		wait until is_null(P);
		
		-- -14191
		sleep <= '0';
		wait for 1 ns;
		X   <= Int_to_DR(-24633, 16);
		Y   <= Int_to_DR(10442, 16);
		Xin := conv_std_logic_vector(-24633, 16);
		Yin := conv_std_logic_vector(10442, 16);
		wait until is_data(P);
		wait for 2 ns;
		sleep <= '1';
		wait for 2 ns;
		for i in 0 to 15 loop
			X(i).rail1 <= '0';
			X(i).rail0 <= '0';
		end loop;
		for i in 0 to 15 loop
			Y(i).rail1 <= '0';
			Y(i).rail0 <= '0';
		end loop;
		wait until is_null(P);
		
		-- 20123
		sleep <= '0';
		wait for 1 ns;
		X   <= Int_to_DR(8370, 16);
		Y   <= Int_to_DR(11753, 16);
		Xin := conv_std_logic_vector(8370, 16);
		Yin := conv_std_logic_vector(11753, 16);
		wait until is_data(P);
		wait for 2 ns;
		sleep <= '1';
		wait for 2 ns;
		for i in 0 to 15 loop
			X(i).rail1 <= '0';
			X(i).rail0 <= '0';
		end loop;
		for i in 0 to 15 loop
			Y(i).rail1 <= '0';
			Y(i).rail0 <= '0';
		end loop;
		wait until is_null(P);
		
		-- 43242
		sleep <= '0';
		wait for 1 ns;
		X   <= Int_to_DR(32297, 16);
		Y   <= Int_to_DR(10945, 16);
		Xin := conv_std_logic_vector(32297, 16);
		Yin := conv_std_logic_vector(10945, 16);
		wait until is_data(P);
		wait for 2 ns;
		sleep <= '1';
		wait for 2 ns;
		for i in 0 to 15 loop
			X(i).rail1 <= '0';
			X(i).rail0 <= '0';
		end loop;
		for i in 0 to 15 loop
			Y(i).rail1 <= '0';
			Y(i).rail0 <= '0';
		end loop;
		wait until is_null(P);
		
		-- 24395
		sleep <= '0';
		wait for 1 ns;
		X   <= Int_to_DR(26891, 16);
		Y   <= Int_to_DR(-2496, 16);
		Xin := conv_std_logic_vector(26891, 16);
		Yin := conv_std_logic_vector(-2496, 16);
		wait until is_data(P);
		wait for 2 ns;
		sleep <= '1';
		wait for 2 ns;
		for i in 0 to 15 loop
			X(i).rail1 <= '0';
			X(i).rail0 <= '0';
		end loop;
		for i in 0 to 15 loop
			Y(i).rail1 <= '0';
			Y(i).rail0 <= '0';
		end loop;
		wait until is_null(P);
		
		-- 38389
		sleep <= '0';
		wait for 1 ns;
		X   <= Int_to_DR(26712, 16);
		Y   <= Int_to_DR(11677, 16);
		Xin := conv_std_logic_vector(26712, 16);
		Yin := conv_std_logic_vector(11677, 16);
		wait until is_data(P);
		wait for 2 ns;
		sleep <= '1';
		wait for 2 ns;
		for i in 0 to 15 loop
			X(i).rail1 <= '0';
			X(i).rail0 <= '0';
		end loop;
		for i in 0 to 15 loop
			Y(i).rail1 <= '0';
			Y(i).rail0 <= '0';
		end loop;
		wait until is_null(P);
		
		-- 16890
		sleep <= '0';
		wait for 1 ns;
		X   <= Int_to_DR(-14869, 16);
		Y   <= Int_to_DR(31759, 16);
		Xin := conv_std_logic_vector(-14869, 16);
		Yin := conv_std_logic_vector(31759, 16);
		wait until is_data(P);
		wait for 2 ns;
		sleep <= '1';
		wait for 2 ns;
		for i in 0 to 15 loop
			X(i).rail1 <= '0';
			X(i).rail0 <= '0';
		end loop;
		for i in 0 to 15 loop
			Y(i).rail1 <= '0';
			Y(i).rail0 <= '0';
		end loop;
		wait until is_null(P);
		
		-- -28
		sleep <= '0';
		wait for 1 ns;
		X   <= Int_to_DR(-4905, 16);
		Y   <= Int_to_DR(4877, 16);
		Xin := conv_std_logic_vector(-4905, 16);
		Yin := conv_std_logic_vector(4877, 16);
		wait until is_data(P);
		wait for 2 ns;
		sleep <= '1';
		wait for 2 ns;
		for i in 0 to 15 loop
			X(i).rail1 <= '0';
			X(i).rail0 <= '0';
		end loop;
		for i in 0 to 15 loop
			Y(i).rail1 <= '0';
			Y(i).rail0 <= '0';
		end loop;
		wait until is_null(P);
		
		-- -20731
		sleep <= '0';
		wait for 1 ns;
		X   <= Int_to_DR(2827, 16);
		Y   <= Int_to_DR(-23558, 16);
		Xin := conv_std_logic_vector(2827, 16);
		Yin := conv_std_logic_vector(-23558, 16);
		wait until is_data(P);
		wait for 2 ns;
		sleep <= '1';
		wait for 2 ns;
		for i in 0 to 15 loop
			X(i).rail1 <= '0';
			X(i).rail0 <= '0';
		end loop;
		for i in 0 to 15 loop
			Y(i).rail1 <= '0';
			Y(i).rail0 <= '0';
		end loop;
		wait until is_null(P);
		
		-- -3662
		sleep <= '0';
		wait for 1 ns;
		X   <= Int_to_DR(-2435, 16);
		Y   <= Int_to_DR(-1227, 16);
		Xin := conv_std_logic_vector(-2435, 16);
		Yin := conv_std_logic_vector(-1227, 16);
		wait until is_data(P);
		wait for 2 ns;
		sleep <= '1';
		wait for 2 ns;
		for i in 0 to 15 loop
			X(i).rail1 <= '0';
			X(i).rail0 <= '0';
		end loop;
		for i in 0 to 15 loop
			Y(i).rail1 <= '0';
			Y(i).rail0 <= '0';
		end loop;
		wait until is_null(P);
		
		
		-- Go to all 1's at the end
		for i in 0 to 15 loop
			X(i).rail1 <= '1';
			X(i).rail0 <= '0';
		end loop;
		for i in 0 to 15 loop
			Y(i).rail1 <= '1';
			Y(i).rail0 <= '0';
		end loop;
		wait;

	end process;
	
	outputs : process(P)
		variable Pout : STD_LOGIC_VECTOR(15 downto 0);

	begin
		if is_data(P) then
			Pout := to_SL(P);
		end if;

	end process;
	
end arch;