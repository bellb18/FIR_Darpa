library ieee;
use ieee.std_logic_1164.all;


entity BaughWooleyMultBoolean is
	port(x             : in  std_logic_vector(9 downto 0);
		 y             : in  std_logic_vector(6 downto 0);
		 p        : out std_logic_vector(15 downto 0));
end entity;

architecture arch_BaughWooleyMultBoolean_NonPipe of BaughWooleyMultBoolean is

	component CSA is 
		port(
			X : IN std_logic;
			Y : IN std_logic;
			CIN   : IN std_logic;
			SIN   : IN std_logic;
			COUT : OUT std_logic;
			SOUT : OUT std_logic);
	end component;
	
	component CSA_inv is 
		port(
			X : IN std_logic;
			Y : IN std_logic;
			CIN   : IN std_logic;
			SIN   : IN std_logic;
			COUT : OUT std_logic;
			SOUT : OUT std_logic);
	end component;
	
	component FA is
		port(
			X     : IN  std_logic;
			Y     : IN  std_logic;
			CIN   : IN  std_logic;
			COUT  : OUT std_logic;
			S     : OUT std_logic);
	end component;
	
	component FA1 is
 		 port(
   			 X       : IN  std_logic;
   			 Y       : IN  std_logic;
   			 COUT    : OUT std_logic;
    		 S       : OUT std_logic);
  	end component;

	--To simplify things, row-N-Sout(0) is not used
	signal rowOneCout, rowOneSout, rowTwoCout, rowTwoSout, rowThreeCout, rowThreeSout, rowFourCout, rowFourSout, 
		rowFiveCout, rowFiveSout, rowSixCout, rowSixSout, rowSevenCout, rowSevenSout, fullAddersCout : std_logic_vector(9 downto 0);
	
begin
	-- adder rows
	firstRowfirstCol: CSA
			port map(x(0), y(0), '0', '0', rowOneCout(0), p(0));
	firstRow: for i in 1 to 8 generate
			middleCols1 : if i < 6 generate
				row : CSA
					port map(x(i), y(0), '0', '0', rowOneCout(i), rowOneSout(i));
				end generate;
			middleCols2 : if i = 6 generate
				row : CSA
					port map(x(i), y(0), '1', '0', rowOneCout(i), rowOneSout(i));
				end generate;
			middleCols3 : if i > 6 generate
				row : CSA
					port map(x(i), y(0), '0', '0', rowOneCout(i), rowOneSout(i));
				end generate;
	end generate;
	firstRowLastCol : CSA_inv
		port map(x(9), y(0), '1', '0', rowOneCout(9), rowOneSout(9));
	
	secondRowfirstCol: CSA
			port map(x(0), y(1), rowOneCout(0), rowOneSout(1),  rowTwoCout(0), p(1));
	secondRow: for i in 1 to 9 generate
			middleCols : if i < 9 generate
				row : CSA
					port map(x(i), y(1), rowOneCout(i), rowOneSout(i+1), rowTwoCout(i), rowTwoSout(i));
				end generate;
			lastCol : if i = 9 generate
				lCol : CSA_inv
					port map(x(9), y(1), rowOneCout(9), '0',  rowTwoCout(i), rowTwoSout(i));
				end generate;
	end generate;
	
	thirdRowfirstCol: CSA
			port map(x(0), y(2), rowTwoCout(0), rowTwoSout(1),  rowThreeCout(0), p(2));
	thirdRow: for i in 1 to 9 generate
			middleCols : if i < 9 generate
				row : CSA
					port map(x(i), y(2), rowTwoCout(i), rowTwoSout(i+1),  rowThreeCout(i), rowThreeSout(i));
				end generate;
			lastCol : if i = 9 generate
				lCol : CSA_inv
					port map(x(9), y(2), rowTwoCout(9), '0',  rowThreeCout(i), rowThreeSout(i));
				end generate;
	end generate;
	
	fourthRowfirstCol: CSA
			port map(x(0), y(3), rowThreeCout(0), rowThreeSout(1), rowFourCout(0), p(3));
	fourthRow: for i in 1 to 9 generate
			middleCols : if i < 9 generate
				row : CSA
					port map(x(i), y(3), rowThreeCout(i), rowThreeSout(i+1), rowFourCout(i), rowFourSout(i));
				end generate;
			lastCol : if i = 9 generate
				lCol : CSA_inv
					port map(x(9), y(3), rowThreeCout(9), '0', rowFourCout(i), rowFourSout(i));
				end generate;
	end generate;
	
	fifthRowfirstCol: CSA
			port map(x(0), y(4), rowFourCout(0), rowFourSout(1), rowFiveCout(0), p(4));
	fifthRow: for i in 1 to 9 generate
			middleCols : if i < 9 generate
				row : CSA
					port map(x(i), y(4), rowFourCout(i), rowFourSout(i+1), rowFiveCout(i), rowFiveSout(i));
				end generate;
			lastCol : if i = 9 generate
				lCol : CSA_inv
					port map(x(9), y(4), rowFourCout(9), '0', rowFiveCout(i), rowFiveSout(i));
				end generate;
	end generate;
	
	sixthRowfirstCol: CSA
					port map(x(0), y(5), rowFiveCout(0), rowFiveSout(1), rowSixCout(0), p(5));
	sixthRow: for i in 1 to 9 generate
			middleCols : if i < 9 generate
				row : CSA
					port map(x(i), y(5), rowFiveCout(i), rowFiveSout(i+1), rowSixCout(i), rowSixSout(i));
				end generate;
			lastCol : if i = 9 generate
				lCol : CSA_inv
					port map(x(9), y(5), rowFiveCout(9), '0', rowSixCout(i), rowSixSout(i));
				end generate;
	end generate;
	
	seventhRowfirstCol: CSA_inv
					port map(x(0), y(6), rowSixCout(0), rowSixSout(1), rowSevenCout(0), p(6));
	seventhRow: for i in 1 to 9 generate
			middleCols : if i < 9 generate
				row : CSA_inv
					port map(x(i), y(6), rowSixCout(i), rowSixSout(i+1), rowSevenCout(i), rowSevenSout(i));
				end generate;
			lastCol : if i = 9 generate
				lCol : CSA
					port map(x(9), y(6), rowSixCout(9), '0', rowSevenCout(i), rowSevenSout(i));
				end generate;
	end generate;
	
	
	-- Full Adder row
	firstFullAdder : FA
		port map(rowSevenCout(0), '0', rowSevenSout(1), fullAddersCout(0), p(7));
	finalRow: for i in 1 to 8 generate
		middleFullAdders : FA
			port map(rowSevenCout(i), fullAddersCout(i - 1), rowSevenSout(i + 1), fullAddersCout(i), p(i + 7));
	end generate;
	finalAdder: FA1
		-- rowSevenSout(0) isn't actually used anywhere so it's used to hold the bit that gets truncated
		port map(fullAddersCout(8), rowSevenCout(9), fullAddersCout(9), rowSevenSout(0));
	

end architecture arch_BaughWooleyMultBoolean_NonPipe;