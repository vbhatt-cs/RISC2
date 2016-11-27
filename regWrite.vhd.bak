library ieee;  
use ieee.std_logic_1164.all; 
 
entity regWrite is  
    port (C,Z: in std_logic;
        IR_MW: in std_logic_vector(15 downto 0);
        clk,reset : in std_logic;
        M16,M17: out std_logic_vector(1 downto 0);  
        M12,M18: out std_logic;
        Z_En,T4_EM_En,Reg_Wr,PC_Wr: out std_logic);  
end entity;
  
architecture behaviour of regWrite is
  
begin  
    process (clk,reset)
        variable M16_var,M17_var: std_logic_vector(1 downto 0);  
        variable M12_var,M18_var: std_logic;
        variable Z_En_var,T4_EM_En_var,Reg_Wr_var,PC_Wr_var: std_logic;

    begin
        --Defaults
            PC_Wr_var := '1';
            if (IR_MW(15 downto 12) = "0110") then --LM
            	M17_var := "00";
                M16_var := "11";
                M18_var := '0';
                Reg_Wr_var := '1';
                T4_EM_En_var := '1';
                M12_var := '1';
                Z_En_var := '0';
            elsif (IR_MW(15 downto 13) = "100") then --JAL,JLR
            	M17_var := "10";
                M16_var := "00";
                M18_var := '1';
                Reg_Wr_var := '1';
                T4_EM_En_var := '0';
                M12_var := '0';
                Z_En_var := '0';  
            elsif (IR_MW(15 downto 12) = "0001") then --ADI
                M17_var := "01";
                M16_var := "10";
                M18_var := '0';
                Reg_Wr_var := '1';
                T4_EM_En_var := '0';
                M12_var := '0';
                Z_En_var := '1';
            elsif (IR_MW(15 downto 12) = "0011") then --LHI
                M17_var := "01";
                M16_var := "00";
                M18_var := '0';
                Reg_Wr_var := '1';
                T4_EM_En_var := '0';
                M12_var := '0';
                Z_En_var := '1';
            elsif (IR_MW(15 downto 12) = "0110") then --LW
                M17_var := "00";
                M16_var := "00";
                M18_var := '0';
                Reg_Wr_var := '1';
                T4_EM_En_var := '0';
                M12_var := '0';
                Z_En_var := '1';
            elsif (IR_MW(15 downto 12) = "0110") then --BEQ --not sure about this
                M17_var := "00";
                M16_var := "11";
                M18_var := '0';
                Reg_Wr_var := '1';
                T4_EM_En_var := '1';
                M12_var := '1';
                Z_En_var := '0';
            elsif ((IR_MW(15 downto 12) = "0000") or (IR_MW(15 downto 12) = "0010")) then --not sure
            	M17_var := "00";
                M16_var := "01";
                M18_var := '0';
                T4_EM_En_var := '0';
                M12_var := '0';
            	if (((IR_MW(1 downto 0) = "10") and C='0') or ((IR_MW(1 downto 0) = "01") and Z='0'))
            		then  --checking for "no change"
            		Reg_Wr_var := '0';
            		Z_En_var := '0';
      			else
      				Reg_Wr_var := '1';
            		Z_En_var := '1';
            	end if;
            else --default --not sure about this
            	M17_var := "00";
                M16_var := "01";
                M18_var := '0';
                Reg_Wr_var := '1';
                T4_EM_En_var := '1';
                M12_var := '1';
                Z_En_var := '0';
            end if;

        M16 <= M16_var;
        M17 <= M17_var;

        M12 <= M12_var;
        M18 <= M18_var;

	Z_En <= Z_En_var;
	T4_EM_En <= T4_EM_En_var;        
        Reg_Wr <= Reg_Wr_var;
        PC_Wr <= PC_Wr_var;
            
    end process;  
end behaviour;
