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

      -- I-type
      when "00" =>
        imm := resize(signed(instr(31 downto 20)), 32);

      -- S-type
      when "01" =>
        imm := resize(signed(instr(31 downto 25) & instr(11 downto 7)), 32);

      -- B-type
      when "10" =>
        imm := resize(signed(instr(31) & instr(30 downto 25) & instr(11 downto 8) & instr(7) & '0'), 32);

      -- U-type
      when "11" =>
        imm := signed(instr(31 downto 12) & x"000");

      when others =>
        imm := (others => '0');

    end case;

    immext <= std_logic_vector(imm);
  end process;
end architecture;
