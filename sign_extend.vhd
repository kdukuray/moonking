library IEEE;
use IEEE.std_logic_1164.ALL;

entity sign_extend is
    Port ( immediate16 : in  std_logic_vector (15 downto 0);
				immediate32: out std_logic_vector (31 downto 0)
			  );
end sign_extend;

architecture sign_extend_arch of sign_extend is


begin

	immediate32( 15 downto 0 ) <= immediate16;
	copy_bits: for i in 31 downto 16 generate
		immediate32( i ) <= immediate16(15);
	end generate copy_bits;

end sign_extend_arch;