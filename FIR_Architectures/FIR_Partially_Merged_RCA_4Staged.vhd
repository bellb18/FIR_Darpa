Library IEEE;
use IEEE.std_logic_1164.all;
use work.ncl_signals.all;
use work.FIR_pack.all;
entity FIR_Partially_Merged_RCA_4Staged is
	port(x     : in  dual_rail_logic_vector(9 downto 0);
		 c     : in  Ctype;
		 ki    : in  std_logic;
		 rst   : in  std_logic;
		 sleep : in  std_logic;
		 ko    : out std_logic;
		 sleepout : out std_logic;
		 y     : out dual_rail_logic_vector(10 downto 0));
end;

architecture arch of FIR_Partially_Merged_RCA_4Staged is
	component Merged_Unpipelined is
	port(x     : in  dual_rail_logic_vector(9 downto 0);
		 y     : in  dual_rail_logic_vector(6 downto 0);
		 a     : in  dual_rail_logic_vector(9 downto 0);
		 b     : in  dual_rail_logic_vector(6 downto 0);
		 sleep : in  std_logic;
		 p     : out dual_rail_logic_vector(15 downto 0));
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
	component genregm is
	generic(width : in integer :=4);
	port(a		: IN dual_rail_logic_vector(width - 1 downto 0);
		 sleep	: IN std_logic;
		 z		: out dual_rail_logic_vector(width - 1 downto 0));
	end component;
	
	
	component compm is
    generic(width: in integer := 4);
    port(a: IN dual_rail_logic_vector(width-1 downto 0);
        ki, rst, sleep: in std_logic;
        ko: OUT std_logic);
	end component;
	
	type Ktype is array (15 downto 0) of std_logic;
	type Stage1 is array (7 downto 0) of dual_rail_logic_vector(15 downto 0);
	type Stage2 is array (3 downto 0) of dual_rail_logic_vector(15 downto 0);
	type Stage3 is array (1 downto 0) of dual_rail_logic_vector(15 downto 0);
	
	signal Xarray : Xtype;
	signal karray, Sarray : Ktype;
	signal S1, S1_Reg: Stage1;
	signal S2, S2_Reg: Stage2;
	signal S3, S3_Reg: Stage3;
	signal S4: dual_rail_logic_vector(15 downto 0);
	signal sleep_shift : std_logic;
	signal ko_temp, ko_pipe1, ko_OutReg1, ko_OutReg2, ko_OutReg3: std_logic;
	signal S1_X: dual_rail_logic_vector(127 downto 0);
	signal S2_X: dual_rail_logic_vector(63 downto 0);
	signal S3_X: dual_rail_logic_vector(31 downto 0);
	signal S4_Z_Reg : dual_rail_logic_vector(15 downto 0);


begin

	Xarray(0) <= x;
	karray(15) <= ko_pipe1;
	Sarray(0) <= sleep;
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
	
	GenMult: for i in 0 to 7 generate -- 00.0000 0000 0000 001
		Multa: Merged_Unpipelined
			port map(Xarray(2*i), c(2*i), Xarray(2*i + 1), c(2*i + 1), sleep_shift, S1(i));
	end generate;



	S1_X <= S1(0) & S1(1) & S1(2) & S1(3) & S1(4) & S1(5) & S1(6) & S1(7);

	--Pipeline 1 Register

	Comp1a: compm
		generic map(128)
		port map(S1_X, ko_OutReg1, rst, sleep_shift, ko_Pipe1);
		
	genrega: for i in 0 to 7 generate
		
	Pipe1: genregm
		generic map(16)
		port map(S1(i), ko_Pipe1, S1_Reg(i));

	end generate;
	
	--End Pipeline 1
	
	
	GenAdd2: for i in 0 to 3 generate
		Adda: RCA_genm
		generic map(16)
		port map(S1_Reg(2*i), S1_Reg(2*i + 1), ko_Pipe1, S2(i));
	end generate;
	
	
	S2_X <= S2(0) & S2(1) & S2(2) & S2(3);
	
	--Pipeline 2 Register
	
	Comp2a: compm
		generic map(64)
		port map(S2_X, ko_OutReg2, rst, ko_Pipe1, ko_OutReg1);
		
	genregb: for i in 0 to 3 generate
		
	Pipe2: genregm
		generic map(16)
		port map(S2(i), ko_OutReg1, S2_Reg(i));

	end generate;
		
	--End Pipeline 2
	
	
	GenAdd3: for i in 0 to 1 generate
		Adda: RCA_genm
		generic map(16)
		port map(S2_Reg(2*i), S2_Reg(2*i + 1), ko_OutReg1, S3(i));
	end generate;


	S3_X <= S3(0) & S3(1);

	--Pipeline 3 Register
	
	Comp3a: compm
		generic map(32)
		port map(S3_X, ko_OutReg3, rst, ko_OutReg1, ko_OutReg2);
	
	genregc: for i in 0 to 1 generate
	
	Pipe3: genregm
		generic map(16)
		port map(S3(i), ko_OutReg2, S3_Reg(i));

	end generate;

	--End Pipeline 3


	FinalAdd: RCA_genm
		generic map(16) 
		port map(S3_Reg(0), S3_Reg(1), ko_OutReg2, S4);
		
		
	--Output Register
	CompOut: compm
		generic map(16)
		port map(S4, ki, rst, ko_OutReg2, ko_OutReg3);
	OutReg: genregm
		generic map(16)
		port map(S4, ko_OutReg3, S4_Z_Reg);
		
	y <= S4_Z_Reg(15 downto 5);
	sleepout <= ko_OutReg3;
	
end arch;