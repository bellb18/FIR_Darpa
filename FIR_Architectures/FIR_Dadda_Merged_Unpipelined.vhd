Library IEEE;
use IEEE.std_logic_1164.all;
use work.ncl_signals.all;
use work.arraypack.all;
entity FIR_Merged_Unpipelined is
	port(x        : in  dual_rail_logic_vector(9 downto 0);
		 c        : in  array16;
		 ki       : in  std_logic;
		 rst      : in  std_logic;
		 sleep    : in  std_logic;
		 ko       : out std_logic;
		 sleepout : out std_logic;
		 y        : out dual_rail_logic_vector(10 downto 0));
end;

architecture arch of FIR_Merged_Unpipelined is
	component Merged_S0 is
		port(X0                      : in  dual_rail_logic_vector(15 downto 0);
			 X1                      : in  dual_rail_logic_vector(31 downto 0);
			 X2                      : in  dual_rail_logic_vector(47 downto 0);
			 X3                      : in  dual_rail_logic_vector(63 downto 0);
			 X4                      : in  dual_rail_logic_vector(79 downto 0);
			 X5                      : in  dual_rail_logic_vector(95 downto 0);
			 X6, X7, X8, X9          : in  dual_rail_logic_vector(111 downto 0);
			 X10                     : in  dual_rail_logic_vector(96 downto 0);
			 X11                     : in  dual_rail_logic_vector(79 downto 0);
			 X12                     : in  dual_rail_logic_vector(63 downto 0);
			 X13                     : in  dual_rail_logic_vector(48 downto 0);
			 X14                     : in  dual_rail_logic_vector(31 downto 0);
			 X15                     : in  dual_rail_logic_vector(15 downto 0);
			 sleep                   : in  std_logic;
			 Z0                      : out dual_rail_logic_vector(15 downto 0);
			 Z1                      : out dual_rail_logic_vector(31 downto 0);
			 Z2                      : out dual_rail_logic_vector(47 downto 0);
			 Z3                      : out dual_rail_logic_vector(63 downto 0);
			 Z4                      : out dual_rail_logic_vector(79 downto 0);
			 Z5, Z6, Z7, Z8, Z9, Z10 : out dual_rail_logic_vector(93 downto 0);
			 Z11                     : out dual_rail_logic_vector(89 downto 0);
			 Z12                     : out dual_rail_logic_vector(63 downto 0);
			 Z13                     : out dual_rail_logic_vector(48 downto 0);
			 Z14                     : out dual_rail_logic_vector(31 downto 0);
			 Z15                     : out dual_rail_logic_vector(15 downto 0));
	end component;

	component Merged_S1 is
		port(X0                                             : in  dual_rail_logic_vector(15 downto 0);
			 X1                                             : in  dual_rail_logic_vector(31 downto 0);
			 X2                                             : in  dual_rail_logic_vector(47 downto 0);
			 X3                                             : in  dual_rail_logic_vector(63 downto 0);
			 X4                                             : in  dual_rail_logic_vector(79 downto 0);
			 X5, X6, X7, X8, X9, X10                        : in  dual_rail_logic_vector(93 downto 0);
			 X11                                            : in  dual_rail_logic_vector(89 downto 0);
			 X12                                            : in  dual_rail_logic_vector(63 downto 0);
			 X13                                            : in  dual_rail_logic_vector(48 downto 0);
			 X14                                            : in  dual_rail_logic_vector(31 downto 0);
			 X15                                            : in  dual_rail_logic_vector(15 downto 0);
			 sleep                                          : in  std_logic;
			 Z0                                             : out dual_rail_logic_vector(15 downto 0);
			 Z1                                             : out dual_rail_logic_vector(31 downto 0);
			 Z2                                             : out dual_rail_logic_vector(47 downto 0);
			 Z3, Z4, Z5, Z6, Z7, Z8, Z9, Z10, Z11, Z12, Z13 : out dual_rail_logic_vector(62 downto 0);
			 Z14                                            : out dual_rail_logic_vector(32 downto 0);
			 Z15                                            : out dual_rail_logic_vector(15 downto 0));
	end component;

	component Merged_S2 is
		port(X0                                                 : in  dual_rail_logic_vector(15 downto 0);
			 X1                                                 : in  dual_rail_logic_vector(31 downto 0);
			 X2                                                 : in  dual_rail_logic_vector(47 downto 0);
			 X3, X4, X5, X6, X7, X8, X9, X10, X11, X12, X13     : in  dual_rail_logic_vector(62 downto 0);
			 X14                                                : in  dual_rail_logic_vector(32 downto 0);
			 X15                                                : in  dual_rail_logic_vector(15 downto 0);
			 sleep                                              : in  std_logic;
			 Z0                                                 : out dual_rail_logic_vector(15 downto 0);
			 Z1                                                 : out dual_rail_logic_vector(31 downto 0);
			 Z2, Z3, Z4, Z5, Z6, Z7, Z8, Z9, Z10, Z11, Z12, Z13 : out dual_rail_logic_vector(41 downto 0);
			 Z15                                                : out dual_rail_logic_vector(21 downto 0));
	end component;

	component Merged_S3 is
		port(X0                                                               : in  dual_rail_logic_vector(15 downto 0);
			 X1                                                               : in  dual_rail_logic_vector(31 downto 0);
			 X2, X3, X4, X5, X6, X7, X8, X9, X10, X11, X12, X13, X14          : in  dual_rail_logic_vector(41 downto 0);
			 X15                                                              : in  dual_rail_logic_vector(21 downto 0);
			 sleep                                                            : in  std_logic;
			 Z0                                                               : out dual_rail_logic_vector(15 downto 0);
			 Z1, Z2, Z3, Z4, Z5, Z6, Z7, Z8, Z9, Z10, Z11, Z12, Z13, Z14, Z15 : out dual_rail_logic_vector(27 downto 0));
	end component;

	component Merged_S4 is
		port(X0                                                               : in  dual_rail_logic_vector(15 downto 0);
			 X1, X2, X3, X4, X5, X6, X7, X8, X9, X10, X11, X12, X13, X14, X15 : in  dual_rail_logic_vector(27 downto 0);
			 sleep                                                            : in  std_logic;
			 Z0                                                               : out dual_rail_logic_vector(15 downto 0);
			 Z1, Z2, Z3, Z4, Z5, Z6, Z7, Z8, Z9, Z10, Z11, Z12, Z13, Z14, Z15 : out dual_rail_logic_vector(18 downto 0));
	end component;

	component Merged_S5 is
		port(X0                                                                   : in  dual_rail_logic_vector(15 downto 0);
			 X1, X2, X3, X4, X5, X6, X7, X8, X9, X10, X11, X12, X13, X14, X15     : in  dual_rail_logic_vector(18 downto 0);
			 sleep                                                                : in  std_logic;
			 Z0, Z1, Z2, Z3, Z4, Z5, Z6, Z7, Z8, Z9, Z10, Z11, Z12, Z13, Z14, Z15 : out dual_rail_logic_vector(12 downto 0));
	end component;

	component Merged_S6 is
		port(X0, X1, X2, X3, X4, X5, X6, X7, X8, X9, X10, X11, X12, X13, X14, X15 : in  dual_rail_logic_vector(12 downto 0);
			 sleep                                                                : in  std_logic;
			 Z0, Z1, Z2, Z3, Z4, Z5, Z6, Z7, Z8, Z9, Z10, Z11, Z12, Z13, Z14, Z15 : out dual_rail_logic_vector(8 downto 0));
	end component;
	
	component Merged_S7 is
		port(X0, X1, X2, X3, X4, X5, X6, X7, X8, X9, X10, X11, X12, X13, X14, X15 : in  dual_rail_logic_vector(8 downto 0);
			 sleep                                                                : in  std_logic;
			 Z0, Z1, Z2, Z3, Z4, Z5, Z6, Z7, Z8, Z9, Z10, Z11, Z12, Z13, Z14, Z15 : out dual_rail_logic_vector(5 downto 0));
	end component;
	
	component Merged_S8 is
		port(X0, X1, X2, X3, X4, X5, X6, X7, X8, X9, X10, X11, X12, X13, X14, X15 : in  dual_rail_logic_vector(5 downto 0);
			 sleep                                                                : in  std_logic;
			 Z0, Z1, Z2, Z3, Z4, Z5, Z6, Z7, Z8, Z9, Z10, Z11, Z12, Z13, Z14, Z15 : out dual_rail_logic_vector(3 downto 0));
	end component;
	
	component Merged_S9 is
		port(X0, X1, X2, X3, X4, X5, X6, X7, X8, X9, X10, X11, X12, X13, X14, X15 : in  dual_rail_logic_vector(3 downto 0);
			 sleep                                                                : in  std_logic;
			 Z0, Z1, Z2, Z3, Z4, Z5, Z6, Z7, Z8, Z9, Z10, Z11, Z12, Z13, Z14, Z15 : out dual_rail_logic_vector(2 downto 0));
	end component;
	
	component Merged_S10 is
		port(X0, X1, X2, X3, X4, X5, X6, X7, X8, X9, X10, X11, X12, X13, X14, X15 : in  dual_rail_logic_vector(2 downto 0);
			 sleep                                                                : in  std_logic;
			 Z0, Z1, Z2, Z3, Z4, Z5, Z6, Z7, Z8, Z9, Z10, Z11, Z12, Z13, Z14, Z15 : out dual_rail_logic_vector(1 downto 0));
	end component;

	component ShiftRegMTNCL is
		generic(width : in integer    := 4;
			    value : in bit_vector := "0110");
		port(wrapin   : in  dual_rail_logic_vector(width - 1 downto 0);
			 ki       : in  std_logic;
			 rst      : in  std_logic;
			 sleep    : in  std_logic;
			 wrapout  : out dual_rail_logic_vector(width - 1 downto 0);
			 sleepout : out std_logic;
			 ko       : out std_logic);
	end component;

	component compm is
		generic(width : in integer := 4);
		port(a              : IN  dual_rail_logic_vector(width - 1 downto 0);
			 ki, rst, sleep : in  std_logic;
			 ko             : OUT std_logic);
	end component;

	type Xtype is array (15 downto 0) of dual_rail_logic_vector(9 downto 0);
	type Ktype is array (15 downto 0) of std_logic;
	type Stage1 is array (7 downto 0) of dual_rail_logic_vector(16 downto 0);
	type Stage2 is array (3 downto 0) of dual_rail_logic_vector(17 downto 0);
	type Stage3 is array (1 downto 0) of dual_rail_logic_vector(18 downto 0);

	signal Xarray         : Xtype;
	signal karray, Sarray : Ktype;
	signal S1             : Stage1;
	signal S2             : Stage2;
	signal S3             : Stage3;
	signal S4             : dual_rail_logic_vector(19 downto 0);
	signal ko_temp        : std_logic;

begin
	Xarray(0)  <= x;
	karray(15) <= ki;
	Sarray(0)  <= sleep;
	sleepout   <= Sarray(15);
	ko_temp    <= karray(0);
	ko         <= ko_temp;

	GenShiftReg : for i in 1 to 15 generate
		Rega : ShiftRegMTNCL
			generic map(
				width => 10,
				value => "0000000000"
			)
			port map(
				wrapin   => Xarray(i - 1),
				ki       => karray(i),
				rst      => rst,
				sleep    => Sarray(i - 1),
				wrapout  => Xarray(i),
				sleepout => Sarray(i),
				ko       => karray(i - 1)
			);
	end generate;

--	GenMult : for i in 0 to 7 generate  -- 00.0000 0000 0000 001
--		Multa : Merged_Unpipelined
--			port map(Xarray(2 * i), c(2 * i), Xarray(2 * i + 1), c(2 * i + 1), sleep, S1(i));
--	end generate;

--	GenAdd1 : for i in 0 to 3 generate  -- 000.0000 0000 0000 00
--		Adda : CLA_genm
--			generic map(17)
--			port map(S1(2 * i), S1(2 * i + 1), sleep, S2(i));
--	end generate;
--
--	GenAdd2 : for i in 0 to 1 generate  -- 0000.0000 0000 0000 0
--		Adda : CLA_genm
--			generic map(18)
--			port map(S2(2 * i), S2(2 * i + 1), sleep, S3(i));
--	end generate;

--	FinalAdd : CLA_genm                 -- 00000.0000 0000 0000 000
--		generic map(19)
--		port map(S3(0), S3(1), sleep, S4);
--
--	y <= S4(15 downto 5);
end arch;