----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:18:32 03/15/2023 
-- Design Name: 
-- Module Name:    CONTROL - Behavioral 
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

entity CONTROL is

port( Instrin          : in std_logic_vector(31 downto 0);
      Ovf              : in std_logic;
		Carry            : in std_logic;
		Zero             : in std_logic;
		Reset            : in std_logic;
		Clk              : in std_logic;
		---------------outputs---------------
		Instrout         : out std_logic_vector(31 downto 0);
		RF_Wr_Data_sel   : out std_logic;
		ALU_Bin_sel      : out std_logic;
		ALU_func         : out std_logic_vector(3 downto 0);
		MEM_WrEn         : out std_logic;
		PC_Immed         : out std_logic_vector(31 downto 0);
		PC_sel           : out std_logic;
		PC_LdEn          : out std_logic
	 );

end CONTROL;

architecture Behavioral of CONTROL is

begin


end Behavioral;

