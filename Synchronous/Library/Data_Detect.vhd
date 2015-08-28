library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity sleep_detector is
   port (
      clk      : in   std_logic;
      x    	   : in   std_logic_vector(9 downto 0);
      reset    : in   std_logic;
      --enable   : in   STD_LOGIC;
      output   : out  std_logic);
end sleep_detector;

architecture a of sleep_detector is
	component counter is
		port(
			x       :   in std_logic_vector(9 downto 0);
			clock	:	in std_logic;
			rst		:	in std_logic;
			num		:	out std_logic_vector(4 downto 0)
		);
	end component;

   type STATE_TYPE is (idle, detect, sleep);
   signal reg_out : std_logic_vector(4 downto 0);
   signal state   : STATE_TYPE;
   
begin
	counter_0 : counter
		port map(x, clk, reset, reg_out);
		
	
		
	process (clk, reset)
	begin
    	if reset = '1' then
        	state <= idle;
		elsif (clk'event and clk = '1') then
    		case state is
        		when idle =>
					if reg_out > 0 then
                		state <= detect;
					else
                		state <= idle;
					end if;
            	when detect =>
            		if reg_out > 15 then
                		state <= sleep;
            		else
                		state <= detect;
            		end if;
            	when sleep=>
            		if reg_out > 1 then
                		state <= idle;
            		else
                		state <= sleep;
            		end if;
			end case;
		end if;
	end process;
   
	process (state)
	begin
		case state is
			when idle =>
				output <= '0';
			when detect =>
				output <= '0';
			when sleep =>
				output <= '1';
		end case;
	end process;
   
end a;