library ieee;  
use ieee.std_logic_1164.all; 
 
entity decode is  
    port (stall: in std_logic;
        clk,reset: in std_logic;
	T3_DR_En,PC_DR_En,IR_DR_En: out std_logic);  
end entity;
  
architecture behaviour of decode is
  
begin  
    process (clk,reset)
        variable T3_DR_En_var,PC_DR_En_var,IR_DR_En_var: std_logic;

    begin
        --Defaults
        T3_DR_En_var := '0';
        PC_DR_En_var := '0';
	IR_DR_En_var := '0';
                  
        if (stall ='0') then
            T3_DR_En_var := '1';
            PC_DR_En_var := '1';
            IR_DR_En_var := '1';
	end if;

        T3_DR_En <= T3_DR_En_var;
        PC_DR_En <= PC_DR_En_var;
        IR_DR_En <= IR_DR_En_var;

    end process;  
end behaviour;
