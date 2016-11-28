library ieee;
use ieee.std_logic_1164.all;

package datapathComponents is
    --Register file. 
    --If address of registers (a1, a2, a4) are given,
    --d1, d2, d4 will have the data in those registers.
    --Given a3,d3 and regWr high, d3 is written into register with address a3.
    component regFile is
        port(
            a1, a2, a3, a4 : in std_logic_vector(2 downto 0);
            d3, pci : in std_logic_vector(15 downto 0);
            d1, d2, d4, pco : out std_logic_vector(15 downto 0);
            regWr, pcWr : in std_logic;
            clk,reset : in std_logic);
    end component;

    --ALU for add, nand
    --aluOP=0 means add, =1 means nand
    component alu is
        port(
            IP1, IP2 : in std_logic_vector(15 downto 0);
            OP : out std_logic_vector(15 downto 0);
            aluOP : in std_logic;
            C: out std_logic);
    end component;
    
    --Memory for data
    --A - address
    --Din - data to write
    --Dout - read data
    --To read - address in A, memR high. Dout will have data
    --To write - address in A, data in Din, memWR high
    component dataMemory is
        port(
            A, Din : in std_logic_vector(15 downto 0);
            Dout : out std_logic_vector(15 downto 0);
            memWR : in std_logic;
            clk : in std_logic);
    end component;

    --Memory for instruction
    --A - address
    --Dout - read data
    --To read - address in A, memR high. Dout will have data
    --To write - address in A, data in Din, memWR high
    component instrMemory is
        port(
            A : in std_logic_vector(15 downto 0);
            Dout : out std_logic_vector(15 downto 0);
            clk : in std_logic);
    end component;
    
    --Generic register
    component dataRegister is
        generic (data_width:integer);
        port(
            Din : in std_logic_vector(data_width-1 downto 0);
            Dout : out std_logic_vector(data_width-1 downto 0);
            clk, enable, reset : in std_logic);
    end component;

    component flipFlop is
        port(
            Din: in std_logic;
            Dout: out std_logic;
            clk, enable, reset: in std_logic);
    end component;
    
    --Comparator
    component Comparator is
        port(
		    Comp_D1,Comp_D2: in std_logic_vector(15 downto 0);
			Comp_out: out std_logic);
    end component; 
    
    --Custom priority encoder
    --v tells whether the output is valid or not
    --a gives the location of least significant 1.
    --d returns the input with zero in the location of the least significant 1.
    component PE is
        port(
            inp: in std_logic_vector(15 downto 0);
            v: out std_logic;
            a: out std_logic_vector(2 downto 0);
            d: out std_logic_vector(15 downto 0));
    end component;
end package;
