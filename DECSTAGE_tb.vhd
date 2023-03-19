--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   14:45:16 03/18/2023
-- Design Name:   
-- Module Name:   /home/ise/sharedforvm/computerOrganisation/DECSTAGE_tb.vhd
-- Project Name:  computerOrganisation
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: DECSTAGE
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
 
ENTITY DECSTAGE_tb IS
END DECSTAGE_tb;
 
ARCHITECTURE behavior OF DECSTAGE_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT DECSTAGE
    PORT(
         Instr : IN  std_logic_vector(31 downto 0);
         ALU_out : IN  std_logic_vector(31 downto 0);
         MEM_out : IN  std_logic_vector(31 downto 0);
         RF_WrData_sel : IN  std_logic;
         RF_WrEn : IN  std_logic;
         RF_B_sel : IN  std_logic;
         Clk : IN  std_logic;
			Reset : IN std_logic;
         RF_A : OUT  std_logic_vector(31 downto 0);
         RF_B : OUT  std_logic_vector(31 downto 0);
         Immed : OUT  std_logic_vector(31 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal Instr : std_logic_vector(31 downto 0) := (others => '0');
   signal ALU_out : std_logic_vector(31 downto 0) := (others => '0');
   signal MEM_out : std_logic_vector(31 downto 0) := (others => '0');
   signal RF_WrData_sel : std_logic := '0';
   signal RF_WrEn : std_logic := '0';
   signal RF_B_sel : std_logic := '0';
   signal Clk : std_logic := '0';
	signal Reset : std_logic := '0';

 	--Outputs
   signal RF_A : std_logic_vector(31 downto 0);
   signal RF_B : std_logic_vector(31 downto 0);
   signal Immed : std_logic_vector(31 downto 0);

   -- Clock period definitions
   constant Clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: DECSTAGE PORT MAP (
          Instr => Instr,
          ALU_out => ALU_out,
          MEM_out => MEM_out,
          RF_WrData_sel => RF_WrData_sel,
          RF_WrEn => RF_WrEn,
          RF_B_sel => RF_B_sel,
          Clk => Clk,
          RF_A => RF_A,
          RF_B => RF_B,
          Immed => Immed,
			 Reset => Reset
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
    	
		
		Instr <= "10000000010001000000001010110000";
		RF_WrEn <='1';
      ALU_out <= "10000000010000100000001010110000";
      MEM_out <= "00000000000000100000001010110000";
      RF_WrData_sel <='0';
      RF_B_sel <= '0';
		Reset <= '1';
		
	   -- hold reset state for 100 ns.
      wait for 100 ns;
		
		Instr <= "10000000010001000000001010110000";
		RF_WrEn <='1';
      ALU_out <= "10000000010000100000001010110000";
      MEM_out <= "00000000000000100000001010110000";
      RF_WrData_sel <='1';
      RF_B_sel <= '0';
		Reset <= '0';
		
		
      wait for Clk_period*10;
		
		Instr <= "10000000000001000001001010110000";
		RF_WrEn <='1';
      ALU_out <= "10000000010000100000001010110000";
      MEM_out <= "00000000000000100000001010110000";
      RF_WrData_sel <='1';
      RF_B_sel <= '0';
		Reset <= '0';
		
		
      wait for Clk_period*10;
		
		
		Instr <= "10000000100010000001001010110000";
		RF_WrEn <='1';
      ALU_out <= "10000000010000100000001010110000";
      MEM_out <= "00000000000000100000001010110000";
      RF_WrData_sel <='1';
      RF_B_sel <= '0';
		Reset <= '0';
		
		
      wait for Clk_period*10;
       
		
      wait;
   end process;

END;
