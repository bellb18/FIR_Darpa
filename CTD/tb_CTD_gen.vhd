Library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;
use work.ncl_signals.all;
use work.functions.all;
use ieee.math_real.all;
use std.textio.all;
use ieee.std_logic_textio.all;

entity tb_CTD_gen is
end;

architecture arch of tb_CTD_gen is
	signal X                            : DUAL_RAIL_LOGIC_VECTOR(10 downto 0);
	signal Z                            : DUAL_RAIL_LOGIC_VECTOR(10 downto 0);
	signal skip : std_logic_vector(3 downto 0);
	signal sleep, ki, ko, sleepout, rst : std_logic;

	component MTNCL_CTD is
	port(X        : in  dual_rail_logic_vector(10 downto 0);
		 skip     : in  std_logic_vector(3 downto 0);
		 ki       : in  std_logic;
		 sleep    : in  std_logic;
		 rst      : in  std_logic;
		 sleepOut : out std_logic;
		 ko       : out std_logic;
		 Z        : out dual_rail_logic_vector(10 downto 0));
	end component;
	
	type XarrayType is array (0 to 99) of integer;
	constant Xarray : XarrayType := (-36, -480, 486, 294, -49, -243, -162, -424, -58, -253, 283, -235, 501, 104, 352, -337, 474, -60, 84, -25, 140, -481, 211, 178, -289, 491, -386, 90, -511, -283, -41, 437, 107, -423, -118, -52, 510, -84, 329, -223, -244, 145, 369, -115, 486, 354, -218, -106, -185, -107, 92, -37, -62, -509, 395, -425, -509, 157, -466, 49, 508, -305, -205, -325, -153, -108, -286, 409, 420, 440, -263, 465, 281, -120, 416, -92, 380, 10, 365, 471, 382, 338, -164, 200, 298, -390, -324, 448, -422, -138, -482, 511, -457, 424, 89, -227, 210, -156, 320, -127);
	

begin
	CUT : MTNCL_CTD
		port map(X, skip, ki, sleep, rst, sleepout, ko, Z);

	inputs : process
		variable Xin : STD_LOGIC_VECTOR(10 downto 0);

	begin
		-- Set Constant Coefficients

		for i in 0 to 10 loop
			X(i).rail1 <= '0';
			X(i).rail0 <= '0';
		end loop;
		
		for i in 0 to 3 loop
			skip(i) <= '0';
		end loop;

		rst   <= '1';
		sleep <= '1';
		wait for 10 ns;
		rst <= '0';

		for i in 0 to 99 loop
			sleep <= '0';
			wait for 1 ns;
			
			if i = 25 then
				skip(0) <= '1';
			elsif i = 50 then
				skip(0) <= '0';
				skip(1) <= '1';
			elsif i = 75 then
				skip(1) <= '0';
				skip(3) <= '1';
			end if;

			X   <= Int_to_DR(Xarray(i), 11);
			Xin := std_logic_vector(to_signed(Xarray(i), 11));

			wait until ko = '0';
			sleep <= '1';
			wait for 1 ns;

			for i in 0 to 10 loop
				X(i).rail1 <= '0';
				X(i).rail0 <= '0';
			end loop;
			wait until ko = '1';
			wait for 1 ns;
		end loop;
		wait;

	end process;

	outputs : process(Z)
		variable Yout    : STD_LOGIC_VECTOR(10 downto 0);
	begin
		if is_data(Z) then
			ki   <= '0';
			Yout := to_SL(Z);
		end if;

		if is_null(Z) then
			ki <= '1';
		end if;
	end process;
end arch;