----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:43:56 03/15/2023 
-- Design Name: 
-- Module Name:    IFSTAGE - Behavioral 
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

entity IFSTAGE is
    Port ( PC_Immed : in  STD_LOGIC_VECTOR (31 downto 0);
           PC_sel   : in  STD_LOGIC;
           PC_LdEn  : in  STD_LOGIC;
           Clk      : in  STD_LOGIC;
           Reset    : in  STD_LOGIC;
           Instr    : out  STD_LOGIC_VECTOR (31 downto 0));
end IFSTAGE;

architecture Behavioral of IFSTAGE is

signal mux_out , add_out , inc_out , pc_out : std_logic_vector(31 downto 0);

component AdderImmediate is
port( Incin 	  : in std_logic_vector(31 downto 0);
		IMMEDin : in std_logic_vector(31 downto 0);
		ADDout  : out std_logic_vector(31 downto 0));
		
end component;


component Incrementor is
port( input  : in  std_logic_vector(31 downto 0);
		output : out std_logic_vector(31 downto 0)); 
		
end component;

component MUX2to1 is
port ( 	  sel  : in  STD_LOGIC;
           Din  : in  STD_LOGIC_VECTOR (31 downto 0);
           Dreg : in  STD_LOGIC_VECTOR (31 downto 0);
           Dout : out  STD_LOGIC_VECTOR (31 downto 0));

end component;


component PC is

port (     PC_in : in  STD_LOGIC_VECTOR (31 downto 0);
           PC_LdEn : in  STD_LOGIC;
           Clk : in  STD_LOGIC;
           Reset : in  STD_LOGIC;
           PC_out : out  STD_LOGIC_VECTOR (31 downto 0));
end component;

component IMEM is
port( ADDRA : in std_logic_vector(9 downto 0);
		CLKA  : in std_logic;
		DOUTA : out std_logic_vector(31 downto 0));
		
end component;

begin

Add : AdderImmediate
port map( Incin => inc_out,	  
			 IMMEDin => PC_Immed,
			 ADDout => add_out);

MUX : MUX2to1
port map(  sel  => PC_sel, 
           Din  => add_out,
           Dreg => inc_out,
           Dout => mux_out);
			  
PC1 : PC
port map(  PC_in   => mux_out,
           PC_LdEn => PC_LdEn,
           Clk     => Clk,
           Reset   => Reset,
			  PC_out  => pc_out
			);
			  
Inc : Incrementor
port map( input  => pc_out,
			 output => inc_out);

		 
		 
mem: IMEM 
port map( ADDRA => pc_out(11 downto 2),
	   CLKA  => Clk, 
		DOUTA => Instr);

end Behavioral;