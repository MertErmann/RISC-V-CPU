library ieee;
use ieee.std_logic_1164.all;

entity tb_fibonacci is
end entity;

architecture sim of tb_fibonacci is

    -- Signals
    signal clk            : std_logic := '0';
    signal rst            : std_logic := '1';
    
    -- Outputs from DUT
    signal pc_o           : std_logic_vector(31 downto 0);
    signal instr_o        : std_logic_vector(31 downto 0);
    signal memwrite_o     : std_logic;
    signal memaddr_o      : std_logic_vector(31 downto 0);
    signal memwd_o        : std_logic_vector(31 downto 0);
    signal reg_write_data : std_logic_vector(31 downto 0);
    signal reg_write_en   : std_logic;

begin

    -- DUT Instantiation
    uut: entity work.riscv_singlecycle_top_dbg
    port map(
        clk              => clk,
        rst              => rst,
        pc_o             => pc_o,
        instr_o          => instr_o,
        memwrite_o       => memwrite_o,
        memaddr_o        => memaddr_o,
        memwd_o          => memwd_o,
        reg_write_data_o => reg_write_data,
        reg_write_en_o   => reg_write_en
    );

    -- Clock Generation (100 MHz)
    process
    begin
        while true loop
            clk <= '0';
            wait for 5 ns;
            clk <= '1';
            wait for 5 ns;
        end loop;
    end process;

    -- Reset Logic
    process
    begin
        rst <= '1';             
        wait for 20 ns;         
        rst <= '0';             
        wait for 5000 ns; -- Run long enough for Fibonacci loop
        wait;                   
    end process;

end architecture;
