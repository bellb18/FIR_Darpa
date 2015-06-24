Library IEEE;
use IEEE.std_logic_1164.all;
use work.ncl_signals.all;
package FIR_Pack is
	type XType is array (15 downto 0) of dual_rail_logic_vector(9 downto 0);
	type CType is array (15 downto 0) of dual_rail_logic_vector(6 downto 0);
end package;