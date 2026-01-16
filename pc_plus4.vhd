library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity pc_plus4 is
    port(
        pc          : in std_logic_vector(31 downto 0);
        pc_plus4    : out std_logic_vector(31 downto 0)
    );
end entity;

architecture RTL of pc_plus4 is
begin
    pc_plus4 <= std_logic_vector(unsigned(pc) + 4);
end architecture;