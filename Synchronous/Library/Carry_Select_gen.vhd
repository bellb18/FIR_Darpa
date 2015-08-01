
-----------------------------------------
-- Definition of Hybrid Carry Look Ahead(CLA)
-- and Ripple Carry Adder(RCA) 4 Bits
-----------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
entity Carry_Select_16b is
	port(
		X   : in  std_logic_vector(15 downto 0);
		Y   : in  std_logic_vector(15 downto 0);
		clk : in  std_logic;
		rst : in  std_logic;
		S   : out std_logic_vector(15 downto 0)
	);
end;

architecture arch of Carry_Select_16b is
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

	component FA1 is
		port(X     : std_logic;
			 Y     : in  std_logic;
			 COUT  : out std_logic;
			 S     : out std_logic);
	end component;

	component MUX is
		port(A : in  std_logic;
			 B : in  std_logic;
			 S : in  std_logic;
			 Z : out std_logic);
	end component;

	component reg_gen is
		generic(width : integer := 16);
		port(
			D   : in  std_logic_vector(width - 1 downto 0);
			clk : in  std_logic;
			rst : in  std_logic;
			Q   : out std_logic_vector(width - 1 downto 0));
	end component;

	signal carryA, carry1, carry0     : std_logic_vector(7 downto 0);
	signal inputXReg, inputYReg, sReg : std_logic_vector(15 downto 0);
	signal sReg0, sReg1               : std_logic_vector(7 downto 0);

begin

	-- Input Registers
	inRegX : reg_gen
		generic map(16)
		port map(X, clk, rst, inputXReg);
	inRegY : reg_gen
		generic map(16)
		port map(Y, clk, rst, inputYReg);

	HAa : HA
		port map(inputXReg(0), inputYReg(0), carryA(0), sReg(0));
	FAGen1m : for i in 1 to 7 generate
		FAa : FA
			port map(inputXReg(i), inputYReg(i), carryA(i - 1), carryA(i), sReg(i));
	end generate;

	-- Carry = 0
	HAb : HA
		port map(inputXReg(8), inputYReg(8), carry0(0), sReg0(0));
	FAGen2m : for i in 1 to 7 generate
		FAa : FA
			port map(inputXReg(i + 8), inputYReg(i + 8), carry0(i - 1), carry0(i), sReg0(i));
	end generate;

	-- Carry = 1
	FAa : FA1
		port map(inputXReg(8), inputYReg(8), carry1(0), sReg1(0));
	FAGen3m : for i in 1 to 7 generate
		FAa : FA
			port map(inputXReg(i + 8), inputYReg(i + 8), carry1(i - 1), carry1(i), sReg1(i));
	end generate;

	-- Multiplex
	MUXmA : for i in 0 to 7 generate
		MUXa : MUX
			port map(sReg0(i), sReg1(i), carryA(7), sReg(i + 8));
	end generate;

	-- Output Register
	outReg : reg_gen
		generic map(16)
		port map(sReg, clk, rst, S);

end arch;