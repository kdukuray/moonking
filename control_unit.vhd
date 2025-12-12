library IEEE;
use IEEE.std_logic_1164.ALL;

entity control_unit is
    Port ( Op : in  std_logic_vector (5 downto 0);
           RegDst : out  std_logic;
			  ALUSrc : out  std_logic;
			  MemToReg : out  std_logic;
			  RegWrite : out  std_logic;
			  MemWrite : out  std_logic;
			  Branch : out  std_logic;
			  ALUOp1 : out  std_logic;
			  ALUOp0 : out  std_logic
			  );
end control_unit;

architecture control_unit_arch of control_unit is

signal Op_result1, Op_result2, Op_result3, Op_result4, Op_result5: std_logic;

begin

	Op_result1 <= ( not Op(0) ) and ( not Op(1) ) and ( not Op(2)) and ( not Op(3)) and ( not Op(4)) and ( not Op(5));
	Op_result2 <= Op(0) and  Op(1) and ( not Op(2)) and ( not Op(3)) and ( not Op(4)) and  Op(5);
	Op_result3 <= Op(0) and Op(1) and ( not Op(2)) and  Op(3) and ( not Op(4)) and  Op(5);
	Op_result4 <= ( not Op(0) ) and ( not Op(1) ) and Op(2) and ( not Op(3)) and ( not Op(4)) and ( not Op(5));
	Op_result5 <= ( not Op(0) ) and ( not Op(1) ) and (not Op(2)) and  Op(3) and ( not Op(4)) and ( not Op(5));
	
	RegDst <= Op_result1;
	ALUSrc <= Op_result2 or Op_result3 or Op_result5;
	MemToReg <= Op_result2;
	RegWrite <= Op_result1 or Op_result2 or Op_result5;
	MemWrite <= Op_result3;
	Branch <= Op_result4;
	ALUOp1 <= Op_result1;
	ALUOp0 <= Op_result4;

end control_unit_arch;