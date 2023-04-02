----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:18:32 03/15/2023 
-- Design Name: 
-- Module Name:    CONTROL - Behavioral 
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

entity CONTROL is

port( Instrin          : in std_logic_vector(31 downto 0);
      Ovf              : in std_logic;
		Cout             : in std_logic;
		Zero             : in std_logic;
		Reset            : in std_logic;
		Clk              : in std_logic;
		
		---------------outputs---------------
		Instrout         : out std_logic_vector(31 downto 0);
		RF_Wr_Data_sel   : out std_logic;
		RF_B_sel         : out std_logic;
		ALU_Bin_sel      : out std_logic;
		ALU_func         : out std_logic_vector(3 downto 0);
		MEM_WrEn         : out std_logic;
		PC_sel           : out std_logic;
		PC_LdEn          : out std_logic;
		RF_WrEn          : out std_logic
	 );

end CONTROL;

architecture Behavioral of CONTROL is


type state is(resetstate, checkstate);
signal curstate , nextstate : state;


begin


process(curstate , Instrin , Zero , nextstate)

begin

case curstate is 
	when resetstate =>
			nextstate <= checkstate;
			Reset <= '0';
			PC_LdEn <= '0';
			MEM_WrEn <= '0';
			RF_WrEn  <= '0';
	
	when checkstate =>
			if( Instrin = "00000000000000000000000000000000") then
				PC_sel  <= '0';
				PC_LdEn <= '1';
			else if(Instrin(31 downto 26) = "100000") then --Rtype
					PC_sel  <= '0';--pc+4(output of incrementor)
					PC_LdEn <= '1';--get the next instruction
					RF_WrEn <='1'; -- we have to write in the registers
					RF_B_sel <= '1'; -- rt register 
					RF_WrData_sel <= '1'; -- all the data comes from ALU
					ALU_Bin_sel <='1'; -- we need always the RF_B when we are in ALU
					Mem_WrEn <= '0'; -- don't care about memory here
-----------------------------R type-----------------------------
					if(Instrin(5 downto 0) = "110000") then -- check the func
							ALU_func <= "0000"; -- add case
					elsif Instrin(5 downto 0) = "110001" then 
							ALU_func <= "0001"; -- sub case
					elsif Instrin(5 downto 0) = "110010" then 
							ALU_func <= "0010"; -- and case
					elsif Instrin(5 downto 0) = "110011" then 
							ALU_func <= "0011"; -- or case
					elsif Instrin(5 downto 0) = "110100" then 
							ALU_func <= "0100"; -- not case 
					elsif Instrin(5 downto 0) = "110101" then 
							ALU_func <= "0101"; -- and case
					elsif Instrin(5 downto 0) = "110110" then 
							ALU_func <= "0110"; -- nor case 
					elsif Instrin(5 downto 0) = "111000" then 
							ALU_func <= "1000"; -- sra case
					elsif Instrin(5 downto 0) = "111001" then 
							ALU_func <= "1001"; -- srl
					elsif Instrin(5 downto 0) = "111010" then 
							ALU_func <= "1010"; -- sll
					elsif Instrin(5 downto 0) = "111100" then 
							ALU_func <= "1100"; -- rol
					elsif Instrin(5 downto 0) = "111101" then 
							ALU_func <= "1101"; --ror 
					else
							nextstate <=  checkstate;
					end if;
						nextstate <= checkstate;
-----------------------------I type-----------------------------
		elsif Instr(31 downto 26) = "111000" or Instr(31 downto 26) = "111001" then -- li and lui
						PC_sel  <= '0';--pc+4(output of incrementor)
						PC_LdEn <= '1';--get the next instruction
						RF_WrEn <='1'; -- we have to write in the registers
						RF_B_sel <= '1'; -- rt register 
						RF_WrData_sel <= '1'; -- all the data comes from ALU
						ALU_Bin_sel <='0'; -- we need always the RF_B when we are in ALU
						Mem_WrEn <= '0'; -- don't care about memory here
						ALU_func <= "0000"; --add 
		elsif Instr(31 downto 26) = "110000" then -- addi
						PC_sel  <= '0';--pc+4(output of incrementor)
						PC_LdEn <= '1';--get the next instruction
						RF_WrEn <='1'; -- we have to write in the registers
						RF_B_sel <= '0'; -- rt register 
						RF_WrData_sel <= '1'; -- all the data comes from ALU
						ALU_Bin_sel <='0'; -- we need always the RF_B when we are in ALU
						Mem_WrEn <= '0'; -- don't care about memory here
						ALU_func <= "0000"; --add 
		elsif Instr(31 downto 26) = "110010" then -- andi
						PC_sel  <= '0';--pc+4(output of incrementor)
						PC_LdEn <= '1';--get the next instruction
						RF_WrEn <='1'; -- we have to write in the registers
						RF_B_sel <= '0'; -- rt register 
						RF_WrData_sel <= '1'; -- all the data comes from ALU
						ALU_Bin_sel <='0'; -- we need always the RF_B when we are in ALU
						Mem_WrEn <= '0'; -- don't care about memory here
						ALU_func <= "0010"; --and
		elsif Instr(31 downto 26) = "110011" then -- addi
						PC_sel  <= '0';--pc+4(output of incrementor)
						PC_LdEn <= '1';--get the next instruction
						RF_WrEn <='1'; -- we have to write in the registers
						RF_B_sel <= '0'; -- rt register 
						RF_WrData_sel <= '1'; -- all the data comes from ALU
						ALU_Bin_sel <='0'; -- we need always the RF_B when we are in ALU
						Mem_WrEn <= '0'; -- don't care about memory here
						ALU_func <= "0011"; --ori
----------------------------j type----------------------------
		elsif Instr(31 downto 26) = "111111" then -- branch
						PC_sel  <= '1';--pc+4 + immediate
						PC_LdEn <= '1';--get the next instruction
						RF_WrEn <='1'; -- we have to write in the registers
						RF_B_sel <= '1'; -- rt register 
						RF_WrData_sel <= '1'; -- all the data comes from ALU
						ALU_Bin_sel <='0'; -- we need always the RF_B when we are in ALU
						Mem_WrEn <= '0'; -- don't care about memory here
						ALU_func <= "0000"; 
		elsif Instr(31 downto 26) = "010000" then -- beq
						PC_LdEn <= '1';--get the next instruction
						RF_WrEn <='1'; -- we have to write in the registers
						RF_B_sel <= '1'; -- rt register 
						RF_WrData_sel <= '1'; -- all the data comes from ALU
						ALU_Bin_sel <='0'; -- we need always the RF_B when we are in ALU
						Mem_WrEn <= '0'; -- don't care about memory here
						ALU_func <= "0001";
						if Zero = '0' then
							PC_sel <= '1';
						else 
							PC_sel <= '0';
						end if;
						
		elsif Instr(31 downto 26) = "010001" then -- bne
						PC_LdEn <= '1';--get the next instruction
						RF_WrEn <='1'; -- we have to write in the registers
						RF_B_sel <= '1'; -- rt register 
						RF_WrData_sel <= '1'; -- all the data comes from ALU
						ALU_Bin_sel <='0'; -- we need always the RF_B when we are in ALU
						Mem_WrEn <= '0'; -- don't care about memory here
						ALU_func <= "0001";
						if Zero = '0' then
							PC_sel <= '0';
						else 
							PC_sel <= '1';
						end if;
----------------------------I type(load and store)----------------------------
      elsif Instr(31 downto 26) = "000011" then -- lb
						PC_sel  <= '0';--pc+4 
						PC_LdEn <= '1';--get the next instruction
						RF_WrEn <='1'; -- we have to write in the registers
						RF_B_sel <= '1'; -- rt register 
						RF_WrData_sel <= '0'; -- all the data comes from memory
						ALU_Bin_sel <='0'; -- we need always the RF_B when we are in ALU
						Mem_WrEn <= '0'; -- don't care about memory here
						ALU_func <= "0000";--add
						
		elsif Instr(31 downto 26) = "001111" then -- lw
						PC_sel  <= '0';--pc+4 
						PC_LdEn <= '1';--get the next instruction
						RF_WrEn <='1'; -- we have to write in the registers
						RF_B_sel <= '1'; -- rt 
						RF_WrData_sel <= '0'; -- all the data comes from memory
						ALU_Bin_sel <='0'; -- we need always the RF_B when we are in ALU
						Mem_WrEn <= '0'; -- don't care about memory here
						ALU_func <= "0000";--add
						
		elsif Instr(31 downto 26) = "000111" then -- sb
						PC_sel  <= '0';--pc+4 
						PC_LdEn <= '1';--get the next instruction
						RF_WrEn <='0'; -- we have to write in the registers
						RF_B_sel <= '1'; -- rt 
						RF_WrData_sel <= '0'; -- all the data comes from memory
						ALU_Bin_sel <='0'; -- we need always the RF_B when we are in ALU
						Mem_WrEn <= '1'; -- don't care about memory here
						ALU_func <= "0000";--add
						
		elsif Instr(31 downto 26) = "011111" then -- sw
						PC_sel  <= '0';--pc+4 
						PC_LdEn <= '1';--get the next instruction
						RF_WrEn <='0'; -- we have to write in the registers
						RF_B_sel <= '1'; -- rt 
						RF_WrData_sel <= '0'; -- all the data comes from memory
						ALU_Bin_sel <='0'; -- we need always the RF_B when we are in ALU
						Mem_WrEn <= '1'; -- don't care about memory here
						ALU_func <= "0000";--add
						
					else
						 nextstate <=  checkstate;
					end if;
						nextstate <= checkstate;
						
		end if;
		end case;
		
end process;

process(Clk , Reset , curstate)
begin

	if(Reset = '1') then
		curstate <= resetstate;
	elsif(Clk'Event and Clk = '1') then
		curstate <= nextstate;
	else
		curstate <= curstate;
	end if;
	

end process;


end Behavioral;

