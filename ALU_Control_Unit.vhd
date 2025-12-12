library IEEE;
use IEEE.std_logic_1164.ALL;

entity ALU_control_unit is
    Port ( funct : in  std_logic_vector (5 downto 0);
				ALUOp : in  std_logic_vector (1 downto 0);
           Operation : out  std_logic_vector (3 downto 0)
			  );
end ALU_control_unit;

architecture ALU_control_unit_arch of ALU_control_unit is

signal temp1, temp2, temp3, temp4: std_logic;

begin

	temp1 <= (funct(0) or funct(3)) and ALUOp(1);
	temp2 <= (not funct(2)) or (not ALUOp(1));
	temp3 <= (funct(1) and ALUOp(1)) or ALUOp(0);
	temp4 <= ALUOp(0) and (not ALUOp(0));
	Operation(0) <= temp1;
	Operation(1) <= temp2;
	Operation(2) <= temp3;
	Operation(3) <= temp4;

end ALU_control_unit_arch;