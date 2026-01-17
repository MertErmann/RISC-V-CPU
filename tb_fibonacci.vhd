library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_fibonacci is
end entity;

architecture sim of tb_fibonacci is

signal clk        : std_logic := '0';
signal rst        : std_logic := '1';

signal pc_o       : std_logic_vector(31 downto 0);
signal instr_o    : std_logic_vector(31 downto 0);

signal memwrite_o : std_logic;
signal memaddr_o  : std_logic_vector(31 downto 0);
signal memwd_o    : std_logic_vector(31 downto 0);

signal store_count     : integer := 0;
signal expected_fib_o  : std_logic_vector(31 downto 0);

begin

clk <= not clk after 5 ns;

uut: entity work.riscv_singlecycle_top_dbg
port map(
    clk         => clk,
    rst         => rst,
    pc_o        => pc_o,
    instr_o     => instr_o,
    memwrite_o  => memwrite_o,
    memaddr_o   => memaddr_o,
    memwd_o     => memwd_o
);

process(store_count)
    variable v : integer;
    variable idx : integer;
begin
    idx := store_count + 1;

    case idx is
        when 0 => v := 0;
        when 1 => v := 1;
        when 2 => v := 1;
        when 3 => v := 2;
        when 4 => v := 3;
        when 5 => v := 5;
        when 6 => v := 8;
        when 7 => v := 13;
        when 8 => v := 21;
        when 9 => v := 34;
        when others => v := 0;
    end case;

    expected_fib_o <= std_logic_vector(to_unsigned(v, 32));
end process;


process
begin
    rst <= '1';
    wait for 30 ns;
    rst <= '0';

    wait for 3000 ns;
    wait;
end process;

process(clk)
begin
    if rising_edge(clk) then
        if rst = '1' then
            store_count <= 0;
        else
            if memwrite_o = '1' then
                store_count <= store_count + 1;
            end if;
        end if;
    end if;
end process;

end architecture;
