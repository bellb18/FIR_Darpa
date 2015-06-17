Library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use ieee.std_logic_arith.all;


entity tb_Boolean_Adder is
end;

architecture arch of tb_Boolean_Adder is
	signal a     : STD_LOGIC;
	signal b     : STD_LOGIC;
	signal carry_in  : STD_LOGIC;
	signal carry_out : STD_LOGIC;
	signal sum   : STD_LOGIC;

	signal a_f_1     : STD_LOGIC;
	signal b_f_1     : STD_LOGIC;
	signal carry_in_f_1  : STD_LOGIC;
	signal carry_out_f_1 : STD_LOGIC;
	signal sum_f_1   : STD_LOGIC;
		
	signal a_h     : STD_LOGIC;
	signal b_h     : STD_LOGIC;
	signal carry_in_h  : STD_LOGIC;
	signal carry_out_h : STD_LOGIC;
	signal sum_h   : STD_LOGIC;
	
  signal a_h_1     : STD_LOGIC;
	signal b_h_1     : STD_LOGIC;
	signal carry_in_h_1  : STD_LOGIC;
	signal carry_out_h_1 : STD_LOGIC;
	signal sum_h_1   : STD_LOGIC;
	
	component FA is
	 port(
    		CIN   : IN  std_logic;
    		X     : IN  std_logic;
		  Y     : IN  std_logic;
    		COUT  : OUT std_logic;
    		S     : OUT std_logic);
	end component;
	
	component HA is
    port(
    X       : IN std_logic;
    Y       : IN std_logic;
    COUT    : OUT std_logic;
    S       : OUT std_logic);
	end component;
	
	component FA1 is
	  port(
    X       : IN  std_logic;
    Y       : IN  std_logic;
    COUT    : OUT std_logic;
    S       : OUT std_logic);
  end component;
  
  component HA1 is
    port(
    X       : IN  std_logic;
    COUT    : OUT std_logic;
    S       : OUT std_logic);
  end component;

begin
	T0 : FA
		port map(carry_in,a,b,carry_out,sum);
	T1 : HA
	  port map(a_h, b_h, carry_out_h, sum_h);
	T2 : FA1
	  port map(a_f_1, b_f_1, carry_out_f_1, sum_f_1);
	T3 : HA1
	  port map(a_h_1, carry_out_h_1, sum_h_1);

  tb_FA : process
  begin
    
    for i in std_logic range '0' to '1' loop
      for j in std_logic range '0' to '1' loop
        for k in std_logic range '0' to '1' loop
          a <= i;
          b <= j;
          carry_in <= k; wait for 10ns;
        end loop;
      end loop;
    end loop;    
    wait;
  end process;
  
  tb_HA : process
  begin    
    for i in std_logic range '0' to '1' loop
      for j in std_logic range '0' to '1' loop
          a_h <= i;
          b_h <= j; wait for 10ns;
      end loop;
    end loop;
    
    wait;
  end process;

  tb_FA_1 : process
  begin    
    for i in std_logic range '0' to '1' loop
      for j in std_logic range '0' to '1' loop
          a_f_1 <= i;
          b_f_1 <= j; wait for 10ns;
      end loop;
    end loop;    
    wait;
  end process;

  tb_HA_1 : process
  begin    
    for i in std_logic range '0' to '1' loop
          a_h_1 <= i; wait for 10ns;
      end loop;
    wait;
  end process;
    	
end arch;