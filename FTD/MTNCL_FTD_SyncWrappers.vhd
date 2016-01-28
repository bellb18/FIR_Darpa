Library IEEE;
use IEEE.std_logic_1164.all;
use work.ncl_signals.all;
use work.FIR_pack.all;
entity MTNCL_FTD_SyncWrappers is
		port(x        : in  std_logic_vector(9 downto 0);
			 c        : in  CType;
			 clk       : in  std_logic;
			 rst      : in  std_logic;
			 y        : out std_logic_vector(10 downto 0));
end;

architecture arch of MTNCL_FTD_SyncWrappers is
	component MTNCL_FTD is
		port(x        : in  dual_rail_logic_vector(9 downto 0);
			 c        : in  CType;
			 ki       : in  std_logic;
			 rst      : in  std_logic;
			 sleep    : in  std_logic;
			 ko       : out std_logic;
			 sleepout : out std_logic;
			 y        : out dual_rail_logic_vector(10 downto 0));
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

signal sleep, ki, sleepout, ko: std_logic;
signal X_dual_rail: dual_rail_logic_vector(9 downto 0);
signal truncated_solution: dual_rail_logic_vector(10 downto 0);

begin
	
	sync_to_async: Sync_to_Async_Interface
	port map(x, ko, clk, rst, sleep, X_dual_rail);
	
	FTD: MTNCL_FTD
	port map(X_dual_rail, c, ki, rst, sleep, ko, sleepout, truncated_solution);

	async_to_sync: Async_to_Sync_Interface
	port map(truncated_solution, sleepout, clk, rst, ki, y);
	
	
end arch;