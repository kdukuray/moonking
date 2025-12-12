library IEEE;
use IEEE.std_logic_1164.ALL;

entity D_Latch is
	port(
		D, En, Clk: in std_logic;
		Q, notQ: out std_logic
	);
end D_Latch;

architecture D_Latch_arch of D_Latch is
	
component SR_Latch is
	port(
		S, R, En, Clk: in std_logic;
		Q, notQ: out std_logic
	);
end component;
signal notD: std_logic;
begin
	notD <=(not D);
	sr_latch_comp: SR_Latch port map(
						S => D,
						R => notD,
						En => En,
						Clk => Clk,
						Q => Q,
						notQ => notQ
						);
end D_Latch_arch;