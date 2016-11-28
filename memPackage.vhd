library ieee;
use ieee.std_logic_1164.all;
package mem_package is
type ram_t is array (0 to 255) of std_logic_vector(15 downto 0);
constant INST_INIT : ram_t := (
0 => "0011000100000001",
1 => "0001001001001100",
2 => "0001001001000011",
3 => "0011011000000001",
4 => "0011100000000001",
5 => "0011101000000001",
6 => "0000000000000010",
7 => "0000000000000000",
8 => "0000001001000010",
others => (others => '0'));

constant DATA_INIT : ram_t := (
20 => x"0001",
21 => x"000F",
--22 => x"000C",
23 => x"FFFF",
24 => x"0045",
--25 => x"FFBB",
--26 => x"0044",
others => (others => '0'));
end package mem_package;
