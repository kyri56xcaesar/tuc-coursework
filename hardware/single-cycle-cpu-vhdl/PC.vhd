----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:14:02 03/09/2023 
-- Design Name: 
-- Module Name:    PC - Behavioral 
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

entity PC is
    Port ( PC_in   : in  STD_LOGIC_VECTOR (31 downto 0); --input
           PC_LdEn : in  STD_LOGIC;                      --load enable signal
           Clk     : in  STD_LOGIC;                      --clock signal
           Reset   : in  STD_LOGIC;                      --reset signal
           PC_out  : out STD_LOGIC_VECTOR (31 downto 0));--output
end PC;

architecture Behavioral of PC is
	
signal temp : std_logic_vector(31 downto 0);

begin

process

begin

	wait until (Clk'EVENT and Clk = '1');--wait for positive clock edge
	
		if Reset = '1' then--if reset is enabled then outpu is zero
			temp <= "00000000000000000000000000000000";
		else
			if(PC_LdEn = '1') then--if load is enabled then load the new data
				temp <= PC_in;
--			elsif (PC_LdEn = '0') then--else hold the previous
--				temp <= temp;
			end if;
			
		end if;
	
end process;

PC_out <= temp;

end Behavioral;

