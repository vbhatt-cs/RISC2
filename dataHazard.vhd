	library ieee;
	use ieee.std_logic_1164.all;
	
	entity Data_Hazard_Detector is
		port
		(IR :in std_logic_vector(15 downto 0);
		 IR_OLD1 :in std_logic_vector(15 downto 0);
		 IR_OLD2 :in std_logic_vector(15 downto 0);
		 IR_OLD3 :in std_logic_vector(15 downto 0);
		 NC_DR,NC_RE_out,NC_EM,NC_MW,C,Zeff: in std_logic;
		 hazard : out std_logic_vector(2 downto 0);
		 stall : out std_logic;
		 clk: in std_logic;
		 forwarding: out std_logic
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
	
	process(IR,IR_OLD1,IR_OLD2,IR_OLD3,clk, re_stall)
		
	variable hazard_var: std_logic_vector(2 downto 0);
	variable stall_var : std_logic := '0';
	variable forwarding_var : std_logic := '0';
		
		begin
		    hazard_var := "000";
		    stall_var := '0';
            forwarding_var := '0';
		if(NC_DR='0') then

			----CASE1 (Alu type)
			if(IR(15 downto 12)="0010" or IR(15 downto 12)="0000") then
				
				if(IR_OLD1(15 downto 12)="0000" or IR_OLD1(15 downto 12)="0010" or IR_OLD2(15 downto 12)="0000" or IR_OLD2(15 
				downto 12)="0010" or IR_OLD3(15 downto 12)="0000" or IR_OLD3(15 downto 12)="0010") then
	
					if(IR_OLD1(5 downto 3)=IR(11 downto 9) and NC_RE='0') then
	
						hazard_var :="000";
						stall_var:='0';
						forwarding_var := '1';
					
					elsif(IR_OLD2(5 downto 3)=IR(11 downto 9) and NC_EM='0') then
	
						hazard_var :="010";
						stall_var:='0';
						forwarding_var := '1';
					elsif(IR_OLD3(5 downto 3)=IR(11 downto 9) and NC_MW='0') then
						
						hazard_var := "100";
						stall_var := '0';
						forwarding_var := '1';
					end if;
					if(IR_OLD1(5 downto 3)=IR(8 downto 6) and NC_RE='0') then
	
						hazard_var :="001";
						stall_var:='0'; 
						forwarding_var := '1';
					
					elsif(IR_OLD2(5 downto 3)=IR(8 downto 6) and NC_EM='0') then
						hazard_var :="011";
						stall_var:='0';
						forwarding_var := '1';
					
					elsif(IR_OLD3(5 downto 3)=IR(8 downto 6) and NC_MW='0') then
						hazard_var :="101";
						stall_var:='0';
						forwarding_var := '1';
					end if;
					
				end if;
		
			--LHI
				if(IR_OLD1(15 downto 12)="0011" or IR_OLD2(15 downto 12)="0011" or IR_OLD3(15 downto 12)="0011") then
	
					if(IR_OLD1(11 downto 9)=IR(11 downto 9) and NC_RE='0') then
	
						hazard_var :="000";
						stall_var:='0'; 
						forwarding_var := '1';
					
					elsif(IR_OLD2(11 downto 9)=IR(11 downto 9) and NC_EM='0') then
	
						hazard_var :="010";
						stall_var:='0'; 
						forwarding_var := '1';
					elsif(IR_OLD3(11 downto 9)=IR(11 downto 9) and NC_MW='0') then
	
						hazard_var :="100";
						stall_var:='0'; 
						forwarding_var := '1';
					end if;
					if(IR_OLD1(11 downto 9)=IR(8 downto 6) and NC_RE='0') then
	
						hazard_var :="001";
						stall_var:='0'; 
						forwarding_var := '1';
					
					elsif(IR_OLD2(11 downto 9)=IR(8 downto 6) and NC_EM='0') then
						
						hazard_var :="011";
						stall_var:='0';
						forwarding_var := '1';	
						
					elsif(IR_OLD3(11 downto 9)=IR(8 downto 6) and NC_MW='0') then
						hazard_var :="101";
						stall_var:='0'; 
						forwarding_var := '1';
					end if; 
				end if;
	
				--lW 
	
				if(IR_OLD1(15 downto 12)="0100" or IR_OLD2(15 downto 12)="0100" or IR_OLD3(15 downto 12)="0100") then
	
					if(IR_OLD1(11 downto 9)=IR(11 downto 9) and NC_RE='0') then
	
						if(re_stall = "00") then
									stall_var:='1';
									re_stall <= "01";
									forwarding_var := '1';
						else     
						hazard_var :="010";
						forwarding_var := '1';
						end if;  
					
					elsif(IR_OLD2(11 downto 9)=IR(11 downto 9) and NC_EM='0') then
	
						hazard_var :="010";
						stall_var:='0'; 
						forwarding_var := '1';
					
					elsif(IR_OLD3(11 downto 9)=IR(11 downto 9) and NC_MW='0') then
	
						hazard_var :="100";
						stall_var:='0'; 
						forwarding_var := '1';
						
					end if;
					if(IR_OLD1(11 downto 9)=IR(8 downto 6) and NC_RE='0') then
	
						if(re_stall = "00") then
									stall_var:='1';
									re_stall <= "01";
									forwarding_var := '1';
							  else     
						hazard_var :="011";
						forwarding_var := '1';
						end if; 
					
					elsif(IR_OLD2(11 downto 9)=IR(8 downto 6) and NC_EM='0') then
						hazard_var :="011";
						stall_var:='0';
						forwarding_var := '1';
					
					elsif(IR_OLD3(11 downto 9)=IR(8 downto 6) and NC_MW='0') then
						hazard_var :="101";
						stall_var:='0';
						forwarding_var := '1';	
					end if;
					
				end if;
	
				--ADI
				if(IR_OLD1(15 downto 12)="0001" or IR_OLD2(15 downto 12)="0001" or IR_OLD3(15 downto 12)="0001") then
	
					if(IR_OLD1(8 downto 6)=IR(11 downto 9) and NC_RE='0') then
	
						hazard_var :="000";
						stall_var:='0'; 
						forwarding_var := '1';
					
					elsif(IR_OLD2(8 downto 6)=IR(11 downto 9) and NC_EM='0') then
	
						hazard_var :="010";
						stall_var:='0';
						forwarding_var := '1';
					
					elsif(IR_OLD3(8 downto 6)=IR(11 downto 9) and NC_MW='0') then
	
						hazard_var :="100";
						stall_var:='0'; 
						forwarding_var := '1';
					end if;
					if(IR_OLD1(8 downto 6)=IR(8 downto 6) and NC_RE='0') then
	
						hazard_var :="001";
						stall_var:='0'; 
						forwarding_var := '1';
					
					elsif(IR_OLD2(8 downto 6)=IR(8 downto 6) and NC_EM='0') then
	
						hazard_var :="010";
						stall_var:='0'; 
						forwarding_var := '1';
					
					elsif(IR_OLD3(8 downto 6)=IR(8 downto 6) and NC_MW='0') then
	
						hazard_var :="101";
						stall_var:='0'; 
						forwarding_var := '1';
				end if;
				end if;
	
	
	
			----CASE2 (ADI or LM)
			if(IR(15 downto 12)="0001" or IR(15 downto 12)="0110") then
	
				if (IR_OLD1(15 downto 12)="0000" or IR_OLD1(15 downto 12)="0010" or IR_OLD2(15 downto 12)="0000" or IR_OLD2(15 
				downto 12)="0010" or IR_OLD3(15 downto 12)="0000" or IR_OLD3(15 downto 12)="0010") then 
	
					if (IR_OLD1(5 downto 3)=IR(11 downto 9) and NC_RE='0') then
						hazard_var :="000";
						forwarding_var := '1';
						
					elsif (IR_OLD2(5 downto 3)=IR(11 downto 9) and NC_EM='0') then
						hazard_var :="010";
						forwarding_var := '1';
					elsif (IR_OLD3(5 downto 3)=IR(11 downto 9) and NC_MW='0') then
						hazard_var :="100";	
						forwarding_var := '1';
					end if;
				end if;
	
				if (IR_OLD1(15 downto 12)="0011" or IR_OLD2(15 downto 12)="0011" or IR_OLD3(15 downto 12)="0011") then
	
					if (IR_OLD1(11 downto 9)=IR(11 downto 9) and NC_RE='0') then
						hazard_var :="000";
						forwarding_var := '1';
					
					elsif (IR_OLD2(11 downto 9)=IR(11 downto 9) and NC_EM='0') then
						hazard_var :="010";
						forwarding_var := '1';
						
					elsif (IR_OLD3(11 downto 9)=IR(11 downto 9) and NC_MW='0') then
						hazard_var :="100";
						forwarding_var := '1';
						
					end if;
				end if; 
	
				if(IR_OLD1(15 downto 12)="0100" or IR_OLD2(15 downto 12)="0100" or IR_OLD3(15 downto 12)="0100") then
	
					if (IR_OLD1 (11 downto 9)=IR(11 downto 9) and NC_RE='0') then 
						if(re_stall = "00") then
									stall_var:='1';
									re_stall <= "01";
									forwarding_var := '1';
									else    
									hazard_var :="010";
									re_stall <= "00";
									forwarding_var := '1';
									end if;
					
					elsif (IR_OLD2(11 downto 9)=IR(11 downto 9) and NC_EM='0') then 
						hazard_var := "010";
						forwarding_var := '1';
					elsif (IR_OLD3(11 downto 9)=IR(11 downto 9) and NC_MW='0') then 
						hazard_var := "100";	
						forwarding_var := '1';
					end if;
				end if;
	
				if (IR_OLD1(15 downto 12)="0001" or IR_OLD2(15 downto 12)="0001" or IR_OLD3(15 downto 12)="0001") then
	
					if (IR_OLD1(8 downto 6)=IR(11 downto 9) and NC_RE='0') then
						hazard_var :="000";
						forwarding_var := '1';
					
					elsif (IR_OLD2(8 downto 6)=IR(11 downto 9) and NC_EM='0') then
						hazard_var :="010";
						forwarding_var := '1';
					elsif (IR_OLD3(8 downto 6)=IR(11 downto 9) and NC_MW='0') then
						hazard_var :="100";
						forwarding_var := '1';	
					
					end if;
					end if;    
						 
				
	
			end if;
			
			
			---CASE3 (LW,BEQ,JLR)
			
			if (IR(15 downto 12)="0100" or IR(15 downto 12)="1100" or IR(15 downto 12)="1001") then
	
				if (IR_OLD1(15 downto 12)="0000" or IR_OLD1(15 downto 12)="0010" or IR_OLD2(15 downto 12)="0000" or IR_OLD2(15 
				downto 12)="0010" or IR_OLD3(15 downto 12)="0000" or IR_OLD3(15 downto 12)="0010") then 

					if (IR_OLD1(5 downto 3)=IR(8 downto 6) and NC_RE='0') then
						hazard_var :="001";	
						forwarding_var := '1';
					elsif (IR_OLD2(5 downto 3)=IR(8 downto 6) and NC_EM='0') then
						hazard_var :="011";
						forwarding_var := '1';
					elsif (IR_OLD3(5 downto 3)=IR(8 downto 6) and NC_MW='0') then
						hazard_var :="101";
						forwarding_var := '1';	
					end if;
				end if;
	
				if (IR_OLD1(15 downto 12)="0011" or IR_OLD2(15 downto 12)="0011" or IR_OLD3(15 downto 12)="0011") then
	
					if (IR_OLD1(11 downto 9)=IR(8 downto 6) and NC_RE='0') then
						hazard_var :="001";
						forwarding_var := '1';
					
					elsif (IR_OLD2(11 downto 9)=IR(8 downto 6) and NC_EM='0') then
						hazard_var :="011";
						forwarding_var := '1';
					elsif (IR_OLD3(11 downto 9)=IR(8 downto 6) and NC_MW='0') then
						hazard_var :="101";
						forwarding_var := '1';	
					end if;
				end if; 
	
				if(IR_OLD1(15 downto 12)="0100" or IR_OLD2(15 downto 12)="0100" or IR_OLD3(15 downto 12)="0100") then
	
					if (IR_OLD1 (11 downto 9)=IR(8 downto 6) and NC_RE='0') then 
						if(re_stall = "00") then
									stall_var:='1';
									re_stall <= "01";
									forwarding_var := '1';
									else    
									hazard_var :="011";
									re_stall <= "00";
									forwarding_var := '1';
									end if;
					
					elsif (IR_OLD2(11 downto 9)=IR(8 downto 6) and NC_EM='0') then 
						hazard_var := "011";
						forwarding_var := '1';
					elsif (IR_OLD3(11 downto 9)=IR(8 downto 6) and NC_MW='0') then 
						hazard_var := "101";	
						forwarding_var := '1';
						
					end if;
				end if;
	
				if (IR_OLD1(15 downto 12)="0001" or IR_OLD2(15 downto 12)="0001" or IR_OLD3(15 downto 12)="0001") then
	
					if (IR_OLD1(8 downto 6)=IR(8 downto 6) and NC_RE='0') then
						hazard_var :="001";
						forwarding_var := '1';
					
					elsif (IR_OLD2(8 downto 6)=IR(8 downto 6) and NC_EM='0') then
						hazard_var :="011";
						forwarding_var := '1';
					elsif (IR_OLD3(8 downto 6)=IR(8 downto 6) and NC_MW='0') then
						hazard_var :="101";
						forwarding_var := '1';	
					end if;
				end if;
	
			end if;
	
	
			----CASE4 (SW)
			if(IR(15 downto 12)="0101") then
	
				if (IR_OLD1(15 downto 12)="0000" or IR_OLD1(15 downto 12)="0010" or IR_OLD2(15 downto 12)="0000" or IR_OLD2(15 
				downto 12)="0010" or IR_OLD3(15 downto 12)="0000" or IR_OLD3(15 downto 12)="0010") then 
					if (IR_OLD1(5 downto 3)=IR(11 downto 9) and NC_RE='0') then
						hazard_var :="000";
						forwarding_var := '1';
					elsif (IR_OLD2(5 downto 3)=IR(11 downto 9) and NC_EM='0') then
						hazard_var :="010";
						forwarding_var := '1';
					elsif (IR_OLD3(5 downto 3)=IR(11 downto 9) and NC_MW='0') then
						hazard_var :="100";
						forwarding_var := '1';
					end if;
					
					if (IR_OLD1(5 downto 3)=IR(8 downto 6) and NC_RE='0') then
						hazard_var :="001";
						forwarding_var := '1';
										
					elsif (IR_OLD2(5 downto 3)=IR(8 downto 6) and NC_EM='0') then
						hazard_var :="011";
						forwarding_var := '1';
					elsif (IR_OLD3(5 downto 3)=IR(8 downto 6) and NC_MW='0') then
						hazard_var :="101";
						forwarding_var := '1';
						
					end if;
				end if;
	
				if (IR_OLD1(15 downto 12)="0011" or IR_OLD2(15 downto 12)="0011" or IR_OLD3(15 downto 12)="0011") then
	
					if (IR_OLD1(11 downto 9)=IR(8 downto 6) and NC_RE='0') then
						hazard_var :="001";
						forwarding_var := '1';
					elsif (IR_OLD2(11 downto 9)=IR(8 downto 6) and NC_EM='0') then
						hazard_var :="010";
						forwarding_var := '1';
					elsif (IR_OLD3(11 downto 9)=IR(8 downto 6) and NC_MW='0') then
						hazard_var :="100";
						forwarding_var := '1';
						
					end if;
				end if; 
	
				if(IR_OLD1(15 downto 12)="0100" or IR_OLD2(15 downto 12)="0100" or IR_OLD3(15 downto 12)="0100") then
	
					if (IR_OLD1 (11 downto 9)=IR(8 downto 6) and NC_RE='0') then 
						if(re_stall = "00") then
									stall_var:='1';
									re_stall <= "01";
									forwarding_var := '1';
									else    
									hazard_var :="011";
									re_stall <= "00";
									forwarding_var := '1';
							 end if;
									
					elsif (IR_OLD2(11 downto 9)=IR(8 downto 6) and NC_EM='0') then 
						hazard_var := "011";
						forwarding_var := '1';
					elsif (IR_OLD3(11 downto 9)=IR(8 downto 6) and NC_MW='0') then 
						hazard_var := "101";
						forwarding_var := '1';
						
					end if;
				end if;
	
				if (IR_OLD1(15 downto 12)="0001" or IR_OLD2(15 downto 12)="0001" or IR_OLD3(15 downto 12)="0001") then
	
					if (IR_OLD1(8 downto 6)=IR(8 downto 6) and NC_RE='0') then
						hazard_var :="001";
						forwarding_var := '1';
					
					elsif (IR_OLD2(8 downto 6)=IR(8 downto 6) and NC_EM='0') then
						hazard_var :="011";
						forwarding_var := '1';
					elsif (IR_OLD3(8 downto 6)=IR(8 downto 6) and NC_MW='0') then
						hazard_var :="101";	
						forwarding_var := '1';
					end if;
				end if;
			
	
			end if;
		
			
			-----CASE 5(SM)
			if(IR(15 downto 12)= "0111") then
					
					if (IR_OLD1(15 downto 12)="0000" or IR_OLD1(15 downto 12)="0010" or IR_OLD2(15 downto 12)="0000" or IR_OLD2(15 
				downto 12)="0010" or IR_OLD3(15 downto 12)="0000" or IR_OLD3(15 downto 12)="0010") then 
	
					if (IR_OLD1(5 downto 3)=IR(11 downto 9) and NC_RE='0') then
						hazard_var :="001";
						forwarding_var := '1';
						
					elsif (IR_OLD2(5 downto 3)=IR(11 downto 9) and NC_EM='0') then
						hazard_var :="011";
						forwarding_var := '1';
					elsif (IR_OLD3(5 downto 3)=IR(11 downto 9) and NC_MW='0') then
						hazard_var :="101";
						forwarding_var := '1';	
					end if;   
				end if;
	
				if (IR_OLD1(15 downto 12)="0011" or IR_OLD2(15 downto 12)="0011" or IR_OLD3(15 downto 12)="0011") then
	
					if (IR_OLD1(11 downto 9)=IR(11 downto 9) and NC_RE='0') then
						hazard_var :="001";
						forwarding_var := '1';
						
					elsif (IR_OLD2(11 downto 9)=IR(11 downto 9) and NC_EM='0') then
						hazard_var :="011";
						forwarding_var := '1';
					elsif (IR_OLD3(11 downto 9)=IR(11 downto 9) and NC_MW='0') then
						hazard_var :="101";	
						forwarding_var := '1';
					end if;
				end if; 
	
				if(IR_OLD1(15 downto 12)="0100" or IR_OLD2(15 downto 12)="0100" or IR_OLD3(15 downto 12)="0100") then
	
					if (IR_OLD1 (11 downto 9)=IR(11 downto 9) and NC_RE='0') then 
						if(re_stall = "00") then
									stall_var:='1';
									re_stall <= "01";
									forwarding_var := '1';
									else    
									hazard_var :="011";
									re_stall <= "00";
									forwarding_var := '1';
									end if;
					
					elsif (IR_OLD2(11 downto 9)=IR(11 downto 9) and NC_EM='0') then 
						hazard_var := "011";
						forwarding_var := '1';
					elsif (IR_OLD3(11 downto 9)=IR(11 downto 9) and NC_MW='0') then 
						hazard_var := "101";	
						forwarding_var := '1';
					end if;
				end if;
	
				if (IR_OLD1(15 downto 12)="0001" or IR_OLD2(15 downto 12)="0001" or IR_OLD3(15 downto 12)="0001") then
	
					if (IR_OLD1(8 downto 6)=IR(11 downto 9) and NC_RE='0') then
						hazard_var :="001";
						forwarding_var := '1';
						
					elsif (IR_OLD2(8 downto 6)=IR(11 downto 9) and NC_EM='0') then
						hazard_var :="011";
						forwarding_var := '1';
					elsif (IR_OLD3(8 downto 6)=IR(11 downto 9) and NC_MW='0') then
						hazard_var :="101";	
						forwarding_var := '1';
					end if;
						
				end if;
				end if;
						
			
			end if;

	
					
			
			hazard <= hazard_var;
			stall <= stall_var;
			forwarding <= forwarding_var;
		end if;	
		end process;
		
	end;
	
