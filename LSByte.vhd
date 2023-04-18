----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:27:02 04/16/2023 
-- Design Name: 
-- Module Name:    LSByte - Behavioral 
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

entity LSByte is

port(    RF_B : in STD_LOGIC_VECTOR(31 downto 0);
			ALU_Out: in STD_LOGIC_VECTOR(31 downto 0);
			OpCode : in STD_LOGIC_VECTOR(5 downto 0);
			MemAddress : out STD_LOGIC_VECTOR(31 downto 0);
			Data_In : out STD_LOGIC_VECTOR(31 downto 0)
		);
		
end LSByte;

architecture Behavioral of LSByte is
signal zeros : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
begin
	Process(RF_B,ALU_Out, OpCode)
		begin 
			if OpCode = "000011" then -- case for lb
				Data_In <= RF_B; -- we dont care what it is since we do lb
				MemAddress <= zeros(31 downto 8) & ALU_Out(7 downto 0);
			elsif OpCode = "000111" then --case for sb
				MemAddress <= ALU_Out;
				Data_In <= zeros(31 downto 8) & RF_B(7 downto 0);
			else
				MemAddress <= ALU_Out;
				Data_In <= RF_B;
			end if;
	end Process;

end Behavioral;