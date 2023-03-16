--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   14:19:00 03/16/2023
-- Design Name:   
-- Module Name:   /home/ise/sharedforvm/computerOrganisation/ALUSTAGE_tb.vhd
-- Project Name:  computerOrganisation
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: ALUSTAGE
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
 
ENTITY ALUSTAGE_tb IS
END ALUSTAGE_tb;
 
ARCHITECTURE behavior OF ALUSTAGE_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT ALUSTAGE
    PORT(
         RF_A : IN  std_logic_vector(31 downto 0);
         RF_B : IN  std_logic_vector(31 downto 0);
         Immed : IN  std_logic_vector(31 downto 0);
         ALU_Bin_sel : IN  std_logic;
         ALU_func : IN  std_logic_vector(3 downto 0);
         ALU_out : OUT  std_logic_vector(31 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal RF_A : std_logic_vector(31 downto 0) := (others => '0');
   signal RF_B : std_logic_vector(31 downto 0) := (others => '0');
   signal Immed : std_logic_vector(31 downto 0) := (others => '0');
   signal ALU_Bin_sel : std_logic := '0';
   signal ALU_func : std_logic_vector(3 downto 0) := (others => '0');

 	--Outputs
   signal ALU_out : std_logic_vector(31 downto 0);
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: ALUSTAGE PORT MAP (
          RF_A => RF_A,
          RF_B => RF_B,
          Immed => Immed,
          ALU_Bin_sel => ALU_Bin_sel,
          ALU_func => ALU_func,
          ALU_out => ALU_out
        );

   
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	
		
		RF_A        <= "00000000000000000000000000001000";
		RF_B        <= "00000000000000000000000000000100";
		Immed       <= "00000000000000000000000000000001";
		ALU_Bin_sel <= '1';--select RF_B
		ALU_func    <= "0000";--add
		
		wait for 50 ns ;
		
		
		RF_A        <= "00000000000000000000000000001000";
		RF_B        <= "00000000000000000000000000000100";
		Immed       <= "00000000000000000000000000000001";
		ALU_Bin_sel <= '0';--select immediate
		ALU_func    <= "0000";--add(i)
		
		wait for 50 ns ;
		
		RF_A        <= "00000000000000000000000000001000";
		RF_B        <= "00000000000000000000000000000100";
		Immed       <= "00000000000000000000000000000001";
		ALU_Bin_sel <= '0';--select immediate
		ALU_func    <= "0001";--sub(i)
		
		wait for 50 ns ;
		
		RF_A        <= "00000000000000000000000000001000";
		RF_B        <= "00000000000000000000000000000100";
		Immed       <= "00000000000000000000000000000001";
		ALU_Bin_sel <= '1';--select  RF_B
		ALU_func    <= "0001";--sub
		
		wait for 50 ns ;
		
		RF_A        <= "00000000000000000000000000001001";
		RF_B        <= "00000000000000000000000000000100";
		Immed       <= "00000000000000000000000000000001";
		ALU_Bin_sel <= '0';--select  immediate
		ALU_func    <= "0010";--and(i)
		
		wait for 50 ns ;
		
		RF_A        <= "00000000000000000000000000001000";
		RF_B        <= "00000000000000000000000000000100";
		Immed       <= "00000000000000000000000000000001";
		ALU_Bin_sel <= '1';--select  RF_B
		ALU_func    <= "0010";--and
		
		wait for 50 ns ;
		
		
		RF_A        <= "00000000000000000000000000001000";
		RF_B        <= "00000000000000000000000000000100";
		Immed       <= "00000000000000000000000000000001";
		ALU_Bin_sel <= '0';--select  immediate
		ALU_func    <= "0011";--or(i)
		
		wait for 50 ns ;
		
		RF_A        <= "00000000000000000000000000001000";
		RF_B        <= "00000000000000000000000000000100";
		Immed       <= "00000000000000000000000000000001";
		ALU_Bin_sel <= '1';--select  RF_B
		ALU_func    <= "0011";--or
		
		wait for 50 ns ;
		
		RF_A        <= "00000000000000000000000000001000";
		RF_B        <= "00000000000000000000000000000100";
		Immed       <= "00000000000000000000000000000001";
		ALU_Bin_sel <= '1';--select  RF_B
		ALU_func    <= "0100";--not A
		
		wait for 50 ns ;
		
		
		--should not change from before
		RF_A        <= "00000000000000000000000000001000";
		RF_B        <= "00000000000000000000000000000100";
		Immed       <= "00000000000000000000000000000001";
		ALU_Bin_sel <= '0';--select  immediate
		ALU_func    <= "0100";--not A
		
		wait for 50 ns ;
		
		RF_A        <= "00000000000000000000000000001000";
		RF_B        <= "00000000000000000000000000000100";
		Immed       <= "00000000000000000000000000000001";
		ALU_Bin_sel <= '0';--select  immediate
		ALU_func    <= "1000";--sra A
		
		wait for 50 ns ;
		
		RF_A        <= "00000000000000000000000000001000";
		RF_B        <= "00000000000000000000000000000100";
		Immed       <= "00000000000000000000000000000001";
		ALU_Bin_sel <= '0';--select  immediate
		ALU_func    <= "1001";--srl A
		
		wait for 50 ns ;
		
		RF_A        <= "00000000000000000000000000001000";
		RF_B        <= "00000000000000000000000000000100";
		Immed       <= "00000000000000000000000000000001";
		ALU_Bin_sel <= '0';--select  immediate
		ALU_func    <= "1010";--sll A
		
		wait for 50 ns ;
		
		RF_A        <= "10000000000000000000000000001000";
		RF_B        <= "00000000000000000000000000000100";
		Immed       <= "00000000000000000000000000000001";
		ALU_Bin_sel <= '0';--select  immediate
		ALU_func    <= "1100";--rotate left A
		
		wait for 50 ns ;
		
		
		RF_A        <= "00000000000000000000000000001001";
		RF_B        <= "00000000000000000000000000000100";
		Immed       <= "00000000000000000000000000000001";
		ALU_Bin_sel <= '0';--select  immediate
		ALU_func    <= "1101";--rotate right A
		
		wait for 50 ns ;
		


      wait;
   end process;

END;
