library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.numeric_std.ALL;

LIBRARY lpm;
USE lpm.all;

library work;
use work.my_types.ALL;

entity register_file is
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
end register_file;

architecture register_file_arch of register_file is

	component decoder is
    generic (
        N : integer := 5;  
        M : integer := 32
    );
    Port (
        A : in STD_LOGIC_VECTOR(N-1 downto 0);
        Y : out STD_LOGIC_VECTOR(M-1 downto 0)
    );
end component;
	
	component mux_32to1 is
    Port ( 
        sel : in  std_logic_vector(4 downto 0); 
        data : in  std_logic_2d_32_32; 
        result : out std_logic_vector(31 downto 0)
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
	
	signal decode_addresses, write_enable_per_reg: std_logic_vector(31 downto 0);
	signal read_regs: std_logic_2d_32_32;

begin

comp_dec : decoder
	PORT MAP (
		Rw,
		decode_addresses
);
	
	
	-- register 0 will always be 0, so we just ground the output.
	write_enable_per_reg(0) <= '0';
	read_regs(0) <= std_logic_vector(to_signed(0, 32));
	
	
	for_registers: for i in 1 to 31 generate
	
	
		write_enable_per_reg(i) <= RegWr and decode_addresses(i);
	
		nr: n_register port map(
			busW,
			Clk,
			write_enable_per_reg(i),
			read_regs(i)
		);
		
	
	
	end generate for_registers;
	
	
	mux32_1_a: mux_32to1
    port map ( 
		data => read_regs,
		sel => Ra,
		result => busA
    );
	 
	 mux32_1_b: mux_32to1
    port map ( 
		data => read_regs,
		sel => Rb,
		result => busB
    );
	


end register_file_arch;