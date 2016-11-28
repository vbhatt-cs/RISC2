library ieee;
use ieee.std_logic_1164.all;
library work;
use work.datapathComponents.all;

entity flipFlop is
    port(
        Din: in std_logic;
        Dout: out std_logic;
        clk, enable, reset: in std_logic);
end entity;

architecture Behave of flipFlop is
begin
    process(clk)
    begin
        if(clk'event and (clk  = '1')) then
            if(reset='1') then
                Dout <= '0';
            elsif(enable = '1') then
                Dout <= Din;
            else
            end if;
        else
        end if;
    end process;
end Behave;