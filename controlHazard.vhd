library ieee;  
use ieee.std_logic_1164.all;

entity controlHazard is
    port(
        PC_RE,PC_EM,IR_RE,IR_EM,T4_RE,T1_RE,memDout,aluOut,RF_pco: in std_logic_vector(15 downto 0);
        C,Z,Z1,NC_RE_out,NC_EM_out,stall: in std_logic;
        Ctrl_forwarding_V,NC_EM_in,NC_DR_in,NC_RE_in: out std_logic;
        M21: out std_logic_vector(2 downto 0);
        clk,reset: in std_logic);
end entity;

architecture Behave of controlHazard is
begin
    process(clk,reset,aluOut,Z,stall)
        variable Ctrl_forwarding_V_var,NC_EM_var,NC_DR_var,NC_RE_var: std_logic;
        variable M21_var: std_logic_vector(2 downto 0);
    begin
        NC_EM_var := '0';
        NC_DR_var := '0';
        NC_RE_var := '0';
        M21_var := "000";
        Ctrl_forwarding_V_var := '0';
        
        if(stall='0' and reset='0') then
            if(IR_EM(15 downto 12) = "0100" and NC_EM_out = '0') then --LW in M state
                if(IR_EM(11 downto 9) = "111") then
                    if(memDout /= PC_EM) then
                        NC_DR_var := '1';
                        NC_RE_var := '1';
                        NC_EM_var := '1';
                        M21_var := "001";
                        Ctrl_forwarding_V_var := '1';
                    end if;
                end if;
            end if;
            
            if(NC_RE_out = '0' and NC_RE_var = '0') then
                if((IR_RE(15 downto 12) = "0000" or IR_RE(15 downto 12) = "0010") and IR_EM(5 downto 3) = "111") then --AD*,ND*
                    if(IR_RE(1 downto 0) = "00") then
                        if(aluOut /= PC_RE) then
                            NC_DR_var := '1';
                            NC_RE_var := '1';
                            Ctrl_forwarding_V_var := '1';
                        end if;
                    elsif(IR_RE(1 downto 0) = "10") then
                        if(C = '1' and aluOut /= PC_RE) then
                            NC_DR_var := '1';
                            NC_RE_var := '1';
                            Ctrl_forwarding_V_var := '1';
                        end if;
                    else
                        if(Z = '1' and aluOut /= PC_RE) then
                            NC_DR_var := '1';
                            NC_RE_var := '1';
                            Ctrl_forwarding_V_var := '1';
                        end if;
                    end if;
                    
                elsif((IR_RE(15 downto 12) = "0001" and IR_EM(8 downto 6) = "111") or IR_RE(15 downto 12) = "1000") then --ADI,JAL
                    if(aluOut /= PC_RE) then
                        NC_DR_var := '1';
                        NC_RE_var := '1';
                        Ctrl_forwarding_V_var := '1';
                    end if;
                    
                elsif(IR_RE(15 downto 12) = "0011" and IR_EM(11 downto 9) = "111") then --LHI
                    if(T4_RE /= PC_RE) then
                        NC_DR_var := '1';
                        NC_RE_var := '1';
                        M21_var := "010";
                        Ctrl_forwarding_V_var := '1';
                    end if;
                    
                elsif(IR_RE(15 downto 12) = "1100") then --BEQ
                    if(Z1 = '1' and aluOut /= PC_RE) then
                        NC_DR_var := '1';
                        NC_RE_var := '1';
                        Ctrl_forwarding_V_var := '1';
                    end if;
                    
                elsif(IR_RE(15 downto 12) = "1001") then --JLR
                    if(T1_RE /= PC_RE) then
                        NC_DR_var := '1';
                        NC_RE_var := '1';
                        M21_var := "011";
                        Ctrl_forwarding_V_var := '1';
                    end if;
                    
                elsif(IR_RE(15 downto 12) = "0110" and IR_RE(8) = '1') then --LM
                    if(RF_pco /= PC_RE) then
                        NC_DR_var := '1';
                        NC_RE_var := '1';
                        M21_var := "100";
                        Ctrl_forwarding_V_var := '1';
                    end if;
                end if;
            end if;
        end if;
        
        NC_EM_in <= NC_EM_var;
        NC_DR_in <= NC_DR_var;
        NC_RE_in <= NC_RE_var;
        M21 <= M21_var;
        Ctrl_forwarding_V <= Ctrl_forwarding_V_var;
    end process;
end Behave;