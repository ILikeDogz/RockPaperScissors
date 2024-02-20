library ieee;
use ieee.std_logic_1164.all;
entity comparator is
    port(
        S : in std_logic_vector(3 downto 0);
        Z : out std_logic
    );
end comparator;
architecture greater_than_nine of comparator is
begin --compares if provided in is greater than 9 or not
    Z <= S(3) and (S(2) or S(1));
end greater_than_nine;