library IEEE;
use IEEE.std_logic_1164.ALL;

entity D_FlipFlop is
	port(
		D, En, Clk: in std_logic;
		Q, notQ: out std_logic
	);
end D_FlipFlop;

architecture D_FlipFlop_arch of D_FlipFlop is
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
						Clk => Clk,
						Q => Q_signal,
						notQ => notQ_signal
						);
	d_latch_comp2: D_Latch port map(
						D => Q_signal,
						En => En,
						Clk => notClk,
						Q => Q,
						notQ => notQ
						);
end D_FlipFlop_arch;