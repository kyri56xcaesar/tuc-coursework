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
		
		--                       Rs   Rd   Rt
		--Instruction  <= "11000000001000110000000000000001"; I-type Addi 
      Instrin        <= "11000000001000110000000000000001";--Rt = Rs+1 (R3 = R1 + 1) R3 should have value 1 after
      RF_Wr_Data_sel <= '1';
      RF_B_sel       <= '1';
      ALU_Bin_sel    <= '0';
      ALU_func       <= "0000";
      MEM_WrEn       <= '0';
      PC_sel         <= '0';
      PC_LdEn        <= '1'; 
		Reset          <= '0';
		wait for Clk_period*4;
		
		
		--                       Rs   Rd   Rt
		--Instruction  <= "11000000011000110000000000000001"; I-type Addi
      Instrin        <= "11000000011000110000000000000001";--Rt = Rs + 1 (R3 = R3 + 1) R3 should have value 2 after
      RF_Wr_Data_sel <= '1';
      RF_B_sel       <= '1';
      ALU_Bin_sel    <= '0';
      ALU_func       <= "0000";
      MEM_WrEn       <= '0';
      PC_sel         <= '0';
      PC_LdEn        <= '1'; 
		Reset          <= '0';
		wait for Clk_period*4;

		
		--                       Rs   Rd   Rt        function
		--Instruction  <= "10000000001001100001100000110001"; R-type sub
      Instrin        <= "10000000001001100001100000110001";--Rd = Rs - Rt (R6 = R1 - R3) R6 should have value -2 after
      RF_Wr_Data_sel <= '1';
      RF_B_sel       <= '0';
      ALU_Bin_sel    <= '1';
      ALU_func       <= "0001";
      MEM_WrEn       <= '0';
      PC_sel         <= '0';
      PC_LdEn        <= '1'; 
		Reset          <= '0';
		wait for Clk_period*4;
		
		
		--                       Rs   Rd   Rt        function
		--Instruction  <= "10000000110001100001100000110100"; R-type not
      Instrin        <= "10000000110001100001100000110100";--Rd = !Rs (R6 = !R6) R6 should have value !2 after 
      RF_Wr_Data_sel <= '1';
      RF_B_sel       <= '1';
      ALU_Bin_sel    <= '1';
      ALU_func       <= "0100";
      MEM_WrEn       <= '0';
      PC_sel         <= '0';
      PC_LdEn        <= '1'; 
		Reset          <= '0';
		wait for Clk_period*4;
		
		
		
		--                       Rs   Rd  Immed         
		--Instruction  <= "10000000110001100000000000000001"; I-type addi
      Instrin        <= "10000000110001100000000000000001";--Rd = Rs + Rt (R6 = R6 +1) R6 should have value +2 after
      RF_Wr_Data_sel <= '1';
      RF_B_sel       <= '1';
      ALU_Bin_sel    <= '0';
      ALU_func       <= "0000";
      MEM_WrEn       <= '0';
      PC_sel         <= '0';
      PC_LdEn        <= '1'; 
		Reset          <= '0';
		wait for Clk_period*4;
		
		
		
		--                       Rs   Rd   Rt        function
		--Instruction  <= "10000000110001110001100000110001"; R-type sub
      Instrin        <= "10000000110001110001100000110001";--Rd = Rs - Rt (R7 = R6 - 2) R7 should have value 0 after
      RF_Wr_Data_sel <= '1';
      RF_B_sel       <= '0';
      ALU_Bin_sel    <= '1';
      ALU_func       <= "0001";
      MEM_WrEn       <= '0';
      PC_sel         <= '0';
      PC_LdEn        <= '1'; 
		Reset          <= '0';
		wait for Clk_period*4;
		
		
		
		--                       Rs   Rd   Rt        function
		--Instruction  <= "10000000110010000011100000110011"; R-type or
      Instrin        <= "10000000110010000011100000110011";--Rd = Rs or R3 (R8 = R6 or R7) R8 should have value 2 after
      RF_Wr_Data_sel <= '1';
      RF_B_sel       <= '0';
      ALU_Bin_sel    <= '1';
      ALU_func       <= "0011";
      MEM_WrEn       <= '0';
      PC_sel         <= '0';
      PC_LdEn        <= '1'; 
		Reset          <= '0';
		wait for Clk_period*4;
		
		
		
		--                       Rs   Rd   Rt        function
		--Instruction  <= "10000001000100000011100000111000"; R-type srl
      Instrin        <= "10000000110010000011100000111000";--Rd = Rs >> 2 (R16 = R8 >> 2) R16 should have value 2/2 = 1 after
      RF_Wr_Data_sel <= '1';
      RF_B_sel       <= '0';
      ALU_Bin_sel    <= '1';
      ALU_func       <= "1000";
      MEM_WrEn       <= '0';
      PC_sel         <= '0';
      PC_LdEn        <= '1'; 
		Reset          <= '0';
		wait for Clk_period*4;
		
		
		
		--                       Rs   Rd   Rt        function
		--Instruction  <= "10000001000100000011100000111001"; R-type sll
      Instrin        <= "10000001000100000011100000111001";--Rd = Rs << 2 (R16 = R8 << 2) R16 should have value 2*2 = 4 after
      RF_Wr_Data_sel <= '1';
      RF_B_sel       <= '0';
      ALU_Bin_sel    <= '1';
      ALU_func       <= "1001";
      MEM_WrEn       <= '0';
      PC_sel         <= '0';
      PC_LdEn        <= '1'; 
		Reset          <= '0';
		wait for Clk_period*4;
		
		--                       Rs   Rd   Rt        function
		--Instruction  <= "10000001000100000011100000111010"; R-type sra
      Instrin        <= "10000001000100000011100000111010";--Rd = Rs >> 1 (R16 = R8 >> 1) R16 should have value +2^32 value after
      RF_Wr_Data_sel <= '1';
      RF_B_sel       <= '1';
      ALU_Bin_sel    <= '1';
      ALU_func       <= "1000";
      MEM_WrEn       <= '0';
      PC_sel         <= '0';
      PC_LdEn        <= '1'; 
		Reset          <= '0';
		wait for Clk_period*4;
		
		--                       Rs   Rd   Rt        function
		--Instruction  <= "10000001000100000011100000111100"; R-type rol
      Instrin        <= "10000001000100000011100000111100";--Rd = Rs >> 1 (R16 = R8 rol 1) R16
      RF_Wr_Data_sel <= '1';
      RF_B_sel       <= '1';
      ALU_Bin_sel    <= '1';
      ALU_func       <= "1100";
      MEM_WrEn       <= '0';
      PC_sel         <= '0';
      PC_LdEn        <= '1'; 
		Reset          <= '0';
		wait for Clk_period*4;
		
		--                       Rs   Rd   immed        
		--Instruction  <= "11100001001100010000000000001000"; I-type li
      Instrin        <= "11100001001100010000000000001000";--Rd = immed (R17 = immed) R17 should have value 8 after
      RF_Wr_Data_sel <= '1';
      RF_B_sel       <= '1';
      ALU_Bin_sel    <= '0';
      ALU_func       <= "0010";
      MEM_WrEn       <= '0';
      PC_sel         <= '0';
      PC_LdEn        <= '1'; 
		Reset          <= '0';
		wait for Clk_period*4;
		
		--                       Rs   Rd   immed        
		--Instruction  <= "11100101001100010000000000011001"; I-type lui
      Instrin        <= "11100101001100010000000000011001";--Rd = immed (R17 = immed) R17 should have value  after
      RF_Wr_Data_sel <= '1';
      RF_B_sel       <= '1';
      ALU_Bin_sel    <= '0';
      ALU_func       <= "0011";
      MEM_WrEn       <= '0';
      PC_sel         <= '0';
      PC_LdEn        <= '1'; 
		Reset          <= '0';
		wait for Clk_period*4;


		--                       Rs   Rd   Rt        function
		--Instruction  <= "11001010001100110011100000111010"; I-type andi
      Instrin        <= "11001001000100000011100000111010";--Rd = Rs and  (R18 = R17 and 8) R18 should have value 8 after
      RF_Wr_Data_sel <= '1';
      RF_B_sel       <= '1';
      ALU_Bin_sel    <= '0';
      ALU_func       <= "0010";
      MEM_WrEn       <= '0';
      PC_sel         <= '0';
      PC_LdEn        <= '1'; 
		Reset          <= '0';
		wait for Clk_period*4;


		--                       Rs   Rd   Rt        function
		--Instruction  <= "11001110001101000011100000111010"; I-type ori
      Instrin        <= "11001110001100110011100000111010";--Rd = Rs | immed (R19 = R8 | immed) R19 should have value immed after
      RF_Wr_Data_sel <= '1';
      RF_B_sel       <= '1';
      ALU_Bin_sel    <= '0';
      ALU_func       <= "0011";
      MEM_WrEn       <= '0';
      PC_sel         <= '0';
      PC_LdEn        <= '1'; 
		Reset          <= '0';
		wait for Clk_period*4;


		--                       Rs   Rd   Rt        function
		--Instruction  <= "01000010100101000011100000111010"; beq
      Instrin        <= "10000001000100000011100000111010";--Rd = Rs >> 1 (R16 = R8 >> 1) R16 should have value +2^32 value after
      RF_Wr_Data_sel <= '1';
      RF_B_sel       <= '1';
      ALU_Bin_sel    <= '0';
      ALU_func       <= "0001";
      MEM_WrEn       <= '0';
      PC_sel         <= '0';
      PC_LdEn        <= '1'; 
		Reset          <= '0';
		wait for Clk_period*4;		
		
		
		--                       Rs   Rd   Rt        function
		--Instruction  <= "01000110100101000011100000111010"; bne
      Instrin        <= "01000110100101000011100000111010";--Rd = Rs >> 1 (R16 = R8 >> 1) R16 should have value +2^32 value after
      RF_Wr_Data_sel <= '1';
      RF_B_sel       <= '1';
      ALU_Bin_sel    <= '0';
      ALU_func       <= "0001";
      MEM_WrEn       <= '0';
      PC_sel         <= '0';
      PC_LdEn        <= '1'; 
		Reset          <= '0';
		wait for Clk_period*4;
		
		
		
		--                       Rs   Rd   Rt        function
		--Instruction  <= "01111100000000110000000000000000"; sw
      Instrin        <= "01111100000000110000000000000000";
      RF_Wr_Data_sel <= '1';
      RF_B_sel       <= '1';
      ALU_Bin_sel    <= '0';
      ALU_func       <= "0000";
      MEM_WrEn       <= '1';
      PC_sel         <= '0';
      PC_LdEn        <= '1'; 
		Reset          <= '0';
		wait for Clk_period*4;
		
		--                       Rs   Rd   immed        
		--Instruction  <= "00111100000111110000000000000000"; lw
      Instrin        <= "00111100000111110000000000000000";
      RF_Wr_Data_sel <= '0';
      RF_B_sel       <= '1';
      ALU_Bin_sel    <= '0';
      ALU_func       <= "0000";
      MEM_WrEn       <= '0';
      PC_sel         <= '0';
      PC_LdEn        <= '1'; 
		Reset          <= '0';
		wait for Clk_period*4;
		
		--                       Rs   Rd   Rt        function
		--Instruction  <= "01111100000000110000000000000001"; sb
      Instrin        <= "01111100000000110000000000000000";
      RF_Wr_Data_sel <= ;
      RF_B_sel       <= ;
      ALU_Bin_sel    <= ;
      ALU_func       <= ;
      MEM_WrEn       <= ;
      PC_Immed       <= ;
      PC_sel         <= ;
      PC_LdEn        <= ; 
		Reset          <= ;
		wait for Clk_period*4;
		
		--                       Rs   Rd   immed        
		--Instruction  <= "00111100000111100000000000000001"; lb
      Instrin        <= "00111100000111110000000000000000";
      RF_Wr_Data_sel <= ;
      RF_B_sel       <= ;
      ALU_Bin_sel    <= ;
      ALU_func       <= ;
      MEM_WrEn       <= ;
      PC_Immed       <= ;
      PC_sel         <= ;
      PC_LdEn        <= ; 
		Reset          <= ;
		wait for Clk_period*4;
		
		--                       Rs   Rd   Rt        function
		--Instruction  <= "10000000110010000011100000110011"; R-type and
      Instrin        <= "10000000110010000011100000110011";--Rd = Rs and R3 (R8 = R6 and R7) R8 should have value  after
      RF_Wr_Data_sel <= '1';
      RF_B_sel       <= '0';
      ALU_Bin_sel    <= '1';
      ALU_func       <= "0010";
      MEM_WrEn       <= '0';
      PC_sel         <= '0';
      PC_LdEn        <= '1'; 
		Reset          <= '0';
		wait for Clk_period*4;
		

      wait;
   end process;

END;