library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity alu is
    port(
        alu_ctrl : in std_logic_vector(2 downto 0);
        srca     : in std_logic_vector(31 downto 0);
        srcb     : in std_logic_vector(31 downto 0);
        alu_rslt : out std_logic_vector(31 downto 0);
        alu_zero : out std_logic
    );
end entity;

architecture RTL of alu is

signal res_r : std_logic_vector(31 downto 0);

begin
process(srca , srcb, alu_ctrl)

variable a_signed      : signed(31 downto 0);
variable b_signed      : signed(31 downto 0);
variable a_unsigned    : unsigned(31 downto 0);
variable b_unsigned    : unsigned(31 downto 0);
variable r             : std_logic_vector(31 downto 0);
variable shamt         : integer range 0 to 31;

begin

a_signed   := signed(srca); 
b_signed   := signed(srcb);
a_unsigned := unsigned(srca); 
b_unsigned := unsigned(srcb);
shamt      := to_integer(unsigned(srcb(4 downto 0)));
r          := (others => '0');

case alu_ctrl is
    
    when "000" =>
        r := std_logic_vector(a_signed + b_signed);

    when "001" =>
        r := std_logic_vector(a_signed - b_signed);

    when "010" =>
        r := srca and srcb;

    when "011" =>
        r := srca or srcb;

    when "100" =>
        r := srca xor srcb;

    when "101" =>
        if a_signed < b_signed then
            r := (31 downto 1 => '0') & '1';
        else
            r := (others => '0');
        end if;

    when "110" =>
        r := std_logic_vector(shift_left(a_unsigned, shamt));

    when "111" =>
        r := std_logic_vector(shift_right(a_unsigned, shamt));
    
    when others => 
        r := (others => '0'); 
	
end case;

res_r <= r;
end process;

alu_rslt <= res_r;
alu_zero <= '1' when res_r = x"00000000" else '0';

end architecture;
