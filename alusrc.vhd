library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity alusrc is
port(
    alusrc_b    : in std_logic;
    imm_ext     : in std_logic_vector(31 downto 0);
    rd2_ext     : in std_logic_vector(31 downto 0);
    srcb        : out std_logic_vector(31 downto 0)
);
end entity;

architecture RTL of alusrc is
begin
    srcb <= imm_ext when alusrc_b = '1' else rd2_ext;
end architecture;