----------------------------------------------------------------------------------
-- Create Date	: 11:22:04 11/05/2019 
-- Module Name	: ram_si_so_irwa - Behavioral 
-- Project Name	: Design of generic FIFO using RAM in VHDL
-- Description	: RAM description
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ram_si_so_irwa is
    Port ( clk 		: in  STD_LOGIC;
           din_we 	: in  STD_LOGIC;
           din_addr : in  STD_LOGIC_VECTOR (4 downto 0);
           din 		: in  STD_LOGIC_VECTOR (7 downto 0);
           dout_addr: in  STD_LOGIC_VECTOR (4 downto 0);
           dout 	: out  STD_LOGIC_VECTOR (7 downto 0));
end ram_si_so_irwa;

architecture Behavioral of ram_si_so_irwa is

    type mem_array_t is array(31 downto 0) of std_logic_vector(7 downto 0);
    signal mem_array : mem_array_t;

begin

    process (clk, mem_array, dout_addr, din_we, din_addr, din)
    begin
        if rising_edge(clk) then

            dout <= mem_array(to_integer(unsigned(dout_addr)));

            if din_we = '1' then
                mem_array(to_integer(unsigned(din_addr))) <= din;
            end if;

        end if;
    end process;

end Behavioral;

