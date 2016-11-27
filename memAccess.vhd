library ieee;  
use ieee.std_logic_1164.all; 
 
entity memAccess is  
    port (IR_EM: in std_logic_vector(15 downto 0);
        clk,reset,PE2_V,PE1_V,NC_EM : in std_logic;
        M9: out std_logic_vector(1 downto 0);  
        M11,M13,M14,M15,stall_M,MLoop1: out std_logic;
        Z_En,Mem_Wr,T2_EM_En,T3_MW_En,T4_MW_En,T2_MW_En,PC_MW_En,IR_MW_En,PC_MW2_En: out std_logic);  
end entity;
  
architecture behaviour of memAccess is
  
begin  
    process (clk,reset,PE2_V,PE1_V)
        variable M9_var: std_logic_vector(1 downto 0);  
        variable M11_var,M13_var,M14_var,M15_var,stall_M_var,MLoop1_var: std_logic;
        variable Z_En_var,Mem_Wr_var,T2_EM_En_var,T3_MW_En_var,T4_MW_En_var,T2_MW_En_var,PC_MW_En_var,
        IR_MW_En_var,PC_MW2_En_var: std_logic;

    begin
        --Defaults
        M11_var := '1'; 
        T3_MW_En_var := '1';
        T4_MW_En_var := '1';
        PC_MW_En_var := '1';
        IR_MW_En_var := '1';
        stall_M_var := '0';
        MLoop1_var := '0';
        Mem_Wr_var := '0';
        
        if(NC_EM='0' and reset='0') then
            if (IR_EM(15 downto 12) = "0110") then --LM
                M15_var := '1';
                M14_var := '1';
                Mem_Wr_var := '0';
                T2_MW_En_var := '1';
                T2_EM_En_var := '1';
                PC_MW2_En_var := '0';
                if(PE1_V='1') then
                    stall_M_var := '1';
                end if;
            elsif (IR_EM(15 downto 12) = "0100") then --LW
                M15_var := '1';
                M14_var := '1';
                Mem_Wr_var := '0';
                T2_MW_En_var := '0';
                T2_EM_En_var := '0';
                PC_MW2_En_var := '0';   
            elsif (IR_EM(15 downto 12) = "0111") then --SM
                M15_var := '0';
                M9_var := "00";
                M13_var := '0';
                Mem_Wr_var := '1';
                T2_MW_En_var := '1';
                T2_EM_En_var := '1';
                PC_MW2_En_var := '0';
                
                if(PE2_V='1') then
                    MLoop1_var := '1';
                    stall_M_var := '1';
                end if;
            elsif (IR_EM(15 downto 12) = "0101") then --SW
                M15_var := '0';
                M9_var := "01";
                M13_var := '1';
                Mem_Wr_var := '1';
                T2_MW_En_var := '0';
                T2_EM_En_var := '0';
                PC_MW2_En_var := '0';
            elsif (IR_EM(15 downto 13) = "100") then --JAL,JLR
                M15_var := '0';
                Mem_Wr_var := '0';
                T2_MW_En_var := '0';
                T2_EM_En_var := '0';
                PC_MW2_En_var := '1';
            else --default
                M15_var := '0';
                M14_var := '0';
                Mem_Wr_var := '0';
                T2_MW_En_var := '0';
                T2_EM_En_var := '0';
                PC_MW2_En_var := '0';
            end if;
        end if;

        M9 <= M9_var;

        M11 <= M11_var;
        M13 <= M13_var;
        M14 <= M14_var;
        M15 <= M15_var;
        
        Z_En <= Z_En_var;
        Mem_Wr <= Mem_Wr_var;
        T2_EM_En <= T2_EM_En_var;
        T3_MW_En <= T3_MW_En_var;
        T4_MW_En <= T4_MW_En_var;
        T2_MW_En <= T2_MW_En_var;
        PC_MW_En <= PC_MW_En_var;
        IR_MW_En <= IR_MW_En_var;
        PC_MW2_En <= PC_MW2_En_var;
        MLoop1 <= MLoop1_var;
            
    end process;  
end behaviour;
