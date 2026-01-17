library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity control_unit is
port(
    
    instr       : in std_logic_vector(31 downto 0);
    zero        : in std_logic;
    pcsrc       : out std_logic;
    resultsrc   : out std_logic;
    memwrite    : out std_logic;
    alucontrol  : out std_logic_vector(2 downto 0);
    alusrc      : out std_logic;
    immsrc      : out std_logic_vector(1 downto 0);
    regwrite    : out std_logic

);
end entity;

architecture RTL of control_unit is

signal opcode : std_logic_vector(6 downto 0);
signal funct3 : std_logic_vector(2 downto 0);
signal funct7 : std_logic_vector(6 downto 0);

constant OP_RTYPE  : std_logic_vector(6 downto 0) := "0110011";
constant OP_ITYPE  : std_logic_vector(6 downto 0) := "0010011";
constant OP_LOAD   : std_logic_vector(6 downto 0) := "0000011";
constant OP_STORE  : std_logic_vector(6 downto 0) := "0100011";
constant OP_BRANCH : std_logic_vector(6 downto 0) := "1100011";
constant OP_JAL    : std_logic_vector(6 downto 0) := "1101111";

constant F7_BASE   : std_logic_vector(6 downto 0) := "0000000";
    
constant ALU_ADD   : std_logic_vector(2 downto 0) := "000"   

begin

opcode <= instr(6 downto 0);
funct3 <= instr(14 downto 12);
funct7 <= instr(31 downto 25);


process(opcode,funct3,funct7)
begin

pcsrc      <= '0';
resultsrc  <= '0';
memwrite   <= '0';
alucontrol <= "000";
alusrc     <= '0';
immsrc     <= "00";
regwrite   <= '0';

case opcode is
        
    when OP_RTYPE =>
        if 
        regwrite <= '1';







end process;
end architecture;