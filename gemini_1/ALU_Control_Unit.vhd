library IEEE;
use IEEE.std_logic_1164.ALL;

entity ALU_control_unit is
    Port ( funct : in  std_logic_vector (5 downto 0);
           ALUOp : in  std_logic_vector (1 downto 0);
           Operation : out  std_logic_vector (3 downto 0)
           );
end ALU_control_unit;

architecture ALU_control_unit_arch of ALU_control_unit is
begin
    process(funct, ALUOp)
    begin
        -- Defaults
        Operation <= "0000"; 
        
        if ALUOp = "00" then -- LW/SW/ADDI -> ADD
            Operation <= "0010";
        elsif ALUOp = "01" then -- BEQ -> SUB
            Operation <= "0110";
        elsif ALUOp = "10" then -- R-Type
            case funct is
                when "100000" => Operation <= "0010"; -- ADD
                when "100010" => Operation <= "0110"; -- SUB
                when "100100" => Operation <= "0000"; -- AND
                when "100101" => Operation <= "0001"; -- OR
                when "101010" => Operation <= "0111"; -- SLT
                when "100111" => Operation <= "1100"; -- NOR (Added)
                when others   => Operation <= "0000";
            end case;
        end if;
    end process;
end ALU_control_unit_arch;