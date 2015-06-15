  ----------------------------------------------------------- 
  -- th55m_a 
  ----------------------------------------------------------- 
library ieee; 
use ieee.std_logic_1164.all;
use work.MTNCL_gates.all;

-- th55m made up of th44m and th22m
entity th55m_a is 
    port(
        a: in std_logic; 
        b: in std_logic; 
        c: in std_logic; 
        d: in std_logic; 
        e: in std_logic; 
         s:in std_logic; 
         z: out std_logic); 
end th55m_a; 


architecture archth55m_a of th55m_a is

    signal imm_res0 : std_logic;

begin

    th44m_a_0 : th44m_a
        port map(
            a => a,
             b => b,
             c => c,
             d => d, 
             s => s,
             z => imm_res0
             );
             
    th22m_a_0 : th22m_a
        port map(
            a => imm_res0, 
             b => e,
             s => s,
             z => z
             ); 

end archth55m_a; 

  ----------------------------------------------------------- 
  -- th15m_a 
  ----------------------------------------------------------- 
library ieee; 
use ieee.std_logic_1164.all;
use work.MTNCL_gates.all;

-- th55m made up of th14m and th12m
entity th15m_a is 
    port(
        a: in std_logic; 
        b: in std_logic; 
        c: in std_logic; 
        d: in std_logic; 
        e: in std_logic; 
         s:in std_logic; 
         z: out std_logic); 
end th15m_a; 


architecture archth15m_a of th15m_a is
    
    signal imm_res0 : std_logic;


begin

    th14m_a_0 : th14m_a
        port map(
            a => a,
             b => b,
             c => c,
             d => d, 
             s => s,
             z => imm_res0
             );
             
    th12m_a_0 : th12m_a
        port map(
            a => imm_res0, 
             b => e,
             s => s,
             z => z
             ); 

end archth15m_a; 