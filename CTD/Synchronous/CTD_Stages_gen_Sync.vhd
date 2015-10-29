Library IEEE;
use IEEE.std_logic_1164.all;
use work.ncl_signals.all;
entity CTD_Stages_gen_Sync is
	generic(size : in integer := 4);
	port(X        : in  std_logic_vector(10 downto 0);
		 skip     : in  std_logic;
		 clk  : in  std_logic;
		 rst      : in  std_logic;
		 Z        : out std_logic_vector(10 downto 0));
end;

architecture arch of CTD_Stages_gen_Sync is
	component reg_gen is
		generic(width : integer := 16);
		port(
			D   : in  std_logic_vector(width - 1 downto 0);
			clk : in  std_logic;
			rst : in  std_logic;
			Q   : out std_logic_vector(width - 1 downto 0));
	end component;
	
	component MUX21_C is
	port(D0, D1, SD : in  std_logic;
		 Z : out std_logic);
	end component;

	-- Signal Declarations
	type CTDXtype is array (0 to size - 1) of STD_LOGIC_VECTOR(10 downto 0);
	signal s1_out, s2_out, s3_out, s2_in : std_logic_vector(10 downto 0);
	signal Xarray : CTDXtype;
begin
	Xarray(0) <= X;
	-- For Size 1 (correct)
	S1: if (size = 1) generate
		Reg1 : reg_gen
			generic map(11)
			port map(X, clk, rst, s1_out);
		GenS1 : for i in 0 to 10 generate
			MDataR1 : MUX21_C
				port map(s1_out(i), X(i), skip, Z(i));
		end generate;
	end generate;
	
	-- For size 2 (correct)
	S2: if (size = 2) generate
		RegFirst : reg_gen
			generic map(11)
			port map(Xarray(0), clk, rst, Xarray(1));
		
		RegLast : reg_gen
			generic map(11)
			port map(Xarray(1), clk, rst, s2_out);
			
		GenS2 : for i in 0 to 10 generate
			MDataR0 : MUX21_C
				port map(s2_out(i), X(i), skip, Z(i));
		end generate;
	end generate;
	
	-- For Size > 2
	S3: if (size > 2) generate
		RegFirst : reg_gen
			generic map(11)
			port map(Xarray(0), clk, rst, Xarray(1));
			
		RegMidGen : for i in 1 to size - 2 generate
			RegMid: reg_gen
				generic map(11)
				port map(Xarray(i), clk, rst, Xarray(i + 1));
		end generate;
		
		RegLast : reg_gen
			generic map(11)
			port map(Xarray(size - 1), clk, rst, s3_out);
		
		GenS3 : for i in 0 to 10 generate
			MDataR0 : MUX21_C
				port map(s3_out(i), X(i), skip, Z(i));
		end generate;
	end generate;

end arch;