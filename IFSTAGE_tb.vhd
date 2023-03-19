-- TestBench Template 

  LIBRARY ieee;
  USE ieee.std_logic_1164.ALL;
  USE ieee.numeric_std.ALL;

  ENTITY IFSTAGE_tb IS
  END IFSTAGE_tb;

  ARCHITECTURE behavior OF IFSTAGE_tb IS 

  -- Component Declaration
          COMPONENT IFSTAGE
          Port ( PC_Immed : in  STD_LOGIC_VECTOR (31 downto 0);
           PC_sel   : in  STD_LOGIC;
           PC_LdEn  : in  STD_LOGIC;
           Clk      : in  STD_LOGIC;
           Reset    : in  STD_LOGIC;
           Instr    : out  STD_LOGIC_VECTOR (31 downto 0));
          END COMPONENT;
				
			  signal PC_Immed : STD_LOGIC_VECTOR (31 downto 0) := (others =>'0');
           signal PC_sel   : STD_LOGIC :='0';
           signal PC_LdEn  : STD_LOGIC :='0';
           signal Clk      : STD_LOGIC :='0';
           signal Reset    : STD_LOGIC :='0';
           signal Instr    : STD_LOGIC_VECTOR (31 downto 0);          
			  
			  constant Clk_period : time := 10 ns;


  BEGIN

  -- Component Instantiation
          uut: IFSTAGE PORT MAP(
			  PC_Immed => PC_Immed,
           PC_sel   => PC_sel,
           PC_LdEn  => PC_LdEn,
           Clk      => Clk,
           Reset    => Reset,
           Instr    => Instr
          );

	
	-- Clock process definitions
   CLK_process :process
   begin
		Clk <= '0';
		wait for Clk_period/2;
		Clk <= '1';
		wait for Clk_period/2;
   end process;
	
  --  Test Bench Statements
     tb : PROCESS
     BEGIN

			PC_Immed <= "00000000000000000000000000001000";
			PC_sel <= '0';
		   PC_LdEn <= '1';
			Reset <= '1';
			wait for 50 ns; -- wait until global set/reset completes
			
			
			Reset <= '0';
			wait for 300 ns;
			
			
			Reset <= '1';
			wait for 50 ns;
			
			--first instruction should come out
			PC_Immed <= "00000000000000000000000000001000";
			PC_sel <= '1';
		   PC_LdEn <= '0';
			wait for 50 ns; -- wait until global set/reset completes
			
			Reset <= '0';
			PC_Immed <= "00000000000000000000000000001000";
			PC_sel <= '1';
		   PC_LdEn <= '1';
			wait for 50 ns; -- wait until global set/reset completes
			

        wait; -- will wait forever
     END PROCESS tb;
  --  End Test Bench 

  END;
