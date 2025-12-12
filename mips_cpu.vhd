library IEEE;
use IEEE.std_logic_1164.ALL;

library work;
use work.my_types.ALL;
use work.my_components.ALL;

entity mips_cpu is
--	port(Clk: in std_logic);

end mips_cpu;

architecture mips_cpu_arch of mips_cpu is

signal pc_input, pc_output: std_logic_vector(31 downto 0) := ( others => '0');
signal branch_mux_input: std_logic_2d_2_32 := (others => ( others => '0'));
signal instruction: std_logic_vector(31 downto 0);
signal instruction_sign_extended: std_logic_vector(31 downto 0);

signal branch: std_logic :='0';
signal pc_branch_and_zero: std_logic := '0';

signal RegDst, ALUSrc, RegWrite, MemToReg, MemRead, MemWrite: std_logic := '0';

signal Rd, Rs, Rt: std_logic_vector(4 downto 0);
signal RegDst_mux_input: std_logic_2d_2_5;

signal read_reg1_out, read_reg2_out: std_logic_vector(31 downto 0); 

signal ALUSrc_mux_input: std_logic_2d_2_32;
signal ALUSrc_mux_out: std_logic_vector(31 downto 0);
signal ALUOp :  std_logic_vector (1 downto 0);
signal ALUControl: std_logic_vector( 3 downto 0);
signal ALUResult: std_logic_vector( 31 downto 0);
signal ALUOverflow, ALU_zero: std_logic := '0';

signal MemToReg_mux_input: std_logic_2d_2_32;
signal MemToReg_mux_out: std_logic_vector( 31 downto 0);
signal mem_data_read: std_logic_vector( 31 downto 0);
signal Clk, data_mem_out_clk: std_logic :='0';

begin

	clk_prc: process
	begin
		Clk <= '0';
		wait for 5 ns;
		Clk <= '1';
		wait for 5 ns;
	end process;


	pc_register: n_register
	port map(
		D => pc_input,
		Clk => Clk,
		En => '1',
		Q => pc_output
	);
	
	instr_mem: instruction_memory
	port map
	(
		address => pc_output(15 downto 0),
		data => (others => '0'),
		clock => Clk,
		wren => '0',
		q => instruction
	);
	
	pc_adder: nbit_add_sub
    port map ( 
			  A => pc_output,
           B => "00000000000000000000000000000001",
			  CarryIn => '0',
			  Add_Sub => '0',
           Sum => branch_mux_input(0)
			  );
			  
	immediate_adder: nbit_add_sub
    port map ( 
			  A => branch_mux_input(0),
           B => instruction_sign_extended,
			  CarryIn => '0',
			  Add_Sub => '0',
           Sum => branch_mux_input(1)
			  );
			  
	
	pc_branch_and_zero <= branch and ALU_zero;
			  
	branch_mux: mux_2to1
    port map ( 
        sel => pc_branch_and_zero,
        data => branch_mux_input,
        result => pc_input
    );
	 
	 
	 cntrl_unit: control_unit
    Port map( Op => instruction(31 downto 26),
           RegDst => RegDst,
			  ALUSrc => ALUSrc,
			  MemToReg => MemToReg,
			  RegWrite =>RegWrite,
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
        result => Rd
    );
	 
	 Rs <= instruction(25 downto 21);
	 Rt <= instruction(20 downto 16);
	 
	 reg_file: register_file
		port map(
			RegWr => RegWrite,
			Rw => Rd,
			Ra => Rs,
			Rb => Rt,
			Clk => Clk,
			busW => MemToReg_mux_out,
			busA => read_reg1_out,
			busB => read_reg2_out
		);
		
	 immediate_sign_extend: sign_extend
		Port map ( 
				immediate16 => instruction(15 downto 0),
				immediate32 => instruction_sign_extended
			  );
	 
	 ALUSrc_mux_input(0) <= read_reg2_out;
	 ALUSrc_mux_input(1) <= instruction_sign_extended;
	 
	 ALUSrc_mux: mux_2to1
    Port map( 
        sel => ALUSrc,
        data => ALUSrc_mux_input,
        result => ALUSrc_mux_out
    );
	 
	 ALU_ctrl: ALU_control_unit
    Port map( funct => instruction(5 downto 0),
				ALUOp => ALUOp,
           Operation => ALUControl
			  );
	 
	ALU: ALU_32bit
	port map(
		a => read_reg1_out,
		b => ALUSrc_mux_out,
		ALUControl => ALUControl,
		Result => ALUResult,
		overflow => ALUOverflow, 
		zero => ALU_zero
	);
	
	-- this propagation delay is to simulate the delay that happens in reality in sram.
	data_mem_out_clk <= Clk after 2 ns;
	
	data_mem: data_memory
	PORT map
	(
		address => ALUResult(15 downto 0),
		clock => Clk,
		outclock => data_mem_out_clk,
		data => read_reg2_out,
		wren => MemWrite,
		q => mem_data_read 
	);
	
	 MemToReg_mux_input(0) <= ALUResult;
	 MemToReg_mux_input(1) <= mem_data_read;
	 
	 MemToReg_mux: mux_2to1
    Port map( 
        sel => MemToReg,
        data => MemToReg_mux_input,
        result => MemToReg_mux_out
    );
	 
	
end mips_cpu_arch;