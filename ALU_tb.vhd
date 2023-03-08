--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   13:07:57 03/08/2023
-- Design Name:   
-- Module Name:   /home/ise/sharedforvm/computerOrganisation/ALU_tb.vhd
-- Project Name:  computerOrganisation
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: ALU
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
 
ENTITY ALU_tb IS
END ALU_tb;
 
ARCHITECTURE behavior OF ALU_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT ALU
    PORT(
         A : IN  std_logic_vector(31 downto 0);
         B : IN  std_logic_vector(31 downto 0);
         Op : IN  std_logic_vector(3 downto 0);
         AluOut : OUT  std_logic_vector(31 downto 0);
         Zero : OUT  std_logic;
         Cout : OUT  std_logic;
         Ovf : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal A : std_logic_vector(31 downto 0) := (others => '0');
   signal B : std_logic_vector(31 downto 0) := (others => '0');
   signal Op : std_logic_vector(3 downto 0) := (others => '0');

 	--Outputs
   signal AluOut : std_logic_vector(31 downto 0);
   signal Zero : std_logic;
   signal Cout : std_logic;
   signal Ovf : std_logic;
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: ALU PORT MAP (
          A => A,
          B => B,
          Op => Op,
          AluOut => AluOut,
          Zero => Zero,
          Cout => Cout,
          Ovf => Ovf
        );

   -- Clock process definitions


   -- Stimulus process
   stim_proc1: process
   begin		
	
      A <= "00000000000000000000000000001000";--8
		B <= "00000000000000000000000000010000";--16
		Op <= "0000";--add
		wait for 50 ns;
		
		A <= "00000000000000000000000000010001";--17
		B <= "00000000000000000000000000010000";--16
		Op <= "0001";--sub
		
		wait for 50 ns;

		A <= "00000000000000000000000000001000";--8
		B <= "00000000000000000000000000010000";--16
		Op <= "0010";--and
		
		wait for 50 ns;

		A <= "00000000000000000000000000001000";--8
		B <= "00000000000000000000000000010000";--16
		Op <= "0011";--or
		
		wait for 50 ns;

		A <= "00000000000000000000000000001000";--8
		B <= "00000000000000000000000000000000";--0
		Op <= "0100";--not
		
		wait for 50 ns;

		A <= "10000000000000000000000000001000";
		Op <= "1000";--arithmetic shift right
		
		wait for 50 ns;

		A <= "00000000000000000000000000001000";--8
		Op <= "1001";--logic shift right
		
		wait for 50 ns;

		A <= "00000000000000000000000000001000";--8
		Op <= "1010";--logic shift left
		
		wait for 50 ns;

		A <= "10000000000000000000000000000000";
		Op <= "1100";--rotate left
		
		wait for 50 ns;

		A <= "00000000000000000000000000000001";
		Op <= "1101";--rotate right
		
		A <= "00000000000000000000000000000000";
		B <= "00000000000000000000000000000000";
		Op <= "0000";
		
		--try hard testing
		wait for 100 ns;
		
		--carry and overflow
		A <= "11111111111111111111111111111111";
		B <= "10000000000000000000000000000000";
		Op <= "0000";--add
		wait for 50 ns;
		
		--should overflow
		A <= "01111111111111111111111111111111";
		B <= "00000000000000000000000000000001";
		wait for 50 ns;
		
		--only carry
		A <= "11111111111111111111111111111111";
		B <= "01111111111111111111111111111111";
		wait for 50 ns;
		
		--zero and carry
		A <= "11111111111111111111111111111111";
		B <= "00000000000000000000000000000001";
		wait for 50 ns;
		
		--zero 
		A <= "11111111111111111111111111111100";
		B <= "00000000000000000000000000000100";
		wait for 100 ns;
		
		
		--subs
		
		
		--zero
		A <= "00000000000000000000000000000100";
		B <= "00000000000000000000000000000100";
		Op <= "0001";--sub
		wait for 50 ns;
		
		--carry
		A <= "11111111111111111111111111111111";
		B <= "00000000000000000000000000000001";
		Op <= "0001";--sub
		wait for 50 ns;
		
		
		
		
      wait;
   end process;
	
END;
