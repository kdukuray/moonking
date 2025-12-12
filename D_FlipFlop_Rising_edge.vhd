library IEEE;
use IEEE.std_logic_1164.ALL;

entity D_FlipFlop_RE is
	port(
		D, En, Clk: in std_logic;
		Q, notQ: out std_logic
	);
end D_FlipFlop_RE;

architecture D_FlipFlop_arch of D_FlipFlop_RE is
component D_Latch is
	port(
		D, En, Clk: in std_logic;
		Q, notQ: out std_logic
	);
end component;
signal Q_signal, notQ_signal, notClk: std_logic;
begin
	notClk <=(not Clk);
	d_latch_comp1: D_Latch port map(
						D => D,
						En => En,
						Clk => notClk,
						Q => Q_signal
						);
	d_latch_comp2: D_Latch port map(
						D => Q_signal,
						En => En,
						Clk => Clk,
						Q => Q,
						notQ => notQ
						);
end D_FlipFlop_arch;