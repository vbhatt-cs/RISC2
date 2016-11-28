library ieee;
use ieee.std_logic_1164.all;

package finalComponents is
    component Datapath_RISC is
        port (
            M2,M10,M13,M14,M15,M18,M19,M5,MLoop1,MLoop2,M9,
            PC_FD_En,T3_FD_En,T3_DR_En,PC_DR_En,IR_DR_En,Z1_En,T1_RE_En,T2_RE_En,T3_RE_En,T4_RE_En,
            IR_RE_En,PC_RE_En,PC_RE2_En,T2_EM_En,T3_EM_En,T4_EM_En,PC_EM_En,IR_EM_En,PC_EM2_En,
            C_En,Z_En,T3_MW_En,T4_MW_En,T2_MW_En,PC_MW_En,IR_MW_En,PC_MW2_En,
            RegWr,PCWr,Alu_op,MemWr: in std_logic;
            M3,M4,M6,M7,M8,M16,M17,M20: in std_logic_vector(1 downto 0);
            M21: in std_logic_vector(2 downto 0);
            C,ZEff,PE1_V,PE2_V,Z1: out std_logic;
            NC_DR_in,NC_RE_in,NC_EM_in: in std_logic;
            NC_DR,NC_RE,NC_EM,NC_MW: out std_logic;
            IR_DR,IR_RE,IR_EM,IR_MW,PC_RE,PC_EM,T1_RE,T4_RE,memDout,aluOut,r7: out std_logic_vector(15 downto 0);
            clk,reset: in std_logic);
    end component;
    
    --Controllers
    component fetch is  
        port (stall,Ctrl_forwarding_V: in std_logic;
            clk,reset : in std_logic;
            M2: out std_logic;
            T3_FD_En,PC_FD_En: out std_logic);  
    end component;
    
    component decode is  
        port (stall: in std_logic;
            clk,reset: in std_logic;
        T3_DR_En,PC_DR_En,IR_DR_En: out std_logic);  
    end component;
    
    component regRead is  
        port (stall,data_forward1,data_forward2,NC_DR: in std_logic;
            IR_DR: in std_logic_vector(15 downto 0);
            clk,reset : in std_logic;
            M3,M4: out std_logic_vector(1 downto 0);  
            M19,M5: out std_logic;
            Z1_En,T1_RE_En,T2_RE_En,T3_RE_En,T4_RE_En,IR_RE_En,PC_RE_En,PC_RE2_En: out std_logic);  
    end component;
    
    component execute is  
        port (IR_RE: in std_logic_vector(15 downto 0);
            clk,reset,PE2_V,NC_RE : in std_logic;
            M6,M7,M8: out std_logic_vector(1 downto 0);  
            M10,stall_E: out std_logic;
            T2_EM_En,T3_EM_En,T4_EM_En,PC_EM_En,IR_EM_En,PC_EM2_En,C_En,Alu_op: out std_logic);  
    end component;
    
    component memAccess is  
        port (IR_EM: in std_logic_vector(15 downto 0);
            clk,reset,PE2_V,PE1_V,NC_EM : in std_logic;
            M9,M13,M14,M15,stall_M,MLoop1: out std_logic;
            Z_En,Mem_Wr,T3_MW_En,T4_MW_En,T2_MW_En,PC_MW_En,IR_MW_En,PC_MW2_En: out std_logic);  
    end component;
    
    component regWrite is  
        port (PE1_V,NC_MW: in std_logic;
            IR_MW: in std_logic_vector(15 downto 0);
            clk,reset : in std_logic;
            M16,M17: out std_logic_vector(1 downto 0);  
            M18,stall_W,MLoop2: out std_logic;
            Reg_Wr,PC_Wr: out std_logic);  
    end component;
    
    --Control hazard block
    component controlHazard is
        port(
            PC_RE,PC_EM,IR_RE,IR_EM,T4_RE,T1_RE,memDout,aluOut,RF_pco: in std_logic_vector(15 downto 0);
            C,Z,Z1,NC_RE_out,NC_EM_out,stall: in std_logic;
            Ctrl_forwarding_V,NC_EM_in,NC_DR_in,NC_RE_in: out std_logic;
            M21: out std_logic_vector(2 downto 0);
            clk,reset: in std_logic);
    end component;
end package;