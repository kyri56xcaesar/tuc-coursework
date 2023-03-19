----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:26:32 03/15/2023 
-- Design Name: 
-- Module Name:    PROCESSOR - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity PROCESSOR is
port(
		Clk : in std_logic;
		Reset : in std_logic
	 );

end PROCESSOR;

architecture Behavioral of PROCESSOR is

component CONTROL is
port( Instrin          : in std_logic_vector(31 downto 0);
      Ovf              : in std_logic;
		Cout             : in std_logic;
		Zero             : in std_logic;
		Reset            : in std_logic;
		Clk              : in std_logic;
		
		---------------outputs---------------
		Instrout         : out std_logic_vector(31 downto 0);
		RF_Wr_Data_sel   : out std_logic;
		RF_B_sel         : out std_logic;
		ALU_Bin_sel      : out std_logic;
		ALU_func         : out std_logic_vector(3 downto 0);
		MEM_WrEn         : out std_logic;
		PC_sel           : out std_logic;
		PC_LdEn          : out std_logic;
		RF_WrEn          : out std_logic
	 );
end component;

component DATAPATH is
port( Instrin        : in std_logic_vector(31 downto 0);
		RF_Wr_Data_sel : in std_logic;
		RF_B_sel       : in std_logic;
		ALU_Bin_sel    : in std_logic;
		ALU_func       : in std_logic_vector(3 downto 0);
		MEM_WrEn       : in std_logic;
		PC_sel         : in std_logic;
		PC_LdEn        : in std_logic;
		Reset          : in std_logic;
		Clk            : in std_logic;
		ALU_zero       : out std_logic;
		ALU_OVF        : out std_logic;
		ALU_COUT       : out std_logic;
		Instrout       : out std_logic_vector(31 downto 0)
	);
	
end component;

signal instructionIn , instructionOut : std_logic_vector(31 downto 0);
signal RF_Wr_Data_sel ,RF_B_sel,ALU_Bin_sel,ALU_func,MEM_WrEn,PC_sel,PC_LdEn,Ovf,Cout,Zero ,RF_WrEn  : std_logic;


begin


Control : CONTROL
port map(Instrin          => instructionIn,     
			Ovf              => Ovf,
			Cout             => Cout,
			Zero             => Zero,
			Reset            => Reset,
			Clk              => Clk,
			Instrout         => instructionOut,
			RF_Wr_Data_sel   => RF_Wr_Data_sel,
			RF_B_sel         => RF_B_sel,
			ALU_Bin_sel      => ALU_Bin_sel,
			ALU_func         => ALU_func,
			MEM_WrEn         => MEM_WrEn,
			PC_sel           => PC_sel,
			PC_LdEn          => PC_LdEn,
			RF_WrEn          => RF_WrEn
			);

DATA : DATAPATH
port map(Instrin          => instructionOut,
			RF_Wr_Data_sel   => RF_Wr_Data_sel,
			RF_B_sel         => RF_B_sel,
			ALU_Bin_sel      => ALU_Bin_sel,
			ALU_func         => ALU_func,
			MEM_WrEn         => MEM_WrEn,
			PC_sel           => PC_sel,
			PC_LdEn          => PC_LdEn,
			Reset            => Reset,
			Clk              => Clk,
			ALU_zero         => Zero,
			ALU_OVF          => Ovf,
			ALU_COUT         => Cout,
			Instrout         => instructionIn
		);

end Behavioral;

