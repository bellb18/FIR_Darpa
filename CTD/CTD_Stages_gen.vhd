Library IEEE;
use IEEE.std_logic_1164.all;
use work.ncl_signals.all;
entity CTD_Stages_genm is
	generic(size : in integer := 4);
	port(X        : in  dual_rail_logic_vector(10 downto 0);
		 skip     : in  std_logic;
		 ki       : in  std_logic;
		 sleep  : in  std_logic;
		 rst      : in  std_logic;
		 sleepout : out std_logic;
		 ko       : out std_logic;
		 Z        : out dual_rail_logic_vector(10 downto 0));
end;

architecture arch of CTD_Stages_genm is
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
	
	component MUX is
	port(a, b, s : in  std_logic;
		 z : out std_logic);
	end component;

	component MUX_genm is
		generic(width : in integer := 8);
		port(A     : in  dual_rail_logic_vector(width - 1 downto 0);
			 B     : in  dual_rail_logic_vector(width - 1 downto 0);
			 S     : in  dual_rail_logic;
			 sleep : in  std_logic;
			 Z     : out dual_rail_logic_vector(width - 1 downto 0));
	end component;

	-- Signal Declarations
	type CTDXtype is array (0 to size - 1) of DUAL_RAIL_LOGIC_VECTOR(10 downto 0);
	signal s1_sleepout, s1_ko, s2_sleepout1, s3_sleepout, s2_sleepout2, s2_ko1, s2_ko2 : std_logic;
	signal s1_out, s2_out, s3_out, s2_in : dual_rail_logic_vector(10 downto 0);
	signal Xarray : CTDXtype;
	signal karray, sarray : std_logic_vector(size - 1 downto 0);

begin
	Xarray(0) <= X;
	-- For Size 1 (correct)
	S1: if (size = 1) generate
		Reg1 : ShiftRegMTNCL
			generic map(11, "00000000000")
			port map(X, ki, rst, sleep, s1_out, s1_sleepout, s1_ko);
		GenS1 : for i in 0 to 10 generate
			MDataR1 : MUX
				port map(s1_out(i).rail1, X(i).rail1, skip, Z(i).rail1);
			MDataR0 : MUX
				port map(s1_out(i).rail0, X(i).rail0, skip, Z(i).rail0);
		end generate;
		MSleep : MUX
			port map(s1_sleepout, sleep, skip, sleepout);
		Mko : MUX
			port map(s1_ko, ki, skip, ko);
	end generate;
	
	-- For size 2 (correct)
	S2: if (size = 2) generate
		RegFirst : ShiftRegMTNCL
			generic map(11, "00000000000")
			port map(Xarray(0), s2_ko2, rst, sleep, Xarray(1), s2_sleepout1, s2_ko1);
		Mko : MUX
			port map(s2_ko1, ki, skip, ko);
		
		RegLast : ShiftRegMTNCL
			generic map(11, "00000000000")
			port map(Xarray(1), ki, rst, s2_sleepout1, s2_out, s2_sleepout2, s2_ko2);
			
		GenS2 : for i in 0 to 10 generate
			MDataR0 : MUX
				port map(s2_out(i).rail0, X(i).rail0, skip, Z(i).rail0); -- Is this sleep wrong?
			MDataR1 : MUX
				port map(s2_out(i).rail1, X(i).rail1, skip, Z(i).rail1); -- Is this sleep wrong?
		end generate;
		
		MSleep : MUX
			port map(s2_sleepout2, sleep, skip, sleepout);
	end generate;
	
	-- For Size > 2
	S3: if (size > 2) generate
		RegFirst : ShiftRegMTNCL
			generic map(11, "00000000000")
			port map(Xarray(0), karray(1), rst, sleep, Xarray(1), sarray(1), karray(0));
		Mko : Mux
			port map(karray(0), ki, skip, ko);
			
		RegMidGen : for i in 1 to size - 2 generate
			RegMid: ShiftRegMTNCL
				generic map(11, "00000000000")
				port map(Xarray(i), karray(i + 1), rst, sarray(i), Xarray(i + 1), sarray(i + 1), karray(i));
		end generate;
		
		RegLast : ShiftRegMTNCL
			generic map(11, "00000000000")
			port map(Xarray(size - 1), ki, rst, sarray(size - 1), s3_out, s3_sleepout, karray(size - 1));
		
		GenS3 : for i in 0 to 10 generate
			MDataR0 : MUX
				port map(s3_out(i).rail0, X(i).rail0, skip, Z(i).rail0);
			MDataR1 : MUX
				port map(s3_out(i).rail1, X(i).rail1, skip, Z(i).rail1);
		end generate;
		
		MSleep : MUX
			port map(s3_sleepout, sleep, skip, sleepout);
	end generate;
	

end arch;