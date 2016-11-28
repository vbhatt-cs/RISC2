library ieee;  
use ieee.std_logic_1164.all; 
 
entity regWrite is  
    port (PE1_V,NC_MW: in std_logic;
        IR_MW: in std_logic_vector(15 downto 0);
        clk,reset : in std_logic;
        M16,M17: out std_logic_vector(1 downto 0);  
        M18,stall_W,MLoop2: out std_logic;
        Reg_Wr,PC_Wr: out std_logic);  
end entity;
  
architecture behaviour of regWrite is
    signal MLoopState: std_logic := '0';
begin  
    process (clk,reset,PE1_V,MLoopState)
        variable M16_var,M17_var: std_logic_vector(1 downto 0);  
        variable M18_var,stall_W_var,MLoop2_var: std_logic := '0';
        variable Reg_Wr_var,PC_Wr_var: std_logic;

    begin
        --Defaults
        Reg_Wr_var := '0';
        stall_W_var := '0';
        M17_var := "00";
        M16_var := "00";
        M18_var := '0';
        PC_Wr_var := '1';
        MLoop2_var := '0';
        
        if(NC_MW='0' and reset='0') then
            if (IR_MW(15 downto 12) = "0110") then --LM
                M17_var := "00";
                M16_var := "11";
                M18_var := '0';
                Reg_Wr_var := '1';
                if(PE1_V='1') then
                    stall_W_var := '1';
                    if(MLoopState='0') then
                        MLoop2_var := '1';
                    else
                        MLoop2_var := '0';
                    end if;
                else
                    MLoop2_var := '0';
                end if;
            elsif (IR_MW(15 downto 13) = "100") then --JAL,JLR
                M17_var := "10";
                M16_var := "00";
                M18_var := '1';
                Reg_Wr_var := '1';
                MLoop2_var := '0';
            elsif (IR_MW(15 downto 12) = "0001") then --ADI
                M17_var := "00";
                M16_var := "10";
                M18_var := '0';
                Reg_Wr_var := '1';
                MLoop2_var := '0';
            elsif (IR_MW(15 downto 12) = "0011") then --LHI
                M17_var := "01";
                M16_var := "00";
                M18_var := '0';
                Reg_Wr_var := '1';
                MLoop2_var := '0';
            elsif (IR_MW(15 downto 12) = "0100") then --LW
                M17_var := "00";
                M16_var := "00";
                M18_var := '0';
                Reg_Wr_var := '1';
                MLoop2_var := '0';
            elsif (IR_MW(15 downto 12) = "0110") then --BEQ --not sure about this
                M17_var := "00";
                M16_var := "11";
                M18_var := '0';
                Reg_Wr_var := '1';
                MLoop2_var := '0';
            elsif ((IR_MW(15 downto 12) = "0000") or (IR_MW(15 downto 12) = "0010")) then --not sure
                M17_var := "00";
                M16_var := "01";
                M18_var := '0';
                Reg_Wr_var := '1';
                MLoop2_var := '0';
            else --default --not sure about this
                M17_var := "00";
                M16_var := "01";
                M18_var := '0';
                Reg_Wr_var := '1';
                MLoop2_var := '0';
            end if;
        end if;
        
        if(clk'event and clk='1') then
            MLoopState <= MLoop2_var;
        end if;

        M16 <= M16_var;
        M17 <= M17_var;

        M18 <= M18_var;
       
        Reg_Wr <= Reg_Wr_var;
        PC_Wr <= PC_Wr_var;
        stall_W <= stall_W_var;
        MLoop2 <= MLoopState;
            
    end process;  
end behaviour;
