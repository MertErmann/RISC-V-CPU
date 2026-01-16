library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity pc_next is
    port(
        pcsrc       : in std_logic;
        pcplus4     : in std_logic_vector(31 downto 0);
        pctarget    : in std_logic_vector(31 downto 0);
        pcnext      : out std_logic_vector(31 downto 0)
        );
end entity;

architecture RTL of pc_next is
begin
    pcnext <= pctarget when pcsrc = '1' else pcplus4;
end architecture;