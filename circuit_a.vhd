library ieee;
use ieee.std_logic_1164.all;
entity circuit_a is
    port(
        S : in STD_LOGIC_VECTOR(3 DOWNTO 0);
        A : out STD_LOGIC_VECTOR(3 DOWNTO 0)
    );
end circuit_a;
architecture a of circuit_a is
begin
    --handles part of the circuit for the bhd converter, from bhd_converter lab
    A(3) <= '0';
    A(2) <= S(2) and S(1);
    A(1) <= not S(1);
    A(0) <= S(0);
end a;