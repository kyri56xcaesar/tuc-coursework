----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:04:41 03/15/2023 
-- Design Name: 
-- Module Name:    DATAPATH - Behavioral 
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

entity DATAPATH is
port( Instrin        : in std_logic_vector(31 downto 0);
		RF_Wr_Data_sel : in std_logic;
		RF_B_sel       : in std_logic;
		ALU_Bin_sel    : in std_logic;
		ALU_func       : in std_logic_vector(3 downto 0);
		MEM_WrEn       : in std_logic;
		PC_sel         : in std_logic;
		PC_LdEn        : in std_logic;
		Reset          : in std_logic;
		Clk            : in std_logic;
		ALU_zero       : out std_logic;
		ALU_OVF        : out std_logic;
		ALU_COUT       : out std_logic;
		Instrout       : out std_logic_vector(31 downto 0)
	);

end DATAPATH;

architecture Behavioral of DATAPATH is


signal ALU_OUT   : std_logic_vector(31 downto 0);
signal MEM_OUT   : std_logic_vector(31 downto 0);
signal Immediate : std_logic_vector(31 downto 0);
signal RF_A      : std_logic_vector(31 downto 0);
signal RF_B      : std_logic_vector(31 downto 0);


component IFSTAGE is
Port ( PC_Immed : in  STD_LOGIC_VECTOR (31 downto 0);
           PC_sel   : in  STD_LOGIC;
           PC_LdEn  : in  STD_LOGIC;
           Clk      : in  STD_LOGIC;
           Reset    : in  STD_LOGIC;
           Instr    : out  STD_LOGIC_VECTOR (31 downto 0));
end component;


component DECSTAGE is
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

end component;

component ALUSTAGE is
Port (     RF_A : in  STD_LOGIC_VECTOR (31 downto 0);
           RF_B : in  STD_LOGIC_VECTOR (31 downto 0);
           Immed : in  STD_LOGIC_VECTOR (31 downto 0);
           ALU_Bin_sel : in  STD_LOGIC;
           ALU_func : in  STD_LOGIC_VECTOR (3 downto 0);
           ALU_out : out  STD_LOGIC_VECTOR (31 downto 0);
			  Zero : out  STD_LOGIC;
           Cout : out  STD_LOGIC;
           Ovf : out  STD_LOGIC);
end component;

component RAM1024 is
 PORT (
    clka : IN STD_LOGIC;
    wea : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    addra : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    dina : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    douta : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
  );
end component;

begin


IFSTG : IFSTAGE
port map(  PC_Immed => Immediate,
           PC_sel   => PC_sel,
           PC_LdEn  => PC_LdEn,
           Clk      => Clk,
           Reset    => Reset,
           Instr    => Instrout
			);

DECSTG : DECSTAGE
port map(  Instr          => Instrin,
           ALU_out        => ALU_OUT,
           MEM_out        => MEM_OUT,
           RF_WrData_sel  => RF_Wr_Data_sel,
			  RF_WrEn        => MEM_WrEn,
			  RF_B_sel       => RF_B_sel,
			  Clk            => Clk,
			  Reset          => Reset,
           RF_A           => RF_A,
           RF_B           => RF_B,
			  Immed          => Immediate
         );


ALUSTG :ALUSTAGE
port map(  RF_A           => RF_A,
           RF_B           => RF_B,
           Immed          => Immediate,
           ALU_Bin_sel    => ALU_Bin_sel,
           ALU_func       => ALU_func,
           ALU_out        => ALU_OUT,
			  Zero           => ALU_zero,
			  Ovf            => ALU_OVF,
			  Cout           => ALU_COUT
         );
			
MEMSTAGE : RAM1024
port map( clka   =>Clk,
          wea    =>MEM_WrEn,
          addra  =>ALU_OUT,
          dina   =>RF_B,
          douta  =>MEM_OUT
         );
			

end Behavioral;

