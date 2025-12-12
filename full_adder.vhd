library IEEE;
use IEEE.std_logic_1164.ALL;

entity full_adder is
    Port ( A : in  std_logic;
           B : in  std_logic;
			  CarryIn: in std_logic;
           Sum : out  std_logic;
           CarryOut : out  std_logic);
end full_adder;

architecture dataflow of full_adder is
begin

    Sum  <= A xor B xor CarryIn;
    CarryOut <= (A and B) or ((A xor B) and CarryIn);

end dataflow;