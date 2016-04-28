
-----------------------------------------
-- Definition of RCA
-----------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
entity RCA_16b is
	port(
		X   : in  std_logic_vector(15 downto 0);
		Y   : in  std_logic_vector(15 downto 0);
		clk : in  std_logic;
		rst : in  std_logic;
		S   : out std_logic_vector(15 downto 0)
	);
end;

architecture arch of RCA_16b is
	component HA
		port(X, Y    : in  std_logic;
			 COUT, S : out std_logic);
	end component;
	component FA is
		port(
			CIN   : in  std_logic;
			X     : in  std_logic;
			Y     : in  std_logic;
			COUT  : out std_logic;
			S     : out std_logic);
	end component;

	component reg_gen is
		generic(width : integer := 16);
		port(
			D   : in  std_logic_vector(width - 1 downto 0);
			clk : in  std_logic;
			rst : in  std_logic;
			Q   : out std_logic_vector(width - 1 downto 0));
	end component;

	signal carryA, X_reg, Y_reg     : std_logic_vector(15 downto 0);
	signal sReg 					: std_logic_vector(15 downto 0);

begin

	-- Input Registers
	inRegX: reg_gen
		generic map(16)
		port map(X, clk, rst, X_reg);
	inRegY: reg_gen
		generic map(16)
		port map(Y, clk, rst, Y_reg);

	HAa : HA
		port map(X_reg(0), Y_reg(0), carryA(0), sReg(0));
	FAGen1m : for i in 1 to 15 generate
		FAa : FA
			port map(X_reg(i), Y_reg(i), carryA(i - 1), carryA(i), sReg(i));
	end generate;

	-- Output Register
	outReg : reg_gen
		generic map(16)
		port map(sReg, clk, rst, S);

end arch;
