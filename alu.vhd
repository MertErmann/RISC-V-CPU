library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity alu is
    port(
        alu_ctrl : in std_logic_vector(3 downto 0);
        srca     : in std_logic_vector(31 downto 0);
        srcb     : in std_logic_vector(31 downto 0);
        alu_rslt : out std_logic_vector(31 downto 0);
        alu_zero : out std_logic
    );
end entity;

architecture RTL of alu is
begin
process(srca , srcb, alu_ctrl)

variable a_signed      : signed(31 downto 0);
variable b_signed      : signed(31 downto 0);
variable a_unsigned    : unsigned(31 downto 0);
variable b_unsigned    : unsigned(31 downto 0);
variable r             : std_logic_vector(31 downto 0);
variable shamt         : integer;

begin

a_signed   := signed(srca); 
b_signed   := signed(srcb);
a_unsigned := unsigned(srca); 
b_unsigned := unsigned(srcb);
shamt      := to_integer(unsigned(srcb(4 downto 0)));
r          := (others => '0');

case alu_ctrl is
    
    when "0000" =>
        r := std_logic_vector(a_signed + b_signed);

    when "0001" =>
        r := std_logic_vector(a_signed - b_signed);

    when "0010" =>
        r := srca and srcb;

    when "0011" =>
        r := srca or srcb;

    when "0100" =>
        r := srca xor srcb;

    when "0101" =>
        if a_signed < b_signed then
            r := (31 downto 1 => '0') & '1';
        else
            r := (others => '0');
        end if;

    when "0110" =>
        r := std_logic_vector(shift_left(a_unsigned, shamt));

    when "0111" =>
        r := std_logic_vector(shift_right(a_unsigned, shamt));

    when "1000" =>
        r := std_logic_vector(shift_right(a_signed, shamt));
    
    when others => 
        r := (others => '0'); 
	
end case;

alu_rslt <= r;

if r = x"00000000" then
    alu_zero <= '1';
else
    alu_zero <= '0';
end if;

end process;

end architecture;
