Library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;
use ieee.std_logic_arith.all;
use work.ncl_signals.all;
use work.functions.all;
use work.PPGen_pack.all;
use ieee.math_real.all;

entity tb_FIR_Merged_Unpipelined is
end;

architecture arch of tb_FIR_Merged_Unpipelined is
	signal X : DUAL_RAIL_LOGIC_VECTOR(9 downto 0);
	signal C : CppType;
	signal Y    : DUAL_RAIL_LOGIC_VECTOR(10 downto 0);
	signal sleep, ki, ko, sleepout, rst : std_logic;
	
component FIR_Merged_Unpipelined is
	port(x        : in  dual_rail_logic_vector(9 downto 0);
		 c        : in  CppType;
		 ki       : in  std_logic;
		 rst      : in  std_logic;
		 sleep    : in  std_logic;
		 ko       : out std_logic;
		 sleepout : out std_logic;
		 y        : out dual_rail_logic_vector(10 downto 0));
end component;

begin
	CUT : FIR_Merged_Unpipelined
		port map(X, C, ki, rst, sleep, ko, sleepout, Y);

	inputs : process
		type Ctype is array (15 downto 0) of std_logic_vector(6 downto 0);
		variable Xin       : STD_LOGIC_VECTOR(9 downto 0);
		variable Cin       : Ctype;

	begin
		
		for i in 0 to 9 loop
			X(i).rail1 <= '0';
			X(i).rail0 <= '0';
		end loop;
		
		rst <= '1';
		sleep <= '1';
		wait for 50 ns;
		rst <= '0';
		for i in 0 to 7 loop
				C(2*i) <= Int_to_DR(-3*i, 7);
				Cin(2*i) := conv_std_logic_vector(-3*i, 7);
				C(2*i + 1) <= Int_to_DR(2*i, 7);
				Cin(2*i + 1) := conv_std_logic_vector(2*i, 7);
		end loop;
		
		for i in 0 to 1023 loop
				sleep <= '0';
				wait for 1 ns;

				X   <= Int_to_DR(i, 10);
				Xin := conv_std_logic_vector(i, 10);

				wait until ko = '0';
				sleep <= '1';
				wait for 1 ns;
				
				for i in 0 to 9 loop
					X(i).rail1 <= '0';
					X(i).rail0 <= '0';
				end loop;
				wait until ko = '1';
			end loop;
		--end loop;

		for i in 0 to 9 loop
			X(i).rail1 <= '1';
			X(i).rail0 <= '0';
		end loop;
		wait;

	end process;

	outputs : process(Y)
		variable Yout : STD_LOGIC_VECTOR(10 downto 0);
	begin
		if is_data(Y) then
			ki <= '0';
			Yout := to_SL(Y);
		end if;
		
		if is_null(Y) then
			ki <= '1';
		end if;

	end process;
	
end arch;