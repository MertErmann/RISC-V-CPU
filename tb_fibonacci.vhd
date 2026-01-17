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
    signal reg_write_data : std_logic_vector(31 downto 0);
    signal reg_write_en   : std_logic;

    signal store_count     : integer := 0;
    signal expected_fib_o  : std_logic_vector(31 downto 0);

begin

    -- 100 MHz clock (10 ns period)
    clk <= not clk after 5 ns;

    uut: entity work.riscv_singlecycle_top_dbg
    port map(
        clk             => clk,
        rst             => rst,
        pc_o            => pc_o,
        instr_o         => instr_o,
        memwrite_o      => memwrite_o,
        memaddr_o       => memaddr_o,
        memwd_o         => memwd_o,
        reg_write_data_o=> reg_write_data,
        reg_write_en_o  => reg_write_en
    );

    -- expected fibonacci based on current store_count
    process(store_count)
        variable v   : integer;
        variable idx : integer;
    begin
        idx := store_count;  -- FIX: +1 yok

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

    -- reset + sim time
    process
    begin
        rst <= '1';
        wait for 30 ns;
        rst <= '0';

        wait for 3000 ns;
        wait;
    end process;

    -- count stores + (opsiyonel) kontrol mesajı
    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                store_count <= 0;
            else
                if memwrite_o = '1' then
                    -- burada store_count bu store'un index'i (0,1,2...)
                    -- istersen assertion ile kontrol:
                    assert memwd_o = expected_fib_o
                        report "FIB MISMATCH! idx=" & integer'image(store_count) &
                               " expected=" & integer'image(to_integer(unsigned(expected_fib_o))) &
                               " got=" & integer'image(to_integer(unsigned(memwd_o)))
                        severity error;

                    -- dalgada görmek için info:
                    report "STORE idx=" & integer'image(store_count) &
                           " fib=" & integer'image(to_integer(unsigned(memwd_o)))
                        severity note;

                    store_count <= store_count + 1;
                end if;
            end if;
        end if;
    end process;

end architecture;
