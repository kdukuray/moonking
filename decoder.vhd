library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;

entity decoder is
    generic (
        N : integer := 5;  -- Number of input bits (default 3)
        M : integer := 32   -- Number of output lines (default 8, should be 2^N)
    );
    Port (
        A : in STD_LOGIC_VECTOR(N-1 downto 0);  -- N-bit input
        Y : out STD_LOGIC_VECTOR(M-1 downto 0)   -- M-bit output
    );
end decoder;

architecture Behavioral of decoder is
begin
    process(A)
    begin
        -- Initialize all outputs to '0'
        Y <= (others => '0');
        
        -- Using the input value 'A' as an index to assert the corresponding output bit
        if (to_integer(unsigned(A)) < M) then
            Y(to_integer(unsigned(A))) <= '1';
        end if;
    end process;
end Behavioral;
