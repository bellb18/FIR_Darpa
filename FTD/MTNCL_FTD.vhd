Library IEEE;
use IEEE.std_logic_1164.all;
use work.ncl_signals.all;
use work.FIR_pack.all;
entity MTNCL_FTD is
		port(x        : in  std_logic_vector(9 downto 0);
			 c        : in  CType;
			 clk       : in  std_logic;
			 rst      : in  std_logic;
			 y        : out std_logic_vector(10 downto 0));
end;

architecture arch of MTNCL_FTD is
	component Dadda_Pipelined_RCAPiped3 is
	port(x     : in  dual_rail_logic_vector(9 downto 0);
		 y     : in  dual_rail_logic_vector(6 downto 0);
		 ki    : in std_logic;
		 sleep : in  std_logic;
		 rst      : in  std_logic;
		 sleepOut : out std_logic;
		 ko 	  : out std_logic;
		 p     : out dual_rail_logic_vector(15 downto 0));
	end component;

	component Carry_Select_16bm is
		port(
			X    : in  dual_rail_logic_vector(15 downto 0);
			Y    : in  dual_rail_logic_vector(15 downto 0);
			ki	 : in std_logic;
			sleep : in  std_logic;
			rst  : in std_logic;
			sleepOut : out std_logic;
			ko 	     : out std_logic;
			S   : out dual_rail_logic_vector(15 downto 0));
	end component;

	component ShiftRegMTNCL4 is
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
	
	component th22n_a is
	port(a   : in  std_logic;
		 b   : in  std_logic;
		 rst : in  std_logic;
		 z   : out std_logic);
	end component;

	component th22d_a is
	port(a   : in  std_logic;
		 b   : in  std_logic;
		 rst : in  std_logic;
		 z   : out std_logic);
	end component;
	
	component Sync_to_Async_Interface is
		port(x_single_rail        : in  std_logic_vector(9 downto 0);
			 ko        : in  std_logic;
			 clk       : in  std_logic;
			 rst      : in  std_logic;
			 sleep 		: out std_logic;
			 x_dual_rail        : out dual_rail_logic_vector(9 downto 0));
	end component;
	
	component Async_to_Sync_Interface is
		port(y        : in  dual_rail_logic_vector(10 downto 0);
			 sleepout        : in  std_logic;
			 clk       : in  std_logic;
			 rst      : in  std_logic;
			 ki 	   : out std_logic;
			 z        : out std_logic_vector(10 downto 0));
	end component;


type Ytype is array (1 to 15) of DUAL_RAIL_LOGIC_VECTOR(15 downto 0);
signal Xarray: Xtype;
signal A: Ytype;
signal B: Ytype;
signal sleepax: std_logic_vector(15 downto 1);
signal koa: std_logic_vector(15 downto 1);
signal sleepr: std_logic_vector(15 downto 1);
signal sleepa: std_logic_vector(15 downto 1);
signal sleepx: std_logic_vector(15 downto 1);
signal kor: std_logic_vector(14 downto 0);
signal kox: std_logic_vector(15 downto 0);
signal koxr: std_logic_vector(14 downto 0);
signal sleep, ki, sleepout, ko: std_logic;
signal X_dual_rail: dual_rail_logic_vector(9 downto 0);
signal solution: dual_rail_logic_vector(15 downto 0);
signal truncated_solution: dual_rail_logic_vector(10 downto 0);

begin
	ADDER15: Carry_Select_16bm
	port map(A(15), B(15), ki, sleepax(15), rst, sleepout, koa(15), solution);
	
	GenAdder: for i in 14 downto 1 generate
	ADDER: Carry_Select_16bm
	port map(A(i), B(i), koa(i + 1), sleepax(i), rst, sleepa(i+1), koa(i), A(i+1));
	end generate GenAdder;
	
	GenMult: for i in 15 downto 1 generate
	Mult: Dadda_Pipelined_RCAPiped3
	port map(Xarray(i), c(i), koa(i), sleepr(i), rst, sleepx(i), kox(i), B(i));
	end generate GenMult;
	
	Mult0: Dadda_Pipelined_RCAPiped3
	port map(X_dual_rail, c(0), koa(1), sleep, rst, sleepa(1), kox(0), A(1));
	
	ShiftReg0: ShiftRegMTNCL4
	generic map(10, "0000000000")
	port map(X_dual_rail, koxr(1), rst, sleep, Xarray(1), sleepr(1), kor(0));
	
	GenReg: for i in 13 downto 1 generate
	ShiftReg: ShiftRegMTNCL4
	generic map(10, "0000000000")
	port map(Xarray(i), koxr(i+1), rst, sleepr(i), Xarray(i+1), sleepr(i+1), kor(i));
	end generate GenReg;
	
	ShiftReglast: ShiftRegMTNCL4
	generic map(10, "0000000000")
	port map(Xarray(14), kox(15), rst, sleepr(14), Xarray(15), sleepr(15), kor(14));
	
	THngate: for i in 15 downto 1 generate
	THout: th22n_a
	port map (sleepa(i), sleepx(i), rst, sleepax(i));
	end generate THngate;
	
	THdgate: for i in 14 downto 0 generate
	THout: th22d_a
	port map (kor(i), kox(i), rst, koxr(i));
	end generate THdgate;

	--ko signal not really needed, but helps to clarify which signal is used for RFD/RFN
	ko <= koxr(0);
	truncated_solution <= solution(15 downto 5);

	sync_to_async: Sync_to_Async_Interface
	port map(x, ko, clk, rst, sleep, X_dual_rail);

	async_to_sync: Async_to_Sync_Interface
	port map(truncated_solution, sleepout, clk, rst, ki, y);
	
	
end arch;