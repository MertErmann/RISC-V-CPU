library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity alu is
    port(
        alu_ctrl : in std_logic_vector(2 downto 0);
        srca     : in std_logic_vector(31 downto 0);
        srcb     : in std_logic_vector(31 downto 0);
        alu_rslt : out std_logic_vector(31 downto 0)
    );
end entity;

architecture RTL of alu is

signal res_r : std_logic_vector(31 downto 0);

begin
process(srca , srcb, alu_ctrl)

variable a_signed 	    : signed(31 downto 0);
variable b_signed 	    : signed(31 downto 0);
variable a_unsigned     : unsigned(31 downto 0);
variable b_unsigned     : unsigned(31 downto 0);
variable r         	    : std_logic_vector(31 downto 0);

begin

a_signed   := signed(srca); 
b_signed   := signed(srcb);
a_unsigned := unsigned(srca); 
b_unsigned := unsigned(srcb);
r 		   := (others => '0');

case alu_ctrl is
    
    when "000" =>
        r := std_logic_vector(a_signed + b_signed);
    
        when others => 
		r := (others => '0'); 
	
end case;

    res_r <= r;
end process;

alu_rslt <= res_r;
end architecture;