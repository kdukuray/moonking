library IEEE;
use IEEE.std_logic_1164.ALL;

entity D_FlipFlop_Negative_Edge is
	port(
		D, En, Clk: in std_logic;
		Q, notQ: out std_logic
	);
end D_FlipFlop_Negative_Edge;

architecture D_FlipFlop_Negative_Edge_arch of D_FlipFlop_Negative_Edge is
signal Q_out: std_logic := '0';
begin
	Q <= Q_out;
	notQ <= not Q_out;
	process(Clk)
	begin
		if(Clk='0' and Clk'EVENT and En='1') then
			Q_out <= D;
		end if;
	end process;

end D_FlipFlop_Negative_Edge_arch;