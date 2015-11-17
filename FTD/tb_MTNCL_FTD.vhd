Library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;
use work.Sync_gates.all;
use work.FIR_Pack.all;
use ieee.math_real.all;
use std.textio.all;
use ieee.std_logic_textio.all;
use work.ncl_signals.all;
use work.functions.all;

entity tb_MTNCL_FTD is
end;

architecture arch of tb_MTNCL_FTD is
	signal X                            : std_LOGIC_VECTOR(9 downto 0);
	signal C                            : CType;
	signal Y                            : std_LOGIC_VECTOR(10 downto 0);
	signal clk, rst					    : std_logic;

	component MTNCL_FTD is
		port(x        : in  std_logic_vector(9 downto 0);
			 c        : in  CType;
			 clk       : in  std_logic;
			 rst      : in  std_logic;
			 y        : out std_logic_vector(10 downto 0));
	end component;

begin
	CUT : MTNCL_FTD
		port map(X, C, clk, rst, Y);

	inputs : process
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
			wait for 32 ns;
			clk <= '1';
			wait for 32 ns;
		end loop;
		wait;

	end process;
	
	outputs : process(Y)
		variable Correct : integer := 0;
		variable j       : integer := 0;
		variable s       : line;
	begin
		if j >= 15 then
			Correct := ((Xarray(j) + Xarray(j - 15)) * 0 + (Xarray(j - 1) + Xarray(j - 14)) * 0 + (Xarray(j - 2) + Xarray(j - 13)) * 1 - 2 * (Xarray(j - 3) + Xarray(j - 12)) + (Xarray(j - 4) + Xarray(j - 11)) * 2 + (Xarray(j - 5) + Xarray(j - 10)) * 0 - 7 * (Xarray(j
							- 6) + Xarray(j - 9)) + (Xarray(j - 7) + Xarray(j - 8)) * 38) / 32;
			if (abs (Correct - to_integer(signed(Y))) >= 2) then
				write(s, string'("Error: "));
				write(s, std_logic_vector'(Y));
				write(s, string'(" /= "));
				write(s, integer'(Correct));
				writeline(OUTPUT, s);
			end if;
		end if;
		j := j + 1;
	end process;
end arch;