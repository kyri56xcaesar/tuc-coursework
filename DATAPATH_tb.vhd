--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   09:23:02 03/19/2023
-- Design Name:   
-- Module Name:   /home/ise/sharedforvm/computerOrganisation/DATAPATH_tb.vhd
-- Project Name:  computerOrganisation
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: DATAPATH
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
 
ENTITY DATAPATH_tb IS
END DATAPATH_tb;
 
ARCHITECTURE behavior OF DATAPATH_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT DATAPATH
    PORT(
         Instrin : IN  std_logic_vector(31 downto 0);
         RF_Wr_Data_sel : IN  std_logic;
         RF_B_sel : IN  std_logic;
         ALU_Bin_sel : IN  std_logic;
         ALU_func : IN  std_logic_vector(3 downto 0);
         MEM_WrEn : IN  std_logic;
         PC_Immed : IN  std_logic_vector(31 downto 0);
         PC_sel : IN  std_logic;
         PC_LdEn : IN  std_logic;
         Reset : IN  std_logic;
         Clk : IN  std_logic;
         ALU_zero : OUT  std_logic_vector(31 downto 0);
         ALU_OVF : OUT  std_logic_vector(31 downto 0);
         ALU_COUT : OUT  std_logic_vector(31 downto 0);
         Instrout : OUT  std_logic_vector(31 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal Instrin : std_logic_vector(31 downto 0) := (others => '0');
   signal RF_Wr_Data_sel : std_logic := '0';
   signal RF_B_sel : std_logic := '0';
   signal ALU_Bin_sel : std_logic := '0';
   signal ALU_func : std_logic_vector(3 downto 0) := (others => '0');
   signal MEM_WrEn : std_logic := '0';
   signal PC_Immed : std_logic_vector(31 downto 0) := (others => '0');
   signal PC_sel : std_logic := '0';
   signal PC_LdEn : std_logic := '0';
   signal Reset : std_logic := '0';
   signal Clk : std_logic := '0';

 	--Outputs
   signal ALU_zero : std_logic_vector(31 downto 0);
   signal ALU_OVF : std_logic_vector(31 downto 0);
   signal ALU_COUT : std_logic_vector(31 downto 0);
   signal Instrout : std_logic_vector(31 downto 0);

   -- Clock period definitions
   constant Clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: DATAPATH PORT MAP (
          Instrin => Instrin,
          RF_Wr_Data_sel => RF_Wr_Data_sel,
          RF_B_sel => RF_B_sel,
          ALU_Bin_sel => ALU_Bin_sel,
          ALU_func => ALU_func,
          MEM_WrEn => MEM_WrEn,
          PC_Immed => PC_Immed,
          PC_sel => PC_sel,
          PC_LdEn => PC_LdEn,
          Reset => Reset,
          Clk => Clk,
          ALU_zero => ALU_zero,
          ALU_OVF => ALU_OVF,
          ALU_COUT => ALU_COUT,
          Instrout => Instrout
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
		Reset <= '1';
      wait for 100 ns;	

      wait for Clk_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
