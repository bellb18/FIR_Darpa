library ieee;
use ieee.std_logic_1164.all;
use work.ncl_signals.all;


entity BaughWooley_Unpipelined is
	port(x             : in  dual_rail_logic_vector(9 downto 0);
		 y             : in  dual_rail_logic_vector(6 downto 0);
		 sleep 		   : in  std_logic;
		 p        : out dual_rail_logic_vector(15 downto 0));
end entity;

architecture arch_BaughWooleyMult_NonPipe of BaughWooley_Unpipelined is

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
	
	component FAm1 is
	port(X     : dual_rail_logic;
		 Y     : in  dual_rail_logic;
		 sleep : in  std_logic;
		 COUT  : out dual_rail_logic;
		 S     : out dual_rail_logic);
	end component;

	signal zero, one     : dual_rail_logic;
	--To simplify things, row-N-Sout(0) is not used
	signal rowOneCout, rowOneSout, rowTwoCout, rowTwoSout, rowThreeCout, rowThreeSout, rowFourCout, rowFourSout, 
		rowFiveCout, rowFiveSout, rowSixCout, rowSixSout, rowSevenCout, rowSevenSout, fullAddersCout : dual_rail_logic_vector(9 downto 0);
	
begin
	
	--Create dual-rail zero and one signals
	zero.rail0 <= '1';
	zero.rail1 <= '0';
	one.rail0 <= '0';
	one.rail1 <= '1';
	
	-- CSA rows
	firstRowfirstCol: CSAm
			port map(x(0), y(0), zero, zero, sleep, rowOneCout(0), p(0));
	firstRow: for i in 1 to 8 generate
			middleCols1 : if i < 6 generate
				row : CSAm
					port map(x(i), y(0), zero, zero, sleep, rowOneCout(i), rowOneSout(i));
				end generate;
			middleCols2 : if i = 6 generate
				row : CSAm
					port map(x(i), y(0), one, zero, sleep, rowOneCout(i), rowOneSout(i));
				end generate;
			middleCols3 : if i > 6 generate
				row : CSAm
					port map(x(i), y(0), zero, zero, sleep, rowOneCout(i), rowOneSout(i));
				end generate;
	end generate;
	firstRowLastCol : CSAm_inv
		port map(x(9), y(0), one, zero, sleep, rowOneCout(9), rowOneSout(9));
	
	secondRowfirstCol: CSAm
			port map(x(0), y(1), rowOneCout(0), rowOneSout(1), sleep, rowTwoCout(0), p(1));
	secondRow: for i in 1 to 9 generate
			middleCols : if i < 9 generate
				row : CSAm
					port map(x(i), y(1), rowOneCout(i), rowOneSout(i+1), sleep, rowTwoCout(i), rowTwoSout(i));
				end generate;
			lastCol : if i = 9 generate
				lCol : CSAm_inv
					port map(x(9), y(1), rowOneCout(9), zero, sleep, rowTwoCout(i), rowTwoSout(i));
				end generate;
	end generate;
	
	thirdRowfirstCol: CSAm
			port map(x(0), y(2), rowTwoCout(0), rowTwoSout(1), sleep, rowThreeCout(0), p(2));
	thirdRow: for i in 1 to 9 generate
			middleCols : if i < 9 generate
				row : CSAm
					port map(x(i), y(2), rowTwoCout(i), rowTwoSout(i+1), sleep, rowThreeCout(i), rowThreeSout(i));
				end generate;
			lastCol : if i = 9 generate
				lCol : CSAm_inv
					port map(x(9), y(2), rowTwoCout(9), zero, sleep, rowThreeCout(i), rowThreeSout(i));
				end generate;
	end generate;
	
	fourthRowfirstCol: CSAm
			port map(x(0), y(3), rowThreeCout(0), rowThreeSout(1), sleep, rowFourCout(0), p(3));
	fourthRow: for i in 1 to 9 generate
			middleCols : if i < 9 generate
				row : CSAm
					port map(x(i), y(3), rowThreeCout(i), rowThreeSout(i+1), sleep, rowFourCout(i), rowFourSout(i));
				end generate;
			lastCol : if i = 9 generate
				lCol : CSAm_inv
					port map(x(9), y(3), rowThreeCout(9), zero, sleep, rowFourCout(i), rowFourSout(i));
				end generate;
	end generate;
	
	fifthRowfirstCol: CSAm
			port map(x(0), y(4), rowFourCout(0), rowFourSout(1), sleep, rowFiveCout(0), p(4));
	fifthRow: for i in 1 to 9 generate
			middleCols : if i < 9 generate
				row : CSAm
					port map(x(i), y(4), rowFourCout(i), rowFourSout(i+1), sleep, rowFiveCout(i), rowFiveSout(i));
				end generate;
			lastCol : if i = 9 generate
				lCol : CSAm_inv
					port map(x(9), y(4), rowFourCout(9), zero, sleep, rowFiveCout(i), rowFiveSout(i));
				end generate;
	end generate;
	
	sixthRowfirstCol: CSAm
					port map(x(0), y(5), rowFiveCout(0), rowFiveSout(1), sleep, rowSixCout(0), p(5));
	sixthRow: for i in 1 to 9 generate
			middleCols : if i < 9 generate
				row : CSAm
					port map(x(i), y(5), rowFiveCout(i), rowFiveSout(i+1), sleep, rowSixCout(i), rowSixSout(i));
				end generate;
			lastCol : if i = 9 generate
				lCol : CSAm_inv
					port map(x(9), y(5), rowFiveCout(9), zero, sleep, rowSixCout(i), rowSixSout(i));
				end generate;
	end generate;
	
	seventhRowfirstCol: CSAm_inv
					port map(x(0), y(6), rowSixCout(0), rowSixSout(1), sleep, rowSevenCout(0), p(6));
	seventhRow: for i in 1 to 9 generate
			middleCols : if i < 9 generate
				row : CSAm_inv
					port map(x(i), y(6), rowSixCout(i), rowSixSout(i+1), sleep, rowSevenCout(i), rowSevenSout(i));
				end generate;
			lastCol : if i = 9 generate
				lCol : CSAm
					port map(x(9), y(6), rowSixCout(9), zero, sleep, rowSevenCout(i), rowSevenSout(i));
				end generate;
	end generate;
	
	
	-- Full Adder row
	firstFullAdder : FAm
		port map(rowSevenSout(1), rowSevenCout(0), zero, sleep, fullAddersCout(0), p(7));
	finalRow: for i in 1 to 8 generate
		middleFullAdders : FAm
			port map(rowSevenSout(i + 1), rowSevenCout(i), fullAddersCout(i - 1), sleep, fullAddersCout(i), p(i + 7));
	end generate;
	finalAdder: FAm1
		-- rowSevenSout(0) isn't actually used anywhere so it's used to hold the bit that gets truncated
		port map(rowSevenCout(9), fullAddersCout(8), sleep, fullAddersCout(9), rowSevenSout(0));
	

end architecture arch_BaughWooleyMult_NonPipe;