library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity register_file is
    port(
        clk : in std_logic;
        we3 : in std_logic;
        wd3 : in std_logic_vector(31 downto 0);
        a1  : in std_logic_vector(4 downto 0);
        a2  : in std_logic_vector(4 downto 0);
        rd  : in std_logic_vector(4 downto 0);
        rd1 : out std_logic_vector(31 downto 0);
        rd2 : out std_logic_vector(31 downto 0)
    );
end entity;

architecture RTL of register_file is

type reg_array_t is array (0 to 31) of std_logic_vector(31 downto 0);
signal regs : reg_array_t := (others => (others => '0'));

begin
    
process(clk)
begin
    if rising_edge(clk) then
        if we3 = '1' then
            if rd /= "00000" then
                regs(to_integer(unsigned(rd))) <= wd3;
            end if;
        end if;
    end if;
end process;

rd1 <= ((others => '0') ) when a1 = "00000" else regs(to_integer(unsigned(a1)));
rd2 <= ((others => '0') ) when a2 = "00000" else regs(to_integer(unsigned(a2)));
end architecture;