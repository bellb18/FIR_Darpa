Library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;
use ieee.std_logic_arith.all;
use work.ncl_signals.all;
use work.functions.all;

use ieee.math_real.all;

entity tb_Merged_Unpipelined is
end;

architecture arch of tb_Merged_Unpipelined is
	signal X, A : DUAL_RAIL_LOGIC_VECTOR(9 downto 0);
	signal Y, B : DUAL_RAIL_LOGIC_VECTOR(6 downto 0);
	signal P    : DUAL_RAIL_LOGIC_VECTOR(16 downto 0);
	signal s : std_logic;
	
	component Merged_Unpipelined is
		port(x     : in  dual_rail_logic_vector(9 downto 0);
			 y     : in  dual_rail_logic_vector(6 downto 0);
			 a     : in  dual_rail_logic_vector(9 downto 0);
			 b     : in  dual_rail_logic_vector(6 downto 0);
			 sleep : in  std_logic;
			 p     : out dual_rail_logic_vector(16 downto 0));
	end component;

begin
	CUT : Merged_Unpipelined
		port map(X, Y, A, B, s, P);

	inputs : process
		variable Xin, Ain       : STD_LOGIC_VECTOR(9 downto 0);
		variable Yin, Bin       : STD_LOGIC_VECTOR(6 downto 0);

	begin
		for i in 0 to 9 loop
			X(i).rail1 <= '0';
			X(i).rail0 <= '0';
			A(i).rail1 <= '0';
			A(i).rail0 <= '0';
		end loop;
		for i in 0 to 6 loop
			Y(i).rail1 <= '0';
			Y(i).rail0 <= '0';
			B(i).rail1 <= '0';
			B(i).rail0 <= '0';
		end loop;

		s <= '1';
		wait for 10 ns;
		
		-- (455 * -14) + (-193 * 45) = -15055
		s <= '0';
		wait for 1 ns;
		X   <= Int_to_DR(455, 10);
		Y   <= Int_to_DR(-14, 7);
		A   <= Int_to_DR(-193, 10);
		B   <= Int_to_DR(45, 7);
		Xin := conv_std_logic_vector(455, 10);
		Yin := conv_std_logic_vector(-14, 7);
		Ain := conv_std_logic_vector(-193, 10);
		Bin := conv_std_logic_vector(45, 7);
		wait until is_data(P);
		wait for 2 ns;
		s <= '1';
		wait for 2 ns;
		for i in 0 to 9 loop
			X(i).rail1 <= '0';
			X(i).rail0 <= '0';
			A(i).rail1 <= '0';
			A(i).rail0 <= '0';
		end loop;
		for i in 0 to 6 loop
			Y(i).rail1 <= '0';
			Y(i).rail0 <= '0';
			B(i).rail1 <= '0';
			B(i).rail0 <= '0';
		end loop;
		wait until is_null(P);
		
		-- (-233 * -5) + (-158 * 57) = -7841
		s <= '0';
		wait for 1 ns;
		X   <= Int_to_DR(-233, 10);
		Y   <= Int_to_DR(-5, 7);
		A   <= Int_to_DR(-158, 10);
		B   <= Int_to_DR(57, 7);
		Xin := conv_std_logic_vector(-233, 10);
		Yin := conv_std_logic_vector(-5, 7);
		Ain := conv_std_logic_vector(-158, 10);
		Bin := conv_std_logic_vector(57, 7);
		wait until is_data(P);
		wait for 2 ns;
		s <= '1';
		wait for 2 ns;
		for i in 0 to 9 loop
			X(i).rail1 <= '0';
			X(i).rail0 <= '0';
			A(i).rail1 <= '0';
			A(i).rail0 <= '0';
		end loop;
		for i in 0 to 6 loop
			Y(i).rail1 <= '0';
			Y(i).rail0 <= '0';
			B(i).rail1 <= '0';
			B(i).rail0 <= '0';
		end loop;
		wait until is_null(P);
		
		-- (-405 * -11) + (250 * 58) = 18955
		s <= '0';
		wait for 1 ns;
		X   <= Int_to_DR(-405, 10);
		Y   <= Int_to_DR(-11, 7);
		A   <= Int_to_DR(250, 10);
		B   <= Int_to_DR(58, 7);
		Xin := conv_std_logic_vector(-405, 10);
		Yin := conv_std_logic_vector(-11, 7);
		Ain := conv_std_logic_vector(250, 10);
		Bin := conv_std_logic_vector(58, 7);
		wait until is_data(P);
		wait for 2 ns;
		s <= '1';
		wait for 2 ns;
		for i in 0 to 9 loop
			X(i).rail1 <= '0';
			X(i).rail0 <= '0';
			A(i).rail1 <= '0';
			A(i).rail0 <= '0';
		end loop;
		for i in 0 to 6 loop
			Y(i).rail1 <= '0';
			Y(i).rail0 <= '0';
			B(i).rail1 <= '0';
			B(i).rail0 <= '0';
		end loop;
		wait until is_null(P);
		
		-- (-404 * 15) + (47 * 55) = -3475
		s <= '0';
		wait for 1 ns;
		X   <= Int_to_DR(-404, 10);
		Y   <= Int_to_DR(15, 7);
		A   <= Int_to_DR(47, 10);
		B   <= Int_to_DR(55, 7);
		Xin := conv_std_logic_vector(-404, 10);
		Yin := conv_std_logic_vector(15, 7);
		Ain := conv_std_logic_vector(47, 10);
		Bin := conv_std_logic_vector(55, 7);
		wait until is_data(P);
		wait for 2 ns;
		s <= '1';
		wait for 2 ns;
		for i in 0 to 9 loop
			X(i).rail1 <= '0';
			X(i).rail0 <= '0';
			A(i).rail1 <= '0';
			A(i).rail0 <= '0';
		end loop;
		for i in 0 to 6 loop
			Y(i).rail1 <= '0';
			Y(i).rail0 <= '0';
			B(i).rail1 <= '0';
			B(i).rail0 <= '0';
		end loop;
		wait until is_null(P);
		
		-- (300 * -62) + (-166 * 39) = -25074
		s <= '0';
		wait for 1 ns;
		X   <= Int_to_DR(300, 10);
		Y   <= Int_to_DR(-62, 7);
		A   <= Int_to_DR(-166, 10);
		B   <= Int_to_DR(39, 7);
		Xin := conv_std_logic_vector(300, 10);
		Yin := conv_std_logic_vector(-62, 7);
		Ain := conv_std_logic_vector(-166, 10);
		Bin := conv_std_logic_vector(39, 7);
		wait until is_data(P);
		wait for 2 ns;
		s <= '1';
		wait for 2 ns;
		for i in 0 to 9 loop
			X(i).rail1 <= '0';
			X(i).rail0 <= '0';
			A(i).rail1 <= '0';
			A(i).rail0 <= '0';
		end loop;
		for i in 0 to 6 loop
			Y(i).rail1 <= '0';
			Y(i).rail0 <= '0';
			B(i).rail1 <= '0';
			B(i).rail0 <= '0';
		end loop;
		wait until is_null(P);
		
		-- (405 * 55) + (445 * 29) = 35180
		s <= '0';
		wait for 1 ns;
		X   <= Int_to_DR(405, 10);
		Y   <= Int_to_DR(55, 7);
		A   <= Int_to_DR(445, 10);
		B   <= Int_to_DR(29, 7);
		Xin := conv_std_logic_vector(405, 10);
		Yin := conv_std_logic_vector(55, 7);
		Ain := conv_std_logic_vector(445, 10);
		Bin := conv_std_logic_vector(29, 7);
		wait until is_data(P);
		wait for 2 ns;
		s <= '1';
		wait for 2 ns;
		for i in 0 to 9 loop
			X(i).rail1 <= '0';
			X(i).rail0 <= '0';
			A(i).rail1 <= '0';
			A(i).rail0 <= '0';
		end loop;
		for i in 0 to 6 loop
			Y(i).rail1 <= '0';
			Y(i).rail0 <= '0';
			B(i).rail1 <= '0';
			B(i).rail0 <= '0';
		end loop;
		wait until is_null(P);
		
		-- (173 * 27) + (67 * -47) = 1522
		s <= '0';
		wait for 1 ns;
		X   <= Int_to_DR(173, 10);
		Y   <= Int_to_DR(27, 7);
		A   <= Int_to_DR(67, 10);
		B   <= Int_to_DR(-47, 7);
		Xin := conv_std_logic_vector(173, 10);
		Yin := conv_std_logic_vector(27, 7);
		Ain := conv_std_logic_vector(67, 10);
		Bin := conv_std_logic_vector(-47, 7);
		wait until is_data(P);
		wait for 2 ns;
		s <= '1';
		wait for 2 ns;
		for i in 0 to 9 loop
			X(i).rail1 <= '0';
			X(i).rail0 <= '0';
			A(i).rail1 <= '0';
			A(i).rail0 <= '0';
		end loop;
		for i in 0 to 6 loop
			Y(i).rail1 <= '0';
			Y(i).rail0 <= '0';
			B(i).rail1 <= '0';
			B(i).rail0 <= '0';
		end loop;
		wait until is_null(P);
		
		-- (-473 * 48) + (411 * -16) = -29280
		s <= '0';
		wait for 1 ns;
		X   <= Int_to_DR(-473, 10);
		Y   <= Int_to_DR(48, 7);
		A   <= Int_to_DR(411, 10);
		B   <= Int_to_DR(-16, 7);
		Xin := conv_std_logic_vector(-473, 10);
		Yin := conv_std_logic_vector(48, 7);
		Ain := conv_std_logic_vector(411, 10);
		Bin := conv_std_logic_vector(-16, 7);
		wait until is_data(P);
		wait for 2 ns;
		s <= '1';
		wait for 2 ns;
		for i in 0 to 9 loop
			X(i).rail1 <= '0';
			X(i).rail0 <= '0';
			A(i).rail1 <= '0';
			A(i).rail0 <= '0';
		end loop;
		for i in 0 to 6 loop
			Y(i).rail1 <= '0';
			Y(i).rail0 <= '0';
			B(i).rail1 <= '0';
			B(i).rail0 <= '0';
		end loop;
		wait until is_null(P);
		
		-- (156 * 27) + (98 * 61) = 10190
		s <= '0';
		wait for 1 ns;
		X   <= Int_to_DR(156, 10);
		Y   <= Int_to_DR(27, 7);
		A   <= Int_to_DR(98, 10);
		B   <= Int_to_DR(61, 7);
		Xin := conv_std_logic_vector(156, 10);
		Yin := conv_std_logic_vector(27, 7);
		Ain := conv_std_logic_vector(98, 10);
		Bin := conv_std_logic_vector(61, 7);
		wait until is_data(P);
		wait for 2 ns;
		s <= '1';
		wait for 2 ns;
		for i in 0 to 9 loop
			X(i).rail1 <= '0';
			X(i).rail0 <= '0';
			A(i).rail1 <= '0';
			A(i).rail0 <= '0';
		end loop;
		for i in 0 to 6 loop
			Y(i).rail1 <= '0';
			Y(i).rail0 <= '0';
			B(i).rail1 <= '0';
			B(i).rail0 <= '0';
		end loop;
		wait until is_null(P);
		
		-- (126 * -32) + (331 * 41) = 9539
		s <= '0';
		wait for 1 ns;
		X   <= Int_to_DR(126, 10);
		Y   <= Int_to_DR(-32, 7);
		A   <= Int_to_DR(331, 10);
		B   <= Int_to_DR(41, 7);
		Xin := conv_std_logic_vector(126, 10);
		Yin := conv_std_logic_vector(-32, 7);
		Ain := conv_std_logic_vector(331, 10);
		Bin := conv_std_logic_vector(41, 7);
		wait until is_data(P);
		wait for 2 ns;
		s <= '1';
		wait for 2 ns;
		for i in 0 to 9 loop
			X(i).rail1 <= '0';
			X(i).rail0 <= '0';
			A(i).rail1 <= '0';
			A(i).rail0 <= '0';
		end loop;
		for i in 0 to 6 loop
			Y(i).rail1 <= '0';
			Y(i).rail0 <= '0';
			B(i).rail1 <= '0';
			B(i).rail0 <= '0';
		end loop;
		wait until is_null(P);

		for i in 0 to 9 loop
			X(i).rail1 <= '1';
			X(i).rail0 <= '0';
			A(i).rail1 <= '1';
			A(i).rail0 <= '0';
		end loop;
		for i in 0 to 6 loop
			Y(i).rail1 <= '1';
			Y(i).rail0 <= '0';
			B(i).rail1 <= '1';
			B(i).rail0 <= '0';
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