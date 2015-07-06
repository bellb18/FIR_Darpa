Library IEEE;
use IEEE.std_logic_1164.all;
use work.ncl_signals.all;
use work.FIR_pack.all;
entity FIR_BaughWooley_RCA_2Stage is
	port(x     : in  dual_rail_logic_vector(9 downto 0);
		 c     : in  Ctype;
		 ki    : in  std_logic;
		 rst   : in  std_logic;
		 sleepin : in  std_logic;
		 ko    : out std_logic;
		 sleepout : out std_logic;
		 y     : out dual_rail_logic_vector(10 downto 0));
end;

architecture arch of FIR_BaughWooley_RCA_2Stage is
	component BaughWooleyMult is
	port(x             : in  dual_rail_logic_vector(9 downto 0);
		 y             : in  dual_rail_logic_vector(6 downto 0);
		 sleep 		   : in  std_logic;
		 p        : out dual_rail_logic_vector(15 downto 0));
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
    generic(width: in integer := 4);
    port(a: IN dual_rail_logic_vector(width-1 downto 0);
        ki, rst, sleep: in std_logic;
        ko: OUT std_logic);
	end component;
	
	component genregm is
	generic(width : in integer := 4);
	port(a     : IN  dual_rail_logic_vector(width - 1 downto 0);
		 sleep : in  std_logic;
		 z     : out dual_rail_logic_vector(width - 1 downto 0));
	end component;
	
	type Ktype is array (15 downto 0) of std_logic;
	type Stage1 is array (15 downto 0) of dual_rail_logic_vector(15 downto 0);
	type Stage2 is array (7 downto 0) of dual_rail_logic_vector(15 downto 0);
	type Stage3 is array (3 downto 0) of dual_rail_logic_vector(15 downto 0);
	type Stage4 is array (1 downto 0) of dual_rail_logic_vector(15 downto 0);
	
	signal Xarray : Xtype;
	signal karray, Sarray : Ktype;
	signal S1, S1_Reg: Stage1;
	signal S1_Concat : dual_rail_logic_vector(255 downto 0);
	signal S2: Stage2;
	signal S3: Stage3;
	signal S4: Stage4;
	signal S5, S5_Reg: dual_rail_logic_vector(15 downto 0);
	signal ko_temp, sleep_shift, ko_pipe1, ko_OutReg : std_logic;

begin

	Xarray(0) <= x;
	karray(15) <= ko_Pipe1;
	Sarray(0) <= sleepin;
	sleep_shift <= Sarray(15);
	ko_temp <= karray(0);
	ko <= ko_temp;
	
	GenShiftReg: for i in 1 to 15 generate
		Rega: ShiftRegMTNCL
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
	
	GenMult: for i in 0 to 15 generate 
		Multa: BaughWooleyMult
			port map(Xarray(i), c(i), sleep_shift, S1(i));
	end generate;
	
	S1_Concat <= S1(0) & S1(1) & S1(2) & S1(3) & S1(4) & S1(5) & S1(6) & S1(7) & S1(8) & S1(9) & S1(10)
	    & S1(11) & S1(12) & S1(13) & S1(14) & S1(15);
	
	--Pipeline Register
	Comp: compm
			generic map(256)
			port map(S1_Concat, ko_OutReg, rst, sleep_shift, ko_Pipe1);
			
	Pipe1: for i in 0 to 15 generate 
		Pipe1a: genregm
			generic map(16)
			port map(S1(i), ko_Pipe1, S1_Reg(i));
	end generate;
	
	GenAdd1: for i in 0 to 7 generate 
		Adda: RCA_genm
		generic map(16)
		port map(S1_Reg(2*i), S1_Reg(2*i + 1), ko_Pipe1, S2(i));
	end generate;
	
	GenAdd2: for i in 0 to 3 generate
		Adda: RCA_genm
		generic map(16)
		port map(S2(2*i), S2(2*i + 1), ko_Pipe1, S3(i));
	end generate;
	
	GenAdd3: for i in 0 to 1 generate
		Adda: RCA_genm
		generic map(16)
		port map(S3(2*i), S3(2*i + 1), ko_Pipe1, S4(i));
	end generate;
	
	FinalAdd: RCA_genm 
		generic map(16)
		port map(S4(0), S4(1), ko_Pipe1, S5);
		
	-- Output Register
	CompOut: compm
		generic map(16)
		port map(S5, ki, rst, ko_Pipe1, ko_OutReg);
	OutReg: genregm
		generic map(16)
		port map(S5, ko_OutReg, S5_Reg);
	
	y <= S5_Reg(15 downto 5);
	sleepout <= ko_OutReg;
	
end arch;