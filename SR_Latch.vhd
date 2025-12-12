library IEEE;
use IEEE.std_logic_1164.ALL;

entity SR_Latch is
	port(
		S, R, En, Clk: in std_logic;
		Q, notQ: out std_logic
	);
end SR_Latch;

architecture SR_Latch_arch of SR_Latch is
signal Q_signal: std_logic := '0'; 
signal notQ_signal: std_logic;
begin
notQ_signal <= (S and En and Clk) nor Q_signal;
notQ <= notQ_signal;
Q_signal <= (R and En and Clk) nor notQ_signal;
Q <= Q_signal;
end SR_Latch_arch;