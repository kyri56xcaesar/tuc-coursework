--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   15:19:42 03/10/2023
-- Design Name:   
-- Module Name:   /home/ise/sharedforvm/computerOrganisation/RegisterFile_tb.vhd
-- Project Name:  computerOrganisation
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: RegisterFile
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
 
ENTITY RegisterFile_tb IS
END RegisterFile_tb;
 
ARCHITECTURE behavior OF RegisterFile_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT RegisterFile
    PORT(
         Ard1 : IN  std_logic_vector(4 downto 0);
         Ard2 : IN  std_logic_vector(4 downto 0);
         Awr : IN  std_logic_vector(4 downto 0);
         Din : IN  std_logic_vector(31 downto 0);
         WrEn : IN  std_logic;
         Clk : IN  std_logic;
         Dout1 : OUT  std_logic_vector(31 downto 0);
         Dout2 : OUT  std_logic_vector(31 downto 0);
			Reset : in   STD_LOGIC);

    END COMPONENT;
    
 
   --Inputs
   signal Ard1 : std_logic_vector(4 downto 0) := (others => '0');
   signal Ard2 : std_logic_vector(4 downto 0) := (others => '0');
   signal Awr : std_logic_vector(4 downto 0) := (others => '0');
   signal Din : std_logic_vector(31 downto 0) := (others => '0');
   signal WrEn : std_logic := '0';
   signal Clk : std_logic := '0';
	signal Reset : std_logic := '1';

 	--Outputs
   signal Dout1 : std_logic_vector(31 downto 0);
   signal Dout2 : std_logic_vector(31 downto 0);

   -- Clock period definitions
   constant Clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: RegisterFile PORT MAP (
          Ard1 => Ard1,
          Ard2 => Ard2,
          Awr => Awr,
          Din => Din,
          WrEn => WrEn,
          Clk => Clk,
          Dout1 => Dout1,
          Dout2 => Dout2,
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
      -- hold reset state for 100 ns.
      wait for 100 ns;	

		-- check the R0 cannot be read.
		Ard1 <= "00000";
		Awr  <= "00000";
		Din  <= "11111111110001010101100000000111";
		WrEn <= '1';
		Reset <='0';
      wait for Clk_period*2;
		
		--now it should write to the register(1)
		Ard1 <= "00001";
		Ard2 <= "00001";
		Awr  <= "00001";
		Din  <= "00000011110001010101100000000000";
		WrEn <= '1';

      wait for Clk_period*2;
		
		
		Ard1 <= "01000";
		Ard2 <= "00010";
		Awr  <= "10101";
		Din  <= "00000011110001010101100000000000";
		WrEn <= '1';
      wait for Clk_period*2;
		
		Ard1 <= "01000";
		Ard2 <= "00010";
		Awr  <= "00111";
		Din  <= "00000011110001010101100000000000";
		WrEn <= '1';
      wait for Clk_period*2;
		
		Ard1 <= "10101";
		Ard2 <= "00010";
		Awr  <= "00001";
		Din  <= "00000011110001010101100000000000";
		WrEn <= '1';
      wait for Clk_period*2;
      
      wait;
   end process;

END;