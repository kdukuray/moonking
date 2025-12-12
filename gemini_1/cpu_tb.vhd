library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity cpu_tb is
end;

architecture bench of cpu_tb is

  -- Component Declaration for the Unit Under Test (UUT)
  component cpu_mips
      port(Clk: in std_logic);
  end component;

  -- Signal Declarations
  signal Clk: std_logic := '0';
  
  -- Clock period definitions
  constant Clk_period : time := 10 ns;

begin

  -- Instantiate the Unit Under Test (UUT)
  uut: cpu_mips port map ( 
      Clk => Clk 
  );

  -- Clock process definitions
  Clk_process :process
  begin
      Clk <= '0';
      wait for Clk_period/2;
      Clk <= '1';
      wait for Clk_period/2;
  end process;

  -- Stimulus process
  stim_proc: process
  begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      -- The simulation will run forever due to the clock process.
      -- You should run it for about 200ns - 500ns in ModelSim 
      -- to see all instructions execute.
      
      wait;
  end process;

end;