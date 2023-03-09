----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:13:33 03/08/2023 
-- Design Name: 
-- Module Name:    CompareModule - Behavioral 
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

entity CompareModule is

port( Ard   : in std_logic_vector(4 downto 0);
      Awr   : in std_logic_vector(4 downto 0);
		CMout : out std_logic);
		
		
end CompareModule;

architecture Behavioral of CompareModule is

begin

CMout<= '1' when (Ard=Awr) else '0';

end Behavioral;