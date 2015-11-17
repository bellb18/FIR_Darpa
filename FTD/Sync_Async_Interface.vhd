--Synchronous to asynchronous conversion
Library IEEE;
use IEEE.std_logic_1164.all;
use work.ncl_signals.all;
entity Sync_to_Async_Interface is
		port(x_single_rail        : in  std_logic_vector(9 downto 0);
			 ko        : in  std_logic;
			 clk       : in  std_logic;
			 rst      : in  std_logic;
			 sleep 		: out std_logic;
			 x_dual_rail        : out dual_rail_logic_vector(9 downto 0));
end;

architecture arch of Sync_to_Async_Interface is
	
	component INV_A is
	port(a : in  std_logic;
		 z : out std_logic);
	end component;
	
	component NAND2 is
	port(a, b: in  std_logic;
		 z : out std_logic);
	end component;
	
	component reg is
	port(
		D   : in  std_logic;
		clk : in  std_logic;
		rst : in  std_logic;
		Q   : out std_logic);
	end component;

signal invRst, DFF_Rst: std_logic;
signal Xrail1, Xrail0, invRail1: std_logic_vector(9 downto 0);

begin
	invKo: INV_A
	port map(ko, sleep);
	
	invReset: INV_A
	port map(rst, invRst);
	
	DFF_Reset: NAND2
	port map(ko, invRst, DFF_Rst);
	
	rail1_DFF: for i in 9 downto 0 generate
	rail1: reg
	port map(x_single_rail(i), clk, DFF_Rst, Xrail1(i));
	end generate rail1_DFF;
	
	--Invert X (X.rail1) to get X.rail0
	inv_Rail1: for i in 9 downto 0 generate
	invertedRail1: INV_A
	port map(x_single_rail(i), invRail1(i));
	end generate inv_Rail1;

	rail0_DFF: for i in 9 downto 0 generate
	rail0: reg
	port map(invRail1(i), clk, DFF_Rst, Xrail0(i));
	end generate rail0_DFF;

	singleRail_to_dualRail: for i in 9 downto 0 generate
	X_dual_rail(i).RAIL0 <= Xrail0(i);
	X_dual_rail(i).RAIL1 <= Xrail1(i);
	end generate singleRail_to_dualRail;
	
end arch;

--Synchronous to asynchronous conversion
Library IEEE;
use IEEE.std_logic_1164.all;
use work.ncl_signals.all;
entity Async_to_Sync_Interface is
		port(y        : in  dual_rail_logic_vector(10 downto 0);
			 sleepout        : in  std_logic;
			 clk       : in  std_logic;
			 rst      : in  std_logic;
			 ki 	   : out std_logic;
			 z        : out std_logic_vector(10 downto 0));
end;

architecture arch of Async_to_Sync_Interface is
	
	component reg is
	port(
		D   : in  std_logic;
		clk : in  std_logic;
		rst : in  std_logic;
		Q   : out std_logic);
	end component;
	
	component regD is
	port(
		D   : in  std_logic;
		clk : in  std_logic;
		rst : in  std_logic;
		Q   : out std_logic);
	end component;

begin
	ignoreNULLreg: regD
	port map('0', clk, sleepout, ki);

	outputRegs: for i in 10 downto 0 generate
	outputReg: reg
	port map(y(i).RAIL1, clk, rst, z(i));
	end generate;
	
end arch;