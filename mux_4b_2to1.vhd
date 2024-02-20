library ieee;
use ieee.std_logic_1164.all;
entity mux_4b_2to1 is
    port(
        S : in std_logic_vector(3 downto 0);
        A : in std_logic_vector(3 downto 0);
        Z : in std_logic;
        mux_out : out std_logic_vector(3 downto 0)
    );
end mux_4b_2to1;
architecture mux of mux_4b_2to1 is
begin
    --acts as a 4bit 2 to 1 mux
    mux_out(0) <= ((not Z) and S(0)) or (Z and A(0));
    mux_out(1) <= ((not Z) and S(1)) or (Z and A(1));
    mux_out(2) <= ((not Z) and S(2)) or (Z and A(2));
    mux_out(3) <= ((not Z) and S(3)) or (Z and A(3));
end mux;