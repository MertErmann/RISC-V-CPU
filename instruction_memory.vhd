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
signal idx : integer range 0 to MEMORY_Depth-1;
type mem_t is array (0 to MEMORY_Depth-1) of std_logic_vector(31 downto 0);
signal mem : mem_t :=(
    0  => x"00000093",
    1  => x"00100113",
    2  => x"00000193",
    3  => x"00a00213",
    4  => x"00000293",
    5  => x"0012a023",
    6  => x"00208333",
    7  => x"00010093",
    8  => x"00030113",
    9  => x"00428293",
    10 => x"00118193",
    11 => x"fe4194e3",
    12 => x"0000006f",
    others => x"00000013"
);


idx     <= to_integer(unsigned(addr(31 downto 2)));
instr   <= mem(idx);

end architecture;
