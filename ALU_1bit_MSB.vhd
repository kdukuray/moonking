library IEEE;
use IEEE.std_logic_1164.ALL;

entity ALU_1bit_MSB is
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
end ALU_1bit_MSB;


architecture ALU_1bit_MSB_arch of ALU_1bit_MSB is

component mux_nto1 is
	 generic(
		logN: integer := 1;
		N: integer := 2
	 );
    Port ( 
        sel : in  std_logic_vector(logN-1 downto 0); 
        data : in  std_logic_vector(N-1 downto 0); 
        result : out std_logic
    );
end component;

component full_adder is
    Port ( A : in  std_logic;
           B : in  std_logic;
			  CarryIn: in std_logic;
           Sum : out  std_logic;
           CarryOut : out  std_logic);
end component;

signal a_values, b_values: std_logic_vector( 1 downto 0);
signal a_mux_result, b_mux_result: std_logic;
signal operations_results: std_logic_vector( 3 downto 0);
signal CarryOut: std_logic;
signal overflow_result: std_logic;
signal sel_a, sel_b: std_logic_vector( 0 downto 0);

begin

	a_values(0) <= a;
	a_values(1) <= not a;
	
	b_values(0) <= b;
	b_values(1) <= not b;
	
	sel_a(0) <= ALUControl(3);
	sel_b(0) <= ALUControl(2);

	a_mux: mux_nto1 
	generic map(
		logN => 1,
		N => 2
	)
	port map(
		sel => sel_a,
		data => a_values,
		result => a_mux_result
	);
	
	b_mux: mux_nto1 
	generic map(
		logN => 1,
		N => 2
	)
	port map(
		sel => sel_b,
		data => b_values,
		result => b_mux_result
	);
	
	operations_results(0) <= a_mux_result and b_mux_result;
	operations_results(1) <= a_mux_result or b_mux_result;
	
	fa: full_adder
    port map( 
			A => a_mux_result,
         B => b_mux_result,
			CarryIn => CarryIn,
         Sum => operations_results(2),
         CarryOut => CarryOut
			);

	operations_results(3) <= less;
	
	result_mux: mux_nto1 
	generic map(
		logN => 2,
		N => 4
	)
	port map(
		sel => ALUControl(1 downto 0),
		data => operations_results,
		result => Result
	);

	
	overflow_result <= CarryIn xor CarryOut;
	overflow <= overflow_result;
	
	Set <= operations_results(2) xor overflow_result;
	
	
end ALU_1bit_MSB_arch;