
-----------------------------------------
-- Definition of Hybrid Carry Look Ahead(CLA)
-- and Ripple Carry Adder(RCA) 4 Bits
-- Must include CLA 16_bit
-----------------------------------------

Library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.MTNCL_gates.all;
use work.ncl_signals.all;
entity CLA_genm is
	generic(width : integer := 8);
	port(
		xi    : in  dual_rail_logic_vector(width - 1 downto 0);
		yi    : in  dual_rail_logic_vector(width - 1 downto 0);
		sleep : in  std_logic;
		sum   : out dual_rail_logic_vector(width downto 0)
	);
end;

architecture arch of CLA_genm is
	component carry_generatem
		port(xi    : in  DUAL_RAIL_LOGIC_VECTOR(3 downto 0);
			 yi    : in  DUAL_RAIL_LOGIC_VECTOR(3 downto 0);
			 cin   : in  DUAL_RAIL_LOGIC;
			 sleep : in  STD_LOGIC;
			 cout  : out DUAL_RAIL_LOGIC);
	end component carry_generatem;
	
	component MSBm is
	port(
		X     : IN  dual_rail_logic;
		Y     : IN  dual_rail_logic;
		Pre   : IN  dual_rail_logic;
		sleep : in  std_logic;
		P     : OUT dual_rail_logic);   --*
	end component;

	component RCA4bm
		port(x     : in  dual_rail_logic_vector(3 downto 0);
			 y     : in  dual_rail_logic_vector(3 downto 0);
			 cin   : in  DUAL_RAIL_LOGIC;
			 sleep : in  std_logic;
			 cout  : out DUAL_RAIL_LOGIC;
			 sum   : out dual_rail_logic_vector(3 downto 0));
	end component RCA4bm;

	component HAm
		port(X, Y    : in  dual_rail_logic;
			 sleep   : in  std_logic;
			 COUT, S : out dual_rail_logic);
	end component;

	component FAm is
		port(
			CIN   : IN  dual_rail_logic;
			X     : IN  dual_rail_logic;
			Y     : IN  dual_rail_logic;
			sleep : in  std_logic;
			COUT  : OUT dual_rail_logic;
			S     : OUT dual_rail_logic);
	end component;

	signal adder_cout : DUAL_RAIL_LOGIC;
	signal carry_in   : DUAL_RAIL_Logic;
	signal temp_carry : DUAL_RAIL_LOGIC_VECTOR((width mod 4) - 1 downto 0);
	signal temp_sum   : DUAL_RAIL_LOGIC_VECTOR((width mod 4) - 1 downto 0);
	signal temp_sum2   : DUAL_RAIL_LOGIC_VECTOR(width downto 0);
	signal temp_carry2 : DUAL_RAIL_LOGIC_VECTOR((width / 4) downto 0);

begin
	Extra_Bits : if (width mod 4 > 0) generate
		HAm_0 : HAm
			port map(xi(0), yi(0), sleep, temp_carry(0), temp_sum(0));
		Full_Adders : for i in 1 to (width mod 4) - 1 generate
			FAm_0 : FAm
				port map(temp_carry(i - 1), xi(i), yi(i), sleep, temp_carry(i), temp_sum(i));
		end generate Full_Adders;
		carry_in <= temp_carry((width mod 4) - 1);
		temp_sum2((width mod 4) - 1 downto 0) <= temp_sum;
	end generate Extra_Bits;

	Otherwise : if (width mod 4 = 0) generate
		carry_in.rail1 <= '0';
		carry_in.rail0 <= '1';
	end generate Otherwise;

	CLA : for i in 1 to (width / 4) generate
		temp_carry2(0) <= carry_in;

		--Generate Carry--
		carry_gen_c4_0 : carry_generatem
			Port map(
				xi    => xi(i * 4 + (width mod 4) - 1 downto 4 * (i - 1) + (width mod 4)),
				yi    => yi(i * 4 + (width mod 4) - 1 downto 4 * (i - 1) + (width mod 4)),
				cin   => temp_carry2(i - 1),
				sleep => sleep,
				cout  => temp_carry2(i)
			);

		--Sum 4 bits---
		rca_4b_0 : RCA4bm
			port map(
				cin   => temp_carry2(i - 1),
				x     => xi(i * 4 + (width mod 4) - 1 downto 4 * (i - 1) + (width mod 4)),
				y     => yi(i * 4 + (width mod 4) - 1 downto 4 * (i - 1) + (width mod 4)),
				sleep => sleep,
				cout  => adder_cout,    --Not needed since carry out is generated earlier
				sum   => temp_sum2(i * 4 + (width mod 4) - 1 downto 4 * (i - 1) + (width mod 4))
			);
			
			MSB_1: MSBm
			port map(xi(width-1), yi(width-1),temp_sum2(width-1), sleep, temp_sum2(width));

	end generate CLA;
	
	sum <= temp_sum2;

end arch;





