--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   15:21:46 03/11/2023
-- Design Name:   
-- Module Name:   /home/ise/sharedforvm/computerOrganisation/MUX32to1_tb.vhd
-- Project Name:  computerOrganisation
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: MUX32to1
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
 
--very simple test just to make sure 
ENTITY MUX32to1_tb IS
END MUX32to1_tb;
 
ARCHITECTURE behavior OF MUX32to1_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT MUX32to1
    PORT(
         sel : IN  std_logic_vector(4 downto 0);
         R0 : IN  std_logic_vector(31 downto 0);
         R1 : IN  std_logic_vector(31 downto 0);
         R2 : IN  std_logic_vector(31 downto 0);
         R3 : IN  std_logic_vector(31 downto 0);
         R4 : IN  std_logic_vector(31 downto 0);
         R5 : IN  std_logic_vector(31 downto 0);
         R6 : IN  std_logic_vector(31 downto 0);
         R7 : IN  std_logic_vector(31 downto 0);
         R8 : IN  std_logic_vector(31 downto 0);
         R9 : IN  std_logic_vector(31 downto 0);
         R10 : IN  std_logic_vector(31 downto 0);
         R11 : IN  std_logic_vector(31 downto 0);
         R12 : IN  std_logic_vector(31 downto 0);
         R13 : IN  std_logic_vector(31 downto 0);
         R14 : IN  std_logic_vector(31 downto 0);
         R15 : IN  std_logic_vector(31 downto 0);
         R16 : IN  std_logic_vector(31 downto 0);
         R17 : IN  std_logic_vector(31 downto 0);
         R18 : IN  std_logic_vector(31 downto 0);
         R19 : IN  std_logic_vector(31 downto 0);
         R20 : IN  std_logic_vector(31 downto 0);
         R21 : IN  std_logic_vector(31 downto 0);
         R22 : IN  std_logic_vector(31 downto 0);
         R23 : IN  std_logic_vector(31 downto 0);
         R24 : IN  std_logic_vector(31 downto 0);
         R25 : IN  std_logic_vector(31 downto 0);
         R26 : IN  std_logic_vector(31 downto 0);
         R27 : IN  std_logic_vector(31 downto 0);
         R28 : IN  std_logic_vector(31 downto 0);
         R29 : IN  std_logic_vector(31 downto 0);
         R30 : IN  std_logic_vector(31 downto 0);
         R31 : IN  std_logic_vector(31 downto 0);
         Mout : OUT  std_logic_vector(31 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal sel : std_logic_vector(4 downto 0) := (others => '0');
   signal R0 : std_logic_vector(31 downto 0) := (others => '0');
   signal R1 : std_logic_vector(31 downto 0) := (others => '0');
   signal R2 : std_logic_vector(31 downto 0) := (others => '0');
   signal R3 : std_logic_vector(31 downto 0) := (others => '0');
   signal R4 : std_logic_vector(31 downto 0) := (others => '0');
   signal R5 : std_logic_vector(31 downto 0) := (others => '0');
   signal R6 : std_logic_vector(31 downto 0) := (others => '0');
   signal R7 : std_logic_vector(31 downto 0) := (others => '0');
   signal R8 : std_logic_vector(31 downto 0) := (others => '0');
   signal R9 : std_logic_vector(31 downto 0) := (others => '0');
   signal R10 : std_logic_vector(31 downto 0) := (others => '0');
   signal R11 : std_logic_vector(31 downto 0) := (others => '0');
   signal R12 : std_logic_vector(31 downto 0) := (others => '0');
   signal R13 : std_logic_vector(31 downto 0) := (others => '0');
   signal R14 : std_logic_vector(31 downto 0) := (others => '0');
   signal R15 : std_logic_vector(31 downto 0) := (others => '0');
   signal R16 : std_logic_vector(31 downto 0) := (others => '0');
   signal R17 : std_logic_vector(31 downto 0) := (others => '0');
   signal R18 : std_logic_vector(31 downto 0) := (others => '0');
   signal R19 : std_logic_vector(31 downto 0) := (others => '0');
   signal R20 : std_logic_vector(31 downto 0) := (others => '0');
   signal R21 : std_logic_vector(31 downto 0) := (others => '0');
   signal R22 : std_logic_vector(31 downto 0) := (others => '0');
   signal R23 : std_logic_vector(31 downto 0) := (others => '0');
   signal R24 : std_logic_vector(31 downto 0) := (others => '0');
   signal R25 : std_logic_vector(31 downto 0) := (others => '0');
   signal R26 : std_logic_vector(31 downto 0) := (others => '0');
   signal R27 : std_logic_vector(31 downto 0) := (others => '0');
   signal R28 : std_logic_vector(31 downto 0) := (others => '0');
   signal R29 : std_logic_vector(31 downto 0) := (others => '0');
   signal R30 : std_logic_vector(31 downto 0) := (others => '0');
   signal R31 : std_logic_vector(31 downto 0) := (others => '0');

 	--Outputs
   signal Mout : std_logic_vector(31 downto 0);
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: MUX32to1 PORT MAP (
          sel => sel,
          R0 => R0,
          R1 => R1,
          R2 => R2,
          R3 => R3,
          R4 => R4,
          R5 => R5,
          R6 => R6,
          R7 => R7,
          R8 => R8,
          R9 => R9,
          R10 => R10,
          R11 => R11,
          R12 => R12,
          R13 => R13,
          R14 => R14,
          R15 => R15,
          R16 => R16,
          R17 => R17,
          R18 => R18,
          R19 => R19,
          R20 => R20,
          R21 => R21,
          R22 => R22,
          R23 => R23,
          R24 => R24,
          R25 => R25,
          R26 => R26,
          R27 => R27,
          R28 => R28,
          R29 => R29,
          R30 => R30,
          R31 => R31,
          Mout => Mout
        );

   
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	
		
		R0 <= "00000000000000000000000000001000";
		R1 <= "11000000000000000000000000000000";
      sel<= "00000";
		
		
		wait for 50 ns;	
		--select the second input
		sel <= "00001";

		wait for 50 ns;
		R0 <= "11100000000000000000000000001000";
		sel<= "00000";
		
		
		wait for 50 ns;
		R5  <= "11111111111111111111111111111111";
		R31 <= "11100000000000000000000000001111";
		sel<= "11111";
		
		
		wait for 50 ns;
		sel<= "00101";


      -- insert stimulus here 

      wait;
   end process;

END;
