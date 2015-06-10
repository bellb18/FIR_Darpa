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
	component carry_prop_gen_m
		port(xi    : in  DUAL_RAIL_LOGIC;
			 yi    : in  DUAL_RAIL_LOGIC;
			 sleep : in  STD_LOGIC;
			 gi    : out DUAL_RAIL_LOGIC;
			 pi    : out DUAL_RAIL_LOGIC);
	end component carry_prop_gen_m;

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
		gen_prop_gen_0 : carry_prop_gen_m
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

