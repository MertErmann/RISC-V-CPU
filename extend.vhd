library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity extend is
port(
  instr   : in  std_logic_vector(31 downto 0);
  immsrc  : in  std_logic_vector(1 downto 0);
  immext  : out std_logic_vector(31 downto 0)
);
end entity;

architecture RTL of extend is
begin
process(instr, immsrc)
variable imm : signed(31 downto 0);

begin
    case immsrc is

      when "00" =>
        imm := resize(signed(instr(31 downto 20)), 32);

      when "01" =>
        imm := resize(signed(instr(31 downto 25) & instr(11 downto 7)), 32);

      when "10" =>
        imm := resize(signed(instr(31) & instr(7) & instr(30 downto 25) & instr(11 downto 8) & '0'), 32);

      when "11" =>
        imm := resize(signed(instr(31) & instr(19 downto 12) & instr(20) & instr(30 downto 21) & '0'), 32);

      when others =>
        imm := (others => '0');

    end case;

immext <= std_logic_vector(imm);
end process;
end architecture;
