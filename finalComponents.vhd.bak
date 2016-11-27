library ieee;
use ieee.std_logic_1164.all;

package finalComponents is
    component Datapath_RISC is
        port (
            M2,M3,M6,M7,M8,M9,M14: in std_logic;
            PCWr,PCTempWr,IREn,MemWr,T1En,T2En,T3En,T4En,RegWr,CEn,ZEn,Alu_op: in std_logic;
            M1,M4,M5,M10,M11,M12,M13: in std_logic_vector(1 downto 0);
            C,Z,PE_V,compVal: out std_logic;
            IRVal: out std_logic_vector(15 downto 0);
            clk,reset: in std_logic );
    end component;
    
    component controlpath is  
        port (
            z,c,pe_v,comp_out : in std_logic;
            clk,reset : in std_logic;
            IRVal : in std_logic_vector(15 downto 0);
            M1,M4,M5,M10,M11,M12,M13 : out std_logic_vector(1 downto 0);  
            M2,M3,M6,M7,M8,M9,M14: out std_logic;
            PCWr,PCTempWr,MemWr,IREn,T1En,T2En,T3En,T4En,RegWr,CEn,ZEn,Alu_op : out std_logic);  
    end component;
end package;