Library IEEE;
use IEEE.std_logic_1164.all;
use work.ncl_signals.all;
entity Dadda_Unpipelined is
    port(x     : in  dual_rail_logic_vector(10 downto 0);
         y     : in  dual_rail_logic_vector(5 downto 0);
         sleep : in  std_logic;
         p     : out dual_rail_logic_vector(16 downto 0));
end;

architecture arch of Dadda_Unpipelined is
    component FAm
        port(CIN, X, Y : in  dual_rail_logic;
             sleep     : in  std_logic;
             COUT, S   : out dual_rail_logic);
    end component;

    component HAm is
    port(
        X     : IN  dual_rail_logic;
        Y     : IN  dual_rail_logic;
        sleep : in  std_logic;
        COUT  : OUT dual_rail_logic;
        S     : OUT dual_rail_logic);
    end component;
    
    component HAm1 is
    port(
        X     : IN  dual_rail_logic;
        COUT  : OUT dual_rail_logic;
        S     : OUT dual_rail_logic);
    end component;
    
    component FAm1 is
    port(X     : dual_rail_logic;
         Y     : in  dual_rail_logic;
         sleep : in  std_logic;
         COUT  : out dual_rail_logic;
         S     : out dual_rail_logic);
    end component;
    
    component and2im is
        port(a     : IN  dual_rail_logic;
             b     : IN  dual_rail_logic;
             sleep : in  std_logic;
             z     : OUT dual_rail_logic);  --*
    end component;

    type Ctype is array (4 downto 0) of dual_rail_logic_vector(16 downto 0);
    type InType is array (10 downto 0) of dual_rail_logic_vector(5 downto 0);

    signal carry_array1, carry_array2, sum_array1, sum_array2         : Ctype;
    signal discard_carry: dual_rail_logic;
    signal input_array                    : InType;

begin
    
    -- Fix inverted inputs
    AndGenx: for i in 0 to 10 generate
        AndGeny: for j in 0 to 5 generate
            AndGen: and2im
                port map(x(i), y(j), sleep, input_array(i)(j));
        end generate;
    end generate;
    
    -- First Stage - All columns will have 6pp or less
    HA05a: HAm1 --P5
        port map(input_array(5)(0), sum_array1(0)(5));
    HaGen0a: for i in 1 to 4 generate --P6-P9
            Ha0a: HAm
        port map(input_array(i + 5)(0), input_array(i + 4)(1), sleep, carry_array1(0)(i+6), sum_array1(0)(i+5));
    end generate;
    FA010a: FAm1 --P10
        port map(input_array(10)(0), input_array(9)(1), sleep, carry_array1(0)(11), sum_array1(0)(10));
    
    -- Second Stage - All columns will have 4pp or less
    HA14a: HAm --P4
        port map(input_array(4)(0), input_array(3)(1), sleep, carry_array1(1)(5), sum_array1(1)(4));
    HA15a: HAm --P5
        port map(input_array(2)(3), input_array(1)(4), sleep, carry_array1(1)(6), sum_array1(1)(5));
    FA15a: FAm --P5
        port map(input_array(4)(1), input_array(3)(2), sum_array1(0)(5), sleep, carry_array2(1)(6), sum_array2(1)(5));
    
    FaGen1a: for i in 1 to 5 generate --P6-P10
        FA1a: FAm
            port map(input_array(i+3)(2), sum_array1(0)(i+5), carry_array1(0)(i+5), sleep, carry_array1(1)(i+6), sum_array1(1)(i+5));
        FA1b: FAm
            port map(input_array(i+2)(3), input_array(i+1)(4), input_array(i)(5), sleep, carry_array2(1)(i+6), sum_array2(1)(i+5));
    end generate;
    
    FA111a: FAm --P11
        port map(carry_array1(0)(11), input_array(10)(1), sum_array1(9)(2), sleep, carry_array1(1)(12), sum_array2(1)(11));
    FA111b: FAm --P11
        port map(input_array(8)(3), input_array(7)(4), sum_array1(6)(5), sleep, carry_array2(1)(12), sum_array2(1)(11));
    FA112a: FAm --P12
        port map(input_array(10)(2), input_array(9)(3), sum_array1(8)(4), sleep, carry_array2(1)(13), sum_array2(1)(12));
    
    -- Third Stage
    
    -- Fourth Stage
    
    -- Final Adder (Carry Propagate)
    p(0) <= input_array(0)(0);
    HA51a: HAm --P1
    	port map(input_array(1)(0), input_array(0)(1), sleep, carry_array1(4)(2), p(1));
    FA52a: FAm --P2
    	port map(input_array(0)(2), sum_array1(3)(2), carry_array1(4)(2), sleep, carry_array1(4)(3), p(2));
    FaGen5a: for i in 3 to 14 generate -- P3-P14
    FA5a: FAm
    	port map(sum_array1(3)(i), carry_array1(3)(i), carry_array1(4)(i), sleep, carry_array1(4)(i+1), p(i));
    end generate;
    FA515a: FAm --P15
    	port map(input_array(10)(5), carry_array1(3)(15), carry_array1(4)(15), sleep, carry_array1(4)(16), p(15));
    HA516a: HAm1 --P16
    	port map(carry_array1(4)(16), discard_carry, p(16));

end arch;