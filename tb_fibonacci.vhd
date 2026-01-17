library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_fibonacci is
end entity;

architecture sim of tb_fibonacci is

    signal clk   : std_logic := '0';
    signal rst   : std_logic := '1';

    signal pc_o       : std_logic_vector(31 downto 0);
    signal instr_o    : std_logic_vector(31 downto 0);

    signal memwrite_o : std_logic;
    signal memaddr_o  : std_logic_vector(31 downto 0);
    signal memwd_o    : std_logic_vector(31 downto 0);

    signal reg_write_data_o : std_logic_vector(31 downto 0);
    signal reg_write_en_o   : std_logic;

begin

    -- DUT
    dut: entity work.riscv_singlecycle_top_dbg
    port map(
        clk => clk,
        rst => rst,

        pc_o    => pc_o,
        instr_o => instr_o,

        memwrite_o => memwrite_o,
        memaddr_o  => memaddr_o,
        memwd_o     => memwd_o,

        reg_write_data_o => reg_write_data_o,
        reg_write_en_o   => reg_write_en_o
    );

    ------------------------------------------------------------------
    -- CLOCK: 100 ns period  (50ns high, 50ns low)
    ------------------------------------------------------------------
    clk <= not clk after 50 ns;

    ------------------------------------------------------------------
    -- RESET + RUN
    ------------------------------------------------------------------
    process
    begin
        -- reset 2 cycle
        rst <= '1';
        wait for 200 ns;
        rst <= '0';

        -- run long enough
        wait for 5000 ns;

        report "SIM DONE" severity failure;
    end process;

end architecture;
