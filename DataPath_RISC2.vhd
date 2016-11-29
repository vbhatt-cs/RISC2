library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.datapathComponents.all;

entity Datapath_RISC is
	port (
        M2,M10,M13,M14,M15,M18,M19,MLoop1,MLoop2,M5,M9,
        PC_FD_En,T3_FD_En,T3_DR_En,PC_DR_En,IR_DR_En,Z1_En,T1_RE_En,T2_RE_En,T3_RE_En,T4_RE_En,IR_RE_En,PC_RE_En,PC_RE2_En,
        T2_EM_En,T3_EM_En,T4_EM_En,PC_EM_En,IR_EM_En,PC_EM2_En,C_En,Z_En,T3_MW_En,T4_MW_En,T2_MW_En,
        PC_MW_En,IR_MW_En,PC_MW2_En,RegWr,PCWr,Alu_op,MemWr,NC_RE_En: in std_logic;
        M3,M4,M6,M7,M8,M16,M17: in std_logic_vector(1 downto 0);
        M21,M20,M22: in std_logic_vector(2 downto 0);
        C,ZEff,PE1_V,PE2_V,Z1: out std_logic;
        NC_DR_in,NC_RE_in,NC_EM_in: in std_logic;
        NC_DR,NC_RE,NC_EM,NC_MW: out std_logic;
        IR_DR,IR_RE,IR_EM,IR_MW,PC_RE,PC_EM,T1_RE,T4_RE,memDout,aluOut,r7: out std_logic_vector(15 downto 0);
        clk,reset: in std_logic);
end entity;

architecture Build of DataPath_RISC is
    signal RF_pci,RF_pco,RF_D1,RF_D2,RF_D3,RF_D4,PE1_in,PE1_D,PE2_in,PE2_D,
        T1_RE_in,T1_RE_out,T2_RE_in,T2_RE_out,T2_EM_in,T2_EM_out,T2_MW_in,T2_MW_out,
	    T3_RE_in,T3_RE_out,T3_EM_in,T3_EM_out,T3_MW_in,T3_MW_out,T3_FD_in,T3_FD_out,
        T3_DR_in,T3_DR_out,T4_RE_in,T4_RE_out,T4_EM_in,T4_EM_out,T4_MW_in,T4_MW_out,
	    PC_FD_in,PC_FD_out,PC_DR_in,PC_DR_out,PC_RE_in,PC_RE_out,PC_EM_in,PC_EM_out,
        PC_MW_in,PC_MW_out,PC_EM2_in,PC_EM2_out,PC_MW2_in,PC_MW2_out,
	    Data_Mem_A,Data_Mem_Din,Data_Mem_dout,Instr_Mem_A,Instr_Mem_out,
	    pc_alu1,pc_alu_out,op_alu1,op_alu2,op_alu_out,op2_alu1,op2_alu_out,
	    Comp1_D1,Comp1_D2,Comp2_D1,SE_out,USE_out,forward1,forward2,ctrl_for,
        IR_FD_in,IR_FD_out,IR_DR_in,IR_RE_in,IR_EM_in,IR_MW_in,IR_DR_out,IR_RE_out,
        IR_EM_out,IR_MW_out: std_logic_vector(15 downto 0);
    signal PE1_A,PE2_A,RF_A1,RF_A2,RF_A3,RF_A4: std_logic_vector(2 downto 0);
    signal PE1_valid,PE2_valid,Comp1_out,Comp2_out,Alu_C,Z,
        NC_DR_out,NC_RE_out,NC_EM_out,NC_MW_out,NC_DR_in1,NC_RE_in1,NC_EM_in1,NC_MW_in1,
        IR_RE_En1,PC_RE_En1,T2_RE_En1,T3_RE_En1,T4_RE_En1,NC_MW_En,NC_RE_En1,
        IR_EM_En1,PC_EM_En1,T2_EM_En1,T3_EM_En1,T4_EM_En1,NC_EM_En: std_logic;
    constant one: std_logic_vector(15 downto 0) := "0000000000000001";
    constant zero: std_logic_vector(15 downto 0) := "0000000000000000";

begin
    --No change  
    NC_DR_in1 <= NC_DR_in;
    ncdr: flipFlop port map
        (Din => NC_DR_in1, Dout => NC_DR_out, enable => IR_DR_En, clk => clk, reset => reset);
    NC_DR <= NC_DR_out;
        
    NC_RE_in1 <= (NC_RE_in or NC_DR_out) when (MLoop1='0') else
                    NC_EM_out;
    NC_RE_En1 <= NC_RE_En or IR_RE_En or MLoop1;
    ncre: flipFlop port map
        (Din => NC_RE_in1, Dout => NC_RE_out, enable => NC_RE_En1, clk => clk, reset => reset);
    NC_RE <= NC_RE_out;
        
    NC_EM_in1 <= (NC_EM_in or NC_RE_out or MLoop1) when (MLoop2='0') else
                    NC_MW_out;
    NC_EM_En <= IR_EM_En or MLoop2;
    ncem: flipFlop port map
        (Din => NC_EM_in1, Dout => NC_EM_out, enable => NC_EM_En, clk => clk, reset => reset);
    NC_EM <= NC_EM_out;  
        
    NC_MW_in1 <= NC_EM_out or MLoop2;
    NC_MW_En <= IR_MW_En or MLoop2;
    ncmw: flipFlop port map
        (Din => NC_MW_in1, Dout => NC_MW_out, enable => NC_MW_En, clk => clk, reset => reset);
    NC_MW <= NC_MW_out;
        
    --Priority Encoder1  -- Doubt
    PE1_in <= T4_EM_out;
    pr1_enc: PE
    	port map(inp=>PE1_in,v=>PE1_valid,a=>PE1_A,d=>PE1_D);
    PE1_V <= PE1_valid;

    --Priority Encoder2  -- Doubt
    PE2_in <= T4_RE_out;
    pr2_enc: PE
    	port map(inp=>PE2_in,v=>PE2_valid,a=>PE2_A,d=>PE2_D);
    PE2_V <= PE2_valid;
	
    --PC_FD         PC_FD_in <= pc_alu_out when (M1='0') else BHT_BrOut;
    PC_FD_in <= pc_alu_out;	
    pc_fd: dataRegister generic map (data_width => 16)
        port map (Din => PC_FD_in, Dout => PC_FD_out, enable => PC_FD_En, clk => clk, reset => reset);
	
    --T3_FD
    T3_FD_in <= PC_FD_out when (M2='0') else Ctrl_for;
    t3_fd: dataRegister generic map (data_width => 16)
        port map (Din => T3_FD_in, Dout => T3_FD_out, enable => T3_FD_En, clk => clk, reset => reset);

    --PC Incrementer
    pc_alu1 <= PC_FD_out when (M2='0') else Ctrl_for;
    incrementer1: ALU
    	 port map (IP1=>pc_alu1,IP2=>one,OP=>pc_alu_out,aluOP=>'0');

    --Instruction Memory
    Instr_Mem_A <= PC_FD_out when (M2='0') else Ctrl_for;
    instr_mem: instrMemory
    		port map(A=>Instr_Mem_A, Dout=>Instr_Mem_out, clk=>clk); 
    
    --IR_FD
    IR_FD_in <= Instr_Mem_out;	
    ir_fd: dataRegister generic map (data_width => 16)
        port map (Din => IR_FD_in, Dout => IR_FD_out, enable => PC_FD_En, clk => clk, reset => reset);

    --T3_DR
    T3_DR_in <= T3_FD_out;
    t3_dr: dataRegister generic map (data_width => 16)
        port map (Din => T3_DR_in, Dout => T3_DR_out, enable => T3_DR_En, clk => clk, reset => reset);

    --PC_DR
    PC_DR_in <= PC_FD_out;
    pc_dr: dataRegister generic map (data_width => 16)
        port map (Din => PC_DR_in, Dout => PC_DR_out, enable => PC_DR_En, clk => clk, reset => reset);

    --IR_DR
    IR_DR_in <= IR_FD_out;
    irdr: dataRegister generic map (data_width => 16)
        port map (Din => IR_DR_in, Dout => IR_DR_out, enable => IR_DR_En, clk => clk, reset => reset);
    IR_DR <= IR_DR_out;

    --Register File
    RF_pci <= PC_MW2_out when (M18 = '1') else PC_MW_out;
    RF_A1 <= IR_DR_out(8 downto 6);
    RF_A2 <= IR_DR_out(11 downto 9);
    RF_A3 <= IR_MW_out(11 downto 9) when (M16="00") else 
    		IR_MW_out(5 downto 3) when (M16="01") else
    		PE1_A when (M16="11") else
    		IR_MW_out(8 downto 6);
    RF_D3 <= PC_MW_out when (M17="10") else 
    		T3_MW_out when (M17="00") else
    		T4_MW_out;
    RF_A4 <= PE2_A;
    rf: regFile 
        port map(a1 => RF_A1, a2 => RF_A2, a3 => RF_A3, a4 => RF_A4, 
                d3 => RF_D3, pci => RF_pci,
                d1 => RF_D1, d2 => RF_D2, d4 => RF_D4, pco => RF_pco,
                regWr => RegWr, pcWr => PCWr, clk => clk, reset => reset);	
    r7 <= RF_pco;

    --T1_RE
    T1_RE_in <= RF_D1 when (M3="00") else
		forward1 when (M3="01") else PC_RE_out;
    t1re: dataRegister generic map (data_width => 16)
        port map (Din => T1_RE_in, Dout => T1_RE_out, enable => T1_RE_En, clk => clk, reset => reset);
    T1_RE <= T1_RE_out;

    --T2_RE
    T2_RE_in <= op2_alu_out when (MLoop1='1') else
        RF_D2 when (M4="00") else
		forward2 when (M4="01") else 
        PC_RE_out when (M4="10");
    T2_RE_En1 <= T2_RE_En or MLoop1;
    t2_re: dataRegister generic map (data_width => 16)
        port map (Din => T2_RE_in, Dout => T2_RE_out, enable => T2_RE_En1, clk => clk, reset => reset);

    --Comparator1
    Comp1_D1 <= RF_D1 when (M3="00") else
		forward1 when (M3="01") else PC_RE_out;
    Comp1_D2 <= RF_D2 when (M4="00") else
		forward2 when (M4="01") else PC_RE_out;
    comp1: Comparator
        port map (Comp_D1 => Comp1_D1, Comp_D2 => Comp1_D2, Comp_out => Comp1_out);

    --Z1
    Z1Reg: flipflop
	port map (Din => Comp1_out, Dout => Z1, enable => Z1_En,clk => clk, reset => reset);

    --IR_RE
    IR_RE_in <= IR_EM_out when (MLoop1='1') else
        IR_DR_out;
    IR_RE_En1 <= IR_RE_En or MLoop1;
    irre: dataRegister generic map (data_width => 16)
        port map (Din => IR_RE_in, Dout => IR_RE_out, enable => IR_RE_En1, clk => clk, reset => reset);
    IR_RE <= IR_RE_out;

    --T3_RE
    T3_RE_in <= T3_EM_out when (MLoop1='1') else
        T3_DR_out;
    T3_RE_En1 <= T3_RE_En or MLoop1;
    t3_re: dataRegister generic map (data_width => 16)
        port map (Din => T3_RE_in, Dout => T3_RE_out, enable => T3_RE_En1, clk => clk, reset => reset);

    --PC_RE
    PC_RE_in <= PC_EM_out when (MLoop1='1') else
        PC_DR_out;
    PC_RE_En1 <= PC_RE_En or MLoop1;
    pcre: dataRegister generic map (data_width => 16)
        port map (Din => PC_RE_in, Dout => PC_RE_out, enable => PC_RE_En1, clk => clk, reset => reset);
    PC_RE <= PC_RE_out;
    
    --Sign Extenders	
    SE_out <= std_logic_vector(resize(signed(IR_DR_out(5 downto 0)),16)) when (M19='0') else
    			std_logic_vector(resize(signed(IR_DR_out(8 downto 0)),16)); 	
    USE_out <= IR_DR_out(8 downto 0)&"0000000"; 

    --T4_RE
    T4_RE_in <= PE2_D when (MLoop1='1') else
        USE_out when (M5='0') else
		SE_out;
    T4_RE_En1 <= T4_RE_En or MLoop1;
    t4re: dataRegister generic map (data_width => 16)
        port map (Din => T4_RE_in, Dout => T4_RE_out, enable => T4_RE_En1, clk => clk, reset => reset);
    T4_RE <= T4_RE_out;

    --T4_EM
    T4_EM_in <= T4_RE_out when (MLoop2='0') else PE1_D;
    T4_EM_En1 <= T4_EM_En or MLoop2;
    t4_em: dataRegister generic map (data_width => 16)
        port map (Din => T4_EM_in, Dout => T4_EM_out, enable => T4_EM_En1, clk => clk, reset => reset);


	--Andasu	
    --T2_EM
    T2_EM_in <= T2_MW_out when (MLoop2='1') else
        T2_RE_out;
    T2_EM_En1 <= T2_EM_En or MLoop2;
    t2_em: dataRegister generic map (data_width => 16)
        port map (Din => T2_EM_in, Dout => T2_EM_out, enable => T2_EM_En1, clk => clk, reset => reset);

    --Data Memory
    Data_Mem_A <= T2_EM_out when (M9 ='1') else	T3_EM_out;
    Data_Mem_din <= T3_EM_out when (M13='0') else T2_EM_out;
    data_mem: dataMemory
    	port map (A=>Data_Mem_A, Din=>Data_Mem_din, Dout=>Data_Mem_dout, memWR=>MemWr, clk=>clk);
    memDout <= data_Mem_dout; 
    
    --T3_EM
    T3_EM_in <= T3_MW_out when (MLoop2='1') else
        OP_ALU_OUT when (M8="00") else 
        T1_RE_out when (M8="01") else RF_D4;
    T3_EM_En1 <= T3_EM_En or MLoop2;
    t3_em : dataRegister generic map (data_width => 16)
	 port map (Din => T3_EM_in, Dout => T3_EM_out, enable => T3_EM_En1,clk => clk, reset => reset);  
	 
    --PC_EM2
    PC_EM2_in <= OP_ALU_OUT when (M10='1') else 
    		T1_RE_out;
			pc_em2 : dataRegister generic map (data_width => 16)
			port map (Din => PC_EM2_in, Dout => PC_EM2_out, enable => PC_EM2_En,clk => clk, reset => reset); 
	    
    --op_alu
    op_alu1 <= T1_RE_out when (M6="00") else 
    		T2_RE_out when (M6="01") else T4_RE_out;
    op_alu2 <= T2_RE_out when (M7="00") else 
		T4_RE_out when (M7="01") else T3_RE_out;
    op_alu: ALU
    	 port map (IP1=>op_alu1,IP2=>op_alu2,OP=>op_alu_out,aluOP=>Alu_op,C=>Alu_C);
    aluOut <= op_alu_out;
		  
    --op2_alu
    op2_alu : alu
	 port map (IP1=>T2_EM_out,IP2=>one,OP=>op2_alu_out,aluOP=> '0');
				  
	--Comparator2
    Comp2_D1 <= T3_EM_out when (M14='0') else Data_mem_dout;			
    comp2: Comparator
        port map (Comp_D1 => Comp2_D1, Comp_D2 => zero, Comp_out => Comp2_out);

    ZReg: flipFlop
         port map (Din => Comp2_out, Dout => Z, enable => Z_En,clk => clk, reset => reset);
    ZEff <= comp2_out when (Z_En='1') else Z;   

    CReg: flipFlop
         port map (Din => Alu_C, Dout => C, enable => C_En,clk => clk, reset => reset);

	 --T2_MW
    T2_MW_in <= op2_alu_out;
    t2_mw: dataRegister generic map (data_width => 16)
        port map (Din => T2_MW_in, Dout => T2_MW_out, enable => T2_MW_En, clk => clk, reset => reset);
    
	 --T3_MW
    T3_MW_in <= T3_EM_out when (M15='0') else Data_mem_dout;
    t3_mw: dataRegister generic map (data_width => 16)
        port map (Din => T3_MW_in, Dout => T3_MW_out, enable => T3_MW_En, clk => clk, reset => reset);	

	--IR_EM
    IR_EM_in <= IR_MW_out when (MLoop2='1') else
        IR_RE_out;
    IR_EM_En1 <= IR_EM_En or MLoop2;
    irem: dataRegister generic map (data_width => 16)
        port map (Din => IR_EM_in, Dout => IR_EM_out, enable => IR_EM_En1, clk => clk, reset => reset);
    IR_EM <= IR_EM_out;
			
	--PC_EM
    PC_EM_in <= PC_MW_out when (MLoop2='1') else
        PC_RE_out;
    PC_EM_En1 <= PC_EM_En or MLoop2;
    pcem: dataRegister generic map (data_width => 16)
        port map (Din => PC_EM_in, Dout => PC_EM_out, enable => PC_EM_En1, clk => clk, reset => reset);
    PC_EM <= PC_EM_out;   
	
	--IR_MW
    IR_MW_in <= IR_EM_out;
    irmw: dataRegister generic map (data_width => 16)
        port map (Din => IR_MW_in, Dout => IR_MW_out, enable => IR_MW_En, clk => clk, reset => reset);
    IR_MW <= IR_MW_out;
			
	--PC_MW
    PC_MW_in <= PC_EM_out;
    pc_mw: dataRegister generic map (data_width => 16)
        port map (Din => PC_MW_in, Dout => PC_MW_out, enable => PC_MW_En, clk => clk, reset => reset);
	
	--PC_MW2
    PC_MW2_in <= PC_EM2_out;
    pc_mw2: dataRegister generic map (data_width => 16)
        port map (Din => PC_MW2_in, Dout => PC_MW2_out, enable => PC_MW2_En, clk => clk, reset => reset);
	
	--T4_MW
    T4_MW_in <= T4_EM_out;
    t4_mW: dataRegister generic map (data_width => 16)
        port map (Din => T4_MW_in, Dout => T4_MW_out, enable => T4_MW_En, clk => clk, reset => reset);

	--Forwarding data
    forward1 <= op_alu_out when (M20 ="000") else
		Data_Mem_dout when (M20 ="010") else 
        RF_D3 when (M20="100") else
        T4_RE_out when (M20="001") else
        T4_EM_out when (M20="011") else
        T4_MW_out;
        
    forward2 <= op_alu_out when (M22 ="000") else
		Data_Mem_dout when (M22 ="010") else 
        RF_D3 when (M22="100") else
        T4_RE_out when (M22="001") else
        T4_EM_out when (M22="011") else
        T4_MW_out;

	--control forwarding data
    ctrl_for <= op_alu_out when (M21 = "000") else 
        Data_Mem_dout when (M21 = "001") else
        T4_RE_out when (M21 = "010") else
        T1_RE_out when (M21 = "011") else RF_pco;
end Build;
