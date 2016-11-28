library ieee;
use ieee.std_logic_1164.all;
package mem_package is
type ram_t is array (0 to 255) of std_logic_vector(15 downto 0);
constant INST_INIT : ram_t := (
0 => "0001000000010100",
1 => "0001001001010100",
2 => "0110001000001001",
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
