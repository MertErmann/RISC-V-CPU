library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_fibonacci is
end entity;

architecture sim of tb_fibonacci is

signal clk      : std_logic := '0';
signal rst      : std_logic := '1';

signal dbg_addr : std_logic_vector(31 downto 0) := (others => '0');
signal dbg_rd   : std_logic_vector(31 downto 0);

type fib_arr_t is array (0 to 9) of integer;
constant fib : fib_arr_t := (0,1,1,2,3,5,8,13,21,34);

begin

clk <= not clk after 5 ns;

uut: entity work.riscv_singlecycle_top
port map(
    clk      => clk,
    rst      => rst,
    dbg_addr => dbg_addr,
    dbg_rd   => dbg_rd
);

process
    variable v : integer;
begin
    rst <= '1';
    wait for 20 ns;
    rst <= '0';

    wait for 1500 ns;

    for i in 0 to 9 loop
        dbg_addr <= std_logic_vector(to_unsigned(i*4, 32));
        wait for 10 ns;
        v := to_integer(unsigned(dbg_rd));

        assert v = fib(i)
            report "FIB FAIL idx=" & integer'image(i) &
                   " expected=" & integer'image(fib(i)) &
                   " got=" & integer'image(v)
            severity failure;
    end loop;

    assert false report "PASS: Fibonacci stored correctly (10 values)" severity failure;
end process;

end architecture;
