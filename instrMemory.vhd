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
begin
    Dout <= ram(to_integer(unsigned(a(7 downto 0))));
end Behave;
