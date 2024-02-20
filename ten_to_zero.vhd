library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ten_to_zero is
    Port ( clock : in STD_LOGIC;
           reset : in STD_LOGIC;
           finished : out std_logic; --counter has hit 0
           count : out STD_LOGIC_VECTOR(3 downto 0) --count in binary
           );
end ten_to_zero;

architecture Behavioral of ten_to_zero is
    signal counter : STD_LOGIC_VECTOR(3 downto 0) := "1010"; -- Initial value is 10 in binary

begin
    process(clock, reset)
    begin
        if reset = '0' then
            counter <= "1010"; --resets to 10
        elsif rising_edge(clock) then
            if counter /= "0000" then
                counter <= counter - '1';
                finished <= '0';
            else
                counter <= "0000";
                finished <= '1';
            end if;
        end if;
    end process;
    count <= counter;
end Behavioral;
