----------------------------------------------------------------------------------
-- Create Date	: 11:12:49 11/05/2019 
-- Module Name	: tb_testtask - Behavioral 
-- Project Name	: Design of generic FIFO using RAM in VHDL
-- Description	: Testbench for the testtask module 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_testtask is
	generic (	data_width	    : INTEGER:= 16;
				fifo_depth 	    : INTEGER:= 64;
				aempty_threshold: INTEGER:= 5;
				afull_threshold : INTEGER:= 60);
end tb_testtask;

architecture Behavioral of tb_testtask is

component testtask is

    generic (	constant data_width	 		: INTEGER;
				constant fifo_depth 	   	: INTEGER;
				constant aempty_threshold  	: INTEGER;
				constant afull_threshold   	: INTEGER);
				 
				 
      Port (clk 		: in  STD_LOGIC;
            rst 		: in  STD_LOGIC;
            din 		: in  STD_LOGIC_VECTOR (data_width-1 downto 0);
            we 			: in  STD_LOGIC;
            re 			: in  STD_LOGIC;
            dout	   	: out STD_LOGIC_VECTOR (data_width-1 downto 0);
            empty 		: out STD_LOGIC;
            aempty 		: out STD_LOGIC;
            afull 		: out STD_LOGIC;
            full 		: out STD_LOGIC;
			count		: out INTEGER);
			  
end component;

-- signal declaration

-- inputs
		signal clk   	: STD_LOGIC:= '1';
        signal rst   	: STD_LOGIC:= '1';
        signal din      : STD_LOGIC_VECTOR (data_width-1 downto 0):=(others => '0');
        signal we       : STD_LOGIC:='0';
        signal re       : STD_LOGIC:='0';
			
-- outputs
		signal dout 	: STD_LOGIC_VECTOR (data_width-1 downto 0):=(others => '0');
        signal empty 	: STD_LOGIC;
        signal aempty	: STD_LOGIC;
        signal afull  	: STD_LOGIC;
        signal full   	: STD_LOGIC;
		signal count  	: integer;
			
			
-- clock period definition
		constant clk_period : time := 10 ns;
		
begin

DUT : entity work.testtask

	generic map(	data_width		 => data_width,
					fifo_depth 	     => fifo_depth,
					aempty_threshold => aempty_threshold,
					afull_threshold  => afull_threshold)

	port map(	clk    => clk,
				rst    => rst,  
				din    => din,  
				we 	   => we,
				re 	   => re,   
				dout   => dout,  
				empty  => empty,
				aempty => aempty,
				afull  => afull, 
				full   => full,
				count  => count);   
				
			
	clk <= not clk after clk_period/2;
		
-- reset process definition
	
rst_process : process
	begin
	wait for clk_period/2;
	wait for clk_period/2;
	rst <= '1';
	wait for clk_period/2;
	rst <= '0';
	wait;
end process rst_process;

---- write process

write_process : process
	variable counter : unsigned (data_width-1 downto 0) := (others => '0'); 
	begin		
		wait for clk_period * 20;
        for i in 0 to fifo_depth-1 loop -- to get fifo_depth number of inputs
				counter := counter + 1;
				din <= std_logic_vector(counter);		
			wait for CLK_period * 1;
				we <= '1';				
			wait for CLK_period * 1;
				we <= '0';	
				
		end loop;
		wait;
end process write_process;

-- read process

read_process : process

	begin
	
	wait for clk_period * 50*(fifo_depth/32);
	wait for clk_period * 40*(fifo_depth/32);
	re <= '1';
	wait;
	
end process read_process;
end Behavioral;

