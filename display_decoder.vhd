LIBRARY ieee;
USE ieee.std_logic_1164.all;
ENTITY display_decoder IS
  PORT (
    S : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    hex_out : OUT STD_LOGIC_Vector(6 DOWNTO 0)
    );
END display_decoder;
ARCHITECTURE decoder OF display_decoder IS
BEGIN
    -- segment A
    hex_out(0) <= ((S(3) nor S(1)) and (S(2) xor S(0))) or (S(3) and S(0) and (S(2) xor S(1)));
    -- segment B
    hex_out(1) <= (S(3) and S(1) and S(0)) or (S(2) and S(1) and (not S(0))) or (S(3) and S(2) and (not S(1)) and (not S(0))) or ((not S(3)) and S(2) and (not S(1)) and S(0));
    -- segment C
    hex_out(2) <= (S(1) and (not S(0)) and (S(3) xnor S(2))) or (S(3) and S(2) and (S(1) xnor S(0)));
    -- segment D
    hex_out(3) <= ((S(3) nor S(1)) and (S(2) xor S(0))) or (S(2) and S(1) and S(0)) or (S(3) and (not S(2)) and S(1) and (not S(0)));
    -- segment E
    hex_out(4) <= ((not S(3)) and S(0)) or ((S(2) nor S(1)) and S(0)) or ((not S(3)) and S(2) and (not S(1)));
    -- segment F
    hex_out(5) <= ((S(3) nor S(2)) and (S(0) or S(1))) or (S(2) and S(0) and (S(3) xor S(1)));
    -- segment G
    hex_out(6) <= (not (S(3) or S(2) or S(1))) or ((not S(3)) and S(2) and S(1) and S(0)) or (S(3) and S(2) and (S(1) nor S(0)));
END decoder;    