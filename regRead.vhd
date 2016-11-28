library ieee;  
use ieee.std_logic_1164.all; 
 
entity regRead is  
    port (stall,data_forward1,data_forward2,NC_DR: in std_logic;
        IR_DR: in std_logic_vector(15 downto 0);
        clk,reset : in std_logic;
        M3,M4: out std_logic_vector(1 downto 0);  
        M19,M5: out std_logic;
        Z1_En,T1_RE_En,T2_RE_En,T3_RE_En,T4_RE_En,IR_RE_En,PC_RE_En,PC_RE2_En: out std_logic);  
end entity;
  
architecture behaviour of regRead is
  
begin  
    process (clk,reset,stall)
        variable M3_var,M4_var: std_logic_vector(1 downto 0);  
        variable M19_var,M5_var: std_logic;
        variable Z1_En_var,T1_RE_En_var,T2_RE_En_var,T3_RE_En_var,T4_RE_En_var,
        	IR_RE_En_var,PC_RE_En_var,PC_RE2_En_var: std_logic;

    begin
        --Defaults
        M3_var := "00";
        M4_var := "00";
        M5_var := '0';       
        M19_var := '0';       
        Z1_En_var := '0';
        T1_RE_En_var := '0';
        T2_RE_En_var := '0';
        T3_RE_En_var := '0';
        T4_RE_En_var := '0';
        IR_RE_En_var := '0';
        PC_RE_En_var := '0';
        PC_RE2_En_var := '0';
                 
        if (stall = '0' and reset='0' and NC_DR='0') then
            if (data_forward1 = '1') then 
                M3_var := "01"; 
            elsif (IR_DR(8 downto 6) = "111") then
                M3_var := "10"; 
            else 
                M3_var := "00";
            end if;
            
            if (data_forward2 = '1') then 
                M4_var := "01"; 
            elsif (IR_DR(11 downto 9) = "111") then
                M4_var := "10";
            else
                M4_var := "00";
            end if;
            T1_RE_En_var := '1';
            T2_RE_En_var := '1';
            T3_RE_En_var := '1';
            T4_RE_En_var := '1';
            IR_RE_En_var := '1';
            PC_RE_En_var := '1';
            if ((IR_DR(15 downto 12) = "0001") or (IR_DR(15 downto 12) = "0100") or (IR_DR(15 downto 12) = "0101")) then
                M5_var := '1';
            elsif (IR_DR(15 downto 12) = "1000") then
                M5_var := '1';
                M19_var := '1';
            elsif (IR_DR(15 downto 12) = "1001") then
                PC_RE2_En_var := '1';
            elsif (IR_DR(15 downto 12) = "1100") then
                M5_var := '1';
                Z1_En_var := '1';
            end if;
        end if;
             
        M3 <= M3_var;
        M4 <= M4_var;
        M5 <= M5_var;        
        M19 <= M19_var;
        Z1_En <= Z1_En_var;
        T1_RE_En <= T1_RE_En_var;
        T2_RE_En <= T2_RE_En_var;
        T3_RE_En <= T3_RE_En_var;
        T4_RE_En <= T4_RE_En_var;
        IR_RE_En <= IR_RE_En_var;
        PC_RE_En <= PC_RE_En_var;
        PC_RE2_En <= PC_RE2_En_var;
            
    end process;  
end behaviour;
