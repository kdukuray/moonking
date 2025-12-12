library IEEE;
use IEEE.std_logic_1164.ALL;

entity n_register is
	generic(N: integer := 32);
	port(
		D: in std_logic_vector( N-1 downto 0);
		Clk: in std_logic;
		En: in std_logic;
		Q: out std_logic_vector( N-1 downto 0)
	);
end n_register;
	
architecture n_register_arch of n_register is

	component D_FlipFlop_Negative_Edge is
		port(
			D, En, Clk: in std_logic;
			Q, notQ: out std_logic
		);
	end component;
	
	begin
	
	reg_generate: for i in 0 to N-1 generate
		D0_FF: D_FlipFlop_Negative_Edge port map(
			D => D(i),
			En => En,
			Clk => Clk,
			Q => Q(i)
		);
	end generate reg_generate;
	
	end n_register_arch;