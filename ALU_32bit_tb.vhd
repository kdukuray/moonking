library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.numeric_std.ALL;

entity ALU_32bit_tb is
end ALU_32bit_tb;

architecture ALU_32bit_tb_arch of ALU_32bit_tb is

component ALU_32bit is
	port(
		a: in std_logic_vector( 31 downto 0);
		b: in std_logic_vector( 31 downto 0);
		ALUControl: in std_logic_vector( 3 downto 0);
		Result: out std_logic_vector( 31 downto 0);
		overflow: out std_logic;
		zero: out std_logic
	);
end component;

signal a: std_logic_vector( 31 downto 0) := (others => '0');
signal b:  std_logic_vector( 31 downto 0) := (others => '0');
signal ALUControl:  std_logic_vector( 3 downto 0) := (others => '0');
signal Result:  std_logic_vector( 31 downto 0);
signal overflow:  std_logic;
signal zero:  std_logic;

begin

	alu_ut: ALU_32bit port map(
		a => a,
		b => b,
		ALUControl => ALUControl,
		Result => Result,
		overflow => overflow,
		zero => zero
	);

	
	tb_process: process
	begin
		-- test 'and' operation
		ALUControl <= "0000";
		a <= "00000000000000000000000000000011";
		b <= "00000000000000000000000000000110";
		wait for 10 ns;
		assert Result = "00000000000000000000000000000010"
			report "AND operation failed" severity error;
		
		-- test 'or' operation
		ALUControl <= "0001";
		a <= "00000000000000000000000000000011";
		b <= "00000000000000000000000000000110";
		wait for 10 ns;
		assert Result = "00000000000000000000000000000111"
			report "OR operation failed" severity error;
		
		-- test addition operation
		ALUControl <= "0010";
		a <= std_logic_vector(to_signed(3, a'length));
		b <= std_logic_vector(to_signed(2, b'length));
		wait for 10 ns;
		assert Result = std_logic_vector(to_signed(5, Result'length))
			report "addition operation failed" severity error;
		
		-- test subtract operation
		ALUControl <= "0110";
		a <= std_logic_vector(to_signed(3, a'length));
		b <= std_logic_vector(to_signed(2, b'length));
		wait for 10 ns;
		assert Result = std_logic_vector(to_signed(1, Result'length))
			report "subtraction operation failed" severity error;
		
		-- test subtract to see when result is 0, to check the zero flag
		ALUControl <= "0110";
		a <= std_logic_vector(to_signed(2, a'length));
		b <= std_logic_vector(to_signed(2, b'length));
		wait for 10 ns;
		assert zero = '1'
			report "zero flag failed to be set" severity error;
		
		-- A check to see if no overflow happens when the two numbers added are negative
		ALUControl <= "0010";
		a <= std_logic_vector(to_signed(-2, a'length));
		b <= std_logic_vector(to_signed(-2, b'length));
		wait for 10 ns;
		assert overflow = '0'
			report "Overflow happened when adding two negative numbers" severity error;
		
		-- This test case is to test overflow flag.
		ALUControl <= "0010";
		a <= "10000000000000000000000000000000";
		b <= std_logic_vector(to_signed(-1, b'length));
		wait for 10 ns;
		assert overflow = '1'
			report "Overflow not detected" severity error;
		
		-- test the set less than operation when false
		ALUControl <= "0111";
		a <= std_logic_vector(to_signed(3, a'length));
		b <= std_logic_vector(to_signed(2, b'length));
		wait for 10 ns;
		assert Result = std_logic_vector(to_signed(0, Result'length))
			report "set less than operation set value 1, when 0 expected" severity error;
		
		-- test the set less than operation when true
		ALUControl <= "0111";
		a <= std_logic_vector(to_signed(2, a'length));
		b <= std_logic_vector(to_unsigned(3, b'length));
		wait for 10 ns;
		assert Result = std_logic_vector(to_signed(1, Result'length))
			report "set less than operation set value 0, when 1 expected" severity error;
		
		-- test nor operation
		ALUControl <= "1100";
		a <= std_logic_vector(to_signed(3, a'length));
		b <= std_logic_vector(to_unsigned(2, b'length));
		wait for 10 ns;
		assert Result = "11111111111111111111111111111100"
			report "OR operation failed" severity error;
		
	end process;


end ALU_32bit_tb_arch;