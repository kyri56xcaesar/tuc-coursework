----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:45:39 03/08/2023 
-- Design Name: 
-- Module Name:    ALU - Behavioral 
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
--use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_SIGNED.ALL;


-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ALU is
    Port ( A : in  STD_LOGIC_VECTOR (31 downto 0);
           B : in  STD_LOGIC_VECTOR (31 downto 0);
           Op : in  STD_LOGIC_VECTOR (3 downto 0);
           AluOut : out  STD_LOGIC_VECTOR (31 downto 0);
           Zero : out  STD_LOGIC;
           Cout : out  STD_LOGIC;
           Ovf : out  STD_LOGIC);
end ALU;

architecture Behavioral of ALU is

signal result : STD_LOGIC_VECTOR (31 downto 0);
signal sameSign : STD_LOGIC;
signal dummyB : STD_LOGIC_VECTOR (31 downto 0);

begin

result <= (A + B) when Op="0000" else
			 (A - B) when Op="0001" else
		(A and B)   when Op="0010" else
		(A or B)		when Op="0011" else
		(not A)     when Op="0100" else
		(A(31) & A(31 downto 1)) when Op="1000" else
		('0' & A(31 downto 1))   when Op="1001" else
		(A(30 downto 0) & '0')   when Op="1010" else
		(A(30 downto 0) & A(31)) when Op="1100" else
		(A(0) & A(31 downto 1))  when Op="1101" else
		result;
		
AluOut <= result;

Zero <= '1' when result = x"0000_0000" else
		 '0';
  
 WITH OP select dummyB<=
	  B when "0000",
	  -B when "0001",
       B when others;
		 
sameSign <= (A(31) xor dummyB(31));--check if the 2 inputs uniforms

Ovf <= (A(31) xor result(31)) when sameSign ='0' else
		  '0';

Cout <= (A(31)) when sameSign = '0' else (not result(31));

end Behavioral;