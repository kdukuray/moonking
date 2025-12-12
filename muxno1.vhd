library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;

entity mux_nto1 is
	 generic(
		logN: integer := 1;
		N: integer := 2
	 );
    Port ( 
        sel : in  std_logic_vector(logN-1 downto 0); 
        data : in  std_logic_vector(N-1 downto 0); 
        result : out std_logic
    );
end mux_nto1;

architecture mux_nto1_arch of mux_nto1 is
begin
	result <= data(to_integer(unsigned(sel)));
end mux_nto1_arch;
