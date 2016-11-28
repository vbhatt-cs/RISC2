library ieee;
use ieee.std_logic_1164.all;
library work;
use work.datapathComponents.all;

entity dataRegister is
	generic (data_width:integer);
	port(
        Din: in std_logic_vector(data_width-1 downto 0);
	    Dout: out std_logic_vector(data_width-1 downto 0);
	    clk, enable, reset: in std_logic);
end entity;

architecture Behave of dataRegister is
begin
    process(clk)
    begin
        if(clk'event and (clk  = '1')) then
            if(reset='1') then
                Dout <= (others => '0');
            elsif(enable = '1') then
                Dout <= Din;
            else
            end if;
        else
        end if;
    end process;
end Behave;