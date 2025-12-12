library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.numeric_std.ALL;

library work;
use work.my_types.ALL;
use work.my_components.ALL;

entity cpu_mips is
	port(Clk: in std_logic);

end cpu_mips;

architecture cpu_mips_arch of cpu_mips is

signal pc_input, pc_output: std_logic_vector( 31 downto 0) := (others => '0');
signal pc_adder_4_out: std_logic_vector( 31 downto 0);

signal instr_mem_data, instruction: std_logic_vector( 31 downto 0) := (others => '0');

signal RegDst, RegWrite, ALUSrc, branch, MemWrite, MemtoReg :  std_logic;

signal RegDst_mux_input :  std_logic_2d_2_5;
signal RegDst_mux_out: std_logic_vector( 4 downto 0);

signal read_reg1, read_reg2: std_logic_vector( 31 downto 0);

signal immediate_sign_extended: std_logic_vector( 31 downto 0);

signal ALUSrc_mux_input:  std_logic_2d_2_32;
signal ALUSrc_mux_out: std_logic_vector( 31 downto 0);

signal ALUOp : std_logic_vector (1 downto 0);
signal ALUCtrl_Op :  std_logic_vector (3 downto 0);
signal ALU_Overflow, ALU_Zero: std_logic;
signal ALUResult :  std_logic_vector (31 downto 0);

signal branch_and_zero: std_logic :='0';
signal branch_mux_input:  std_logic_2d_2_32;
signal immediate_adder_out :  std_logic_vector (31 downto 0);
signal read_mem_out: std_logic_vector (31 downto 0);

signal MemtoReg_mux_input:  std_logic_2d_2_32;
signal MemtoReg_mux_out:  std_logic_vector (31 downto 0);

begin

	pc_register: n_register
	port map(
		D => pc_input,
		Clk => Clk,
		En => '1',
		Q => pc_output
	);
	
	pc_adder_4: nbit_add_sub
    Port map( 
			  A => pc_output,
           B => "00000000000000000000000000000100",
			  CarryIn => '0',
			  Add_Sub => '0',
           Sum => pc_adder_4_out,
           CarryOut => '0',
			  overflow => '0'
			  );
	
	immediate_adder: nbit_add_sub
    Port map( 
			  A => pc_adder_4_out,
           B => immediate_sign_extended,
			  CarryIn => '0',
			  Add_Sub => '0',
           Sum => immediate_adder_out,
           CarryOut => '0',
			  overflow => '0'
			  );
	
	instrc_mem: instruction_memory
	PORT map
	(
		address => pc_output,
		clock => Clk,
		data => instr_mem_data,
		wren => '0',
		q => instruction
	);
	
	ctrl_unit: control_unit
    Port map ( 
			  Op => instruction(31 downto 26),
           RegDst => RegDst,
			  ALUSrc => ALUSrc,
			  MemToReg => MemtoReg,
			  RegWrite => RegWrite,
			  MemWrite => MemWrite,
			  Branch => branch,
			  ALUOp1 => ALUOp(1),
			  ALUOp0 => ALUOp(0)
			  );
	
	RegDst_mux_input(0) <= instruction(20 downto 16);
	RegDst_mux_input(1) <= instruction(15 downto 11);
			  
	RegDst_mux: mux_2to1_5bits
    Port map( 
        sel => RegDst,
        data => RegDst_mux_input,
        result => RegDst_mux_out
    );
	 
	reg_file: register_file
	port map(
		RegWr => RegWrite,
		Rw => RegDst_mux_out,
		Ra => instruction(25 downto 21),
		Rb => instruction(20 downto 16),
		Clk => Clk,
		busW => MemtoReg_mux_out,
		busA => read_reg1,
		busB => read_reg2
	);
	
	imm_sign_extend: sign_extend
    Port map( immediate16 => instruction(15 downto 0),
				immediate32 => immediate_sign_extended
			  );
			  
	 ALUSrc_mux_input(0) <= read_reg2;
	 ALUSrc_mux_input(1) <= immediate_sign_extended;
	 
	 ALUSrc_mux: mux_2to1
    Port map( 
        sel => ALUSrc,
        data => ALUSrc_mux_input,
        result => ALUSrc_mux_out
    );
	 
	 ALU_ctrl: ALU_control_unit
    Port map( 
				funct => instruction(5 downto 0),
				ALUOp => ALUOp,
				Operation => ALUCtrl_Op
			  );
			  
	ALU_Unit: ALU_32bit
	port map(
		a => read_reg1,
		b => ALUSrc_mux_out,
		ALUControl => ALUCtrl_Op,
		Result => ALUResult,
		overflow => ALU_Overflow,
		zero => ALU_Zero
	);
	
	branch_and_zero <= branch and ALU_Zero;
	
	branch_mux_input(0) <= pc_adder_4_out;
	branch_mux_input(1) <= immediate_adder_out;
	
	Branch_mux: mux_2to1
    Port map( 
        sel => branch_and_zero,
        data => branch_mux_input,
        result => pc_output
    );
	 
	data_mem: data_memory
	PORT map
	(
		address => ALUResult,
		clock => Clk,
		data => read_reg2,
		wren => MemWrite,
		q => read_mem_out
	);
	
	MemtoReg_mux_input(1) <= read_mem_out;
	MemtoReg_mux_input(0) <= ALUResult;
	
	MemtoReg_mux: mux_2to1
    Port map( 
        sel => MemtoReg,
        data => MemtoReg_mux_input,
        result => MemtoReg_mux_out
    );
	
end cpu_mips_arch;