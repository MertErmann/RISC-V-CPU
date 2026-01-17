library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity control_unit is
    port(
        instr       : in  std_logic_vector(31 downto 0);
        alu_zero    : in  std_logic;
        pcsrc       : out std_logic;
        resultsrc   : out std_logic;
        memwrite    : out std_logic;
        alucontrol  : out std_logic_vector(3 downto 0);
        alusrc      : out std_logic;
        immsrc      : out std_logic_vector(1 downto 0);
        regwrite    : out std_logic
    );
end entity;

architecture rtl of control_unit is
    signal opcode : std_logic_vector(6 downto 0);
    signal funct3 : std_logic_vector(2 downto 0);
    signal funct7 : std_logic_vector(6 downto 0);

    constant OP_RTYPE  : std_logic_vector(6 downto 0) := "0110011";
    constant OP_ITYPE  : std_logic_vector(6 downto 0) := "0010011";
    constant OP_LOAD   : std_logic_vector(6 downto 0) := "0000011";
    constant OP_STORE  : std_logic_vector(6 downto 0) := "0100011";
    constant OP_BRANCH : std_logic_vector(6 downto 0) := "1100011";
    constant OP_JAL    : std_logic_vector(6 downto 0) := "1101111";

    constant ALU_ADD : std_logic_vector(3 downto 0) := "0000";
    constant ALU_SUB : std_logic_vector(3 downto 0) := "0001";
    constant ALU_AND : std_logic_vector(3 downto 0) := "0010";
    constant ALU_OR  : std_logic_vector(3 downto 0) := "0011";
    constant ALU_XOR : std_logic_vector(3 downto 0) := "0100";
    constant ALU_SLT : std_logic_vector(3 downto 0) := "0101";
    constant ALU_SLL : std_logic_vector(3 downto 0) := "0110";
    constant ALU_SRL : std_logic_vector(3 downto 0) := "0111";
    constant ALU_SRA : std_logic_vector(3 downto 0) := "1000";
begin
    opcode <= instr(6 downto 0);
    funct3 <= instr(14 downto 12);
    funct7 <= instr(31 downto 25);

    process(opcode, funct3, funct7, alu_zero)
        variable take_branch : std_logic;
    begin
        -- defaults
        regwrite   <= '0';
        memwrite   <= '0';
        resultsrc  <= '0';
        alusrc     <= '0';
        immsrc     <= "00";
        alucontrol <= ALU_ADD;
        pcsrc      <= '0';

        case opcode is
            when OP_RTYPE =>
                regwrite  <= '1';
                alusrc    <= '0';
                resultsrc <= '0';
                case funct3 is
                    when "000" =>
                        if funct7 = "0100000" then alucontrol <= ALU_SUB;
                        else                         alucontrol <= ALU_ADD;
                        end if;
                    when "111" => alucontrol <= ALU_AND;
                    when "110" => alucontrol <= ALU_OR;
                    when "100" => alucontrol <= ALU_XOR;
                    when "010" => alucontrol <= ALU_SLT;
                    when "001" => alucontrol <= ALU_SLL;
                    when "101" =>
                        if funct7 = "0100000" then alucontrol <= ALU_SRA;
                        else                         alucontrol <= ALU_SRL;
                        end if;
                    when others => alucontrol <= ALU_ADD;
                end case;

            when OP_ITYPE =>
                regwrite  <= '1';
                alusrc    <= '1';
                resultsrc <= '0';
                immsrc    <= "00";
                case funct3 is
                    when "000" => alucontrol <= ALU_ADD;
                    when "111" => alucontrol <= ALU_AND;
                    when "110" => alucontrol <= ALU_OR;
                    when "100" => alucontrol <= ALU_XOR;
                    when "010" => alucontrol <= ALU_SLT;
                    when "001" => alucontrol <= ALU_SLL;
                    when "101" =>
                        if funct7 = "0100000" then alucontrol <= ALU_SRA;
                        else                         alucontrol <= ALU_SRL;
                        end if;
                    when others => alucontrol <= ALU_ADD;
                end case;

            when OP_LOAD =>
                regwrite   <= '1';
                alusrc     <= '1';
                resultsrc  <= '1';
                immsrc     <= "00";
                alucontrol <= ALU_ADD;

            when OP_STORE =>
                memwrite   <= '1';
                alusrc     <= '1';
                immsrc     <= "01";
                alucontrol <= ALU_ADD;

            when OP_BRANCH =>
                alusrc     <= '0';
                immsrc     <= "10";
                alucontrol <= ALU_SUB;

                take_branch := '0';
                if funct3 = "000" then           -- BEQ
                    if alu_zero = '1' then take_branch := '1'; end if;
                elsif funct3 = "001" then        -- BNE
                    if alu_zero = '0' then take_branch := '1'; end if;
                else
                    take_branch := '0';
                end if;

                pcsrc <= take_branch;

            when OP_JAL =>
                immsrc   <= "11";
                pcsrc    <= '1';
                regwrite <= '1';  -- jal rd, imm (ama sen resultsrc PC+4 yapmadığın için şimdilik rd anlamsız)

            when others =>
                null;
        end case;

    end process;

end architecture;
