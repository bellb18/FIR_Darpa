
-----------------------------------------
-- Definition of Hybrid Carry Look Ahead(CLA)
-- and Ripple Carry Adder(RCA) 4 Bits
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



-----------------------------------------
-- Definition of Hybrid Carry Look Ahead(CLA)
-- 16 - bits and 16 - bit output
-----------------------------------------

Library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.MTNCL_gates.all;
use work.ncl_signals.all;
entity CLA_16m is
	port(
		X    : in  dual_rail_logic_vector(15 downto 0);
		Y    : in  dual_rail_logic_vector(15 downto 0);
		sleep : in  std_logic;
		S   : out dual_rail_logic_vector(15 downto 0)
	);
end;

architecture arch of CLA_16m is
	component carry_generatem
		port(xi    : in  DUAL_RAIL_LOGIC_VECTOR(3 downto 0);
			 yi    : in  DUAL_RAIL_LOGIC_VECTOR(3 downto 0);
			 cin   : in  DUAL_RAIL_LOGIC;
			 sleep : in  STD_LOGIC;
			 cout  : out DUAL_RAIL_LOGIC);
	end component carry_generatem;

	component RCA4bm
		port(x     : in  dual_rail_logic_vector(3 downto 0);
			 y     : in  dual_rail_logic_vector(3 downto 0);
			 cin   : in  DUAL_RAIL_LOGIC;
			 sleep : in  std_logic;
			 cout  : out DUAL_RAIL_LOGIC;
			 sum   : out dual_rail_logic_vector(3 downto 0));
	end component RCA4bm;

	signal adder_cout : DUAL_RAIL_LOGIC_VECTOR(3 downto 0);
	signal temp_carry : DUAL_RAIL_LOGIC_VECTOR(4 downto 0);


begin
	temp_carry(0).rail0 <= '1';
	temp_carry(0).rail1 <= '0';
	CLAGen : for i in 0 to 3 generate
		CLA1 : carry_generatem
			port map(X(4 * i + 3 downto 4 * i), Y(4 * i + 3 downto 4 * i), temp_carry(i), sleep, temp_carry(i + 1));
		RCA1 : RCA4bm
			port map(X(4 * i + 3 downto 4 * i), Y(4 * i + 3 downto 4 * i), temp_carry(i), sleep, adder_cout(i), S(4 * i + 3 downto 4 * i));
	end generate;
end arch;



-----------------------------------------
-- Definition of Propapate/Generate
-- Propagate term:
-- pi = ai + bi
-- Generate Term:
-- gi = ai * bi
-----------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.ncl_signals.all;
use work.MTNCL_gates.all;

entity carry_propagatem is
    Port ( 
        xi : in  DUAL_RAIL_LOGIC;
        yi : in  DUAL_RAIL_LOGIC;
        sleep : in STD_LOGIC;
        gi : out  DUAL_RAIL_LOGIC;
        pi : out  DUAL_RAIL_LOGIC
    );
end carry_propagatem;

architecture structural of carry_propagatem is
    

begin

    -- Propagate Term --
    -- RAIL 1 --
    -- pi = xi + yi
    th12m_0 : th12m_a
        port map(a     => xi.RAIL1,
                 b     => yi.RAIL1,
                 s => sleep,
                 z     => pi.RAIL1);
                 
    -- RAIL 0 --
    -- pi' = xi'yi'
    th22m_a_0 : th22m_a
        port map(a     => xi.RAIL0,
                 b     => yi.RAIL0,
                 s => sleep,
                 z     => pi.RAIL0);
    
    
    -- Generate Term --
    -- RAIL1 --
    -- gi = xiyi
    th22m_a_1 : th22m_a
        port map(a     => xi.RAIL1,
                 b     => yi.RAIL1,
                 s => sleep,
                 z     => gi.RAIL1);
    
    -- RAIL 0 --
    -- gi' = xi' + yi'
    th12m_1 : th12m_a
        port map(a     => xi.RAIL0,
                 b     => yi.RAIL0,
                 s => sleep,
                 z     => gi.RAIL0);

end structural;



library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.MTNCL_gates.all;
use work.ncl_signals.all;

entity carry_generatem is
	Port(
		xi    : in  DUAL_RAIL_LOGIC_VECTOR(3 downto 0);
		yi    : in  DUAL_RAIL_LOGIC_VECTOR(3 downto 0);
		cin   : in  DUAL_RAIL_LOGIC;
		sleep : in  STD_LOGIC;
		cout  : out DUAL_RAIL_LOGIC
	);
end carry_generatem;

architecture Structural of carry_generatem is
	component carry_propagatem
		port(xi    : in  DUAL_RAIL_LOGIC;
			 yi    : in  DUAL_RAIL_LOGIC;
			 sleep : in  STD_LOGIC;
			 gi    : out DUAL_RAIL_LOGIC;
			 pi    : out DUAL_RAIL_LOGIC);
	end component carry_propagatem;

	component th55m_a is
		port(
			a : in  std_logic;
			b : in  std_logic;
			c : in  std_logic;
			d : in  std_logic;
			e : in  std_logic;
			s : in  std_logic;
			z : out std_logic);
	end component;

	component th15m_a is
		port(
			a : in  std_logic;
			b : in  std_logic;
			c : in  std_logic;
			d : in  std_logic;
			e : in  std_logic;
			s : in  std_logic;
			z : out std_logic);
	end component;

	signal gi                   : DUAL_RAIL_LOGIC_VECTOR(3 downto 0);
	signal pi                   : DUAL_RAIL_LOGIC_VECTOR(3 downto 0);
	signal p3_g2_RAIL1          : STD_LOGIC;
	signal p3_p2_g1_RAIL1       : STD_LOGIC;
	signal p3_p2_p1_g0_RAIL1    : STD_LOGIC;
	signal p3_p2_p1_p0_c0_RAIL1 : STD_LOGIC;

	signal p3_g2_RAIL0          : STD_LOGIC;
	signal p3_p2_g1_RAIL0       : STD_LOGIC;
	signal p3_p2_p1_g0_RAIL0    : STD_LOGIC;
	signal p3_p2_p1_p0_c0_RAIL0 : STD_LOGIC;

begin
	GENERATE_prop_gen : for i in 0 to 3 generate
		gen_prop_gen_0 : carry_propagatem
			port map(xi    => xi(i),
				     yi    => yi(i),
				     sleep => sleep,
				     gi    => gi(i),
				     pi    => pi(i));
	end generate;

	--Generate Carry Out 4 (C4)--
	-- C4 = g3 + p3 g2 + p3 p2 g1 + p3 p2 p1 g0 + p3 p2 p1 p0 c0
	-- Rail 1 ---
	th22m_0 : th22m_a
		port map(
			a => pi(3).RAIL1,
			b => gi(2).RAIL1,
			s => sleep,
			z => p3_g2_RAIL1
		);

	th33m_0 : th33m_a
		port map(
			a => pi(3).RAIL1,
			b => pi(2).RAIL1,
			c => gi(1).RAIL1,
			s => sleep,
			z => p3_p2_g1_RAIL1
		);

	th44m_0 : th44m_a
		port map(
			a => pi(3).RAIL1,
			b => pi(2).RAIL1,
			c => pi(1).RAIL1,
			d => gi(0).RAIL1,
			s => sleep,
			z => p3_p2_p1_g0_RAIL1
		);

	th55m_0 : th55m_a
		port map(
			a => pi(3).RAIL1,
			b => pi(2).RAIL1,
			c => pi(1).RAIL1,
			d => pi(0).RAIL1,
			e => cin.RAIL1,
			s => sleep,
			z => p3_p2_p1_p0_c0_RAIL1
		);

	th15m_0 : th15m_a
		port map(
			a => gi(3).RAIL1,
			b => p3_g2_RAIL1,
			c => p3_p2_g1_RAIL1,
			d => p3_p2_p1_g0_RAIL1,
			e => p3_p2_p1_p0_c0_RAIL1,
			s => sleep,
			z => cout.RAIL1
		);

	--- Rail 0 ---
	-- ~C4 = ~G3 * (~P3 ~G2) * (~P3 ~P2 ~G1) * (~P3 ~P2 ~P1 ~G0) * (~P3 ~P2 ~P1 ~P0 ~C0)

	th12m_1 : th12m_a
		port map(a => pi(3).RAIL0,
			     b => gi(2).RAIL0,
			     s => sleep,
			     z => p3_g2_RAIL0);

	th13m_1 : th13m_a
		port map(a => pi(3).RAIL0,
			     b => pi(2).RAIL0,
			     c => gi(1).RAIL0,
			     s => sleep,
			     z => p3_p2_g1_RAIL0);

	th14m_1 : th14m_a
		port map(a => pi(3).RAIL0,
			     b => pi(2).RAIL0,
			     c => pi(1).RAIL0,
			     d => gi(0).RAIL0,
			     s => sleep,
			     z => p3_p2_p1_g0_RAIL0);

	th15m_1 : th15m_a
		port map(a => pi(3).RAIL0,
			     b => pi(2).RAIL0,
			     c => pi(1).RAIL0,
			     d => pi(0).RAIL0,
			     e => cin.RAIL0,
			     s => sleep,
			     z => p3_p2_p1_p0_c0_RAIL0);

	th55m_1 : th55m_a
		port map(a => gi(3).RAIL0,
			     b => p3_g2_RAIL0,
			     c => p3_p2_g1_RAIL0,
			     d => p3_p2_p1_g0_RAIL0,
			     e => p3_p2_p1_p0_c0_RAIL0,
			     s => sleep,
			     z => cout.RAIL0);

end Structural;



-----------------------------------------
-- Definition of rca_4b(Ripple Carry Adder)
-----------------------------------------

Library IEEE;
use IEEE.std_logic_1164.all;
use work.ncl_signals.all;
use work.MTNCL_gates.all;

entity RCA4bm is
	port(
		x     : in  dual_rail_logic_vector(3 downto 0);
		y     : in  dual_rail_logic_vector(3 downto 0);
		cin   : in  DUAL_RAIL_LOGIC;
		sleep : in  std_logic;
		cout  : out DUAL_RAIL_LOGIC;
		sum   : out dual_rail_logic_vector(3 downto 0)
	);
end;

architecture arch of RCA4bm is
	component FAm
		port(
			CIN, X, Y : in  dual_rail_logic;
			sleep     : in  std_logic;
			COUT, S   : out dual_rail_logic);
	end component;

	signal carry : dual_rail_logic_vector(3 downto 1);

begin

	---Initial Stage---
	GFA0 : FAm
		port map(
			CIN   => cin,
			X     => x(0),
			Y     => y(0),
			sleep => sleep,
			COUT  => carry(1),
			S     => sum(0)
		);

	---Middle Stages---
	GenFA : for i in 1 to 4 - 2 generate
		GFA : FAm
			port map(
				CIN   => carry(i),
				X     => x(i),
				Y     => y(i),
				sleep => sleep,
				COUT  => carry(i + 1),
				S     => sum(i)
			);
	end generate;

	---Last Stage---
	lastFA : FAm
		port map(
			CIN   => carry(4 - 1),
			X     => x(4 - 1),
			Y     => y(4 - 1),
			sleep => sleep,
			COUT  => cout,              ---Note: Result has one bit extra
			S     => sum(4 - 1)
		);

end arch;





