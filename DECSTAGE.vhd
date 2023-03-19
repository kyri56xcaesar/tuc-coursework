----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:06:52 03/09/2023 
-- Design Name: 
-- Module Name:    DECSTAGE - Behavioral 
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

entity DECSTAGE is
    Port ( Instr : in  STD_LOGIC_VECTOR (31 downto 0);
           ALU_out : in  STD_LOGIC_VECTOR (31 downto 0);
           MEM_out : in  STD_LOGIC_VECTOR (31 downto 0);
           RF_WrData_sel : in  STD_LOGIC;
			  RF_WrEn       : in STD_LOGIC;
			  RF_B_sel : in STD_LOGIC;
			  Clk :in STD_LOGIC;
			  Reset : in STD_LOGIC;
           RF_A : out  STD_LOGIC_VECTOR (31 downto 0);
           RF_B : out  STD_LOGIC_VECTOR (31 downto 0);
			  Immed : out  STD_LOGIC_VECTOR (31 downto 0)
			  );
end DECSTAGE;

architecture Behavioral of DECSTAGE is

signal mux_out1  : std_logic_vector(4 downto 0);
signal mux_out2  : std_logic_vector(31 downto 0);



component MUX2to1 is
Port (     sel  : in  STD_LOGIC;
           Din  : in  STD_LOGIC_VECTOR (31 downto 0);
           Dreg : in  STD_LOGIC_VECTOR (31 downto 0);
           Dout : out  STD_LOGIC_VECTOR (31 downto 0));

end component;

component MUX5bit2to1 is
Port (     sel  : in  STD_LOGIC;
           Instr1  : in  STD_LOGIC_VECTOR (4 downto 0);
           Instr2 : in  STD_LOGIC_VECTOR (4 downto 0);
           muxout : out  STD_LOGIC_VECTOR (4 downto 0));

end component;


component RegisterFile is
 Port (    Ard1  : in   STD_LOGIC_VECTOR (4 downto 0);
           Ard2  : in   STD_LOGIC_VECTOR (4 downto 0);
           Awr   : in   STD_LOGIC_VECTOR (4 downto 0);
           Din   : in   STD_LOGIC_VECTOR (31 downto 0);
           WrEn  : in   STD_LOGIC;
           Clk   : in   STD_LOGIC;
			  Reset : in   STD_LOGIC;	
           Dout1 : out  STD_LOGIC_VECTOR (31 downto 0);
           Dout2 : out  STD_LOGIC_VECTOR (31 downto 0));

end component;

--component cloud
component DECcloud is 
Port ( Instr  : in  STD_LOGIC_VECTOR (15 downto 0);
       Immed : out  STD_LOGIC_VECTOR (31 downto 0);
		 OPcode : in STD_LOGIC_VECTOR (5 downto 0)
		);
		
end component;

begin

MUX1 : MUX2to1
port map(  sel  => RF_WrData_sel,
           Din  => ALU_out,
           Dreg => MEM_out,
           Dout => mux_out2);


MUX2 : MUX5bit2to1
port map(  sel  => RF_B_sel,
           Instr1  => Instr(15 downto 11),
           Instr2 => Instr(20 downto 16),
           muxout => mux_out1);

RF : RegisterFile
port map(  Ard1  => Instr(25 downto 21),
           Ard2  => mux_out1,
           Awr   => Instr(20 downto 16),
           Din   => mux_out2,
           WrEn  => RF_WrEn,
           Clk   => Clk,
           Dout1 => RF_A,
           Dout2 => RF_B,
			  Reset => Reset);


Cloud : DECcloud
port map( Instr  => Instr(15 downto 0),
          Immed  => Immed,
		    OPcode => Instr(31 downto 26)
			);

end Behavioral;