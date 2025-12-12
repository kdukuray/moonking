library IEEE;
use IEEE.std_logic_1164.ALL;

entity nbit_add_sub is
	 Generic(
		N: integer := 32
	 );
    Port ( A : in  std_logic_vector(N-1 downto 0);
           B : in  std_logic_vector(N-1 downto 0);
			  CarryIn: in std_logic;
			  Add_Sub: in std_logic;
           Sum : out  std_logic_vector(N-1 downto 0);
           CarryOut : out  std_logic;
			  overflow : out  std_logic
			  );
end nbit_add_sub;

architecture nbit_add_sub_arch of nbit_add_sub is

component full_adder is
    Port ( A : in  std_logic;
           B : in  std_logic;
			  CarryIn: in std_logic;
           Sum : out  std_logic;
           CarryOut : out  std_logic);
end component;

signal carry, B_sub: std_logic_vector(31 downto 0) := (others =>'0');
-- signal overflow: std_logic := '0';

begin

	CarryOut <= carry(N-1);
	
	overflow <= carry(N-1) xor carry(N-2);
	
	B_sub(0) <= B(0) xor Add_Sub;
	fa0: full_adder port map(
		 A(0),
		 B_sub(0),
		 CarryIn,
		 sum(0),
		 carry(0)
		 );
	
	generate_add_sub: for i in 1 to N-1 generate
	
		 B_sub(i) <= B(i) xor Add_Sub;
		 fa: full_adder port map(
		 A(i),
		 B_sub(i),
		 carry(i-1),
		 sum(i),
		 carry(i)
		 );
		 
	end generate generate_add_sub;
	
end nbit_add_sub_arch;