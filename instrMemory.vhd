library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.datapathComponents.all;
use work.mem_package.all;

entity instrMemory is
    port( 
        A : in std_logic_vector(15 downto 0);
        Dout : out std_logic_vector(15 downto 0);
        clk : in std_logic);
end entity;

architecture Behave of instrMemory is
    signal ram : ram_t := INST_INIT;
    signal a_sync: std_logic_vector(15 downto 0);
begin
    Dout <= ram(to_integer(unsigned(a_sync)));
    process(clk)
    begin
        if(rising_edge(Clk)) then
            a_sync <= a;
        end if;
    end process;
end Behave;