library ieee;
use ieee.std_logic_1164.all;
use work.ncl_signals.all;
use work.functions.all;
use work.MTNCL_gates.all;

entity BaughWooleyMult is
	port(X             : in  dual_rail_logic_vector(10 downto 0);
		 Y             : in  dual_rail_logic_vector(5 downto 0);
		 sleep 		   : in  std_logic;
		 result        : out dual_rail_logic_vector(17 downto 0));
end entity;

architecture arch_BaughWooleyMult_NonPipe of BaughWooleyMult is

	component CSAm is
		port(
			AI    : IN  dual_rail_logic;
			BI    : IN  dual_rail_logic;
			CIN   : IN  dual_rail_logic;
			SIN   : IN  dual_rail_logic;
			sleep : in  std_logic;
			COUT  : OUT dual_rail_logic;
			SOUT  : OUT dual_rail_logic);
	end component;

	component CSAm_inv is
		port(
			AI    : IN  dual_rail_logic;
			BI    : IN  dual_rail_logic;
			CIN   : IN  dual_rail_logic;
			SIN   : IN  dual_rail_logic;
			sleep : in  std_logic;
			COUT  : OUT dual_rail_logic;
			SOUT  : OUT dual_rail_logic);
	end component;
	
	component FAm is
		port(
			CIN   : IN  dual_rail_logic;
			X     : IN  dual_rail_logic;
			Y     : IN  dual_rail_logic;
			sleep : in  std_logic;
			COUT  : OUT dual_rail_logic;
			S     : OUT dual_rail_logic); --*
	end component;

	signal zero, one     : dual_rail_logic;
	--To simplify things, row-N-Sout(0) is not used
	signal rowOneCout, rowOneSout, rowTwoCout, rowTwoSout, rowThreeCout, rowThreeSout, rowFourCout, rowFourSout, 
		rowFiveCout, rowFiveSout, rowSixCout, rowSixSout	: dual_rail_logic_vector(10 downto 0);
	signal fullAddersSout : dual_rail_logic_vector(9 downto 0);
	
begin
	
	--Create dual-rail zero and one signals
	zero.rail0 <= '1';
	zero.rail1 <= '0';
	one.rail0 <= '0';
	one.rail1 <= '1';

	--Rows : for i in 0 to 5 generate
		--Columns : for j in 0 to 10 generate
			--firstCol: if j = 0 generate
				--fCol : CSAm
					--port map(X(j), Y(i), zero, zero, sleep, cout(i), result(j));
				--end generate;
			--middleCols : if j < 10 generate
				--row : CSAm
					--port map(X(j), Y(i), zero, zero, sleep, cout, sout);
				--end generate;
			--lastCol : if j = 10 generate
				--lCol : CSAm_inv
					--port map(X(j), Y(i), zero, one, sleep, cout, sout);
				--end generate;
		--end generate;
	--end generate;
	
	-- CSA rows
	firstRow: for i in 0 to 10 generate
		firstCol: if i = 0 generate
				fCol : CSAm
					port map(X(i), Y(0), zero, zero, sleep, rowOneCout(0), result(0));
				end generate;
			middleCols : if i < 10 generate
				row : CSAm
					port map(X(i), Y(0), zero, zero, sleep, rowOneCout(i), rowOneSout(i));
				end generate;
			lastCol : if i = 10 generate
				lCol : CSAm_inv
					port map(X(10), Y(0), zero, one, sleep, rowOneCout(10), rowOneSout(10));
				end generate;
	end generate;
	
	secondRow: for i in 0 to 10 generate
		firstCol: if i = 0 generate
				fCol : CSAm
					port map(X(0), Y(1), rowOneCout(0), rowOneSout(1), sleep, rowTwoCout(0), result(1));
				end generate;
			middleCols : if i < 10 generate
				row : CSAm
					port map(X(i), Y(1), rowOneCout(i), rowOneSout(i+1), sleep, rowTwoCout(i), rowTwoSout(i));
				end generate;
			lastCol : if i = 10 generate
				lCol : CSAm_inv
					port map(X(10), Y(1), rowOneCout(10), zero, sleep, rowTwoCout(i), rowTwoSout(i));
				end generate;
	end generate;
	
	thirdRow: for i in 0 to 10 generate
		firstCol: if i = 0 generate
				fCol : CSAm
					port map(X(0), Y(2), rowTwoCout(0), rowTwoSout(1), sleep, rowThreeCout(0), result(2));
				end generate;
			middleCols : if i < 10 generate
				row : CSAm
					port map(X(i), Y(2), rowTwoCout(i), rowTwoSout(i+1), sleep, rowThreeCout(i), rowThreeSout(i));
				end generate;
			lastCol : if i = 10 generate
				lCol : CSAm_inv
					port map(X(10), Y(2), rowTwoCout(10), zero, sleep, rowThreeCout(i), rowThreeSout(i));
				end generate;
	end generate;
	
	fourthRow: for i in 0 to 10 generate
		firstCol: if i = 0 generate
				fCol : CSAm
					port map(X(0), Y(3), rowThreeCout(0), rowThreeSout(1), sleep, rowFourCout(0), result(3));
				end generate;
			middleCols : if i < 10 generate
				row : CSAm
					port map(X(i), Y(3), rowThreeCout(i), rowThreeSout(i+1), sleep, rowFourCout(i), rowFourSout(i));
				end generate;
			lastCol : if i = 10 generate
				lCol : CSAm_inv
					port map(X(10), Y(3), rowThreeCout(10), zero, sleep, rowFourCout(i), rowFourSout(i));
				end generate;
	end generate;
	
	fifthRow: for i in 0 to 10 generate
		firstCol: if i = 0 generate
				fCol : CSAm
					port map(X(0), Y(4), rowFourCout(0), rowFourSout(1), sleep, rowFiveCout(0), result(4));
				end generate;
			middleCols : if i < 10 generate
				row : CSAm
					port map(X(i), Y(4), rowFourCout(i), rowFourSout(i+1), sleep, rowFiveCout(i), rowFiveSout(i));
				end generate;
			lastCol : if i = 10 generate
				lCol : CSAm_inv
					port map(X(10), Y(4), rowFourCout(10), zero, sleep, rowFiveCout(i), rowFiveSout(i));
				end generate;
	end generate;
	
	sixthRow: for i in 0 to 10 generate
		firstCol: if i = 0 generate
				fCol : CSAm
					port map(X(0), Y(5), rowFiveCout(0), rowFiveSout(1), sleep, rowSixCout(0), result(5));
				end generate;
			middleCols : if i < 10 generate
				row : CSAm
					port map(X(i), Y(5), rowFiveCout(i), rowFiveSout(i+1), sleep, rowSixCout(i), rowSixSout(i));
				end generate;
			lastCol : if i = 10 generate
				lCol : CSAm_inv
					port map(X(10), Y(5), rowFiveCout(10), zero, sleep, rowSixCout(i), rowSixSout(i));
				end generate;
	end generate;
	
	
	-- Full Adder row
	firstFullAdder : FAm
		port map(zero, rowSixSout(1), rowSixCout(0), sleep, result(6), fullAddersSout(0));
	finalRow: for i in 1 to 9 generate
		middleFullAdders : FAm
			port map(fullAddersSout(i - 1), rowSixSout(i + 1), rowSixCout(i), sleep, result(i + 6), fullAddersSout(i));
	end generate;
	finalAdder: FAm
		port map(fullAddersSout(8), zero, rowSixCout(10), sleep, result(16), fullAddersSout(9));
	

end architecture arch_BaughWooleyMult_NonPipe;