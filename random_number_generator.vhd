library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
entity random_number_generator is
    Port (
        release : in std_logic;
        clock : in std_logic;
        reset : in std_logic;
        number : out std_logic_vector(1 downto 0)
    );
end random_number_generator;

architecture Behavioral of random_number_generator is
    signal random_value : integer range 0 to 2 := 0; -- Initialize with any value between 1 and 3
    signal random_output : std_logic_vector(1 downto 0);
begin
    process(clock, reset)
    begin
        if reset = '0' then
            random_value <= 0; --resets the value
        elsif rising_edge(clock) then 
            random_value <= (random_value + 1) mod 3; -- Increment the value with each clock cycle and take the modulus
        end if;
    end process;
    process(random_value)
    begin
        case random_value is
            when 0 =>
                random_output <= "01";
            when 1 =>
                random_output <= "10";
            when others =>
                random_output <= "11";
        end case;
    end process;  
    process(release)
    begin
        if release = '1' then
            number <= random_output; --gives out the random number when ready, it is already calculated though
            --the user input and the clock cycle are the only forms of entropy that can really be obtained on the fpga, thus to do a more complicated algorithim would be quite pointless
        else
            number <= "00";
        end if;
    end process;
end Behavioral;
