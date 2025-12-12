library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;

library work;
use work.my_types.ALL;

entity mux_32to1 is
    Port ( 
        sel : in  std_logic_vector(4 downto 0); 
        data : in  std_logic_2d_32_32; 
        result : out std_logic_vector(31 downto 0)
    );
end mux_32to1;

architecture mux_32to1_arch of mux_32to1 is
begin
	result <= data(to_integer(unsigned(sel)));
--    with sel select
--        result <= data(0)  when "00000",
--                   data(1)  when "00001",
--                   data(2)  when "00010",
--                   data(3)  when "00011",
--                   data(4)  when "00100",
--                   data(5)  when "00101",
--                   data(6)  when "00110",
--                   data(7)  when "00111",
--                   data(8)  when "01000",
--                   data(9)  when "01001",
--                   data(10) when "01010",
--                   data(11) when "01011",
--                   data(12) when "01100",
--                   data(13) when "01101",
--                   data(14) when "01110",
--                   data(15) when "01111",
--                   data(16) when "10000",
--                   data(17) when "10001",
--                   data(18) when "10010",
--                   data(19) when "10011",
--                   data(20) when "10100",
--                   data(21) when "10101",
--                   data(22) when "10110",
--                   data(23) when "10111",
--                   data(24) when "11000",
--                   data(25) when "11001",
--                   data(26) when "11010",
--                   data(27) when "11011",
--                   data(28) when "11100",
--                   data(29) when "11101",
--                   data(30) when "11110",
--                   data(31) when "11111",
--                   (others => '0') when others;
end mux_32to1_arch;
