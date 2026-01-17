library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity riscv_singlecycle_top_dbg is
    port(
        clk         : in  std_logic;
        rst         : in  std_logic;

        pc_o        : out std_logic_vector(31 downto 0);
        instr_o     : out std_logic_vector(31 downto 0);

        memwrite_o  : out std_logic;
        memaddr_o   : out std_logic_vector(31 downto 0);
        memwd_o     : out std_logic_vector(31 downto 0)
    );
end entity;

architecture RTL of riscv_singlecycle_top_dbg is

signal pc         : std_logic_vector(31 downto 0);
signal pcnext     : std_logic_vector(31 downto 0);
signal pc_plus4   : std_logic_vector(31 downto 0);
signal pctarget   : std_logic_vector(31 downto 0);

signal instr      : std_logic_vector(31 downto 0);

signal rs1        : std_logic_vector(4 downto 0);
signal rs2        : std_logic_vector(4 downto 0);
signal rd         : std_logic_vector(4 downto 0);

signal rd1        : std_logic_vector(31 downto 0);
signal rd2        : std_logic_vector(31 downto 0);

signal imm_ext    : std_logic_vector(31 downto 0);

signal srcb       : std_logic_vector(31 downto 0);
signal alu_result : std_logic_vector(31 downto 0);
signal alu_zero   : std_logic;

signal read_data  : std_logic_vector(31 downto 0);

signal wb_pre     : std_logic_vector(31 downto 0);
signal wb_data    : std_logic_vector(31 downto 0);

signal pcsrc      : std_logic;
signal resultsrc  : std_logic;
signal memwrite   : std_logic;
signal alusrc_b   : std_logic;
signal regwrite   : std_logic;
signal alucontrol : std_logic_vector(3 downto 0);
signal immsrc     : std_logic_vector(1 downto 0);

signal is_jal     : std_logic;

begin

pc_o       <= pc;
instr_o    <= instr;
memwrite_o <= memwrite;
memaddr_o  <= alu_result;
memwd_o    <= rd2;

rs1 <= instr(19 downto 15);
rs2 <= instr(24 downto 20);
rd  <= instr(11 downto 7);

is_jal <= '1' when instr(6 downto 0) = "1101111" else '0';

u_pc: entity work.program_counter
port map(
    clk     => clk,
    rst     => rst,
    pc_next => pcnext,
    pc      => pc
);

u_imem: entity work.instruction_memory
port map(
    addr  => pc,
    instr => instr
);

u_pcplus4: entity work.pc_plus4
port map(
    pc       => pc,
    pc_plus4 => pc_plus4
);

u_extend: entity work.extend
port map(
    instr  => instr,
    immsrc => immsrc,
    immext => imm_ext
);

u_pctarget: entity work.pc_target
port map(
    imm_ext       => imm_ext,
    pc            => pc,
    pc_target_out => pctarget
);

u_pcnext: entity work.pc_next
port map(
    pcsrc    => pcsrc,
    pcplus4  => pc_plus4,
    pctarget => pctarget,
    pcnext   => pcnext
);

u_control: entity work.control_unit
port map(
    instr      => instr,
    alu_zero   => alu_zero,
    pcsrc      => pcsrc,
    resultsrc  => resultsrc,
    memwrite   => memwrite,
    alucontrol => alucontrol,
    alusrc     => alusrc_b,
    immsrc     => immsrc,
    regwrite   => regwrite
);

u_rf: entity work.register_file
port map(
    clk => clk,
    we3 => regwrite,
    wd3 => wb_data,
    a1  => rs1,
    a2  => rs2,
    rd  => rd,
    rd1 => rd1,
    rd2 => rd2
);

u_alusrc: entity work.alusrc
port map(
    alusrc_b => alusrc_b,
    imm_ext  => imm_ext,
    rd2_ext  => rd2,
    srcb     => srcb
);

u_alu: entity work.alu
port map(
    alu_ctrl => alucontrol,
    srca     => rd1,
    srcb     => srcb,
    alu_rslt => alu_result,
    alu_zero => alu_zero
);

u_dmem: entity work.Data_Memory
port map(
    clk        => clk,
    we         => memwrite,
    alu_result => alu_result,
    wd         => rd2,
    rd         => read_data
);

u_wbmux: entity work.resultsrc_mux
port map(
    alu_result => alu_result,
    read_data  => read_data,
    resultsrc  => resultsrc,
    result     => wb_pre
);

wb_data <= pc_plus4 when is_jal = '1' else wb_pre;

end architecture;
