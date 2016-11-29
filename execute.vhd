library ieee;  
use ieee.std_logic_1164.all; 
 
entity execute is  
    port (IR_RE: in std_logic_vector(15 downto 0);
        clk,reset,PE2_V,NC_RE,C,Zeff,data_forward3 : in std_logic;
        M6,M7,M8,M24: out std_logic_vector(1 downto 0);
        PE2_A: in std_logic_vector(2 downto 0);
        M10,stall_E,NC_EM_in,NC_RE_in,NC_RE_En: out std_logic;
        T2_EM_En,T3_EM_En,T4_EM_En,PC_EM_En,IR_EM_En,PC_EM2_En,C_En,Alu_op: out std_logic);  
end entity;
  
architecture behaviour of execute is
  
begin  
    process (clk,reset,PE2_V,C,Zeff,data_forward3)
        variable M6_var,M7_var,M8_var,M24_var: std_logic_vector(1 downto 0);  
        variable M10_var,stall_E_var: std_logic;
        variable T2_EM_En_var,T3_EM_En_var,T4_EM_En_var,PC_EM_En_var,NC_RE_En_var,NC_RE_in_var,
            IR_EM_En_var,PC_EM2_En_var,C_En_var,Alu_op_var, NC_EM_in_var: std_logic;

    begin
        --Defaults
        T2_EM_En_var := '1';
        T3_EM_En_var := '1';
        T4_EM_En_var := '1';
        PC_EM_En_var := '1';
        IR_EM_En_var := '1';
        stall_E_var := '0';
        Alu_op_var := '0';
        M6_var := "00";
        M7_var := "00";
        M8_var := "00";
        PC_EM2_En_var := '0';
        C_En_var := '0';
        M10_var := '0';
        NC_EM_in_var := '0';
        NC_RE_En_var := '0';
        NC_RE_in_var := '0';
        M24_var := "00";
    
        if(NC_RE='0' and reset='0') then
            if (IR_RE(15 downto 12) = "0110") then --LM 
                M6_var := "00";
                M7_var := "01";
                M8_var := "01";
                PC_EM2_En_var := '0';
                C_En_var := '0';
                stall_E_var := '1';
                NC_RE_in_var := '1';
                NC_RE_En_var := '1';
            elsif (IR_RE(15 downto 12) = "0111") then --SM
                M6_var := "00";
                M7_var := "01";
                M8_var := "10";
                
                if (data_forward3 = '1') then 
                    M24_var := "01"; 
                elsif (PE2_A = "111") then
                    M24_var := "10"; 
                else 
                    M24_var := "00";
                end if;
            
                PC_EM2_En_var := '0';
                C_En_var := '0';
                if(PE2_V='1') then
                    stall_E_var := '1';
                else
                    NC_EM_in_var := '1';
                end if;
            elsif (IR_RE(15 downto 12) = "1100") then --BEQ
                M6_var := "10";
                M7_var := "10";
                M8_var := "01";
                M10_var := '1';
                PC_EM2_En_var := '1';
                C_En_var := '0';
            elsif (IR_RE(15 downto 12) = "1000") then --JAL
                M6_var := "10";
                M7_var := "10";
                M8_var := "01";
                M10_var := '1';
                PC_EM2_En_var := '1';
                C_En_var := '0';
            elsif (IR_RE(15 downto 12) = "1001") then --JLR
                M6_var := "00";
                M7_var := "00";
                M8_var := "01";
                M10_var := '1';
                PC_EM2_En_var := '1';
                C_En_var := '0';
            elsif (IR_RE(15 downto 12) = "0011") then --LHI
                M6_var := "00";
                M7_var := "00";
                M8_var := "01";
                PC_EM2_En_var := '0';
                C_En_var := '0';
            elsif (IR_RE(15 downto 12) = "0001") then --ADI
                M6_var := "01";
                M7_var := "01";
                M8_var := "00";
                PC_EM2_En_var := '0';
                C_En_var := '0';
            elsif ((IR_RE(15 downto 13) = "010")) then --LW and SW
                M6_var := "00";
                M7_var := "01";
                M8_var := "00";
                PC_EM2_En_var := '0';
                C_En_var := '0';
            else --default
                if (IR_RE(15 downto 12) = "0010") then
                    Alu_op_var := '1';
                end if;
                
                if(IR_RE(1)='1' and C='0') then --Carry
                    NC_EM_in_var := '1';
                end if;
                
                if(IR_RE(0)='1' and Zeff='0') then --Zero
                    NC_EM_in_var := '1';
                end if;
                
                M6_var := "00";
                M7_var := "00";
                M8_var := "00";
                PC_EM2_En_var := '0';
                C_En_var := '1';
            end if;
        else
            T4_EM_En_var := '0';
        end if;

        M6 <= M6_var;
        M7 <= M7_var;
        M8 <= M8_var;
        M10 <= M10_var;
        M24 <= M24_var;
        stall_E <= stall_E_var;

        T2_EM_En <= T2_EM_En_var;
        T3_EM_En <= T3_EM_En_var;
        T4_EM_En <= T4_EM_En_var;
        PC_EM_En <= PC_EM_En_var;
        IR_EM_En <= IR_EM_En_var;
        PC_EM2_En <= PC_EM2_En_var;
        C_En <= C_En_var;
        Alu_OP <= Alu_OP_var;
        NC_EM_in <= NC_EM_in_var;
        NC_RE_in <= NC_RE_in_var;
        NC_RE_En <= NC_RE_En_var;
            
    end process;  
end behaviour;
