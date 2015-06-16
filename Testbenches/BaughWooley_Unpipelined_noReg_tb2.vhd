Library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;
use work.ncl_signals.all;
use work.functions.all;
use ieee.math_real.all;
use ieee.std_logic_arith.all;


entity tb2_BaughWooley_Unpipelined_noReg is
end;

architecture arch of tb2_BaughWooley_Unpipelined_noReg is
	signal X : DUAL_RAIL_LOGIC_VECTOR(9 downto 0);
	signal Y : DUAL_RAIL_LOGIC_VECTOR(6 downto 0);
	signal P    : DUAL_RAIL_LOGIC_VECTOR(15 downto 0);
	signal s : std_logic;
	
	component BaughWooleyMult is
    port(x     : in  dual_rail_logic_vector(9 downto 0);
         y     : in  dual_rail_logic_vector(6 downto 0);
         sleep : in  std_logic;
         p     : out dual_rail_logic_vector(15 downto 0));
	end component;

begin
	CUT : BaughWooleyMult
		port map(X, Y, s, P);

	inputs : process
		variable Xin       : STD_LOGIC_VECTOR(9 downto 0);
		variable Yin       : STD_LOGIC_VECTOR(6 downto 0);

	begin
		for i in 0 to 9 loop
			X(i).rail1 <= '0';
			X(i).rail0 <= '0';
		end loop;
		for i in 0 to 6 loop
			Y(i).rail1 <= '0';
			Y(i).rail0 <= '0';
		end loop;

		s <= '1';
		wait for 10 ns;
		
		-- 101 * -50 = -5050 (1110 1100 0100 0110)
		s <= '0';
		wait for 1 ns;
		X   <= Int_to_DR(101, 10);
		Y   <= Int_to_DR(-50, 7);
		Xin := conv_std_logic_vector(101, 10);
		Yin := conv_std_logic_vector(-50, 7);
		wait until is_data(P);
		wait for 2 ns;
		s <= '1';
		wait for 2 ns;
		for i in 0 to 9 loop
			X(i).rail1 <= '0';
			X(i).rail0 <= '0';
		end loop;
		for i in 0 to 6 loop
			Y(i).rail1 <= '0';
			Y(i).rail0 <= '0';
		end loop;
		wait until is_null(P);
		
		-- -281 * 51 = -14331 (1100 10000 0000 0101)
		s <= '0';
		wait for 1 ns;
		X   <= Int_to_DR(-281, 10);
		Y   <= Int_to_DR(51, 7);
		Xin := conv_std_logic_vector(-281, 10);
		Yin := conv_std_logic_vector(51, 7);
		wait until is_data(P);
		wait for 2 ns;
		s <= '1';
		wait for 2 ns;
		for i in 0 to 9 loop
			X(i).rail1 <= '0';
			X(i).rail0 <= '0';
		end loop;
		for i in 0 to 6 loop
			Y(i).rail1 <= '0';
			Y(i).rail0 <= '0';
		end loop;
		wait until is_null(P);
		
		-- -372 * 31 = -11532 (1101 0010 1111 0100)
		s <= '0';
		wait for 1 ns;
		X   <= Int_to_DR(-372, 10);
		Y   <= Int_to_DR(31, 7);
		Xin := conv_std_logic_vector(-372, 10);
		Yin := conv_std_logic_vector(31, 7);
		wait until is_data(P);
		wait for 2 ns;
		s <= '1';
		wait for 2 ns;
		for i in 0 to 9 loop
			X(i).rail1 <= '0';
			X(i).rail0 <= '0';
		end loop;
		for i in 0 to 6 loop
			Y(i).rail1 <= '0';
			Y(i).rail0 <= '0';
		end loop;
		wait until is_null(P);
		
		-- 383 * 55 = 21065 (0101 0010 0100 1001)
		s <= '0';
		wait for 1 ns;
		X   <= Int_to_DR(383, 10);
		Y   <= Int_to_DR(55, 7);
		Xin := conv_std_logic_vector(383, 10);
		Yin := conv_std_logic_vector(55, 7);
		wait until is_data(P);
		wait for 2 ns;
		s <= '1';
		wait for 2 ns;
		for i in 0 to 9 loop
			X(i).rail1 <= '0';
			X(i).rail0 <= '0';
		end loop;
		for i in 0 to 6 loop
			Y(i).rail1 <= '0';
			Y(i).rail0 <= '0';
		end loop;
		wait until is_null(P);
		
		--423 * 60 = 25380 (0110 0011 0010 0100)
		s <= '0';
		wait for 1 ns;
		X   <= Int_to_DR(428, 10);
		Y   <= Int_to_DR(60, 7);
		Xin := conv_std_logic_vector(428, 10);
		Yin := conv_std_logic_vector(60, 7);
		wait until is_data(P);
		wait for 2 ns;
		s <= '1';
		wait for 2 ns;
		for i in 0 to 9 loop
			X(i).rail1 <= '0';
			X(i).rail0 <= '0';
		end loop;
		for i in 0 to 6 loop
			Y(i).rail1 <= '0';
			Y(i).rail0 <= '0';
		end loop;
		wait until is_null(P);
		
		-- -438 * 52 = -22776 (1010 0111 0000 1000)
		s <= '0';
		wait for 1 ns;
		X   <= Int_to_DR(-438, 10);
		Y   <= Int_to_DR(52, 7);
		Xin := conv_std_logic_vector(-438, 10);
		Yin := conv_std_logic_vector(52, 7);
		wait until is_data(P);
		wait for 2 ns;
		s <= '1';
		wait for 2 ns;
		for i in 0 to 9 loop
			X(i).rail1 <= '0';
			X(i).rail0 <= '0';
		end loop;
		for i in 0 to 6 loop
			Y(i).rail1 <= '0';
			Y(i).rail0 <= '0';
		end loop;
		wait until is_null(P);
		
		-- 96 * 64 = 6144 (0001 1000 0000 0000)
		s <= '0';
		wait for 1 ns;
		X   <= Int_to_DR(96, 10);
		Y   <= Int_to_DR(64, 7);
		Xin := conv_std_logic_vector(96, 10);
		Yin := conv_std_logic_vector(64, 7);
		wait until is_data(P);
		wait for 2 ns;
		s <= '1';
		wait for 2 ns;
		for i in 0 to 9 loop
			X(i).rail1 <= '0';
			X(i).rail0 <= '0';
		end loop;
		for i in 0 to 6 loop
			Y(i).rail1 <= '0';
			Y(i).rail0 <= '0';
		end loop;
		wait until is_null(P);
		
		-- 227 * 31 = 7037 (0001 1011 0111 1101)
		s <= '0';
		wait for 1 ns;
		X   <= Int_to_DR(227, 10);
		Y   <= Int_to_DR(31, 7);
		Xin := conv_std_logic_vector(227, 10);
		Yin := conv_std_logic_vector(31, 7);
		wait until is_data(P);
		wait for 2 ns;
		s <= '1';
		wait for 2 ns;
		for i in 0 to 9 loop
			X(i).rail1 <= '0';
			X(i).rail0 <= '0';
		end loop;
		for i in 0 to 6 loop
			Y(i).rail1 <= '0';
			Y(i).rail0 <= '0';
		end loop;
		wait until is_null(P);
		
		-- 284 * 60 = 17040 (0100 0010 1001 0000)
		s <= '0';
		wait for 1 ns;
		X   <= Int_to_DR(284, 10);
		Y   <= Int_to_DR(60, 7);
		Xin := conv_std_logic_vector(284, 10);
		Yin := conv_std_logic_vector(60, 7);
		wait until is_data(P);
		wait for 2 ns;
		s <= '1';
		wait for 2 ns;
		for i in 0 to 9 loop
			X(i).rail1 <= '0';
			X(i).rail0 <= '0';
		end loop;
		for i in 0 to 6 loop
			Y(i).rail1 <= '0';
			Y(i).rail0 <= '0';
		end loop;
		wait until is_null(P);
		
		-- 339 * -31 = -10509 (0010 1001 0000 1101)
		s <= '0';
		wait for 1 ns;
		X   <= Int_to_DR(339, 10);
		Y   <= Int_to_DR(-31, 7);
		Xin := conv_std_logic_vector(339, 10);
		Yin := conv_std_logic_vector(-31, 7);
		wait until is_data(P);
		wait for 2 ns;
		s <= '1';
		wait for 2 ns;
		for i in 0 to 9 loop
			X(i).rail1 <= '0';
			X(i).rail0 <= '0';
		end loop;
		for i in 0 to 6 loop
			Y(i).rail1 <= '0';
			Y(i).rail0 <= '0';
		end loop;
		wait until is_null(P);
		
		
		-- Go to all 1's at the end
		for i in 0 to 9 loop
			X(i).rail1 <= '1';
			X(i).rail0 <= '0';
		end loop;
		for i in 0 to 6 loop
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