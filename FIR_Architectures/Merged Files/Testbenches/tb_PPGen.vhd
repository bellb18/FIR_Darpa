Library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;
use ieee.std_logic_arith.all;
use work.ncl_signals.all;
use work.functions.all;
use work.FIR_pack.all;
use ieee.math_real.all;

entity tb_PPGen is
end;

architecture arch of tb_PPGen is
	signal X : XType;
	signal C : CType;

	signal s : std_logic;

	signal Z0             : dual_rail_logic_vector(15 downto 0);
	signal Z1             : dual_rail_logic_vector(31 downto 0);
	signal Z2             : dual_rail_logic_vector(47 downto 0);
	signal Z3             : dual_rail_logic_vector(63 downto 0);
	signal Z4             : dual_rail_logic_vector(79 downto 0);
	signal Z5             : dual_rail_logic_vector(95 downto 0);
	signal Z6, Z7, Z8, Z9 : dual_rail_logic_vector(111 downto 0);
	signal Z10            : dual_rail_logic_vector(96 downto 0);
	signal Z11            : dual_rail_logic_vector(79 downto 0);
	signal Z12            : dual_rail_logic_vector(63 downto 0);
	signal Z13            : dual_rail_logic_vector(48 downto 0);
	signal Z14            : dual_rail_logic_vector(31 downto 0);
	signal Z15            : dual_rail_logic_vector(15 downto 0);

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

begin
	CUT : Merged_PPGen
		port map(X, C, s, Z0, Z1, Z2, Z3, Z4, Z5, Z6, Z7, Z8, Z9, Z10, Z11, Z12, Z13, Z14, Z15);

	inputs : process
	begin

		-- NULL Cycle
		for i in 0 to 15 loop
			for j in 0 to 6 loop
				for k in 0 to 9 loop
					X(i)(k).rail1 <= '0';
					X(i)(k).rail0 <= '0';
					C(i)(j).rail1 <= '0';
					C(i)(j).rail0 <= '0';
				end loop;
			end loop;
		end loop;

		s <= '1';
		wait for 50 ns;

		s <= '0';
		wait for 1 ns;

		-- Data 1
		for i in 0 to 15 loop
			for j in 0 to 6 loop
				for k in 0 to 9 loop
					X(i)(k).rail1 <= '1';
					X(i)(k).rail0 <= '0';
					C(i)(j).rail1 <= '1';
					C(i)(j).rail0 <= '0';
				end loop;
			end loop;
		end loop;

		wait for 100 ns;
		s <= '1';
		wait for 2 ns;

		-- NULL Cycle
		for i in 0 to 15 loop
			for j in 0 to 6 loop
				for k in 0 to 9 loop
					X(i)(k).rail1 <= '0';
					X(i)(k).rail0 <= '0';
					C(i)(j).rail1 <= '0';
					C(i)(j).rail0 <= '0';
				end loop;
			end loop;
		end loop;
		wait;

	end process;

end arch;