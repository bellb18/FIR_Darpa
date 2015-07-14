----------------------------------------------------------- 
-- Shift-register in MTNCL with fast shift
----------------------------------------------------------- 
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.ncl_signals.all;
use work.functions.all;
use work.MTNCL_gates.all;
use work.FIR_Pack.all;

entity FastShiftReg is
	port(X   : in  dual_rail_logic_vector(9 downto 0);
		 ki       : in  std_logic;
		 rst      : in  std_logic;
		 Y   : out  Xtype;
		 sleepout : out std_logic;
		 ko       : out std_logic);
end FastShiftReg;

architecture arch of FastShiftReg is
	
	component FastShiftReg_Piece is
	port(X   : in  dual_rail_logic_vector(9 downto 0);
		 ki       : in  std_logic;
		 rst      : in  std_logic;
		 Y  : out dual_rail_logic_vector(9 downto 0);
		 sleepout : out std_logic;
		 ko       : out std_logic);
	end component;
	
	type Ktype is array (15 downto 0) of std_logic;
	
	signal Xarray : Xtype;
	signal karray, Sarray : Ktype;

begin
	Y <= Xarray;
	Xarray(0) <= X;
	ko <= karray(0);
	sleepout <= Sarray(1);
	
	GenReg : for i in 1 to 15 generate
		Rega : FastShiftReg_Piece
			port map(Xarray(i - 1), ki, rst, Xarray(i), Sarray(i), karray(i - 1));
	end generate;
end arch;


----------------------------------------------------------- 
-- Shift-register in MTNCL with fast shift
----------------------------------------------------------- 
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.ncl_signals.all;
use work.functions.all;
use work.MTNCL_gates.all;

entity FastShiftReg_Piece is
	port(X   : in  dual_rail_logic_vector(9 downto 0);
		 ki       : in  std_logic;
		 rst      : in  std_logic;
		 Y  : out dual_rail_logic_vector(9 downto 0);
		 sleepout : out std_logic;
		 ko       : out std_logic);
end FastShiftReg_Piece;

architecture arch of FastShiftReg_Piece is
	component genregrstm is
		generic(width : in integer    := 4;
			    dn    : in bit        := '1';
			    value : in bit_vector := "0110");
		port(a     : IN  dual_rail_logic_vector(width - 1 downto 0);
			 rst   : in  std_logic;
			 sleep : in  std_logic;
			 z     : out dual_rail_logic_vector(width - 1 downto 0));
	end component;

	component compm is
		generic(width : in integer := 4);
		port(a              : IN  dual_rail_logic_vector(width - 1 downto 0);
			 ki, rst, sleep : in  std_logic;
			 ko             : OUT std_logic);
	end component;

	component compdm is
		generic(width : in integer := 4);
		port(a              : IN  dual_rail_logic_vector(width - 1 downto 0);
			 ki, rst, sleep : in  std_logic;
			 ko             : OUT std_logic);
	end component;

	signal Out1, Out2 : dual_rail_logic_vector(9 downto 0);
	signal c1, c2, c3, c_wrap    : std_logic;

begin
	-- Shift Register
	Mcompdata1 : compdm
		generic map(10)
		port map(X, c2, rst, c3, c1); --reset to requrest for DATA
	Mregnull1 : genregrstm
		generic map(10, '0', "0000000000")  --reset to NULL        
		port map(X, rst, c_wrap, Out1);
	
	Mcompnull2 : compm                   -----reset to request for NULL
		generic map(10)
		port map(Out1, c3, rst, c_wrap, c2);
	Mregdata2 : genregrstm
		generic map(10, '1', "0000000000")  ----reset to DATA
		port map(Out1, rst, c2, Out2);
	
	Mcompdata3 : compdm
		generic map(10)
		port map(Out2, c_wrap, rst, c2, c3); --reset to requrest for DATA
	Mregnull3 : genregrstm
		generic map(10, '0', "0000000000")  --reset to NULL        
		port map(Out2, rst, c3, Y);

	th22ma: th22m_a
		port map(c1, ki, '0', c_wrap);
	
	ko <= c_wrap;
	sleepout <= c3;

end arch;


----------------------------------------------------------- 
-- State Machine
----------------------------------------------------------- 
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.ncl_signals.all;
use work.functions.all;
use work.MTNCL_gates.all;

entity FastShiftReg_StateMachine is
	port(ki, rst   : in  std_logic;
		 ko, s1, s2, s3 : out std_logic);
end FastShiftReg_StateMachine;

architecture arch of FastShiftReg_StateMachine is
	component genregrstm is
		generic(width : in integer    := 4;
			    dn    : in bit        := '1';
			    value : in bit_vector := "0110");
		port(a     : IN  dual_rail_logic_vector(width - 1 downto 0);
			 rst   : in  std_logic;
			 sleep : in  std_logic;
			 z     : out dual_rail_logic_vector(width - 1 downto 0));
	end component;

	component compm is
		generic(width : in integer := 4);
		port(a              : IN  dual_rail_logic_vector(width - 1 downto 0);
			 ki, rst, sleep : in  std_logic;
			 ko             : OUT std_logic);
	end component;

	component compdm is
		generic(width : in integer := 4);
		port(a              : IN  dual_rail_logic_vector(width - 1 downto 0);
			 ki, rst, sleep : in  std_logic;
			 ko             : OUT std_logic);
	end component;
	
	component INV_A is
	port(a : in  std_logic;
		 z : out std_logic);
	end component;
	
	component and2_a is
	port(a : in  std_logic;
		 b : in  std_logic;
		 z : out std_logic);
	end component;

	signal go, c1, c2, c3, c_wrap, ki_inv, temp_s1_inv    : std_logic;
	signal state2, state3, state_out, wrap : dual_rail_logic_vector(2 downto 0);
	signal temp0, temp1, temp2, temp_s1, temp_s2, temp_s3, r0_inv0, r0_inv1, r0_inv2  : std_logic;

begin
	-- State Machine
	Mcompdata1 : compdm
		generic map(3)
		port map(wrap, c2, rst, c1, c3); --reset to requrest for DATA
	Mregnull1 : genregrstm
		generic map(3, '0', "000")  --reset to NULL        
		port map(wrap, rst, c3, state2);
	
	Mcompnull2 : compm                   -----reset to request for NULL
		generic map(3)
		port map(state2, c1, rst, c3, c2);
	Mregdata2 : genregrstm
		generic map(3, '1', "010")  ----reset to DATA
		port map(state2, rst, c2, state3);
	
	Mcompdata3 : compdm
		generic map(3)
		port map(state3, c_wrap, rst, c2, c1); --reset to requrest for DATA
	Mregnull3 : genregrstm
		generic map(3, '0', "000")  --reset to NULL        
		port map(state3, rst, c1, state_out);
		
	-- wrap
	wrap(0).rail1 <= state_out(1).rail0;
	wrap(0).rail0 <= state_out(1).rail1;
	wrap(1).rail1 <= state_out(2).rail0;
	wrap(1).rail0 <= state_out(2).rail1;
	wrap(2).rail1 <= state_out(0).rail0;
	wrap(2).rail0 <= state_out(0).rail1;
	
	INV_Ki : INV_A
		port map(ki, ki_inv);
	INV_s1 : INV_A
		port map(temp_s1, temp_s1_inv);
	thxor0ma : thxor0m_a
		port map(ki, temp_s1, ki_inv, temp_s1_inv, c2, go);
	th22ma: th22m_a
		port map(c1, go, c2, c_wrap);
	
	
	
	-- Outputs
	ORa: th12nm_a
		port map(state_out(0).rail1, temp0, rst, '0', temp_s1);
	ORb: th12dm_a
		port map(state_out(1).rail1, temp1, rst, '0', temp_s2);
	ORc: th12nm_a
		port map(state_out(2).rail1, temp2, rst, '0', temp_s3);
	
	ANDa: th22m_a
		port map(r0_inv0, temp_s1, '0', temp0);
	ANDb: th22m_a
		port map(r0_inv1, temp_s2, '0', temp1);
	ANDc: th22m_a
		port map(r0_inv2, temp_s3, '0', temp2);
	
	INV1 : INV_A
		port map(state_out(0).rail0, r0_inv0);
	INV2 : INV_A
		port map(state_out(1).rail0, r0_inv1);
	INV3 : INV_A
		port map(state_out(2).rail0, r0_inv2);
	
	
	s3 <= temp_s3;
	s2 <= temp_s2;
	s1 <= temp_s1;
	
	INV_Out : INV_A
		port map(temp_s3, ko);

end arch;