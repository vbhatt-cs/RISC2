	library ieee;
	use ieee.std_logic_1164.all;
	
	entity Data_Hazard_Detector is
		port
		(IR :in std_logic_vector(15 downto 0);
		 IR_OLD1 :in std_logic_vector(15 downto 0);
		 IR_OLD2 :in std_logic_vector(15 downto 0);
		 IR_OLD3 :in std_logic_vector(15 downto 0);
		 NC_DR,NC_RE_out,NC_EM,NC_MW,C,Zeff: in std_logic;
		 hazard1,hazard2 : out std_logic_vector(2 downto 0);
		 stall : out std_logic;
		 clk: in std_logic;
		 forwarding1,forwarding2: out std_logic
		);
	
	end entity;
	
	architecture behavioural of Data_Hazard_Detector is 
        signal re_stall : std_logic_vector(1 downto 0);
        signal NC_RE: std_logic;
	begin
        process(C,Zeff,IR)
            variable NC_RE_var: std_logic;
        begin
            NC_RE_var := '0';
            if(NC_RE_out = '0') then
                if((IR(15 downto 12) = "0000" or IR(15 downto 12) = "0010")) then --AD*,ND*
                    if(IR(1 downto 0) = "10" and C='0') then
                            NC_RE_var := '1';
                    elsif(IR(1 downto 0) = "01" and Zeff='0') then
                            NC_RE_var := '1';
                    end if;
                end if;
            end if;
            NC_RE <= NC_RE_var or NC_RE_out;
        end process;
	
        process(IR,IR_OLD1,IR_OLD2,IR_OLD3,clk,re_stall)
            variable hazard1_var,hazard2_var: std_logic_vector(2 downto 0);
            variable re_stall_var : std_logic_vector(1 downto 0);
            variable stall_var : std_logic := '0';
            variable forwarding2_var,forwarding1_var : std_logic := '0';
        begin
            hazard1_var := "000";
            hazard2_var := "000";
            stall_var := '0';
            forwarding2_var := '0';
            forwarding1_var := '0';
            re_stall_var := "00";
            
            if(NC_DR='0') then
                ----CASE1 (Alu type)
                if(IR(15 downto 12)="0010" or IR(15 downto 12)="0000") then
                    if(IR_OLD1(15 downto 12)="0000" or IR_OLD1(15 downto 12)="0010") then
                        if(IR_OLD1(5 downto 3)=IR(11 downto 9) and NC_RE='0') then
                            hazard2_var :="000";
                            stall_var:='0';
                            forwarding2_var := '1';
                        end if;
                        
                        if(IR_OLD1(5 downto 3)=IR(8 downto 6) and NC_RE='0') then
                            hazard1_var :="000";
                            stall_var:='0'; 
                            forwarding1_var := '1';
                        end if;
                    end if;
                    
                    if(IR_OLD2(15 downto 12)="0000" or IR_OLD2(15 downto 12)="0010") then
                        if(IR_OLD2(5 downto 3)=IR(11 downto 9) and NC_EM='0') then
                            hazard2_var :="010";
                            stall_var:='0';
                            forwarding2_var := '1';
                        end if;
                        
                        if(IR_OLD2(5 downto 3)=IR(8 downto 6) and NC_EM='0') then
                            hazard1_var :="010";
                            stall_var:='0';
                            forwarding1_var := '1';
                        end if;
                    end if;
                    
                    if(IR_OLD3(15 downto 12)="0000" or IR_OLD3(15 downto 12)="0010") then
                        if(IR_OLD3(5 downto 3)=IR(11 downto 9) and NC_MW='0') then
                            hazard2_var := "100";
                            stall_var := '0';
                            forwarding2_var := '1';
                        end if;
                        
                        if(IR_OLD3(5 downto 3)=IR(8 downto 6) and NC_MW='0') then
                            hazard1_var :="100";
                            stall_var:='0';
                            forwarding1_var := '1';
                        end if;
                    end if;
            
                    --LHI
                    if(IR_OLD1(15 downto 12)="0011" or IR_OLD2(15 downto 12)="0011" or IR_OLD3(15 downto 12)="0011") then
                        if(IR_OLD1(11 downto 9)=IR(11 downto 9) and NC_RE='0') then
                            hazard2_var :="001";
                            stall_var:='0'; 
                            forwarding2_var := '1';
                        elsif(IR_OLD2(11 downto 9)=IR(11 downto 9) and NC_EM='0') then
                            hazard2_var :="011";
                            stall_var:='0'; 
                            forwarding2_var := '1';
                        elsif(IR_OLD3(11 downto 9)=IR(11 downto 9) and NC_MW='0') then
                            hazard2_var :="101";
                            stall_var:='0'; 
                            forwarding2_var := '1';
                        end if;
                        
                        if(IR_OLD1(11 downto 9)=IR(8 downto 6) and NC_RE='0') then
                            hazard1_var :="001";
                            stall_var:='0'; 
                            forwarding1_var := '1';
                        elsif(IR_OLD2(11 downto 9)=IR(8 downto 6) and NC_EM='0') then
                            hazard1_var :="011";
                            stall_var:='0';
                            forwarding1_var := '1';	
                        elsif(IR_OLD3(11 downto 9)=IR(8 downto 6) and NC_MW='0') then
                            hazard1_var :="101";
                            stall_var:='0'; 
                            forwarding1_var := '1';
                        end if; 
                    end if;
        
                    --lW,JAL,JLR 
                    if(IR_OLD1(15 downto 12)="0100" or IR_OLD2(15 downto 12)="0100" or IR_OLD3(15 downto 12)="0100" or
                    IR_OLD1(15 downto 13)="100" or IR_OLD2(15 downto 13)="100" or IR_OLD3(15 downto 13)="100") then
                        if(IR_OLD1(11 downto 9)=IR(11 downto 9) and NC_RE='0') then
                            if(re_stall = "00") then
                                stall_var:='1';
                                re_stall_var := "01";
                            else
                                re_stall_var := "00";
                                hazard2_var :="010";
                                forwarding2_var := '1';
                            end if;  
                        elsif(IR_OLD2(11 downto 9)=IR(11 downto 9) and NC_EM='0') then
                            hazard2_var :="010";
                            stall_var:='0'; 
                            forwarding2_var := '1';
                        elsif(IR_OLD3(11 downto 9)=IR(11 downto 9) and NC_MW='0') then
                            hazard2_var :="100";
                            stall_var:='0'; 
                            forwarding2_var := '1';
                        end if;
                        
                        if(IR_OLD1(11 downto 9)=IR(8 downto 6) and NC_RE='0') then
                            if(re_stall = "00") then
                                stall_var:='1';
                                re_stall_var := "01";
                            else
                                re_stall_var := "00";
                                hazard1_var :="010";
                                forwarding1_var := '1';
                            end if; 
                        elsif(IR_OLD2(11 downto 9)=IR(8 downto 6) and NC_EM='0') then
                            hazard1_var :="010";
                            stall_var:='0';
                            forwarding1_var := '1';
                        elsif(IR_OLD3(11 downto 9)=IR(8 downto 6) and NC_MW='0') then
                            hazard1_var :="100";
                            stall_var:='0';
                            forwarding1_var := '1';	
                        end if;
                    end if;
        
                    --ADI
                    if(IR_OLD1(15 downto 12)="0001" or IR_OLD2(15 downto 12)="0001" or IR_OLD3(15 downto 12)="0001") then
                        if(IR_OLD1(8 downto 6)=IR(11 downto 9) and NC_RE='0') then
                            hazard2_var :="000";
                            stall_var:='0'; 
                            forwarding2_var := '1';
                        elsif(IR_OLD2(8 downto 6)=IR(11 downto 9) and NC_EM='0') then
                            hazard2_var :="010";
                            stall_var:='0';
                            forwarding2_var := '1';
                        elsif(IR_OLD3(8 downto 6)=IR(11 downto 9) and NC_MW='0') then
                            hazard2_var :="100";
                            stall_var:='0'; 
                            forwarding2_var := '1';
                        end if;
                        
                        if(IR_OLD1(8 downto 6)=IR(8 downto 6) and NC_RE='0') then
                            hazard1_var :="000";
                            stall_var:='0'; 
                            forwarding1_var := '1';
                        elsif(IR_OLD2(8 downto 6)=IR(8 downto 6) and NC_EM='0') then
                            hazard1_var :="010";
                            stall_var:='0'; 
                            forwarding1_var := '1';
                        elsif(IR_OLD3(8 downto 6)=IR(8 downto 6) and NC_MW='0') then
                            hazard1_var :="100";
                            stall_var:='0'; 
                            forwarding1_var := '1';
                        end if;
                    end if;
                end if;
        
                ----CASE2 (ADI or LM)
                if(IR(15 downto 12)="0001" or IR(15 downto 12)="0110") then
                    if (IR_OLD1(15 downto 12)="0000" or IR_OLD1(15 downto 12)="0010" or IR_OLD2(15 downto 12)="0000" or IR_OLD2(15 
                    downto 12)="0010" or IR_OLD3(15 downto 12)="0000" or IR_OLD3(15 downto 12)="0010") then 
                        if (IR_OLD1(5 downto 3)=IR(11 downto 9) and NC_RE='0') then
                            hazard2_var :="000";
                            forwarding2_var := '1';
                        elsif (IR_OLD2(5 downto 3)=IR(11 downto 9) and NC_EM='0') then
                            hazard2_var :="010";
                            forwarding2_var := '1';
                        elsif (IR_OLD3(5 downto 3)=IR(11 downto 9) and NC_MW='0') then
                            hazard2_var :="100";	
                            forwarding2_var := '1';
                        end if;
                    end if;
        
                    if (IR_OLD1(15 downto 12)="0011" or IR_OLD2(15 downto 12)="0011" or IR_OLD3(15 downto 12)="0011") then
                        if (IR_OLD1(11 downto 9)=IR(11 downto 9) and NC_RE='0') then
                            hazard2_var :="001";
                            forwarding2_var := '1';
                        elsif (IR_OLD2(11 downto 9)=IR(11 downto 9) and NC_EM='0') then
                            hazard2_var :="011";
                            forwarding2_var := '1';
                        elsif (IR_OLD3(11 downto 9)=IR(11 downto 9) and NC_MW='0') then
                            hazard2_var :="101";
                            forwarding2_var := '1';
                        end if;
                    end if; 
        
                    if(IR_OLD1(15 downto 12)="0100" or IR_OLD2(15 downto 12)="0100" or IR_OLD3(15 downto 12)="0100" or
                    IR_OLD1(15 downto 13)="100" or IR_OLD2(15 downto 13)="100" or IR_OLD3(15 downto 13)="100") then
                        if (IR_OLD1 (11 downto 9)=IR(11 downto 9) and NC_RE='0') then 
                            if(re_stall = "00") then
                                stall_var:='1';
                                re_stall_var := "01";
                            else    
                                hazard2_var :="010";
                                re_stall_var:= "00";
                                forwarding2_var := '1';
                            end if;
                        elsif (IR_OLD2(11 downto 9)=IR(11 downto 9) and NC_EM='0') then 
                            hazard2_var := "010";
                            forwarding2_var := '1';
                        elsif (IR_OLD3(11 downto 9)=IR(11 downto 9) and NC_MW='0') then 
                            hazard2_var := "100";	
                            forwarding2_var := '1';
                        end if;
                    end if;
        
                    if (IR_OLD1(15 downto 12)="0001" or IR_OLD2(15 downto 12)="0001" or IR_OLD3(15 downto 12)="0001") then
                        if (IR_OLD1(8 downto 6)=IR(11 downto 9) and NC_RE='0') then
                            hazard2_var :="000";
                            forwarding2_var := '1';
                        elsif (IR_OLD2(8 downto 6)=IR(11 downto 9) and NC_EM='0') then
                            hazard2_var :="010";
                            forwarding2_var := '1';
                        elsif (IR_OLD3(8 downto 6)=IR(11 downto 9) and NC_MW='0') then
                            hazard2_var :="100";
                            forwarding2_var := '1';	
                        end if;
                    end if;    
                end if;

                ---CASE3 (LW,JLR)			
                if (IR(15 downto 12)="0100" or IR(15 downto 12)="1001") then
                    if (IR_OLD1(15 downto 12)="0000" or IR_OLD1(15 downto 12)="0010" or IR_OLD2(15 downto 12)="0000" or IR_OLD2(15 
                    downto 12)="0010" or IR_OLD3(15 downto 12)="0000" or IR_OLD3(15 downto 12)="0010") then 
                        if (IR_OLD1(5 downto 3)=IR(8 downto 6) and NC_RE='0') then
                            hazard1_var :="000";	
                            forwarding1_var := '1';
                        elsif (IR_OLD2(5 downto 3)=IR(8 downto 6) and NC_EM='0') then
                            hazard1_var :="010";
                            forwarding1_var := '1';
                        elsif (IR_OLD3(5 downto 3)=IR(8 downto 6) and NC_MW='0') then
                            hazard1_var :="100";
                            forwarding1_var := '1';	
                        end if;
                    end if;
        
                    if (IR_OLD1(15 downto 12)="0011" or IR_OLD2(15 downto 12)="0011" or IR_OLD3(15 downto 12)="0011") then
                        if (IR_OLD1(11 downto 9)=IR(8 downto 6) and NC_RE='0') then
                            hazard1_var :="001";
                            forwarding1_var := '1';
                        elsif (IR_OLD2(11 downto 9)=IR(8 downto 6) and NC_EM='0') then
                            hazard1_var :="011";
                            forwarding1_var := '1';
                        elsif (IR_OLD3(11 downto 9)=IR(8 downto 6) and NC_MW='0') then
                            hazard1_var :="101";
                            forwarding1_var := '1';	
                        end if;
                    end if; 
        
                    if(IR_OLD1(15 downto 12)="0100" or IR_OLD2(15 downto 12)="0100" or IR_OLD3(15 downto 12)="0100" or
                    IR_OLD1(15 downto 13)="100" or IR_OLD2(15 downto 13)="100" or IR_OLD3(15 downto 13)="100") then
                        if (IR_OLD1 (11 downto 9)=IR(8 downto 6) and NC_RE='0') then 
                            if(re_stall = "00") then
                                stall_var:='1';
                                re_stall_var := "01";
                            else    
                                hazard1_var :="010";
                                re_stall_var := "00";
                                forwarding1_var := '1';
                            end if;
                        elsif (IR_OLD2(11 downto 9)=IR(8 downto 6) and NC_EM='0') then 
                            hazard1_var := "010";
                            forwarding1_var := '1';
                        elsif (IR_OLD3(11 downto 9)=IR(8 downto 6) and NC_MW='0') then 
                            hazard1_var := "100";	
                            forwarding1_var := '1';
                            
                        end if;
                    end if;
        
                    if (IR_OLD1(15 downto 12)="0001" or IR_OLD2(15 downto 12)="0001" or IR_OLD3(15 downto 12)="0001") then
                        if (IR_OLD1(8 downto 6)=IR(8 downto 6) and NC_RE='0') then
                            hazard1_var :="000";
                            forwarding1_var := '1';
                        elsif (IR_OLD2(8 downto 6)=IR(8 downto 6) and NC_EM='0') then
                            hazard1_var :="010";
                            forwarding1_var := '1';
                        elsif (IR_OLD3(8 downto 6)=IR(8 downto 6) and NC_MW='0') then
                            hazard1_var :="100";
                            forwarding1_var := '1';	
                        end if;
                    end if;
                end if;
        
                ----CASE4 (SW,BEQ)
                if(IR(15 downto 12)="0101" or IR(15 downto 12)="1100" ) then
                    if (IR_OLD1(15 downto 12)="0000" or IR_OLD1(15 downto 12)="0010" or IR_OLD2(15 downto 12)="0000" or IR_OLD2(15 
                    downto 12)="0010" or IR_OLD3(15 downto 12)="0000" or IR_OLD3(15 downto 12)="0010") then 
                        if (IR_OLD1(5 downto 3)=IR(11 downto 9) and NC_RE='0') then
                            hazard2_var :="000";
                            forwarding2_var := '1';
                        elsif (IR_OLD2(5 downto 3)=IR(11 downto 9) and NC_EM='0') then
                            hazard2_var :="010";
                            forwarding2_var := '1';
                        elsif (IR_OLD3(5 downto 3)=IR(11 downto 9) and NC_MW='0') then
                            hazard2_var :="100";
                            forwarding2_var := '1';
                        end if;
                        
                        if (IR_OLD1(5 downto 3)=IR(8 downto 6) and NC_RE='0') then
                            hazard1_var :="000";
                            forwarding1_var := '1'; 
                        elsif (IR_OLD2(5 downto 3)=IR(8 downto 6) and NC_EM='0') then
                            hazard1_var :="010";
                            forwarding1_var := '1';
                        elsif (IR_OLD3(5 downto 3)=IR(8 downto 6) and NC_MW='0') then
                            hazard1_var :="100";
                            forwarding1_var := '1';
                        end if;
                    end if;
        
                    if (IR_OLD1(15 downto 12)="0011" or IR_OLD2(15 downto 12)="0011" or IR_OLD3(15 downto 12)="0011") then
                        if (IR_OLD1(5 downto 3)=IR(11 downto 9) and NC_RE='0') then
                            hazard2_var :="001";
                            forwarding2_var := '1';
                        elsif (IR_OLD2(5 downto 3)=IR(11 downto 9) and NC_EM='0') then
                            hazard2_var :="011";
                            forwarding2_var := '1';
                        elsif (IR_OLD3(5 downto 3)=IR(11 downto 9) and NC_MW='0') then
                            hazard2_var :="101";
                            forwarding2_var := '1';
                        end if;
                        
                        if (IR_OLD1(11 downto 9)=IR(8 downto 6) and NC_RE='0') then
                            hazard1_var :="001";
                            forwarding1_var := '1';
                        elsif (IR_OLD2(11 downto 9)=IR(8 downto 6) and NC_EM='0') then
                            hazard1_var :="011";
                            forwarding1_var := '1';
                        elsif (IR_OLD3(11 downto 9)=IR(8 downto 6) and NC_MW='0') then
                            hazard1_var :="101";
                            forwarding1_var := '1';
                        end if;
                    end if; 
        
                    if(IR_OLD1(15 downto 12)="0100" or IR_OLD2(15 downto 12)="0100" or IR_OLD3(15 downto 12)="0100" or
                    IR_OLD1(15 downto 13)="100" or IR_OLD2(15 downto 13)="100" or IR_OLD3(15 downto 13)="100") then
                        if (IR_OLD1 (11 downto 9)=IR(8 downto 6) and NC_RE='0') then 
                            if(re_stall = "00") then
                                stall_var:='1';
                                re_stall_var := "01";
                            else    
                                hazard1_var :="010";
                                re_stall_var := "00";
                                forwarding1_var := '1';
                            end if;
                        elsif (IR_OLD2(11 downto 9)=IR(8 downto 6) and NC_EM='0') then 
                            hazard1_var := "010";
                            forwarding1_var := '1';
                        elsif (IR_OLD3(11 downto 9)=IR(8 downto 6) and NC_MW='0') then 
                            hazard1_var := "100";
                            forwarding1_var := '1';
                        end if;
                        
                        if (IR_OLD1 (11 downto 9)=IR(11 downto 9) and NC_RE='0') then 
                            if(re_stall = "00") then
                                stall_var:='1';
                                re_stall_var := "01";
                            else    
                                hazard2_var :="010";
                                re_stall_var := "00";
                                forwarding2_var := '1';
                            end if;
                        elsif (IR_OLD2(11 downto 9)=IR(11 downto 9) and NC_EM='0') then 
                            hazard2_var := "010";
                            forwarding2_var := '1';
                        elsif (IR_OLD3(11 downto 9)=IR(11 downto 9) and NC_MW='0') then 
                            hazard2_var := "100";
                            forwarding2_var := '1';
                        end if;
                    end if;
        
                    if (IR_OLD1(15 downto 12)="0001" or IR_OLD2(15 downto 12)="0001" or IR_OLD3(15 downto 12)="0001") then
                        if (IR_OLD1(8 downto 6)=IR(8 downto 6) and NC_RE='0') then
                            hazard1_var :="000";
                            forwarding1_var := '1';
                        elsif (IR_OLD2(8 downto 6)=IR(8 downto 6) and NC_EM='0') then
                            hazard1_var :="010";
                            forwarding1_var := '1';
                        elsif (IR_OLD3(8 downto 6)=IR(8 downto 6) and NC_MW='0') then
                            hazard1_var :="100";	
                            forwarding1_var := '1';
                        end if;
                        
                        if (IR_OLD1(8 downto 6)=IR(11 downto 9) and NC_RE='0') then
                            hazard2_var :="000";
                            forwarding2_var := '1';
                        elsif (IR_OLD2(8 downto 6)=IR(11 downto 9) and NC_EM='0') then
                            hazard2_var :="010";
                            forwarding2_var := '1';
                        elsif (IR_OLD3(8 downto 6)=IR(11 downto 9) and NC_MW='0') then
                            hazard2_var :="100";	
                            forwarding2_var := '1';
                        end if;
                    end if;
                end if;
                
                -----CASE 5(SM)
                if(IR(15 downto 12)= "0111") then
                    if (IR_OLD1(15 downto 12)="0000" or IR_OLD1(15 downto 12)="0010" or IR_OLD2(15 downto 12)="0000" or IR_OLD2(15 
                    downto 12)="0010" or IR_OLD3(15 downto 12)="0000" or IR_OLD3(15 downto 12)="0010") then 
                        if (IR_OLD1(5 downto 3)=IR(11 downto 9) and NC_RE='0') then
                            hazard2_var :="000";
                            forwarding2_var := '1';
                        elsif (IR_OLD2(5 downto 3)=IR(11 downto 9) and NC_EM='0') then
                            hazard2_var :="010";
                            forwarding2_var := '1';
                        elsif (IR_OLD3(5 downto 3)=IR(11 downto 9) and NC_MW='0') then
                            hazard2_var :="100";
                            forwarding2_var := '1';	
                        end if;   
                    end if;
        
                    if (IR_OLD1(15 downto 12)="0011" or IR_OLD2(15 downto 12)="0011" or IR_OLD3(15 downto 12)="0011") then
                        if (IR_OLD1(11 downto 9)=IR(11 downto 9) and NC_RE='0') then
                            hazard2_var :="001";
                            forwarding2_var := '1';
                        elsif (IR_OLD2(11 downto 9)=IR(11 downto 9) and NC_EM='0') then
                            hazard2_var :="011";
                            forwarding2_var := '1';
                        elsif (IR_OLD3(11 downto 9)=IR(11 downto 9) and NC_MW='0') then
                            hazard2_var :="101";	
                            forwarding2_var := '1';
                        end if;
                    end if; 
        
                    if(IR_OLD1(15 downto 12)="0100" or IR_OLD2(15 downto 12)="0100" or IR_OLD3(15 downto 12)="0100" or
                    IR_OLD1(15 downto 13)="100" or IR_OLD2(15 downto 13)="100" or IR_OLD3(15 downto 13)="100") then
                        if (IR_OLD1 (11 downto 9)=IR(11 downto 9) and NC_RE='0') then 
                            if(re_stall = "00") then
                                stall_var:='1';
                                re_stall_var := "01";
                            else    
                                hazard2_var :="010";
                                re_stall_var := "00";
                                forwarding2_var := '1';
                            end if;
                        elsif (IR_OLD2(11 downto 9)=IR(11 downto 9) and NC_EM='0') then 
                            hazard2_var := "010";
                            forwarding2_var := '1';
                        elsif (IR_OLD3(11 downto 9)=IR(11 downto 9) and NC_MW='0') then 
                            hazard2_var := "100";	
                            forwarding2_var := '1';
                        end if;
                    end if;
        
                    if (IR_OLD1(15 downto 12)="0001" or IR_OLD2(15 downto 12)="0001" or IR_OLD3(15 downto 12)="0001") then
                        if (IR_OLD1(8 downto 6)=IR(11 downto 9) and NC_RE='0') then
                            hazard2_var :="000";
                            forwarding2_var := '1'; 
                        elsif (IR_OLD2(8 downto 6)=IR(11 downto 9) and NC_EM='0') then
                            hazard2_var :="010";
                            forwarding2_var := '1';
                        elsif (IR_OLD3(8 downto 6)=IR(11 downto 9) and NC_MW='0') then
                            hazard2_var :="100";	
                            forwarding2_var := '1';
                        end if;
                    end if;
                end if;
            end if;
           
            if(rising_edge(clk)) then
                re_stall <= re_stall_var;
            end if;
            
            hazard1 <= hazard1_var;
            hazard2 <= hazard2_var;
            stall <= stall_var;
            forwarding2 <= forwarding2_var;
            forwarding1 <= forwarding1_var;
        end process;
	end Behavioural;