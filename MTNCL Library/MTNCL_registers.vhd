----------------------------------------------------------
--Contains 
--regm - No reset register
--regdm - Reset high register
--regnm - Reset low register
--genregm - Generic sized no-reset register
--genregrstm - Generic sized resettable register
--ShiftRegMTNCL - Pattern delay shift register
----------------------------------------------------------

----------------------------------------------------------- 
-- regm
----------------------------------------------------------- 
library ieee;
use ieee.std_logic_1164.all;
use work.ncl_signals.all;
use work.MTNCL_gates.all;

entity regm is
	port(a     : in  dual_rail_logic;
		 sleep : in  std_logic;
		 z     : out dual_rail_logic);
end regm;

architecture arch of regm is

	signal t0, t1 : std_logic;
begin
	Gr0 : th12m_a
		port map(a.rail0, t0, sleep, t0);
	Gr1 : th12m_a
		port map(a.rail1, t1, sleep, t1);

	z.rail0 <= t0;
	z.rail1 <= t1;

end arch;

----------------------------------------------------------- 
-- regdm
----------------------------------------------------------- 
library ieee;
use ieee.std_logic_1164.all;
use work.ncl_signals.all;
use work.MTNCL_gates.all;

entity regdm is
	port(a     : in  dual_rail_logic;
		 rst   : in  std_logic;
		 sleep : in  std_logic;
		 z     : out dual_rail_logic);
end regdm;

architecture arch of regdm is

	signal t0, t1 : std_logic;
begin
	Gr0 : th12nm_a
		port map(a.rail0, t0, rst, sleep, t0);
	Gr1 : th12dm_a
		port map(a.rail1, t1, rst, sleep, t1);

	z.rail0 <= t0;
	z.rail1 <= t1;

end arch;

----------------------------------------------------------- 
-- regnm
----------------------------------------------------------- 
library ieee;
use ieee.std_logic_1164.all;
use work.ncl_signals.all;
use work.MTNCL_gates.all;
entity regnm is
	port(a     : in  dual_rail_logic;
		 rst   : in  std_logic;
		 sleep : in  std_logic;
		 z     : out dual_rail_logic);
end regnm;

architecture arch of regnm is
	signal t0, t1 : std_logic;
begin
	Gr0 : th12dm_a
		port map(a.rail0, t0, rst, sleep, t0);
	Gr1 : th12nm_a
		port map(a.rail1, t1, rst, sleep, t1);

	z.rail0 <= t0;
	z.rail1 <= t1;

end arch;

----------------------------------------------------------- 
-- regnullm
----------------------------------------------------------- 
library ieee;
use ieee.std_logic_1164.all;
use work.ncl_signals.all;
use work.MTNCL_gates.all;
entity regnullm is
	port(a     : in  dual_rail_logic;
		 rst   : in  std_logic;
		 sleep : in  std_logic;
		 z     : out dual_rail_logic);
end regnullm;

architecture arch of regnullm is

	signal t0, t1 : std_logic;
begin
	Gr0 : th12nm_a
		port map(a.rail0, t0, rst, sleep, t0);
	Gr1 : th12nm_a
		port map(a.rail1, t1, rst, sleep, t1);

	z.rail0 <= t0;
	z.rail1 <= t1;

end arch;

-- Generic Sleep Register
library ieee;
use ieee.std_logic_1164.all;
use work.ncl_signals.all;

entity genregm is
	generic(width : in integer := 4);
	port(a     : IN  dual_rail_logic_vector(width - 1 downto 0);
		 sleep : in  std_logic;
		 z     : out dual_rail_logic_vector(width - 1 downto 0));
end genregm;

architecture arch of genregm is
	component regm is
		port(a     : in  dual_rail_logic;
			 sleep : in  std_logic;
			 z     : out dual_rail_logic);
	end component;

begin
	Greg : for i in 0 to width - 1 generate
	begin
		Gsr0 : regm
			port map(a(i), sleep, z(i));

	end generate;

end arch;

----------------------------------------------------------- 
-- genregrstm
----------------------------------------------------------- 
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.ncl_signals.all;
--use work.MTNCL_gates.all;
use work.functions.all;

entity genregrstm is
	generic(width : in integer    := 4;
		    dn    : in bit        := '1';
		    value : in bit_vector := "0110");
	port(a     : IN  dual_rail_logic_vector(width - 1 downto 0);
		 rst   : in  std_logic;
		 sleep : in  std_logic;

		 z     : out dual_rail_logic_vector(width - 1 downto 0));
end genregrstm;

architecture arch of genregrstm is
	component regnm is
		port(a     : in  dual_rail_logic;
			 rst   : in  std_logic;
			 sleep : in  std_logic;
			 z     : out dual_rail_logic);
	end component;

	component regdm is
		port(a     : in  dual_rail_logic;
			 rst   : in  std_logic;
			 sleep : in  std_logic;
			 z     : out dual_rail_logic);
	end component;

	component regnullm is
		port(a     : in  dual_rail_logic;
			 rst   : in  std_logic;
			 sleep : in  std_logic;
			 z     : out dual_rail_logic);
	end component;

--signal  regval : unsigned (width-1 downto 0) := to_unsigned(value,width);
begin

	--convert value into std_logic
	-- regval <= (to_unsigned(value, width));
	Gwithreset : for i in 0 to width - 1 generate
		Gresetnull : if dn = '0' generate
			G1 : regnullm
				port map(a(i), rst, sleep, z(i));
		end generate;

		Gresetlow : if (dn = '1' and value(i) = '0') generate
			G2 : regnm
				port map(a(i), rst, sleep, z(i));
		end generate;
		Gresethigh : if (dn = '1' and value(i) = '1') generate
			G3 : regdm
				port map(a(i), rst, sleep, z(i));
		end generate;
	end generate;

end arch;

----------------------------------------------------------- 
--Pattern-delay shift-register in MTNCL
----------------------------------------------------------- 
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.ncl_signals.all;
use work.functions.all;

entity ShiftRegMTNCL is
	generic(width : in integer    := 4;
		    value : in bit_vector := "0110");
	port(wrapin   : in  dual_rail_logic_vector(width - 1 downto 0);
		 ki       : in  std_logic;
		 rst      : in  std_logic;
		 sleep    : in  std_logic;
		 wrapout  : out dual_rail_logic_vector(width - 1 downto 0);
		 sleepout : out std_logic;
		 ko       : out std_logic);
end ShiftRegMTNCL;

architecture arch of ShiftRegMTNCL is
	component genregrstm is
		generic(width : in integer    := 4;
			    dn    : in bit        := '1';
			    value : in bit_vector := "0110");
		port(a     : IN  dual_rail_logic_vector(width - 1 downto 0);
			 rst   : in  std_logic;
			 sleep : in  std_logic;
			 z     : out dual_rail_logic_vector(width - 1 downto 0));
	end component;

	component compm is
		generic(width : in integer := 4);
		port(a              : IN  dual_rail_logic_vector(width - 1 downto 0);
			 ki, rst, sleep : in  std_logic;
			 ko             : OUT std_logic);
	end component;

	component compdm is
		generic(width : in integer := 4);
		port(a              : IN  dual_rail_logic_vector(width - 1 downto 0);
			 ki, rst, sleep : in  std_logic;
			 ko             : OUT std_logic);
	end component;

	signal wrap, r12 : dual_rail_logic_vector(width - 1 downto 0);
	signal c1, c2    : std_logic;

begin
	Gregdata : genregrstm
		generic map(width, '1', value)  ----reset to DATA
		port map(wrapin, rst, c1, r12);
	Gcompnull : compm                   -----reset to request for NULL
		generic map(width)
		port map(wrapin, c2, rst, sleep, c1);

	Gregnull : genregrstm
		generic map(width, '0', value)  --reset to NULL        
		port map(r12, rst, c2, wrap);
	Gcompdata : compdm
		generic map(width)
		port map(r12, ki, rst, c1, c2); --reset to requrest for DATA

	wrapout <= wrap;

	sleepout <= c2;
	ko       <= c1;

end arch;