library IEEE;
use IEEE.std_logic_1164.ALL;

entity ALU_32bit is
	port(
		a: in std_logic_vector( 31 downto 0);
		b: in std_logic_vector( 31 downto 0);
		ALUControl: in std_logic_vector( 3 downto 0);
		Result: out std_logic_vector( 31 downto 0);
		overflow: out std_logic;
		zero: out std_logic
	);
end ALU_32bit;

architecture ALU_32bit_arch of ALU_32bit is

	component ALU_1bit is
	port(
		a: in std_logic;
		b: in std_logic;
		less: in std_logic;
		CarryIn: in std_logic;
		ALUControl: in std_logic_vector( 3 downto 0);
		Result: out std_logic;
		CarryOut: out std_logic
	);
	end component;

	component ALU_1bit_MSB is
	port(
		a: in std_logic;
		b: in std_logic;
		less: in std_logic;
		CarryIn: in std_logic;
		ALUControl: in std_logic_vector( 3 downto 0);
		Result: out std_logic;
		Set: out std_logic;
		Overflow: out std_logic
	);
	end component;
	
	signal CarryOut: std_logic_vector(31 downto 0);
	signal Set: std_logic;
	signal zero_signal: std_logic := '0';
	signal result_signal: std_logic_vector(31 downto 0);
	

begin

	alu_unit0: ALU_1bit
		port map(
			a => a(0),
			b => b(0),
			less => Set,
			CarryIn => ALUControl(2),
			ALUControl => ALUControl,
			Result => result_signal(0),
			CarryOut => CarryOut(0)
		);

	ALU_generate: for i in 30 downto 1 generate
		alu_unit: ALU_1bit
		port map(
			a => a(i),
			b => b(i),
			less => '0',
			CarryIn => CarryOut(i-1),
			ALUControl => ALUControl,
			Result => result_signal(i),
			CarryOut => CarryOut(i)
		);
	end generate ALU_generate;
	
	alu_unit31: ALU_1bit_MSB
		port map(
			a => a(31),
			b => b(31),
			less => '0',
			CarryIn => CarryOut(30),
			ALUControl => ALUControl,
			Result => result_signal(31),
			Set => Set,
			Overflow => Overflow
		);
	result <= result_signal;
	
	zero_signal <= 
						result_signal(0) or
						result_signal(1) or
						result_signal(2) or
						result_signal(3) or
						result_signal(4) or
						result_signal(5) or
						result_signal(6) or
						result_signal(7) or
						result_signal(8) or
						result_signal(9) or
						result_signal(10) or
						result_signal(11) or
						result_signal(12) or
						result_signal(13) or
						result_signal(14) or
						result_signal(15) or
						result_signal(16) or
						result_signal(17) or
						result_signal(18) or
						result_signal(19) or
						result_signal(20) or
						result_signal(21) or
						result_signal(22) or
						result_signal(23) or
						result_signal(24) or
						result_signal(25) or
						result_signal(26) or
						result_signal(27) or
						result_signal(28) or
						result_signal(29) or
						result_signal(30) or
						result_signal(31);
						
	
	zero <= not zero_signal;
		

	
end ALU_32bit_arch;