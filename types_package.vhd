library IEEE;
use IEEE.std_logic_1164.ALL;

package my_types is

type std_logic_2d_32_32 is array (0 to 31) of std_logic_vector(31 DOWNTO 0);
type std_logic_2d_4_32 is array (0 to 3) of std_logic_vector(31 DOWNTO 0);
type std_logic_2d_2_32 is array (0 to 1) of std_logic_vector(31 DOWNTO 0);
type std_logic_2d_2_5 is array (0 to 1) of std_logic_vector(4 DOWNTO 0);

end package my_types;