library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.datapathComponents.all;
use work.mem_package.all;

entity dataMemory is
    port( 
        A,Din : in std_logic_vector(15 downto 0);
        Dout : out std_logic_vector(15 downto 0);
        memWR : in std_logic;
        clk : in std_logic);
end entity;

architecture Behave of dataMemory is
    signal ram : ram_t := DATA_INIT;
begin
    Dout <= ram(to_integer(unsigned(A(7 downto 0))));
    process(clk)
    begin
        if(rising_edge(Clk)) then
            if(memWR='1') then
                ram(to_integer(unsigned(A(7 downto 0)))) <= Din;
            end if;
        end if;
    end process;
end Behave;
