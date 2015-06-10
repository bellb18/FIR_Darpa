-- delays based on physical-level simulations of static gates designed with 1.8V, 0.18um technology

------------------------------------- 
-- inv_a 
------------------------------------- 
library ieee;
use ieee.std_logic_1164.all;

entity inv_a is
	port(a : in  std_logic;
		 z : out std_logic);
end inv_a;

architecture archinv_a of inv_a is
begin
	inv_a : process(a)
	begin
		if a = '0' then
			z <= '1' after 1 ns;
		elsif a = '1' then
			z <= '0' after 1 ns;
		else
			z <= not a;
		end if;
	end process;
end archinv_a;

------------------------------------- 
-- th12b_a 
------------------------------------- 
library ieee;
use ieee.std_logic_1164.all;

entity th12b_a is
	port(a  : in  std_logic;
		 b  : in  std_logic;
		 zb : out std_logic);
end th12b_a;

architecture archth12b_a of th12b_a is
begin
	th12b_a : process(a, b)
	begin
		if a = '0' and b = '0' then
			zb <= '1' after 1 ns;
		elsif a = '1' or b = '1' then
			zb <= '0' after 3 ns;
		else
			zb <= a nor b;
		end if;
	end process;
end archth12b_a;

----------------------------------------------------------- 
-- th12_a 
----------------------------------------------------------- 
library ieee;
use ieee.std_logic_1164.all;

entity th12_a is
	port(a : in  std_logic;
		 b : in  std_logic;
		 z : out std_logic);
end th12_a;

architecture archth12_a of th12_a is
begin
	th12_a : process(a, b)
	begin
		if a = '0' and b = '0' then
			z <= '0' after 2 ns;
		elsif a = '1' or b = '1' then
			z <= '1' after 8 ns;
		else
			z <= a or b;
		end if;
	end process;
end archth12_a;

------------------------------------- 
-- th13b_a 
------------------------------------- 
library ieee;
use ieee.std_logic_1164.all;

entity th13b_a is
	port(a  : in  std_logic;
		 b  : in  std_logic;
		 c  : in  std_logic;
		 zb : out std_logic);
end th13b_a;

architecture archth13b_a of th13b_a is
begin
	th13b_a : process(a, b, c)
	begin
		if a = '0' and b = '0' and c = '0' then
			zb <= '1' after 3 ns;
		elsif a = '1' or b = '1' or c = '1' then
			zb <= '0' after 3 ns;
		else
			zb <= not (a or b or c);
		end if;
	end process;
end archth13b_a;

----------------------------------------------------------- 
-- th13_a 
----------------------------------------------------------- 
library ieee;
use ieee.std_logic_1164.all;

entity th13_a is
	port(a : in  std_logic;
		 b : in  std_logic;
		 c : in  std_logic;
		 z : out std_logic);
end th13_a;

architecture archth13_a of th13_a is
begin
	th13_a : process(a, b, c)
	begin
		if a = '0' and b = '0' and c = '0' then
			z <= '0' after 3 ns;
		elsif a = '1' or b = '1' or c = '1' then
			z <= '1' after 3 ns;
		else
			z <= a or b or c;
		end if;
	end process;
end archth13_a;

----------------------------------------------------------- 
-- th14b_a 
----------------------------------------------------------- 
library ieee;
use ieee.std_logic_1164.all;

entity th14b_a is
	port(a  : in  std_logic;
		 b  : in  std_logic;
		 c  : in  std_logic;
		 d  : in  std_logic;
		 zb : out std_logic);
end th14b_a;

architecture archth14b_a of th14b_a is
begin
	th14b_a : process(a, b, c, d)
	begin
		if a = '0' and b = '0' and c = '0' and d = '0' then
			zb <= '1' after 4 ns;
		elsif a = '1' or b = '1' or c = '1' or d = '1' then
			zb <= '0' after 4 ns;
		else
			zb <= not (a or b or c or d);
		end if;
	end process;
end archth14b_a;

----------------------------------------------------------- 
-- th14_a 
----------------------------------------------------------- 
library ieee;
use ieee.std_logic_1164.all;

entity th14_a is
	port(a : in  std_logic;
		 b : in  std_logic;
		 c : in  std_logic;
		 d : in  std_logic;
		 z : out std_logic);
end th14_a;

architecture archth14_a of th14_a is
begin
	th14_a : process(a, b, c, d)
	begin
		if a = '0' and b = '0' and c = '0' and d = '0' then
			z <= '0' after 4 ns;
		elsif a = '1' or b = '1' or c = '1' or d = '1' then
			z <= '1' after 4 ns;
		else
			z <= a or b or c or d;
		end if;
	end process;
end archth14_a;

----------------------------------------------------------- 
-- th22d_a 
----------------------------------------------------------- 
library ieee;
use ieee.std_logic_1164.all;

entity th22d_a is
	port(a   : in  std_logic;
		 b   : in  std_logic;
		 rst : in  std_logic;
		 z   : out std_logic);
end th22d_a;

architecture archth22d_a of th22d_a is
begin
	th22d_a : process(a, b, rst)
	begin
		if rst = '1' then               -- reset 
			z <= '1' after 2 ns;
		elsif (a = '1' and b = '1') then
			z <= '1' after 2 ns;
		elsif (a = '0' and b = '0') then
			z <= '0' after 2 ns;
		end if;
	end process;
end archth22d_a;

----------------------------------------------------------- 
-- th22n_a 
----------------------------------------------------------- 
library ieee;
use ieee.std_logic_1164.all;

entity th22n_a is
	port(a   : in  std_logic;
		 b   : in  std_logic;
		 rst : in  std_logic;
		 z   : out std_logic);
end th22n_a;

architecture archth22n_a of th22n_a is
begin
	th22n_a : process(a, b, rst)
	begin
		if rst = '1' then               -- reset 
			z <= '0' after 2 ns;
		elsif (a = '1' and b = '1') then
			z <= '1' after 2 ns;
		elsif (a = '0' and b = '0') then
			z <= '0' after 2 ns;
		end if;
	end process;
end archth22n_a;

----------------------------------------------------------- 
-- th22_a 
----------------------------------------------------------- 
library ieee;
use ieee.std_logic_1164.all;

entity th22_a is
	port(a : in  std_logic;
		 b : in  std_logic;
		 z : out std_logic);
end th22_a;

architecture archth22_a of th22_a is
begin
	th22_a : process(a, b)
	begin
		if (a = '1' and b = '1') then
			z <= '1' after 2 ns;
		elsif (a = '0' and b = '0') then
			z <= '0' after 2 ns;
		end if;
	end process;

end archth22_a;

----------------------------------------------------------- 
-- th23w2_a 
----------------------------------------------------------- 
library ieee;
use ieee.std_logic_1164.all;

entity th23w2_a is
	port(a : in  std_logic;             -- weight 2 
		 b : in  std_logic;
		 c : in  std_logic;
		 z : out std_logic);
end th23w2_a;

architecture archth23w2_a of th23w2_a is
begin
	th23w2_a : process(a, b, c)
	begin
		if (a = '0' and b = '0' and c = '0') then
			z <= '0' after 3 ns;
		elsif (a = '1' or (b = '1' and c = '1')) then
			z <= '1' after 3 ns;
		end if;                         -- else NULL 
	end process;
end archth23w2_a;

----------------------------------------------------------- 
-- th23_a 
----------------------------------------------------------- 
library ieee;
use ieee.std_logic_1164.all;

entity th23_a is
	port(a : in  std_logic;
		 b : in  std_logic;
		 c : in  std_logic;
		 z : out std_logic);
end th23_a;

architecture archth23_a of th23_a is
begin
	th23_a : process(a, b, c)
	begin
		if (a = '0' and b = '0' and c = '0') then
			z <= '0' after 3 ns;
		elsif (a = '1' and b = '1') or (b = '1' and c = '1') or (c = '1' and a = '1') then
			z <= '1' after 3 ns;
		end if;
	end process;

end archth23_a;

----------------------------------------------------------- 
-- th24_a 
----------------------------------------------------------- 
library ieee;
use ieee.std_logic_1164.all;

entity th24_a is
	port(a : in  std_logic;
		 b : in  std_logic;
		 c : in  std_logic;
		 d : in  std_logic;
		 z : out std_logic);
end th24_a;

architecture archth24_a of th24_a is
begin
	th24_a : process(a, b, c, d)
	begin
		if (a = '0' and b = '0' and c = '0' and d = '0') then
			z <= '0' after 4 ns;
		elsif ((a = '1' and b = '1') or (a = '1' and c = '1') or (a = '1' and d = '1') or (b = '1' and c = '1') or (b = '1' and d = '1') or (c = '1' and d = '1')) then
			z <= '1' after 4 ns;
		end if;                         -- else NULL 
	end process;
end archth24_a;

----------------------------------------------------------- 
-- th24w22_a 
----------------------------------------------------------- 
library ieee;
use ieee.std_logic_1164.all;

entity th24w22_a is
	port(a : in  std_logic;             -- weight 2 
		 b : in  std_logic;             -- weight 2 
		 c : in  std_logic;
		 d : in  std_logic;
		 z : out std_logic);
end th24w22_a;

architecture archth24w22_a of th24w22_a is
begin
	th24w22_a : process(a, b, c, d)
	begin
		if (a = '0' and b = '0' and c = '0' and d = '0') then
			z <= '0' after 4 ns;
		elsif (a = '1' or b = '1' or (c = '1' and d = '1')) then
			z <= '1' after 4 ns;
		end if;                         -- else NULL 
	end process;
end archth24w22_a;

----------------------------------------------------------- 
-- th24w2_a 
----------------------------------------------------------- 
library ieee;
use ieee.std_logic_1164.all;

entity th24w2_a is
	port(a : in  std_logic;             -- weight 2 
		 b : in  std_logic;
		 c : in  std_logic;
		 d : in  std_logic;
		 z : out std_logic);
end th24w2_a;

architecture archth24w2_a of th24w2_a is
begin
	th24w2_a : process(a, b, c, d)
	begin
		if (a = '0' and b = '0' and c = '0' and d = '0') then
			z <= '0' after 4 ns;
		elsif (a = '1' or (b = '1' and c = '1') or (b = '1' and d = '1') or (c = '1' and d = '1')) then
			z <= '1' after 4 ns;
		end if;                         -- else NULL 
	end process;
end archth24w2_a;

----------------------------------------------------------- 
-- th33d_a 
----------------------------------------------------------- 
library ieee;
use ieee.std_logic_1164.all;

entity th33d_a is
	port(a   : in  std_logic;
		 b   : in  std_logic;
		 c   : in  std_logic;
		 rst : in  std_logic;
		 z   : out std_logic);
end th33d_a;

architecture archth33d_a of th33d_a is
begin
	th33d_a : process(a, b, c, rst)
	begin
		if rst = '1' then
			z <= '1' after 3 ns;
		elsif (a = '1' and b = '1' and c = '1') then
			z <= '1' after 3 ns;
		elsif (a = '0' and b = '0' and c = '0') then
			z <= '0' after 3 ns;
		end if;                         -- else NULL 
	end process;
end archth33d_a;

----------------------------------------------------------- 
-- th33n_a 
----------------------------------------------------------- 
library ieee;
use ieee.std_logic_1164.all;

entity th33n_a is
	port(a   : in  std_logic;
		 b   : in  std_logic;
		 c   : in  std_logic;
		 rst : in  std_logic;
		 z   : out std_logic);
end th33n_a;

architecture archth33n_a of th33n_a is
begin
	th33n_a : process(a, b, c, rst)
	begin
		if rst = '1' then
			z <= '0' after 3 ns;
		elsif (a = '1' and b = '1' and c = '1') then
			z <= '1' after 3 ns;
		elsif (a = '0' and b = '0' and c = '0') then
			z <= '0' after 3 ns;
		end if;                         -- else NULL 
	end process;
end archth33n_a;

----------------------------------------------------------- 
-- th33_a 
----------------------------------------------------------- 
library ieee;
use ieee.std_logic_1164.all;

entity th33_a is
	port(a : in  std_logic;
		 b : in  std_logic;
		 c : in  std_logic;
		 z : out std_logic);
end th33_a;

architecture archth33_a of th33_a is
begin
	th33_a : process(a, b, c)
	begin
		if (a = '1' and b = '1' and c = '1') then
			z <= '1' after 3 ns;
		elsif (a = '0' and b = '0' and c = '0') then
			z <= '0' after 3 ns;
		end if;                         -- else NULL 
	end process;
end archth33_a;

----------------------------------------------------------- 
-- th33w2_a 
----------------------------------------------------------- 
library ieee;
use ieee.std_logic_1164.all;

entity th33w2_a is
	port(a : in  std_logic;             -- weight 2 
		 b : in  std_logic;
		 c : in  std_logic;
		 z : out std_logic);
end th33w2_a;

architecture archth33w2_a of th33w2_a is
begin
	th33w2_a : process(a, b, c)
	begin
		if (a = '0' and b = '0' and c = '0') then
			z <= '0' after 3 ns;
		elsif (a = '1' and (b = '1' or c = '1')) then
			z <= '1' after 3 ns;
		end if;                         -- else NULL 
	end process;
end archth33w2_a;

----------------------------------------------------------- 
--th34w22_a 
----------------------------------------------------------- 
library ieee;
use ieee.std_logic_1164.all;

entity th34w22_a is
	port(a : in  std_logic;             -- weight 2 
		 b : in  std_logic;             -- weight 2 
		 c : in  std_logic;
		 d : in  std_logic;
		 z : out std_logic);
end th34w22_a;

architecture archth34w22_a of th34w22_a is
begin
	th34w22_a : process(a, b, c, d)
	begin
		if (a = '0' and b = '0' and c = '0' and d = '0') then
			z <= '0' after 4 ns;
		elsif (a = '1' and b = '1') or (a = '1' and c = '1') or (a = '1' and d = '1') or (b = '1' and c = '1') or (b = '1' and d = '1') then
			z <= '1' after 4 ns;
		end if;                         -- else NULL 
	end process;
end archth34w22_a;

----------------------------------------------------------- 
--th34w2_a 
----------------------------------------------------------- 
library ieee;
use ieee.std_logic_1164.all;

entity th34w2_a is
	port(a : in  std_logic;             -- weight 2 
		 b : in  std_logic;
		 c : in  std_logic;
		 d : in  std_logic;
		 z : out std_logic);
end th34w2_a;

architecture archth34w2_a of th34w2_a is
begin
	th34w2_a : process(a, b, c, d)
	begin
		if (a = '0' and b = '0' and c = '0' and d = '0') then
			z <= '0' after 4 ns;
		elsif (a = '1' and b = '1') or (a = '1' and c = '1') or (a = '1' and d = '1') or (b = '1' and c = '1' and d = '1') then
			z <= '1' after 4 ns;
		end if;                         -- else NULL 
	end process;
end archth34w2_a;

----------------------------------------------------------- 
-- th34w32_a 
----------------------------------------------------------- 
library ieee;
use ieee.std_logic_1164.all;

entity th34w32_a is
	port(a : in  std_logic;             -- weight 3 
		 b : in  std_logic;             -- weight 2 
		 c : in  std_logic;
		 d : in  std_logic;
		 z : out std_logic);
end th34w32_a;

architecture archth34w32_a of th34w32_a is
begin
	th34w32_a : process(a, b, c, d)
	begin
		if (a = '0' and b = '0' and c = '0' and d = '0') then
			z <= '0' after 4 ns;
		elsif (a = '1' or (b = '1' and (c = '1' or d = '1'))) then
			z <= '1' after 4 ns;
		end if;                         -- else NULL 
	end process;
end archth34w32_a;

----------------------------------------------------------- 
-- th34w3_a 
----------------------------------------------------------- 
library ieee;
use ieee.std_logic_1164.all;

entity th34w3_a is
	port(a : in  std_logic;             -- weight 3 
		 b : in  std_logic;
		 c : in  std_logic;
		 d : in  std_logic;
		 z : out std_logic);
end th34w3_a;

architecture archth34w3_a of th34w3_a is
begin
	th34w3_a : process(a, b, c, d)
	begin
		if (a = '0' and b = '0' and c = '0' and d = '0') then
			z <= '0' after 4 ns;
		elsif (a = '1' or (b = '1' and c = '1' and d = '1')) then
			z <= '1' after 4 ns;
		end if;                         -- else NULL 
	end process;
end archth34w3_a;

----------------------------------------------------------- 
-- th34_a 
----------------------------------------------------------- 
library ieee;
use ieee.std_logic_1164.all;

entity th34_a is
	port(a : in  std_logic;
		 b : in  std_logic;
		 c : in  std_logic;
		 d : in  std_logic;
		 z : out std_logic);
end th34_a;

architecture archth34_a of th34_a is
begin
	th34w3_a : process(a, b, c, d)
	begin
		if (a = '0' and b = '0' and c = '0' and d = '0') then
			z <= '0' after 4 ns;
		elsif ((a = '1' and b = '1' and c = '1') or (a = '1' and c = '1' and d = '1') or (a = '1' and b = '1' and d = '1') or (b = '1' and c = '1' and d = '1')) then
			z <= '1' after 4 ns;
		end if;                         -- else NULL 
	end process;
end archth34_a;

----------------------------------------------------------- 
-- th44_a 
----------------------------------------------------------- 
library ieee;
use ieee.std_logic_1164.all;

entity th44_a is
	port(a : in  std_logic;
		 b : in  std_logic;
		 c : in  std_logic;
		 d : in  std_logic;
		 z : out std_logic);
end th44_a;

architecture archth44_a of th44_a is
begin
	th44_a : process(a, b, c, d)
	begin
		if (a = '1' and b = '1' and c = '1' and d = '1') then
			z <= '1' after 4 ns;
		elsif (a = '0' and b = '0' and c = '0' and d = '0') then
			z <= '0' after 4 ns;
		end if;                         -- else NULL 
	end process;
end archth44_a;

----------------------------------------------------------- 
-- th44w22_a 
----------------------------------------------------------- 
library ieee;
use ieee.std_logic_1164.all;

entity th44w22_a is
	port(a : in  std_logic;             -- weight 2 
		 b : in  std_logic;             -- weight 2 
		 c : in  std_logic;
		 d : in  std_logic;
		 z : out std_logic);
end th44w22_a;

architecture archth44w22_a of th44w22_a is
begin
	th44w22_a : process(a, b, c, d)
	begin
		if ((a = '1' and b = '1') or (a = '1' and c = '1' and d = '1') or (b = '1' and c = '1' and d = '1')) then
			z <= '1' after 4 ns;
		elsif (a = '0' and b = '0' and c = '0' and d = '0') then
			z <= '0' after 4 ns;
		end if;                         -- else NULL 
	end process;
end archth44w22_a;

----------------------------------------------------------- 
-- th44w2_a 
----------------------------------------------------------- 
library ieee;
use ieee.std_logic_1164.all;

entity th44w2_a is
	port(a : in  std_logic;             -- weight 2 
		 b : in  std_logic;
		 c : in  std_logic;
		 d : in  std_logic;
		 z : out std_logic);
end th44w2_a;

architecture archth44w2_a of th44w2_a is
begin
	th44w2_a : process(a, b, c, d)
	begin
		if ((a = '1' and b = '1' and c = '1') or (a = '1' and b = '1' and d = '1') or (a = '1' and c = '1' and d = '1')) then
			z <= '1' after 4 ns;
		elsif (a = '0' and b = '0' and c = '0' and d = '0') then
			z <= '0' after 4 ns;
		end if;                         -- else NULL 
	end process;
end archth44w2_a;

----------------------------------------------------------- 
-- th44w322_a 
----------------------------------------------------------- 
library ieee;
use ieee.std_logic_1164.all;

entity th44w322_a is
	port(a : in  std_logic;             -- weight 3 
		 b : in  std_logic;             -- weight 2 
		 c : in  std_logic;             -- weight 2 
		 d : in  std_logic;
		 z : out std_logic);
end th44w322_a;

architecture archth44w322_a of th44w322_a is
begin
	th44w322_a : process(a, b, c, d)
	begin
		if (a = '0' and b = '0' and c = '0' and d = '0') then
			z <= '0' after 4 ns;
		elsif (a = '1' and (b = '1' or c = '1' or d = '1')) or (b = '1' and c = '1') then
			z <= '1' after 4 ns;
		end if;                         -- else NULL 
	end process;
end archth44w322_a;

----------------------------------------------------------- 
-- th44w3_a 
----------------------------------------------------------- 
library ieee;
use ieee.std_logic_1164.all;

entity th44w3_a is
	port(a : in  std_logic;             -- weight 3 
		 b : in  std_logic;
		 c : in  std_logic;
		 d : in  std_logic;
		 z : out std_logic);
end th44w3_a;

architecture archth44w3_a of th44w3_a is
begin
	th44w3_a : process(a, b, c, d)
	begin
		if (a = '0' and b = '0' and c = '0' and d = '0') then
			z <= '0' after 4 ns;
		elsif a = '1' and (b = '1' or c = '1' or d = '1') then
			z <= '1' after 4 ns;
		end if;                         -- else NULL 
	end process;
end archth44w3_a;

----------------------------------------------------------- 
-- th54w22_a 
----------------------------------------------------------- 
library ieee;
use ieee.std_logic_1164.all;

entity th54w22_a is
	port(a : in  std_logic;             -- weight 2 
		 b : in  std_logic;             -- weight 2 
		 c : in  std_logic;
		 d : in  std_logic;
		 z : out std_logic);
end th54w22_a;

architecture archth54w22_a of th54w22_a is
begin
	th54w22_a : process(a, b, c, d)
	begin
		if (a = '0' and b = '0' and c = '0' and d = '0') then
			z <= '0' after 4 ns;
		elsif (a = '1' and b = '1' and (c = '1' or d = '1')) then
			z <= '1' after 4 ns;
		end if;                         -- else NULL 
	end process;
end archth54w22_a;

----------------------------------------------------------- 
-- th54w322_a 
----------------------------------------------------------- 
library ieee;
use ieee.std_logic_1164.all;

entity th54w322_a is
	port(a : in  std_logic;             -- weight 3 
		 b : in  std_logic;             -- weight 2 
		 c : in  std_logic;             -- weight 2 
		 d : in  std_logic;
		 z : out std_logic);
end th54w322_a;

architecture archth54w322_a of th54w322_a is
begin
	th54w322_a : process(a, b, c, d)
	begin
		if (a = '0' and b = '0' and c = '0' and d = '0') then
			z <= '0' after 4 ns;
		elsif (a = '1' and b = '1') or (a = '1' and c = '1') or (b = '1' and c = '1' and d = '1') then
			z <= '1' after 4 ns;
		end if;                         -- else NULL 
	end process;
end archth54w322_a;

----------------------------------------------------------- 
-- th54w32_a 
----------------------------------------------------------- 
library ieee;
use ieee.std_logic_1164.all;

entity th54w32_a is
	port(a : in  std_logic;             -- weight 3 
		 b : in  std_logic;             -- weight 2 
		 c : in  std_logic;
		 d : in  std_logic;
		 z : out std_logic);
end th54w32_a;

architecture archth54w32_a of th54w32_a is
begin
	th54w32_a : process(a, b, c, d)
	begin
		if (a = '0' and b = '0' and c = '0' and d = '0') then
			z <= '0' after 4 ns;
		elsif (a = '1' and b = '1') or (a = '1' and c = '1' and d = '1') then
			z <= '1' after 4 ns;
		end if;                         -- else NULL 
	end process;
end archth54w32_a;

----------------------------------------------------------- 
-- thand0_a 
----------------------------------------------------------- 
library ieee;
use ieee.std_logic_1164.all;

entity thand0_a is
	port(a : in  std_logic;
		 b : in  std_logic;
		 c : in  std_logic;
		 d : in  std_logic;
		 z : out std_logic);
end thand0_a;

architecture archthand0_a of thand0_a is
begin
	thand0_a : process(a, b, c, d)
	begin
		if (a = '0' and b = '0' and c = '0' and d = '0') then
			z <= '0' after 4 ns;
		elsif ((a = '1' and b = '1') or (b = '1' and c = '1') or (a = '1' and d = '1')) then
			z <= '1' after 4 ns;
		end if;                         -- else NULL 
	end process;
end archthand0_a;

----------------------------------------------------------- 
-- th24comp_a 
----------------------------------------------------------- 
library ieee;
use ieee.std_logic_1164.all;

entity th24comp_a is
	port(a : in  std_logic;
		 b : in  std_logic;
		 c : in  std_logic;
		 d : in  std_logic;
		 z : out std_logic);
end th24comp_a;

architecture archth24comp_a of th24comp_a is
begin
	th24comp_a : process(a, b, c, d)
	begin
		if (a = '0' and b = '0' and c = '0' and d = '0') then
			z <= '0' after 4 ns;
		elsif (a = '1' or b = '1') and (c = '1' or d = '1') then
			z <= '1' after 4 ns;
		end if;                         -- else NULL 
	end process;
end archth24comp_a;

----------------------------------------------------------- 
-- thxor0_a      
----------------------------------------------------------- 
library ieee;
use ieee.std_logic_1164.all;

entity thxor0_a is
	port(a : in  std_logic;
		 b : in  std_logic;
		 c : in  std_logic;
		 d : in  std_logic;
		 z : out std_logic);
end thxor0_a;

architecture archthxor0_a of thxor0_a is
begin
	thxor0_a : process(a, b, c, d)
	begin
		if (a = '0' and b = '0' and c = '0' and d = '0') then
			z <= '0' after 4 ns;
		elsif (a = '1' and b = '1') or (c = '1' and d = '1') then
			z <= '1' after 4 ns;
		end if;                         -- else NULL 
	end process;
end archthxor0_a;

----------------------------------------------------------- 
-- and2_a 
----------------------------------------------------------- 
library ieee;
use ieee.std_logic_1164.all;

entity and2_a is
	port(a : in  std_logic;
		 b : in  std_logic;
		 z : out std_logic);
end and2_a;

architecture archand2_a of and2_a is
begin
	and2_a : process(a, b)
	begin
		if (a = '1' and b = '1') then
			z <= '1' after 2 ns;
		elsif (a = '0' or b = '0') then
			z <= '0' after 2 ns;
		end if;
	end process;
end archand2_a;

----------------------------------------------------------- 
-- or2_a 
----------------------------------------------------------- 
library ieee;
use ieee.std_logic_1164.all;

entity or2_a is
	port(a : in  std_logic;
		 b : in  std_logic;
		 z : out std_logic);
end or2_a;

architecture archor2_a of or2_a is
begin
	or2_a : process(a, b)
	begin
		z <= a or b after 2 ns;
	end process;
end archor2_a;

----------------------------------------------------------- 
-- and3_a 
----------------------------------------------------------- 
library ieee;
use ieee.std_logic_1164.all;

entity and3_a is
	port(a : in  std_logic;
		 b : in  std_logic;
		 c : in  std_logic;
		 z : out std_logic);
end and3_a;

architecture archand3_a of and3_a is
begin
	and3_a : process(a, b, c)
	begin
		if (a = '1' and b = '1' and c = '1') then
			z <= '1' after 3 ns;
		elsif (a = '0' or b = '0' or c = '0') then
			z <= '0' after 3 ns;
		end if;
	end process;
end archand3_a;

----------------------------------------------------------- 
-- and4_a 
----------------------------------------------------------- 
library ieee;
use ieee.std_logic_1164.all;

entity and4_a is
	port(a : in  std_logic;
		 b : in  std_logic;
		 c : in  std_logic;
		 d : in  std_logic;
		 z : out std_logic);
end and4_a;

architecture archand4_a of and4_a is
begin
	and4_a : process(a, b, c, d)
	begin
		if (a = '1' and b = '1' and c = '1' and d = '1') then
			z <= '1' after 4 ns;
		elsif (a = '0' or b = '0' or c = '0' or d = '0') then
			z <= '0' after 4 ns;
		end if;
	end process;
end archand4_a;

-------------------------------------------------------- 

