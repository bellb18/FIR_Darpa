Library IEEE;
use IEEE.std_logic_1164.all;
use work.ncl_signals.all;
package FIR_Pack is
	type XType is array (15 downto 0) of dual_rail_logic_vector(9 downto 0);
	type X16Type is array (15 downto 0) of dual_rail_logic_vector(15 downto 0);
	type CType is array (15 downto 0) of dual_rail_logic_vector(6 downto 0);
	type CSLType is array (15 downto 0) of std_logic_vector(6 downto 0);
	
	type XarrayType is array (0 to 99) of integer;
	constant Xarray : XarrayType := (-36, -480, 486, 294, -49, -243, -162, -424, -58, -253, 283, -235, 501, 104, 352, -337, 474, -60, 84, -25, 140, -481, 211, 178, -289, 491, -386, 90, -511, -283, -41, 437, 107, -423, -118, -52, 510, -84, 329, -223, -244, 145, 369, -115, 486, 354, -218, -106, -185, -107, 92, -37, -62, -509, 395, -425, -509, 157, -466, 49, 508, -305, -205, -325, -153, -108, -286, 409, 420, 440, -263, 465, 281, -120, 416, -92, 380, 10, 365, 471, 382, 338, -164, 200, 298, -390, -324, 448, -422, -138, -482, 511, -457, 424, 89, -227, 210, -156, 320, -127);
end package;