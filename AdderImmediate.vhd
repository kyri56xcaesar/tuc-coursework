----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:45:03 03/09/2023 
-- Design Name: 
-- Module Name:    AdderImmediate - Behavioral 
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

entity AdderImmediate is

port( Incin 	  : in std_logic_vector(31 downto 0);
		IMMEDin    : in std_logic_vector(31 downto 0);
		ADDout     : out std_logic_vector(31 downto 0));
	
end AdderImmediate;

architecture Behavioral of AdderImmediate is

signal result : std_logic_vector(31 downto 0);

begin

result <= (Incin + IMMEDin);


ADDout <= result ;

end Behavioral;

