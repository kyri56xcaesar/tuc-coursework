--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   16:28:53 03/11/2023
-- Design Name:   
-- Module Name:   /home/ise/sharedforvm/computerOrganisation/REG_tb.vhd
-- Project Name:  computerOrganisation
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: Reg
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY REG_tb IS
END REG_tb;
 
ARCHITECTURE behavior OF REG_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Reg
    PORT(
         CLK : IN  std_logic;
         DATA : IN  std_logic_vector(31 downto 0);
         Dout : OUT  std_logic_vector(31 downto 0);
         WE : IN  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal CLK : std_logic := '0';
   signal DATA : std_logic_vector(31 downto 0) := (others => '0');
   signal WE : std_logic := '0';

 	--Outputs
   signal Dout : std_logic_vector(31 downto 0);

   -- Clock period definitions
   constant CLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Reg PORT MAP (
          CLK => CLK,
          DATA => DATA,
          Dout => Dout,
          WE => WE
        );

   -- Clock process definitions
   CLK_process :process
   begin
		CLK <= '0';
		wait for CLK_period/2;
		CLK <= '1';
		wait for CLK_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for CLK_period*5;
		
		DATA <= "00000000000000000000000000000000";
		WE <= '0';
		
		--write output
		wait for CLK_period*5;
		
		DATA <= "10000000000000000000000000000000";
		WE <= '1';
		
		--hold the same output
		wait for CLK_period*5;
		
		DATA <= "01000000000000000000000000000000";
		WE <= '0';
		
		--change the data
		wait for CLK_period*5;
		
		DATA <= "00000000000000000000000000000111";
		WE <= '1';
		
		--do not change
		wait for CLK_period*5;
		
		DATA <= "00000000000000000000000000000001";
		WE <= '0';
		

      -- insert stimulus here 

      wait;
   end process;

END;
