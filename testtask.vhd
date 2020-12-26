------------------------------------------------------------------------------------------------------------------
-- Name		: Rajarajeswari Angia Krishnan
-- Create Date	: 15:15:21 11/05/2019 
-- Module Name	: testtask - Behavioral
-- Project Name	: Design of generic FIFO using RAM in VHDL
-- Description	: This module will generate array of RAM to store the data in FIFO.
--		  The given RAM has predefined data width of 8 bit and depth of 32 (32 different address possible)
--		  The RAM array is generated based on the number of datas written to the FIFO and the width of data.
---------------------------------------------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity testtask is

    generic (	data_width	    : INTEGER;
				fifo_depth 	  	: INTEGER;
				aempty_threshold: INTEGER;
				afull_threshold : INTEGER);
				 
				 
      Port (clk 		: in   STD_LOGIC;
            rst 		: in   STD_LOGIC;
            din	   		: in   STD_LOGIC_VECTOR (data_width-1 downto 0);
            we 			: in   STD_LOGIC;
            re 			: in   STD_LOGIC;
            dout     	: out  STD_LOGIC_VECTOR (data_width-1 downto 0);
            empty 		: out  STD_LOGIC;
            aempty 		: out  STD_LOGIC;
            afull 		: out  STD_LOGIC;
            full 		: out  STD_LOGIC;
			count		: out  INTEGER);
end testtask;

	
architecture Behavioral of testtask is



component ram_si_so_irwa
    port
    (
        clk       	:  in std_logic;
        din_we    	:  in std_logic;
        din_addr  	:  in std_logic_vector(4 downto 0);
        din       	:  in std_logic_vector(7 downto 0);
        dout_addr 	:  in std_logic_vector(4 downto 0);
        dout      	: out std_logic_vector(7 downto 0)
    );
end component ram_si_so_irwa;


signal din_ram    : std_logic_vector(data_width-1 downto 0);
signal dout_ram   : std_logic_vector(fifo_depth/32*data_width-1 downto 0);
signal ramadd_in  : std_logic_vector(4 downto 0);
signal ramadd_out : std_logic_vector(4 downto 0);


signal head     : integer := 0; -- points to next location where data has to be written to fifo
signal tail     : integer := 0; -- points to next location where data has to be read from fifo


signal count_i  : integer := 0;
signal empty_i  : std_logic;
signal full_i   : std_logic;
signal aempty_i : std_logic;
signal afull_i  : std_logic;
signal we_i 	: std_logic_vector(0 to (fifo_depth/32 - 1));


-- RAM array generation
begin
	ram_depth: for d in 0 to (fifo_depth/32 -1) generate	

	begin
		ram_width: for w in 0 to (data_width/8 - 1) generate
		 
				ramstorage: ram_si_so_irwa port map
											( clk		 =>	clk, 
											  din_addr 	 => ramadd_in, 
											  din		 =>	din((w+1)*8-1 downto w*8),
											  din_we 	 => we_i(d),
											  dout_addr  => ramadd_out, 
											  dout		 =>	dout_ram(( d * data_width +(w+1) * 8) -1 downto (d * data_width + w * 8))
											  );									  	
					
		end generate ram_width;
	end generate ram_depth;

-- FIFO data input to the RAM input
ram_we: for I in 0 to fifo_depth/32-1 generate
	we_i(I) 	<= (we and not full_i) when head >= I*32 and head < (I+1)*32 else '0';
	ramadd_in 	<= std_logic_vector(to_unsigned(head,ramadd_in'length));
	din_ram   	<= din;
end generate ram_we;

-- RAM data to the FIFO output
ramadd_out <= std_logic_vector(to_unsigned(tail,ramadd_out'length));
dout 	   <= dout_ram(((tail/32)+1)*data_width-1 downto (tail/32)*data_width);		       


count  <= count_i;
empty  <= empty_i;
full   <= full_i;
aempty <= aempty_i;
afull  <= afull_i;

 
empty_i  <= '1' when count_i = 0 else '0';
aempty_i <= '1' when count_i <= aempty_threshold else '0';
full_i   <= '1' when count_i = fifo_depth else '0';
afull_i  <= '1' when count_i >= afull_threshold else '0';
				

-- Write data

process_head: process(clk)

begin
	
if rising_edge(clk) then
 
	if (we = '1') and full_i = '0'  then
		if (head = fifo_depth -1) then
				head <= 0;
		else
				head <= head + 1;
		end if;
	end if;
	
end if;	

end process process_head;

-- Read data 

process_tail: process(clk)

begin

if rising_edge(clk) then

	if (re = '1') and empty_i = '0' then
		if (tail = fifo_depth-1) then
			tail <= 0;
		else
			tail <= tail + 1;
		end if;
   end if;
   
end if;	
end process process_tail;

--- count update

process_count: process(rst, clk, count_i)

begin
	if rst = '1' then
		count_i <= 0;
	elsif rising_edge(clk) then
		if we /= re then
			if we = '1' and full_i = '0' then
				count_i <= count_i + 1;
			end if;
			
			if re = '1' and empty_i = '0' then
				count_i <= count_i - 1;
			end if;
		end if;
	end if;
	
end process process_count;

end Behavioral;




