library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Data_Memory is
generic(
    DEPTH_WORDS : integer := 4096
);
port(
    clk         : in std_logic;
    we          : in std_logic;
    alu_result  : in std_logic_vector(31 downto 0);
    wd          : in std_logic_vector(31 downto 0);
    rd          : out std_logic_vector(31 downto 0)

);
end entity;

architecture RTL of Data_Memory is 

type ram_t is array (0 to DEPTH_WORDS-1) of std_logic_vector(31 downto 0);
signal ram : ram_t := (others => (others => '0'));
signal word_index : integer range 0 to DEPTH_WORDS-1;


begin
word_index <= to_integer(unsigned(alu_result(31 downto 2)));
rd <= ram(word_index);


process(clk)
begin
if rising_edge(clk) then
    if we = '1' then
        ram(word_index) <= wd;
    end if;
end if; 
end process;

end architecture;
