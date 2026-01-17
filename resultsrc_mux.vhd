library ieee;
use ieee.std_logic_1164.all;

entity resultsrc_mux is
port(
    alu_result  : in  std_logic_vector(31 downto 0);
    read_data   : in  std_logic_vector(31 downto 0);
    resultsrc   : in  std_logic;
    result      : out std_logic_vector(31 downto 0)
);
end entity;

architecture RTL of resultsrc_mux is
begin
    result <= read_data when resultsrc = '1' else alu_result;
end architecture;
