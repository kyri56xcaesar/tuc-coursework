----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:41:24 03/08/2023 
-- Design Name: 
-- Module Name:    MUX2to1 - Behavioral 
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

entity MUX2to1 is
    Port ( sel  : in  STD_LOGIC;                       --select input
           Din  : in  STD_LOGIC_VECTOR (31 downto 0);  --input 1
           Dreg : in  STD_LOGIC_VECTOR (31 downto 0);  --input 2
           Dout : out  STD_LOGIC_VECTOR (31 downto 0));--output
end MUX2to1;

architecture Behavioral of MUX2to1 is

begin
	--select output based on sel signal
   Dout <= Dreg when (sel='0') else
	        Din;

end Behavioral;

