library ieee;
use ieee.std_logic_1164.all;
library work;
use work.finalComponents.all;
use work.datapathComponents.all;

entity RISC2 is 
    port(clk,rst: in std_logic;
            x: out std_logic);
end entity;

architecture Struct of RISC2 is
    signal M2,M10,M13,M14,M15,M18,M19,M5,M9,
        PC_FD_En,T3_FD_En,T3_DR_En,PC_DR_En,IR_DR_En,Z1_En,T1_RE_En,T2_RE_En,T3_RE_En,T4_RE_En,
        IR_RE_En,PC_RE_En,PC_RE2_En,T2_EM_En,T3_EM_En,T4_EM_En,PC_EM_En,IR_EM_En,PC_EM2_En,
        C_En,Z_En,T3_MW_En,T4_MW_En,T2_MW_En,PC_MW_En,IR_MW_En,PC_MW2_En,NC_RE_in1,NC_RE_in2,
        NC_RE_En,RegWr,PCWr,Alu_op,MemWr,forwarding: std_logic;
    signal M3,M4,M6,M7,M8,M16,M17,M24: std_logic_vector(1 downto 0);
    signal M21,M20,M22,M23,PE2_A: std_logic_vector(2 downto 0);
    signal C,ZEff,PE1_V,PE2_V,Z1: std_logic;
    signal IR_DR,IR_RE,IR_EM,IR_MW,PC_RE,PC_EM,T1_RE,T4_RE,memDout,aluOut,r7: std_logic_vector(15 downto 0);
    signal reset: std_logic;
    signal NC_DR_in,NC_RE_in,NC_EM_in,NC_EM_in1,NC_EM_in2,NC_DR,NC_RE,NC_EM,NC_MW: std_logic;
    signal stall,stall_E,stall_M,stall_W,stall_dh,Ctrl_forwarding_V: std_logic;
    signal data_forward1,data_forward2,data_forward3,MLoop1,MLoop2: std_logic;
begin
    NC_EM_in <= NC_EM_in1 or NC_EM_in2;
    NC_RE_in <= NC_RE_in1 or NC_RE_in2;
    
    x <= M5 or clk;
    reset <= not rst;
    dp: Datapath_RISC port map
        (M2=>M2,M10=>M10,M13=>M13,M14=>M14,M15=>M15,M18=>M18,M19=>M19,M21=>M21,M23=>M23,M24=>M24,
        PC_FD_En=>PC_FD_En,T3_FD_En=>T3_FD_En,T3_DR_En=>T3_DR_En,PC_DR_En=>PC_DR_En,
        IR_DR_En=>IR_DR_En,Z1_En=>Z1_En,T1_RE_En=>T1_RE_En,T2_RE_En=>T2_RE_En,T3_RE_En=>T3_RE_En,
        T4_RE_En=>T4_RE_En,IR_RE_En=>IR_RE_En,PC_RE_En=>PC_RE_En,PC_RE2_En=>PC_RE2_En,
        T2_EM_En=>T2_EM_En,T3_EM_En=>T3_EM_En,T4_EM_En=>T4_EM_En,PC_EM_En=>PC_EM_En,
        IR_EM_En=>IR_EM_En,PC_EM2_En=>PC_EM2_En,C_En=>C_En,Z_En=>Z_En,T3_MW_En=>T3_MW_En,
        T4_MW_En=>T4_MW_En,T2_MW_En=>T2_MW_En,PC_MW_En=>PC_MW_En,IR_MW_En=>IR_MW_En,
        PC_MW2_En=>PC_MW2_En,RegWr=>RegWr,PCWr=>PCWr,Alu_op=>Alu_op,MemWr=>MemWr,
        M3=>M3,M4=>M4,M5=>M5,M6=>M6,M7=>M7,M8=>M8,M9=>M9,M16=>M16,M17=>M17,M20=>M20,M22=>M22,
        C=>C,ZEff=>ZEff,PE1_V=>PE1_V,PE2_V=>PE2_V,Z1=>Z1,NC_RE_En=>NC_RE_En,PE2_A_out=>PE2_A,
        NC_DR_in=>NC_DR_in,NC_RE_in=>NC_RE_in,NC_EM_in=>NC_EM_in,NC_DR=>NC_DR,
        NC_RE=>NC_RE,NC_EM=>NC_EM,NC_MW=>NC_MW,MLoop1=>MLoop1,MLoop2=>MLoop2,
        IR_DR=>IR_DR,IR_RE=>IR_RE,IR_EM=>IR_EM,IR_MW=>IR_MW,PC_RE=>PC_RE,PC_EM=>PC_EM,T1_RE=>T1_RE,
        T4_RE=>T4_RE,memDout=>memDout,aluOut=>aluOut,r7=>r7,clk=>clk,reset=>reset);
        
    --Stall
    stall <= stall_dh or stall_E or stall_M or stall_W;
    
    f: fetch port map
        (stall=>stall,Ctrl_forwarding_V=>Ctrl_forwarding_V,clk=>clk,reset=>reset,M2=>M2,
        T3_FD_En=>T3_FD_En,PC_FD_En=>PC_FD_En);
        
    d: decode port map
        (stall=>stall,clk=>clk,reset=>reset,T3_DR_En=>T3_DR_En,PC_DR_En=>PC_DR_En,
        IR_DR_En=>IR_DR_En);
        
    r: regRead port map
        (stall=>stall,data_forward1=>data_forward1,data_forward2=>data_forward2,NC_DR=>NC_DR,
        IR_DR=>IR_DR,clk=>clk,reset=>reset,M3=>M3,M4=>M4,M5=>M5,M19=>M19,Z1_En=>Z1_En,
        T1_RE_En=>T1_RE_En,T2_RE_En=>T2_RE_En,T3_RE_En=>T3_RE_En,T4_RE_En=>T4_RE_En,
        IR_RE_En=>IR_RE_En,PC_RE_En=>PC_RE_En,PC_RE2_En=>PC_RE2_En);
        
    e: execute port map
        (IR_RE=>IR_RE,clk=>clk,reset=>reset,M6=>M6,M7=>M7,M8=>M8,M10=>M10,NC_RE_in=>NC_RE_in2,
        stall_E=>stall_E,NC_EM_in=>NC_EM_in2,T2_EM_En=>T2_EM_En,T3_EM_En=>T3_EM_En,M24=>M24,
        data_forward3=>data_forward3,T4_EM_En=>T4_EM_En,PC_EM_En=>PC_EM_En,IR_EM_En=>IR_EM_En,
        PC_EM2_En=>PC_EM2_En,C_En=>C_En,NC_RE_En=>NC_RE_En,Alu_op=>Alu_op,NC_RE=>NC_RE,
        PE2_V=>PE2_V,PE2_A=>PE2_A,C=>C,Zeff=>ZEff);
        
    m: memAccess port map
        (IR_EM=>IR_EM,clk=>clk,reset=>reset,M9=>M9,M13=>M13,M14=>M14,M15=>M15,
        stall_M=>stall_M,MLoop1=>MLoop1,Z_En=>Z_En,Mem_Wr=>MemWr,T3_MW_En=>T3_MW_En,
        T4_MW_En=>T4_MW_En,T2_MW_En=>T2_MW_En,PC_MW_En=>PC_MW_En,IR_MW_En=>IR_MW_En,
        PC_MW2_En=>PC_MW2_En,NC_EM=>NC_EM,PE1_V=>PE1_V,PE2_V=>PE2_V);
        
    w: regWrite port map
        (IR_MW=>IR_MW,clk=>clk,reset=>reset,M16=>M16,M17=>M17,M18=>M18,PE1_V=>PE1_V,NC_MW=>NC_MW,
        stall_W=>stall_W,MLoop2=>MLoop2,Reg_Wr=>RegWr,PC_Wr=>PCWr);
        
    ch: controlHazard port map
        (PC_RE=>PC_RE,PC_EM=>PC_EM,IR_RE=>IR_RE,IR_EM=>IR_EM,T4_RE=>T4_RE,T1_RE=>T1_RE,
        IR_MW=>IR_MW,NC_MW=>NC_MW,
        memDout=>memDout,aluOut=>aluOut,RF_pco=>r7,C=>C,Z=>ZEff,Z1=>Z1,NC_RE_out=>NC_RE,
        NC_EM_out=>NC_EM,stall=>stall,Ctrl_forwarding_V=>Ctrl_forwarding_V,NC_EM_in=>NC_EM_in1,
        NC_DR_in=>NC_DR_in,NC_RE_in=>NC_RE_in1,M21=>M21,clk=>clk,reset=>reset);
        
    dh: Data_Hazard_Detector port map
        (IR=>IR_DR,IR_OLD1=>IR_RE,IR_OLD2=>IR_EM,IR_OLD3=>IR_MW,hazard3=>M23,
        NC_DR=>NC_DR,NC_RE_out=>NC_RE,NC_EM=>NC_EM,NC_MW=>NC_MW,hazard1=>M20,hazard2=>M22,
        stall=>stall_dh,clk=>clk,forwarding1=>data_forward1,forwarding2=>data_forward2,
        forwarding3=>data_forward3,C=>C,Zeff=>ZEff,PE2_A=>PE2_A);
    
end Struct;