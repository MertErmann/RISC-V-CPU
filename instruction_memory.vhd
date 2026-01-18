library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity instruction_memory is
generic(
    memory_depth : integer := 256
);
port(
    addr  : in std_logic_vector(31 downto 0);
    instr : out std_logic_vector(31 downto 0)
);
end entity;

architecture RTL of instruction_memory is
signal idx : integer range 0 to memory_depth-1;
type mem_t is array (0 to memory_depth-1) of std_logic_vector(31 downto 0);
signal mem : mem_t := (
    0  => x"00000093", 
    1  => x"00100113", 
    2  => x"01400213", 
    3  => x"002081B3", 
    4  => x"000100B3", 
    5  => x"00018133", 
    6  => x"FFF20213", 
    7  => x"00020463", 
    8  => x"FE0006E3", 
    9  => x"00000063", 
    others => x"00000013" 
);
begin
    idx   <= to_integer(unsigned(addr(31 downto 2)));
    instr <= mem(idx);
end architecture;
