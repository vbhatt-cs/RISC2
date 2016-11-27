	library ieee;
	use ieee.std_logic_1164.all;
	
	entity dataHazard is
		port
		(IR :in std_logic_vector(15 downto 0);
		 IR_OLD1 :in std_logic_vector(15 downto 0);
		 IR_OLD2 :in std_logic_vector(15 downto 0);
		 IR_OLD3 :in std_logic_vector(15 downto 0);
		 hazard : out std_logic_vector(2 downto 0);
		  next_reg_PE_output :in std_logic_vector(2 downto 0);
		  all_zero_PE : in std_logic;
		  start_PE : in std_logic;
		 stall : out std_logic;
		 stall2 :out std_logic;
		 clk: in std_logic
		);
	
	end entity;
	
	architecture behavioural of dataHazard is 
	
	signal re_stall : std_logic_vector(1 downto 0); 
		
	begin
	
	
	process(IR,IR_OLD1,IR_OLD2,IR_OLD3,clk,start_PE,all_zero_PE,next_reg_PE_output,re_stall)
		
	variable hazard_var std_logic_vector(2 downto 0);
	variable stall_var,stall2_var : std_logic := '0';
		
		begin
		if(clk'event and clk = '1') then

			----CASE1
			if(IR(15 downto 12)="1100") then
				
				if(IR_OLD1(15 downto 12)="0000" or IR_OLD1(15 downto 12)="0010" or IR_OLD2(15 downto 12)="0000" or IR_OLD2(15 
				downto 12)="0010" or IR_OLD3(15 downto 12)="0000" or IR_OLD3(15 downto 12)="0010") then
	
					if(IR_OLD1(5 downto 3)=IR(11 downto 9) ) then
	
						hazard_var :="000";
						stall_var:='0'; 
					
					elsif(IR_OLD2(5 downto 3)=IR(11 downto 9) ) then
	
						hazard_var :="010";
						stall_var:='0'; 
					elsif(IR_OLD3(5 downto 3)=IR(11 downto 9) ) then
						
						hazard_var := "100";
						stall_var := '0';
					end if;
					if(IR_OLD1(5 downto 3)=IR(8 downto 6) ) then
	
						hazard_var :="001";
						stall_var:='0'; 
					
					elsif(IR_OLD2(5 downto 3)=IR(8 downto 6)) then
						hazard_var :="011";
						stall_var:='0';
					
					elsif(IR_OLD3(5 downto 3)=IR(8 downto 6)) then
						hazard_var :="101";
						stall_var:='0';
					end if;
					
				end if;
		--LHI
				if(IR_OLD1(15 downto 12)="0011" or IR_OLD2(15 downto 12)="0011" or IR_OLD3(15 downto 12)="0011") then
	
					if(IR_OLD1(11 downto 9)=IR(11 downto 9) ) then
	
						hazard_var :="000";
						stall_var:='0'; 
					
					elsif(IR_OLD2(11 downto 9)=IR(11 downto 9) ) then
	
						hazard_var :="010";
						stall_var:='0'; 
					elsif(IR_OLD3(11 downto 9)=IR(11 downto 9) ) then
	
						hazard_var :="100";
						stall_var:='0'; 
					end if;
					if(IR_OLD1(11 downto 9)=IR(8 downto 6) ) then
	
						hazard_var :="001";
						stall_var:='0'; 
					
					elsif(IR_OLD2(11 downto 9)=IR(8 downto 6)) then
						
						hazard_var :="011";
						stall_var:='0'; 
						
					elsif(IR_OLD3(11 downto 9)=IR(8 downto 6)) then
						hazard_var :="101";
						stall_var:='0'; 
					end if; 
				end if;
	
				--lW 
	
				if(IR_OLD1(15 downto 12)="0100" or IR_OLD2(15 downto 12)="0100" or IR_OLD3(15 downto 12)="0100") then
	
					if(IR_OLD1(11 downto 9)=IR(11 downto 9) ) then
	
						if(re_stall = "00") then
									stall_var:='1';
									re_stall <= "01";
						else     
						hazard_var :="010";
						end if;  
					
					elsif(IR_OLD2(11 downto 9)=IR(11 downto 9) ) then
	
						hazard_var :="010";
						stall_var:='0'; 
					
					elsif(IR_OLD3(11 downto 9)=IR(11 downto 9) ) then
	
						hazard_var :="100";
						stall_var:='0'; 
					end if;
					if(IR_OLD1(11 downto 9)=IR(8 downto 6) ) then
	
						if(re_stall = "00") then
									stall_var:='1';
									re_stall <= "01";
							  else     
						hazard_var :="011";
						end if; 
					
					elsif(IR_OLD2(11 downto 9)=IR(8 downto 6)) then
						hazard_var :="011";
						stall_var:='0';
					
					elsif(IR_OLD3(11 downto 9)=IR(8 downto 6)) then
						hazard_var :="101";
						stall_var:='0';	
					end if;
					
				end if;
	
				--ADI
				if(IR_OLD1(15 downto 12)="0001" or IR_OLD2(15 downto 12)="0001" or IR_OLD3(15 downto 12)="0001") then
	
					if(IR_OLD1(8 downto 6)=IR(11 downto 9) ) then
	
						hazard_var :="000";
						stall_var:='0'; 
					
					elsif(IR_OLD2(8 downto 6)=IR(11 downto 9) ) then
	
						hazard_var :="010";
						stall_var:='0'; 
					
					elsif(IR_OLD3(8 downto 6)=IR(11 downto 9) ) then
	
						hazard_var :="100";
						stall_var:='0'; 
					end if;
					if(IR_OLD1(8 downto 6)=IR(8 downto 6) ) then
	
						hazard_var :="001";
						stall_var:='0'; 
					
					elsif(IR_OLD2(8 downto 6)=IR(8 downto 6) ) then
	
						hazard_var :="010";
						stall_var:='0'; 
					
					elsif(IR_OLD3(8 downto 6)=IR(8 downto 6) ) then
	
						hazard_var :="101";
						stall_var:='0'; 
				end if;
				end if;
	
	
	
			----CASE2 (ADI or LM)
			if(IR(15 downto 12)="0001" or IR(15 downto 12)="0110") then
	
				if (IR_OLD1(15 downto 12)="0000" or IR_OLD1(15 downto 12)="0010" or IR_OLD2(15 downto 12)="0000" or IR_OLD2(15 
				downto 12)="0010" or IR_OLD3(15 downto 12)="0000" or IR_OLD3(15 downto 12)="0010") then 
	
					if (IR_OLD1(5 downto 3)=IR(11 downto 9)) then
						hazard_var :="000";
						
					elsif (IR_OLD2(5 downto 3)=IR(11 downto 9)) then
						hazard_var :="010";
					elsif (IR_OLD3(5 downto 3)=IR(11 downto 9)) then
						hazard_var :="100";	
					end if;
				end if;
	
				if (IR_OLD1(15 downto 12)="0011" or IR_OLD2(15 downto 12)="0011" or IR_OLD3(15 downto 12)="0011") then
	
					if (IR_OLD1(11 downto 9)=IR(11 downto 9)) then
						hazard_var :="000";
					
					elsif (IR_OLD2(11 downto 9)=IR(11 downto 9)) then
						hazard_var :="010";
						
					elsif (IR_OLD3(11 downto 9)=IR(11 downto 9)) then
						hazard_var :="100";
						
					end if;
				end if; 
	
				if(IR_OLD1(15 downto 12)="0100" or IR_OLD2(15 downto 12)="0100" or IR_OLD3(15 downto 12)="0100") then
	
					if (IR_OLD1 (11 downto 9)=IR(11 downto 9)) then 
						if(re_stall = "00") then
									stall2_var:='1';
									re_stall <= "01";
									else    
									hazard_var :="010";
									re_stall <= "00";
									end if;
					
					elsif (IR_OLD2(11 downto 9)=IR(11 downto 9)) then 
						hazard_var := "010";
					elsif (IR_OLD3(11 downto 9)=IR(11 downto 9)) then 
						hazard_var := "100";	
					end if;
				end if;
	
				if (IR_OLD1(15 downto 12)="0001" or IR_OLD2(15 downto 12)="0001" or IR_OLD3(15 downto 12)="0001") then
	
					if (IR_OLD1(8 downto 6)=IR(11 downto 9)) then
						hazard_var :="000";
					
					elsif (IR_OLD2(8 downto 6)=IR(11 downto 9)) then
						hazard_var :="010";
					elsif (IR_OLD3(8 downto 6)=IR(11 downto 9)) then
						hazard_var :="100";	
					
					end if;
					end if;    
						 
					if(IR_OLD1(15 downto 12) = "0110") then
						 if(next_reg_PE_output = IR(11 downto 9) and all_zero_PE = '1') then
							  hazard_var := "100";
						stall_var:='0';--not sure
						 end if;
					end if;    
				if (IR_OLD1(15 downto 12)="1000" or IR_OLD1(15 downto 12)="1001") then
	
					if (IR_OLD1(11 downto 9)=IR(11 downto 9)) then
						hazard_var :="100";
						
					end if;
				end if; 			
	
			end if;
			
			
			---CASE3 (LW)
			
			if (IR(15 downto 12)="0100") then
	
				if (IR_OLD1(15 downto 12)="0000" or IR_OLD1(15 downto 12)="0010" or IR_OLD2(15 downto 12)="0000" or IR_OLD2(15 
				downto 12)="0010" or IR_OLD3(15 downto 12)="0000" or IR_OLD3(15 downto 12)="0010") then 

					if (IR_OLD1(5 downto 3)=IR(8 downto 6)) then
						hazard_var :="001";	
					elsif (IR_OLD2(5 downto 3)=IR(8 downto 6)) then
						hazard_var :="011";
					elsif (IR_OLD3(5 downto 3)=IR(8 downto 6)) then
						hazard_var :="101";	
					end if;
				end if;
	
				if (IR_OLD1(15 downto 12)="0011" or IR_OLD2(15 downto 12)="0011" or IR_OLD3(15 downto 12)="0011") then
	
					if (IR_OLD1(11 downto 9)=IR(8 downto 6)) then
						hazard_var :="001";
					
					elsif (IR_OLD2(11 downto 9)=IR(8 downto 6)) then
						hazard_var :="011";
					elsif (IR_OLD3(11 downto 9)=IR(8 downto 6)) then
						hazard_var :="101";	
					end if;
				end if; 
	
				if(IR_OLD1(15 downto 12)="0100" or IR_OLD2(15 downto 12)="0100" or IR_OLD3(15 downto 12)="0100") then
	
					if (IR_OLD1 (11 downto 9)=IR(8 downto 6)) then 
						if(re_stall = "00") then
									stall2_var:='1';
									re_stall <= "01";
									else    
									hazard_var :="011";
									re_stall <= "00";
									end if;
					
					elsif (IR_OLD2(11 downto 9)=IR(8 downto 6)) then 
						hazard_var := "011";
					elsif (IR_OLD3(11 downto 9)=IR(8 downto 6)) then 
						hazard_var := "101";	
						
					end if;
				end if;
	
				if (IR_OLD1(15 downto 12)="0001" or IR_OLD2(15 downto 12)="0001" or IR_OLD3(15 downto 12)="0001") then
	
					if (IR_OLD1(8 downto 6)=IR(8 downto 6)) then
						hazard_var :="001";
					
					elsif (IR_OLD2(8 downto 6)=IR(8 downto 6)) then
						hazard2_var :="011";
					elsif (IR_OLD3(8 downto 6)=IR(8 downto 6)) then
						hazard3_var :="101";	
					end if;
				end if;
	
			end if;
	
	
			----CASE4 (SW)
			if(IR(15 downto 12)="0101") then
	
				if (IR_OLD1(15 downto 12)="0000" or IR_OLD1(15 downto 12)="0010" or IR_OLD2(15 downto 12)="0000" or IR_OLD2(15 
				downto 12)="0010" or IR_OLD3(15 downto 12)="0000" or IR_OLD3(15 downto 12)="0010") then 
					if (IR_OLD1(5 downto 3)=IR(11 downto 9)) then
						hazard_var :="000";
					elsif (IR_OLD2(5 downto 3)=IR(11 downto 9)) then
						hazard_var :="010";
					elsif (IR_OLD3(5 downto 3)=IR(11 downto 9)) then
						hazard_var :="100";
					end if;
					
					if (IR_OLD1(5 downto 3)=IR(8 downto 6)) then
						hazard_var :="001";
										
					elsif (IR_OLD2(5 downto 3)=IR(8 downto 6)) then
						hazard_var :="011";
					elsif (IR_OLD3(5 downto 3)=IR(8 downto 6)) then
						hazard_var :="101";
						
					end if;
				end if;
	
				if (IR_OLD1(15 downto 12)="0011" or IR_OLD2(15 downto 12)="0011" or IR_OLD3(15 downto 12)="0011") then
	
					if (IR_OLD1(11 downto 9)=IR(8 downto 6)) then
						hazard_var :="001";
					elsif (IR_OLD2(11 downto 9)=IR(8 downto 6)) then
						hazard_var :="010";
					elsif (IR_OLD3(11 downto 9)=IR(8 downto 6)) then
						hazard_var :="100";
						
					end if;
				end if; 
	
				if(IR_OLD1(15 downto 12)="0100" or IR_OLD2(15 downto 12)="0100" or IR_OLD3(15 downto 12)="0100") then
	
					if (IR_OLD1 (11 downto 9)=IR(8 downto 6)) then 
						if(re_stall = "00") then
									stall2_var:='1';
									re_stall <= "01";
									else    
									hazard_var :="011";
									re_stall <= "00";
							 end if;
									
					elsif (IR_OLD2(11 downto 9)=IR(8 downto 6)) then 
						hazard_var := "011";
					elsif (IR_OLD3(11 downto 9)=IR(8 downto 6)) then 
						hazard_var := "101";
						
					end if;
				end if;
	
				if (IR_OLD1(15 downto 12)="0001" or IR_OLD2(15 downto 12)="0001" or IR_OLD3(15 downto 12)="0001") then
	
					if (IR_OLD1(8 downto 6)=IR(8 downto 6)) then
						hazard_var :="001";
					
					elsif (IR_OLD2(8 downto 6)=IR(8 downto 6)) then
						hazard_var :="011";
					elsif (IR_OLD3(8 downto 6)=IR(8 downto 6)) then
						hazard_var :="101";	
					end if;
				end if;
	
					if(IR_OLD1(15 downto 12) = "0110") then
						 if(next_reg_PE_output = IR(8 downto 6) and all_zero_PE ='1') then
							  hazard_var := "101";
						stall_var:='0';
						 end if;
					end if;			
	
			end if;
	
					
			
			hazard <= hazard_var;
			stall <= stall_var;
			stall2 <= stall2_var;
		end if;	
		end process;
		
	end;
	
