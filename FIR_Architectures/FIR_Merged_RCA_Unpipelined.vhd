Library IEEE;
use IEEE.std_logic_1164.all;
use work.ncl_signals.all;
use work.FIR_pack.all;
use IEEE.numeric_std.all;

entity FIR_Merged_RCA_Unpipelined is
	port(X        : in  dual_rail_logic_vector(9 downto 0);
		 C        : in  CType;
		 ki       : in  std_logic;
		 rst      : in  std_logic;
		 sleep    : in  std_logic;
		 ko       : out std_logic;
		 sleepout : out std_logic;
		 Y        : out dual_rail_logic_vector(10 downto 0));
end;

architecture arch of FIR_Merged_RCA_Unpipelined is
	component Merged_PPGen is
	port(X              : in  XType;
		 C              : in  CType;
		 sleep          : in  std_logic;
		 Z0             : out dual_rail_logic_vector(15 downto 0);
		 Z1             : out dual_rail_logic_vector(31 downto 0);
		 Z2             : out dual_rail_logic_vector(47 downto 0);
		 Z3             : out dual_rail_logic_vector(63 downto 0);
		 Z4             : out dual_rail_logic_vector(79 downto 0);
		 Z5             : out dual_rail_logic_vector(95 downto 0);
		 Z6, Z7, Z8, Z9 : out dual_rail_logic_vector(111 downto 0);
		 Z10            : out dual_rail_logic_vector(96 downto 0);
		 Z11            : out dual_rail_logic_vector(79 downto 0);
		 Z12            : out dual_rail_logic_vector(63 downto 0);
		 Z13            : out dual_rail_logic_vector(48 downto 0);
		 Z14            : out dual_rail_logic_vector(31 downto 0);
		 Z15            : out dual_rail_logic_vector(15 downto 0));
	end component;
	
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
			 Z2, Z3, Z4, Z5, Z6, Z7, Z8, Z9, Z10, Z11, Z12, Z13, Z14 : out dual_rail_logic_vector(41 downto 0);
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
	
	component RCA_genm is
	generic(width : integer := 16);
	port(
		X    : in  dual_rail_logic_vector(width - 1 downto 0);
		Y    : in  dual_rail_logic_vector(width - 1 downto 0);
		sleep : in  std_logic;
		S   : out dual_rail_logic_vector(width - 1 downto 0)
	);
	end component;

	--type Xpptype is array (15 downto 0) of dual_rail_logic_vector(9 downto 0);
	type Ktype is array (15 downto 0) of std_logic;
	--type Stage1 is array (7 downto 0) of dual_rail_logic_vector(16 downto 0);
	--type Stage2 is array (3 downto 0) of dual_rail_logic_vector(17 downto 0);
	--type Stage3 is array (1 downto 0) of dual_rail_logic_vector(18 downto 0);

	signal Xarray         : Xtype;
	signal karray, Sarray : Ktype;
	--signal S1             : Stage1;
	--signal S2             : Stage2;
	--signal S3             : Stage3;
	--signal S4             : dual_rail_logic_vector(19 downto 0);
	signal ko_temp        : std_logic;
	
	-- PP generation
	signal PP_Z0, PP_Z15            	 : dual_rail_logic_vector(15 downto 0);
	signal 	 PP_Z1, PP_Z14             	 :  dual_rail_logic_vector(31 downto 0);
	signal	 PP_Z2            			 : dual_rail_logic_vector(47 downto 0);
	signal	 PP_Z3, PP_Z12             	 : dual_rail_logic_vector(63 downto 0);
	signal	 PP_Z4, PP_Z11             	 : dual_rail_logic_vector(79 downto 0);
	signal	 PP_Z5            			 : dual_rail_logic_vector(95 downto 0);
	signal 	 PP_Z6, PP_Z7, PP_Z8, PP_Z9  : dual_rail_logic_vector(111 downto 0);
	signal	 PP_Z10           			 : dual_rail_logic_vector(96 downto 0);
	signal	 PP_Z13           			 : dual_rail_logic_vector(48 downto 0);
	
	-- Stage 0 signals
	signal S0_Z0, S0_Z15                     		    : dual_rail_logic_vector(15 downto 0);
	signal S0_Z1, S0_Z14                 		    : dual_rail_logic_vector(31 downto 0);
	signal S0_Z2                     				 	    : dual_rail_logic_vector(47 downto 0);
	signal S0_Z3, S0_Z12                  		    : dual_rail_logic_vector(63 downto 0);
	signal S0_Z4                    				   	    : dual_rail_logic_vector(79 downto 0);
	signal S0_Z5, S0_Z6, S0_Z7, S0_Z8, S0_Z9, S0_Z10 : dual_rail_logic_vector(93 downto 0);
	signal S0_Z11                   		        : dual_rail_logic_vector(89 downto 0);
	signal S0_Z13                 				            : dual_rail_logic_vector(48 downto 0);
		
	-- Stage 1 signals
	signal S1_Z0                                              : dual_rail_logic_vector(15 downto 0);
	signal S1_Z1                                              : dual_rail_logic_vector(31 downto 0);
	signal S1_Z2                                              : dual_rail_logic_vector(47 downto 0);
	signal S1_Z3, S1_Z4, S1_Z5, S1_Z6, S1_Z7, S1_Z8, S1_Z9, S1_Z10, S1_Z11, S1_Z12, S1_Z13 : dual_rail_logic_vector(62 downto 0);
	signal S1_Z14                                             : dual_rail_logic_vector(32 downto 0);
	signal S1_Z15                                             : dual_rail_logic_vector(15 downto 0);
	
	-- Stage 2 signals
	 signal S2_Z0                                               : dual_rail_logic_vector(15 downto 0);
	 signal	S2_Z1                                               : dual_rail_logic_vector(31 downto 0);
	 signal	S2_Z2, S2_Z3, S2_Z4, S2_Z5, S2_Z6, S2_Z7, S2_Z8, S2_Z9, S2_Z10, S2_Z11, S2_Z12, S2_Z13, S2_Z14 : dual_rail_logic_vector(41 downto 0);
	 signal	S2_Z15                                              : dual_rail_logic_vector(21 downto 0);
	 
	 -- Stage 3 signals
	 signal S3_Z0                                               : dual_rail_logic_vector(15 downto 0);
	 signal	S3_Z1, S3_Z2, S3_Z3, S3_Z4, S3_Z5, S3_Z6, S3_Z7, S3_Z8, S3_Z9, S3_Z10, S3_Z11, S3_Z12, S3_Z13, 
	 	S3_Z14, S3_Z15 : dual_rail_logic_vector(27 downto 0);
	 	
	 -- Stage 4 signals
	 signal S4_Z0                                                  : dual_rail_logic_vector(15 downto 0);
	 signal S4_Z1, S4_Z2, S4_Z3, S4_Z4, S4_Z5, S4_Z6, S4_Z7, S4_Z8, S4_Z9, S4_Z10, S4_Z11, S4_Z12, S4_Z13, S4_Z14,
	  S4_Z15 : dual_rail_logic_vector(18 downto 0);
	
	 -- Stages 5-10 signals
	 signal S5_Z0, S5_Z1, S5_Z2, S5_Z3, S5_Z4, S5_Z5, S5_Z6, S5_Z7, S5_Z8, S5_Z9, S5_Z10, S5_Z11, S5_Z12, S5_Z13,
	  S5_Z14, S5_Z15 : dual_rail_logic_vector(12 downto 0);	
	 signal  S6_Z0, S6_Z1, S6_Z2, S6_Z3, S6_Z4, S6_Z5, S6_Z6, S6_Z7, S6_Z8, S6_Z9, S6_Z10, S6_Z11, S6_Z12, S6_Z13,
	  S6_Z14, S6_Z15 : dual_rail_logic_vector(8 downto 0);
	 signal S7_Z0, S7_Z1, S7_Z2, S7_Z3, S7_Z4, S7_Z5, S7_Z6, S7_Z7, S7_Z8, S7_Z9, S7_Z10, S7_Z11, S7_Z12, S7_Z13, 
	  S7_Z14, S7_Z15 : dual_rail_logic_vector(5 downto 0);
	 signal S8_Z0, S8_Z1, S8_Z2, S8_Z3, S8_Z4, S8_Z5, S8_Z6, S8_Z7, S8_Z8, S8_Z9, S8_Z10, S8_Z11, S8_Z12, S8_Z13, 
	  S8_Z14, S8_Z15 : dual_rail_logic_vector(3 downto 0);
	 signal S9_Z0, S9_Z1, S9_Z2, S9_Z3, S9_Z4, S9_Z5, S9_Z6, S9_Z7, S9_Z8, S9_Z9, S9_Z10, S9_Z11, S9_Z12, S9_Z13,
	  S9_Z14, S9_Z15 : dual_rail_logic_vector(2 downto 0);
	 signal S10_Z0, S10_Z1, S10_Z2, S10_Z3, S10_Z4, S10_Z5, S10_Z6, S10_Z7, S10_Z8, S10_Z9, S10_Z10, S10_Z11, S10_Z12,
	  S10_Z13, S10_Z14, S10_Z15 : dual_rail_logic_vector(1 downto 0);
	  
	 signal RCA_X, RCA_Y, RCA_Z : dual_rail_logic_vector(15 downto 0);
	 
	 
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
	
	PP : Merged_PPGen
		port map(Xarray, c, sleep, PP_Z0, PP_Z1, PP_Z2, PP_Z3, PP_Z4, PP_Z5, PP_Z6, PP_Z7, PP_Z8, PP_Z9, PP_Z10, PP_Z11, 
			PP_Z12, PP_Z13, PP_Z14, PP_Z15);
	
	Stage0 : Merged_S0
		port map(PP_Z0, PP_Z1, PP_Z2, PP_Z3, PP_Z4, PP_Z5, PP_Z6, PP_Z7, PP_Z8, PP_Z9, PP_Z10, PP_Z11, 
			PP_Z12, PP_Z13, PP_Z14, PP_Z15, sleep, S0_Z0, S0_Z1, S0_Z2, S0_Z3, S0_Z4, S0_Z5, S0_Z6, S0_Z7, S0_Z8, S0_Z9,
			S0_Z10, S0_Z11, S0_Z12, S0_Z13, S0_Z14, S0_Z15);
			
	Stage1 : Merged_S1
		port map(S0_Z0, S0_Z1, S0_Z2, S0_Z3, S0_Z4, S0_Z5, S0_Z6, S0_Z7, S0_Z8, S0_Z9, S0_Z10, S0_Z11, S0_Z12,
			S0_Z13, S0_Z14, S0_Z15, sleep, S1_Z0, S1_Z1, S1_Z2, S1_Z3, S1_Z4, S1_Z5, S1_Z6, S1_Z7, S1_Z8, S1_Z9,
			S1_Z10, S1_Z11, S1_Z12, S1_Z13, S1_Z14, S1_Z15);
			
	Stage2: Merged_S2
		port map(S1_Z0, S1_Z1, S1_Z2, S1_Z3, S1_Z4, S1_Z5, S1_Z6, S1_Z7, S1_Z8, S1_Z9, S1_Z10, S1_Z11, S1_Z12, 
			S1_Z13, S1_Z14, S1_Z15, sleep, S2_Z0, S2_Z1, S2_Z2, S2_Z3, S2_Z4, S2_Z5, S2_Z6, S2_Z7, S2_Z8, S2_Z9, 
			S2_Z10, S2_Z11, S2_Z12, S2_Z13, S2_Z14, S2_Z15);
			
	Stage3: Merged_S3
		port map(S2_Z0, S2_Z1, S2_Z2, S2_Z3, S2_Z4, S2_Z5, S2_Z6, S2_Z7, S2_Z8, S2_Z9, S2_Z10, S2_Z11, S2_Z12, S2_Z13,
			S2_Z14, S2_Z15, sleep, S3_Z0, S3_Z1, S3_Z2, S3_Z3, S3_Z4, S3_Z5, S3_Z6, S3_Z7, S3_Z8, S3_Z9, S3_Z10, S3_Z11,
		    S3_Z12, S3_Z13, S3_Z14, S3_Z15);
		    
	Stage4: Merged_S4
		port map(S3_Z0, S3_Z1, S3_Z2, S3_Z3, S3_Z4, S3_Z5, S3_Z6, S3_Z7, S3_Z8, S3_Z9, S3_Z10, S3_Z11,
		    S3_Z12, S3_Z13, S3_Z14, S3_Z15, sleep, S4_Z0, S4_Z1, S4_Z2, S4_Z3, S4_Z4, S4_Z5, S4_Z6, S4_Z7, S4_Z8, S4_Z9,
		    S4_Z10, S4_Z11, S4_Z12, S4_Z13, S4_Z14, S4_Z15);
		    
	Stage5: Merged_S5
		port map(S4_Z0, S4_Z1, S4_Z2, S4_Z3, S4_Z4, S4_Z5, S4_Z6, S4_Z7, S4_Z8, S4_Z9, S4_Z10, S4_Z11, S4_Z12, 
			S4_Z13, S4_Z14, S4_Z15, sleep, S5_Z0, S5_Z1, S5_Z2, S5_Z3, S5_Z4, S5_Z5, S5_Z6, S5_Z7, S5_Z8, S5_Z9, S5_Z10,
			S5_Z11, S5_Z12, S5_Z13, S5_Z14, S5_Z15);
			
	Stage6: Merged_S6
		port map(S5_Z0, S5_Z1, S5_Z2, S5_Z3, S5_Z4, S5_Z5, S5_Z6, S5_Z7, S5_Z8, S5_Z9, S5_Z10, S5_Z11, S5_Z12, S5_Z13,
			S5_Z14, S5_Z15, sleep, S6_Z0, S6_Z1, S6_Z2, S6_Z3, S6_Z4, S6_Z5, S6_Z6, S6_Z7, S6_Z8, S6_Z9, S6_Z10,
			S6_Z11, S6_Z12, S6_Z13, S6_Z14, S6_Z15);
	
	Stage7: Merged_S7
		port map(S6_Z0, S6_Z1, S6_Z2, S6_Z3, S6_Z4, S6_Z5, S6_Z6, S6_Z7, S6_Z8, S6_Z9, S6_Z10, S6_Z11, S6_Z12, S6_Z13,
	        S6_Z14, S6_Z15, sleep, S7_Z0, S7_Z1, S7_Z2, S7_Z3, S7_Z4, S7_Z5, S7_Z6, S7_Z7, S7_Z8, S7_Z9, S7_Z10, S7_Z11,
	        S7_Z12, S7_Z13, S7_Z14, S7_Z15);
	  
	Stage8: Merged_S8
		port map(S7_Z0, S7_Z1, S7_Z2, S7_Z3, S7_Z4, S7_Z5, S7_Z6, S7_Z7, S7_Z8, S7_Z9, S7_Z10, S7_Z11, S7_Z12, S7_Z13, 
	        S7_Z14, S7_Z15, sleep, S8_Z0, S8_Z1, S8_Z2, S8_Z3, S8_Z4, S8_Z5, S8_Z6, S8_Z7, S8_Z8, S8_Z9, S8_Z10, S8_Z11,
	        S8_Z12, S8_Z13, S8_Z14, S8_Z15);
	      
	Stage9: Merged_S9
		port map(S8_Z0, S8_Z1, S8_Z2, S8_Z3, S8_Z4, S8_Z5, S8_Z6, S8_Z7, S8_Z8, S8_Z9, S8_Z10, S8_Z11, S8_Z12, S8_Z13, 
	        S8_Z14, S8_Z15, sleep, S9_Z0, S9_Z1, S9_Z2, S9_Z3, S9_Z4, S9_Z5, S9_Z6, S9_Z7, S9_Z8, S9_Z9, S9_Z10, S9_Z11,
	        S9_Z12, S9_Z13, S9_Z14, S9_Z15);
	        
	Stage10: Merged_S10
		port map(S9_Z0, S9_Z1, S9_Z2, S9_Z3, S9_Z4, S9_Z5, S9_Z6, S9_Z7, S9_Z8, S9_Z9, S9_Z10, S9_Z11, S9_Z12, S9_Z13,
	        S9_Z14, S9_Z15, sleep, S10_Z0, S10_Z1, S10_Z2, S10_Z3, S10_Z4, S10_Z5, S10_Z6, S10_Z7, S10_Z8, S10_Z9,
	        S10_Z10, S10_Z11, S10_Z12, S10_Z13, S10_Z14, S10_Z15);
	        
	RCA_X <= S10_Z15(0) & S10_Z14(0) & S10_Z13(0) & S10_Z12(0) & S10_Z11(0) & S10_Z10(0) & S10_Z9(0) & S10_Z8(0) & S10_Z7(0)
	        & S10_Z6(0) & S10_Z5(0) & S10_Z4(0) & S10_Z3(0) & S10_Z2(0) & S10_Z1(0) & S10_Z0(0);
	RCA_Y <= S10_Z15(1) & S10_Z14(1) & S10_Z13(1) & S10_Z12(1) & S10_Z11(1) & S10_Z10(1) & S10_Z9(1) & S10_Z8(1) & S10_Z7(1)
	        & S10_Z6(1) & S10_Z5(1) & S10_Z4(1) & S10_Z3(1) & S10_Z2(1) & S10_Z1(1) & S10_Z0(1);
	        
	RCA: RCA_genm
		generic map(16)
		port map(RCA_X, RCA_Y, sleep, RCA_Z);

	y <= RCA_Z(15 downto 5);
end arch;