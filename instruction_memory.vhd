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
    0 => x"00f00093", 
    1 => x"00f00193", 
    2 => x"00000013", 
    3 => x"00000013",
    others => x"00000013"
);
begin

idx     <= to_integer(unsigned(addr(31 downto 2)));
instr   <= mem(idx);

end architecture;
