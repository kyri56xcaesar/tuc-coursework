----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:18:56 03/08/2023 
-- Design Name: 
-- Module Name:    MUX32to1 - Behavioral 
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

entity MUX32to1 is
port(sel   : in  std_logic_vector(4 downto 0); --input selection signal , select 1 out of 32 inputs
	  R0    : in  std_logic_vector(31 downto 0);
	  R1    : in  std_logic_vector(31 downto 0);
	  R2    : in  std_logic_vector(31 downto 0);
	  R3    : in  std_logic_vector(31 downto 0);
	  R4    : in  std_logic_vector(31 downto 0);
	  R5    : in  std_logic_vector(31 downto 0);
	  R6    : in  std_logic_vector(31 downto 0);
	  R7    : in  std_logic_vector(31 downto 0);
	  R8    : in  std_logic_vector(31 downto 0);
	  R9    : in  std_logic_vector(31 downto 0);
	  R10   : in  std_logic_vector(31 downto 0);
	  R11   : in  std_logic_vector(31 downto 0);
	  R12   : in  std_logic_vector(31 downto 0);
	  R13   : in  std_logic_vector(31 downto 0);
	  R14   : in  std_logic_vector(31 downto 0);
	  R15   : in  std_logic_vector(31 downto 0);
	  R16   : in  std_logic_vector(31 downto 0);
	  R17   : in  std_logic_vector(31 downto 0);
	  R18   : in  std_logic_vector(31 downto 0);
	  R19   : in  std_logic_vector(31 downto 0);
	  R20   : in  std_logic_vector(31 downto 0);
	  R21   : in  std_logic_vector(31 downto 0);
	  R22   : in  std_logic_vector(31 downto 0);
	  R23   : in  std_logic_vector(31 downto 0);
	  R24   : in  std_logic_vector(31 downto 0);
	  R25   : in  std_logic_vector(31 downto 0);
	  R26   : in  std_logic_vector(31 downto 0);
	  R27   : in  std_logic_vector(31 downto 0);
	  R28   : in  std_logic_vector(31 downto 0);
	  R29   : in  std_logic_vector(31 downto 0);
	  R30   : in  std_logic_vector(31 downto 0);
	  R31   : in  std_logic_vector(31 downto 0);
	  Mout  : out std_logic_vector(31 downto 0));
	 
end MUX32to1;

architecture Behavioral of MUX32to1 is

signal temp : std_logic_vector(31 downto 0);

begin

temp <= R0  when sel = "00000" else
        R1  when sel = "00001" else
		  R2  when sel = "00010" else
		  R3  when sel = "00011" else
		  R4  when sel = "00100" else
		  R5  when sel = "00101" else
		  R6  when sel = "00110" else
		  R7  when sel = "00111" else
		  R8  when sel = "01000" else
		  R9  when sel = "01001" else
		  R10 when sel = "01010" else
		  R11 when sel = "01011" else
		  R12 when sel = "01100" else
		  R13 when sel = "01101" else
		  R14 when sel = "01110" else
		  R15 when sel = "01111" else
		  R16 when sel = "10000" else
		  R17 when sel = "10001" else
		  R18 when sel = "10010" else
		  R19 when sel = "10011" else
		  R20 when sel = "10100" else
		  R21 when sel = "10101" else
		  R22 when sel = "10110" else
		  R23 when sel = "10111" else
		  R24 when sel = "11000" else
		  R25 when sel = "11001" else
		  R26 when sel = "11010" else
		  R27 when sel = "11011" else
		  R28 when sel = "11100" else
		  R29 when sel = "11101" else
		  R30 when sel = "11110" else
		  R31;
		  
		  
Mout <= temp;

end Behavioral;

