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
           Dout2 : out  STD_LOGIC_VECTOR (31 downto 0);
			  Reset : in   STD_LOGIC);
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
		 Reset : in STD_LOGIC;
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
signal sign_din,sign_decOut,sign_we,sign_MUX1,sign_MUX2 : STD_LOGIC_VECTOR(31 downto 0);

type ar2d is array (0 to 31) of std_logic_vector(31 downto 0);
signal sign_Reg: ar2d;--2 dim 32x32 array

signal comp1,comp2 :STD_LOGIC;

begin

--sign_we(0) <= (WrEn and '0');

for1:for i in 1 to 31 generate

	sign_we(i) <= (WrEn and sign_decOut(i));

end generate;

DEC1: DEC5to32
  Port map (  Awr=> Awr,
              Dout=>sign_decOut
				  );

Reg0: Reg
  Port map ( DATA=>"00000000000000000000000000000000",
             CLK=>CLK,
				 WE=>'1',
				 Dout=>sign_Reg(0),
				 Reset => Reset
				 );
--GENERATE 1-31 Registers----
for2:for i in 1 to 31 generate
 
 RegX: Reg
   Port map ( DATA=>Din,
              CLK=>CLK,
              WE=>sign_we(i),
              Dout=>sign_Reg(i),
				  Reset => Reset
             );	
end generate;	

MUX1: MUX32to1
   Port map ( sel=>Ard1,
              R0 =>sign_Reg(0),
              R1 =>sign_Reg(1),
              R2 =>sign_Reg(2),	
              R3 =>sign_Reg(3),
              R4 =>sign_Reg(4),
              R5 =>sign_Reg(5),
              R6 =>sign_Reg(6),
              R7 =>sign_Reg(7),
              R8 =>sign_Reg(8),
				  R9 =>sign_Reg(9),
              R10 =>sign_Reg(10),
              R11 =>sign_Reg(11),
              R12 =>sign_Reg(12),
              R13 =>sign_Reg(13),
              R14 =>sign_Reg(14),
              R15 =>sign_Reg(15),
              R16 =>sign_Reg(16),
              R17 =>sign_Reg(17),
              R18 =>sign_Reg(18),
              R19 =>sign_Reg(19),
              R20 =>sign_Reg(20),
              R21 =>sign_Reg(21),
              R22 =>sign_Reg(22),
				  R23 =>sign_Reg(23),
              R24 =>sign_Reg(24),
              R25 =>sign_Reg(25),
              R26 =>sign_Reg(26),
              R27 =>sign_Reg(27),
              R28 =>sign_Reg(28),
              R29 =>sign_Reg(29),
              R30 =>sign_Reg(30),
              R31 =>sign_Reg(31),
              
              Mout=>sign_MUX1
            );

MUX2: MUX32to1
   Port map ( sel=>Ard2,
              R0 =>sign_Reg(0),
              R1 =>sign_Reg(1),
              R2 =>sign_Reg(2),	
              R3 =>sign_Reg(3),
              R4 =>sign_Reg(4),
              R5 =>sign_Reg(5),
              R6 =>sign_Reg(6),
              R7 =>sign_Reg(7),
              R8 =>sign_Reg(8),
				  R9 =>sign_Reg(9),
              R10 =>sign_Reg(10),
              R11 =>sign_Reg(11),
              R12 =>sign_Reg(12),
              R13 =>sign_Reg(13),
              R14 =>sign_Reg(14),
              R15 =>sign_Reg(15),
              R16 =>sign_Reg(16),
              R17 =>sign_Reg(17),
              R18 =>sign_Reg(18),
              R19 =>sign_Reg(19),
              R20 =>sign_Reg(20),
              R21 =>sign_Reg(21),
              R22 =>sign_Reg(22),
				  R23 =>sign_Reg(23),
              R24 =>sign_Reg(24),
              R25 =>sign_Reg(25),
              R26 =>sign_Reg(26),
              R27 =>sign_Reg(27),
              R28 =>sign_Reg(28),
              R29 =>sign_Reg(29),
              R30 =>sign_Reg(30),
              R31 =>sign_Reg(31),
              
              Mout=>sign_MUX2
            );				

C1: CompareModule
     Port map ( Ard=>Ard1,
                Awr=>Awr,
                CMout=>comp1
               );

C2: CompareModule
     Port map ( Ard=>Ard2,
                Awr=>Awr,
                CMout=>comp2
               );

MUX3: MUX2to1
   Port map ( sel=>comp1,
	           Din=>Din,
				  Dreg=>sign_MUX1,
				  Dout=>Dout1
				 );
MUX4: MUX2to1
   Port map ( sel=>comp2,
	           Din=>Din,
				  Dreg=>sign_MUX2,
				  Dout=>Dout2
				 );

end Structural;