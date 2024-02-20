library ieee;
use ieee.std_logic_1164.all;
entity circuit_b is
    port(
        Z : in std_logic;
        B : out std_logic_vector(3 downto 0)
    );
end circuit_b;
architecture b of circuit_b is
begin
    -- from bhd_converter lab
    B(0) <= Z;
    B(1) <= '0';
    B(2) <= '0';
    B(3) <= '0';
end b;