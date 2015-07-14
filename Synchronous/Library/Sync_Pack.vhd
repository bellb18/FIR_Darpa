library ieee;
package Sync_gates is
	use ieee.std_logic_1164.all;
	component INV_A is
		port(a : in  std_logic;
			 z : out std_logic);
	end component;
end Sync_gates;