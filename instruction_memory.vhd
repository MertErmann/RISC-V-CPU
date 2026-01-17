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
    0  => x"00000093", -- addi x1, x0, 0
    1  => x"00100113", -- addi x2, x0, 1
    2  => x"01400213", -- addi x4, x0, 20

    3  => x"002081B3", -- add  x3, x1, x2        (loop)
    4  => x"000100B3", -- add  x1, x2, x0
    5  => x"00018133", -- add  x2, x3, x0
    6  => x"FFF20213", -- addi x4, x4, -1
    7  => x"00020463", -- beq  x4, x0, done
    8  => x"FE0006E3", -- beq x0, x0, loop  (DOĞRU)


    9  => x"00000063", -- done: beq x0, x0, done (halt)
    others => x"00000013" -- NOP
);

begin
    idx   <= to_integer(unsigned(addr(31 downto 2)));
    instr <= mem(idx);
end architecture;
