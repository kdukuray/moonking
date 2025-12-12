library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std .ALL;

library work;
use work.my_types.ALL;

entity mux_2to1_5bits is
    Port ( 
        sel : in  std_logic; 
        data : in  std_logic_2d_2_5;
        result : out std_logic_vector(4 downto 0)
    );
end mux_2to1_5bits;

architecture mux_2to1_5bits_arch of mux_2to1_5bits is
begin
    with sel select
        result <= data(0)  when '0',
                   data(1)  when '1',
                   (others => '0') when others;
end mux_2to1_5bits_arch;
