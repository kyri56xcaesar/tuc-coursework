----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:06:22 03/15/2023 
-- Design Name: 
-- Module Name:    DECcloud - Behavioral 
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

entity DECcloud is
    Port ( Instr  : in  STD_LOGIC_VECTOR (15 downto 0);--last 16 bits of the whole instruction
           Immed  : out STD_LOGIC_VECTOR (31 downto 0);--immediate as output after extention
			  OPcode : in  STD_LOGIC_VECTOR (5 downto 0)  --first 6 bits of the whole instruction
			 );
end DECcloud;

architecture Behavioral of DECcloud is

signal temp : STD_LOGIC_VECTOR(31 downto 0);--temporary inside signal

begin

temp <= ((31 downto 16 => Instr(15)) & Instr) when (OPcode = "111000" or OPcode = "110000" or OPcode = "000011" or OPcode = "000111" or  --sign extend
		  OPcode = "001111" or OPcode = "011111") else 
		  (Instr & "0000000000000000") when OPcode = "111001" else --lui
		  ((31 downto 18 => Instr(15)) & Instr & "00") when (OPcode = "010000" or OPcode = "010001" or OPcode = "111111") else -- sign extend and sll 2
		  ("0000000000000000" & Instr);--zero fill --when (OPcode = "110010" or OPcode = "110011" ) else
		  
		  
			
Immed <= temp;

end Behavioral;

