----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:50:26 03/08/2023 
-- Design Name: 
-- Module Name:    Register - Behavioral 
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

entity Reg is
    Port ( CLK   : in  STD_LOGIC;							 --clock signal , synchronous circuit
           DATA  : in  STD_LOGIC_VECTOR (31 downto 0); --data stored inside register
           Dout  : out  STD_LOGIC_VECTOR (31 downto 0);--output
			  Reset : in STD_LOGIC;								 --synchronous reset	
           WE    : in  STD_LOGIC);							 --write enable signal
end Reg;

architecture Behavioral of Reg is

signal temp : STD_LOGIC_VECTOR (31 downto 0);--temporary signal

begin

process 

begin
	wait until (CLK'EVENT and CLK='1');--wait for positive edge of clock
	
	--if reset is enabled , output is zero 
	if Reset = '1' then
		temp <= "00000000000000000000000000000000";
	else--if reset is low
		if WE = '1' then --and write signal is anabled
			temp <= DATA;--pass input data to output
		end if;
	end if;

--if write enable signal is low then hold the previous data

end process;

	Dout <= temp;

end Behavioral;

