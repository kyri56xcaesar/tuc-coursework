--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   12:00:24 04/02/2023
-- Design Name:   
-- Module Name:   /home/ise/sharedforvm/computerOrganisation/CONTROL_tb.vhd
-- Project Name:  computerOrganisation
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: CONTROL
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
 
ENTITY CONTROL_tb IS
END CONTROL_tb;
 
ARCHITECTURE behavior OF CONTROL_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT CONTROL
    PORT(
         Instrin : IN  std_logic_vector(31 downto 0);
         Ovf : IN  std_logic;
         Cout : IN  std_logic;
         Zero : IN  std_logic;
         Reset : IN  std_logic;
         Clk : IN  std_logic;
         Instrout : OUT  std_logic_vector(31 downto 0);
         RF_Wr_Data_sel : OUT  std_logic;
         RF_B_sel : OUT  std_logic;
         ALU_Bin_sel : OUT  std_logic;
         ALU_func : OUT  std_logic_vector(3 downto 0);
         MEM_WrEn : OUT  std_logic;
         PC_sel : OUT  std_logic;
         PC_LdEn : OUT  std_logic;
         RF_WrEn : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal Instrin : std_logic_vector(31 downto 0) := (others => '0');
   signal Ovf : std_logic := '0';
   signal Cout : std_logic := '0';
   signal Zero : std_logic := '0';
   signal Reset : std_logic := '0';
   signal Clk : std_logic := '0';

 	--Outputs
   signal Instrout : std_logic_vector(31 downto 0);
   signal RF_Wr_Data_sel : std_logic;
   signal RF_B_sel : std_logic;
   signal ALU_Bin_sel : std_logic;
   signal ALU_func : std_logic_vector(3 downto 0);
   signal MEM_WrEn : std_logic;
   signal PC_sel : std_logic;
   signal PC_LdEn : std_logic;
   signal RF_WrEn : std_logic;

   -- Clock period definitions
   constant Clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: CONTROL PORT MAP (
          Instrin => Instrin,
          Ovf => Ovf,
          Cout => Cout,
          Zero => Zero,
          Reset => Reset,
          Clk => Clk,
          Instrout => Instrout,
          RF_Wr_Data_sel => RF_Wr_Data_sel,
          RF_B_sel => RF_B_sel,
          ALU_Bin_sel => ALU_Bin_sel,
          ALU_func => ALU_func,
          MEM_WrEn => MEM_WrEn,
          PC_sel => PC_sel,
          PC_LdEn => PC_LdEn,
          RF_WrEn => RF_WrEn
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

      wait for Clk_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
