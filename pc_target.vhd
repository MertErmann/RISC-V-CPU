library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity pc_target is 
port(
    imm_ext         : in std_logic_vector(31 downto 0);
    pc              : in std_logic_vector(31 downto 0);
    pc_target_out   : out std_logic_vector(31 downto 0)
);
end entity;


architecture RTL of pc_target is
begin
    pc_target_out <= std_logic_vector(unsigned(pc) + unsigned(imm_ext));
end architecture;
