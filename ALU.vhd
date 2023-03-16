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
    Port ( A      : in  STD_LOGIC_VECTOR (31 downto 0); --input A
           B      : in  STD_LOGIC_VECTOR (31 downto 0); --input B
           Op     : in  STD_LOGIC_VECTOR (3 downto 0);  --operation code(add , sub etc)
           AluOut : out  STD_LOGIC_VECTOR (31 downto 0);--result of operation
           Zero   : out  STD_LOGIC;                     --if result is zero
           Cout   : out  STD_LOGIC;                     --if we have carry out
           Ovf    : out  STD_LOGIC);                    --overflow indicator
end ALU;

architecture Behavioral of ALU is

signal result : STD_LOGIC_VECTOR (31 downto 0);
signal sameSign : STD_LOGIC;
signal dummyB : STD_LOGIC_VECTOR (31 downto 0);
signal tempOvf : STD_LOGIC;
signal tempCout : STD_LOGIC;

begin

result <= (A + B)                  when Op="0000" else--add
			 (A - B)                  when Op="0001" else--sub
		    (A and B)                when Op="0010" else--and
		    (A or B)		           when Op="0011" else--or
		    (not A)                  when Op="0100" else--not
		    (A(31) & A(31 downto 1)) when Op="1000" else--arithmetic shift right
		    ('0' & A(31 downto 1))   when Op="1001" else--shift right logical
		    (A(30 downto 0) & '0')   when Op="1010" else--shift left logical
		    (A(30 downto 0) & A(31)) when Op="1100" else--rotate left
		    (A(0) & A(31 downto 1))  when Op="1101" else--rotate right
		result;
		
AluOut <= result;

Zero <= '1' when result = x"0000_0000" else--if result is all zeros
		 '0';
  
  --if we have sub we have to adjust B for overflow and carry out check
 WITH OP select dummyB<=
	  B when "0000",
	  -B when "0001",
       B when others;
		 
sameSign <= (A(31) xor dummyB(31));--check if the 2 inputs uniforms

tempOvf <= (A(31) xor result(31)) when sameSign ='0' else--if 2 inputs have the same sign then if the msb(sign) of one of them
		  '0';														   --differs from the msb of the result then we have overflow
																			--we expected e.g a positive result and got a negative

tempCout <= (A(31)) when sameSign = '0' else (not result(31));


--enable overflow and carry out only when it can happen
--that can only happen only when we have 
--addition or substraction
Ovf <= tempOvf when (Op="0000") else
		 tempOvf when (Op="0001") else
		 '0';

Cout <= tempCout when (Op="0000") else
		  tempCout when (Op="0001") else
		  '0';



end Behavioral;