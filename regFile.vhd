library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.datapathComponents.all;

entity regFile is
    port(
        a1, a2, a3, a4 : in std_logic_vector(2 downto 0);
        d3, pci : in std_logic_vector(15 downto 0);
        d1, d2, d4, pco : out std_logic_vector(15 downto 0);
        regWr, pcWr : in std_logic;
        clk,reset : in std_logic);
end entity;

architecture Behave of regFile is
    type vec16 is array(natural range <>) of std_logic_vector(15 downto 0);
    signal reg : vec16(0 to 7) := (others => (others => '0'));
begin

    d1 <= reg(to_integer(unsigned(a1)));
    d2 <= reg(to_integer(unsigned(a2)));
    d4 <= reg(to_integer(unsigned(a4)));
    pco <= reg(7);
    
    process(clk)
        variable wrAddr : integer := 0;
    begin
        wrAddr := to_integer(unsigned(a3));
        if(rising_edge(Clk)) then
            if(reset='1') then
                reg <= (others => (others => '0'));
            else 
                if(regWR='1') then
                    reg(wrAddr) <= d3;
                end if;
                -- Write to PC. R7 not being written through A3,D3.
                if(pcWr='1' and (wrAddr/=7 or regWR='0')) then 
                    reg(7) <= pci;
                end if;
            end if;
        end if; 
    end process;
end Behave;
