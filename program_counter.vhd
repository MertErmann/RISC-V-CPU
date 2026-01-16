library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity program_counter is
    port(
        
        clk         : in std_logic;
        rst         : in std_logic;
        pc_next     : in std_logic_vector(31 downto 0);
        pc          : out std_logic_vector(31 downto 0)

    );
end entity;


architecture RTL of program_counter is

signal pc_r : std_logic_vector(31 downto 0);

begin
    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                pc_r <= (others => '0');
            else
                pc_r <= pc_next;
            end if; 
        end if;
    end process;
    
pc <= pc_r;

end architecture;
