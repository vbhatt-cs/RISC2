library ieee;  
use ieee.std_logic_1164.all; 
 
entity fetch is  
    port (stall,Ctrl_forwarding_V: in std_logic;
        clk,reset : in std_logic;
        M2: out std_logic;
        T3_FD_En,PC_FD_En: out std_logic);  
end entity;
  
architecture behaviour of fetch is 
  
begin  
    process (clk,reset) 
        variable M2_var,T3_FD_En_var,PC_FD_En_var: std_logic;

    begin
        --Defaults
        M2_var := '0';
        T3_FD_En_var := '0';
        PC_FD_En_var := '0';
	
	if (stall = '0') then
            if (Ctrl_forwarding_V ='0') then
	    	M2_var := '1' ;
	    else 
		M2_var := '0';
	    end if;
            PC_FD_En_var := '1';
            T3_FD_En_var := '1';
	end if;
        
        M2 <= M2_var;     
        T3_FD_En <= T3_FD_En_var;
        PC_FD_En <= PC_FD_En_var;
            
    end process;  
end behaviour;
