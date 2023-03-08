----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:05:29 03/08/2023 
-- Design Name: 
-- Module Name:    RegisterFile - Behavioral 
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

entity RegisterFile is
    Port ( Ard1  : in   STD_LOGIC_VECTOR (4 downto 0);
           Ard2  : in   STD_LOGIC_VECTOR (4 downto 0);
           Awr   : in   STD_LOGIC_VECTOR (4 downto 0);
           Din   : in   STD_LOGIC_VECTOR (31 downto 0);
           WrEn  : in   STD_LOGIC;
           Clk   : in   STD_LOGIC;
           Dout1 : out  STD_LOGIC_VECTOR (31 downto 0);
           Dout2 : out  STD_LOGIC_VECTOR (31 downto 0));
end RegisterFile;

architecture Structural of RegisterFile is


component DEC5to32 is
port( Awr : in  std_logic_vector(4 downto 0);
      Dout: out std_logic_vector(31 downto 0));

end component;

component Reg is
Port ( CLK : in  STD_LOGIC;
       DATA : in  STD_LOGIC_VECTOR (31 downto 0);
       Dout : out  STD_LOGIC_VECTOR (31 downto 0);
       WE : in  STD_LOGIC);
		 
end component;

component MUX32to1 is
port(sel   : in  std_logic_vector(4 downto 0);
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

end component;

component MUX2to1 is
Port ( sel  : in  STD_LOGIC;
       Din  : in  STD_LOGIC_VECTOR (31 downto 0);
       Dreg : in  STD_LOGIC_VECTOR (31 downto 0);
       Dout : out  STD_LOGIC_VECTOR (31 downto 0));

end component;


component CompareModule is
port( Ard   : in std_logic_vector(4 downto 0);
      Awr   : in std_logic_vector(4 downto 0);
		CMout : out std_logic);

end component;

--signals--


begin


end Structural;