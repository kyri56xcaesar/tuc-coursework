--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   15:33:55 03/16/2023
-- Design Name:   
-- Module Name:   /home/ise/sharedforvm/computerOrganisation/DECcloud_tb.vhd
-- Project Name:  computerOrganisation
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: DECcloud
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
 
ENTITY DECcloud_tb IS
END DECcloud_tb;
 
ARCHITECTURE behavior OF DECcloud_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT DECcloud
    PORT(
         Instr : IN  std_logic_vector(15 downto 0);
         Immed : OUT  std_logic_vector(31 downto 0);
         OPcode : IN  std_logic_vector(5 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal Instr : std_logic_vector(15 downto 0) := (others => '0');
   signal OPcode : std_logic_vector(5 downto 0) := (others => '0');

 	--Outputs
   signal Immed : std_logic_vector(31 downto 0);
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: DECcloud PORT MAP (
          Instr => Instr,
          Immed => Immed,
          OPcode => OPcode
        );

  

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      --sign extend
		Instr  <= "0000000000000110";
		OPcode <= "111000";--li
		wait for 10 ns;
		
		--sign extend
		Instr  <= "1000000000000110";
		OPcode <= "000011";--lb
		wait for 10 ns;
		
		--sign extend
		Instr  <= "1000000000000110";
		OPcode <= "000111";--sb
		wait for 10 ns;
		
		--sign extend
		Instr  <= "1000000000000110";
		OPcode <= "001111";--lw
		wait for 10 ns;
		
		--sign extend
		Instr  <= "1000000000000110";
		OPcode <= "011111";--sw
		wait for 10 ns;
		
		--zero fill
		Instr  <= "1000000000000110";
		OPcode <= "110010";--andi
		wait for 10 ns;
		
		--zero fill
		Instr  <= "1000000000000110";
		OPcode <= "110011";--ori
		wait for 10 ns;
		
		--sign extend sll 2
		Instr  <= "1000000000000111";
		OPcode <= "111111";--branch
		wait for 10 ns;
		
		--sign extend sll 2
		Instr  <= "1000000000000001";
		OPcode <= "010000";--beq
		wait for 10 ns;
		
		--sign extend sll 2
		Instr  <= "1000000000000001";
		OPcode <= "010001";--bne
		wait for 10 ns;
		
		
		--sll 16 and zero fill 
		Instr  <= "1111111111111111";
		OPcode <= "111001";--lui
		wait for 10 ns;

      wait;
   end process;

END;
