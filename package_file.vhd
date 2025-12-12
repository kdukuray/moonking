library IEEE;
use IEEE.std_logic_1164.ALL;

library work;
use work.my_types.ALL;

package my_components is

component nbit_add_sub is
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
end component;

component n_register is
	generic(N: integer := 32);
	port(
		D: in std_logic_vector( N-1 downto 0);
		Clk: in std_logic;
		En: in std_logic;
		Q: out std_logic_vector( N-1 downto 0)
	);
end component;

component mux_2to1 is
    Port ( 
        sel : in  std_logic; 
        data : in  std_logic_2d_2_32;
        result : out std_logic_vector(31 downto 0)
    );
end component;

component mux_2to1_5bits is
    Port ( 
        sel : in  std_logic; 
        data : in  std_logic_2d_2_5;
        result : out std_logic_vector(4 downto 0)
    );
end component;

component instruction_memory IS
	PORT
	(
		address		: IN STD_LOGIC_VECTOR (15 DOWNTO 0);
		clock		: IN STD_LOGIC  := '1';
		data		: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		wren		: IN STD_LOGIC ;
		q		: OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
	);
END component;

component register_file is
	generic(N: integer := 32);
	port(
		RegWr: in std_logic;
		Rw: in std_logic_vector( 4 downto 0);
		Ra: in std_logic_vector( 4 downto 0);
		Rb: in std_logic_vector( 4 downto 0);
		Clk: in std_logic;
		busW: in std_logic_vector( N-1 downto 0);
		busA: out std_logic_vector( N-1 downto 0);
		busB: out std_logic_vector( N-1 downto 0)
	);
end component;

component ALU_control_unit is
    Port ( funct : in  std_logic_vector (5 downto 0);
				ALUOp : in  std_logic_vector (1 downto 0);
           Operation : out  std_logic_vector (3 downto 0)
			  );
end component;

component control_unit is
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
end component;

component sign_extend is
    Port ( immediate16 : in  std_logic_vector (15 downto 0);
				immediate32: out std_logic_vector (31 downto 0)
			  );
end component;

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

component data_memory IS
	PORT
	(
		address		: IN STD_LOGIC_VECTOR (15 DOWNTO 0);
		clock		: IN STD_LOGIC  := '1';
		outclock	: IN STD_LOGIC  := '1';
		data		: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		wren		: IN STD_LOGIC ;
		q		: OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
	);
END component;


end package my_components;