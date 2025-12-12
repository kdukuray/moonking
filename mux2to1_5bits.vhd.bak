library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std .ALL;

library work;
use work.my_components.ALL;

entity mux_2to1 is
    Port ( 
        sel : in  std_logic; 
        data : in  std_logic_2d_2_32;
        result : out std_logic_vector(31 downto 0)
    );
end mux_2to1;

architecture mux_2to1_arch of mux_2to1 is
begin
    with sel select
        result <= data(0)  when '0',
                   data(1)  when '1',
                   (others => '0') when others;
end mux_2to1_arch;
