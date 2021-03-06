Library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;
use work.ncl_signals.all;
use work.functions.all;
use work.FIR_pack.all;
use ieee.math_real.all;
use std.textio.all;
use ieee.std_logic_textio.all;

entity tb_FIR_Timing is
end;

architecture arch of tb_FIR_Timing is
	signal X                            : DUAL_RAIL_LOGIC_VECTOR(9 downto 0);
	signal C                            : CType;
	signal Y                            : DUAL_RAIL_LOGIC_VECTOR(10 downto 0);
	signal sleep, ki, ko, sleepout, rst : std_logic;

	component FIR_Liang_Pipelined_Dadda8 is
		port(X        : in  dual_rail_logic_vector(9 downto 0);
			 C        : in  CType;
			 ki       : in  std_logic;
			 rst      : in  std_logic;
			 sleep    : in  std_logic;
			 ko       : out std_logic;
			 sleepout : out std_logic;
			 Y        : out dual_rail_logic_vector(10 downto 0));
	end component;

begin
	CUT : FIR_Liang_Pipelined_Dadda8
		port map(X, C, ki, rst, sleep, ko, sleepout, Y);

	inputs : process
		variable Xin : STD_LOGIC_VECTOR(9 downto 0);
		variable Cin : CSLtype;

	begin
		-- Set Constant Coefficients
		C(0)    <= Int_to_DR(0, 7);
		Cin(0)  := std_logic_vector(to_signed(0, 7));
		C(1)    <= Int_to_DR(0, 7);
		Cin(1)  := std_logic_vector(to_signed(0, 7));
		C(2)    <= Int_to_DR(1, 7);
		Cin(2)  := std_logic_vector(to_signed(1, 7));
		C(3)    <= Int_to_DR(-2, 7);
		Cin(3)  := std_logic_vector(to_signed(-2, 7));
		C(4)    <= Int_to_DR(2, 7);
		Cin(4)  := std_logic_vector(to_signed(2, 7));
		C(5)    <= Int_to_DR(0, 7);
		Cin(5)  := std_logic_vector(to_signed(0, 7));
		C(6)    <= Int_to_DR(-7, 7);
		Cin(6)  := std_logic_vector(to_signed(-7, 7));
		C(7)    <= Int_to_DR(38, 7);
		Cin(7)  := std_logic_vector(to_signed(38, 7));
		C(8)    <= Int_to_DR(38, 7);
		Cin(8)  := std_logic_vector(to_signed(38, 7));
		C(9)    <= Int_to_DR(-7, 7);
		Cin(9)  := std_logic_vector(to_signed(-7, 7));
		C(10)   <= Int_to_DR(0, 7);
		Cin(10) := std_logic_vector(to_signed(0, 7));
		C(11)   <= Int_to_DR(2, 7);
		Cin(11) := std_logic_vector(to_signed(2, 7));
		C(12)   <= Int_to_DR(-2, 7);
		Cin(12) := std_logic_vector(to_signed(-2, 7));
		C(13)   <= Int_to_DR(1, 7);
		Cin(13) := std_logic_vector(to_signed(1, 7));
		C(14)   <= Int_to_DR(0, 7);
		Cin(14) := std_logic_vector(to_signed(0, 7));
		C(15)   <= Int_to_DR(0, 7);
		Cin(15) := std_logic_vector(to_signed(0, 7));

		for i in 0 to 9 loop
			X(i).rail1 <= '0';
			X(i).rail0 <= '0';
		end loop;

		rst   <= '1';
		sleep <= '1';
		wait for 10 ns;
		rst <= '0';

		for i in 0 to 99 loop
			sleep <= '0';
			wait for 1 ns;

			X   <= Int_to_DR(Xarray(i), 10);
			Xin := std_logic_vector(to_signed(Xarray(i), 10));

			wait until ko = '0';
			sleep <= '1';
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

	outputs : process(Y)
		variable Yout    : STD_LOGIC_VECTOR(10 downto 0);
		variable Correct : integer := 0;
		variable j       : integer := 0;
		variable s       : line;
	begin
		if is_data(Y) then
			ki   <= '0';
			Yout := to_SL(Y);
			if j >= 15 then
				Correct := ((Xarray(j) + Xarray(j - 15)) * 0 + (Xarray(j - 1) + Xarray(j - 14)) * 0 + (Xarray(j - 2) + Xarray(j - 13)) * 1 - 2 * (Xarray(j - 3) + Xarray(j - 12)) + (Xarray(j - 4) + Xarray(j - 11)) * 2 + (Xarray(j - 5) + Xarray(j - 10)) * 0 - 7 * (Xarray(j
								- 6) + Xarray(j - 9)) + (Xarray(j - 7) + Xarray(j - 8)) * 38) / 32;
				if (abs (Correct - to_integer(signed(Yout))) >= 2) then
					write(s, string'("Error: "));
					write(s, std_logic_vector'(Yout));
					write(s, string'(" /= "));
					write(s, integer'(Correct));
					writeline(OUTPUT, s);
				end if;
			end if;
			j := j + 1;
		end if;

		if is_null(Y) then
			ki <= '1';
		end if;
	end process;
end arch;