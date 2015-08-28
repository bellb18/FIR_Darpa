library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity counter is
port(
	x       :   in std_logic_vector(9 downto 0);
	clock	:	in std_logic;
	rst		:	in std_logic;
	--enable	:	in std_logic; 
	num		:	out std_logic_vector(4 downto 0)
);
end counter;

architecture behv of counter is		 	  
	component reg_gen is
	generic(width : integer := 16);
	port(
		D   : in  std_logic_vector(width - 1 downto 0);
		clk : in  std_logic;
		rst : in  std_logic;
		Q   : out std_logic_vector(width - 1 downto 0));
	end component;
    
    signal Pre_Q	: std_logic_vector(4 downto 0);
    signal reg_out	: std_logic_vector(9 downto 0);

begin
-- behavior describe the counter
	reg_0 : reg_gen
		generic map (10)
		port map(x, clock, rst, reg_out);

    process(clock, rst)
    begin
	if rst = '1' then
 	    Pre_Q(4 downto 0) <= (others=>'0');
	elsif (clock='1' and clock'event) then
		--if enable = '1' then
		if x = reg_out then
			if Pre_Q > 15 then
				Pre_Q <= Pre_Q;
			else
				Pre_Q <= Pre_Q + 1;
			end if;
		else
			Pre_Q(4 downto 0) <= (others=>'0');
	    end if;
	end if;
    end process;
	
    -- concurrent assignment statement
    num <= Pre_Q;

end behv;
