----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:10:30 03/18/2023 
-- Design Name: 
-- Module Name:    MUX5bit2to1 - Behavioral 
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

entity MUX5bit2to1 is
    Port ( Instr1 : in  STD_LOGIC_VECTOR (4 downto 0);
           Instr2 : in  STD_LOGIC_VECTOR (4 downto 0);
           sel : in  STD_LOGIC;
			  muxout : out STD_LOGIC_VECTOR (4 downto 0)
			 );
end MUX5bit2to1;

architecture Behavioral of MUX5bit2to1 is

signal temp : std_logic_vector(4 downto 0);

begin
--
--process(Instr1 , Instr2 , sel)
--
--begin
--
--
--if sel = '0' then
--	temp <= Instr1;
--else	
--	temp <= Instr2;
--end if;
--
--end process;
--
--muxout <= temp ;

muxout <= Instr1 when sel = '0' else 
		  Instr2;

end Behavioral;

