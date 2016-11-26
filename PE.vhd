library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.datapathComponents.all;

entity PE is
    port(
        inp: in std_logic_vector(15 downto 0);
        v: out std_logic;
        a: out std_logic_vector(2 downto 0);
        d: out std_logic_vector(15 downto 0));
end entity;

architecture behave of PE is
begin
    process(inp)
    begin
        d <= inp;
        v <= '1';
        a <= "000";
        if (inp(7)='1') then
            a <= "000";
            d(7) <= '0';
        elsif (inp(8)='1') then
            a <= "001";
            d(8) <= '0';
        elsif (inp(9)='1') then
            a <= "010";
            d(9) <= '0';
        elsif (inp(10)='1') then
            a <= "011";
            d(10) <= '0';
        elsif (inp(11)='1') then
            a <= "100";
            d(11) <= '0';
        elsif (inp(12)='1') then
            a <= "101";
            d(12) <= '0';
        elsif (inp(13)='1') then
            a <= "110";
            d(13) <= '0';
        elsif (inp(14)='1') then
            a <= "111";
            d(14) <= '0';
        else
            v <= '0';
        end if;
    end process;
end behave;