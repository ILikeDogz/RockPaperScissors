library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity twenty_six_bit_counter is
    Port (
        clk_counter : in STD_LOGIC;
        enable : in std_logic;
        reset_counter : in STD_LOGIC;
        count_out : out STD_LOGIC_VECTOR(25 downto 0)
    );
end twenty_six_bit_counter;

architecture Behavioral of twenty_six_bit_counter is
    component T_Flip_Flop is
        port (
            T : in std_logic;
            clear : in std_logic;
            clock : in std_logic;
            Q : out std_logic);
        end component;
    signal t_internal : STD_LOGIC_VECTOR(25 downto 0);
    signal q_internal : STD_LOGIC_VECTOR(25 downto 0);
begin
    -- for loops are magical, uses tff to create a 26 bit counter
    my_counter: for i in 0 to 25 generate
        my_DFF : T_Flip_Flop port map (T => t_internal(i), clear => reset_counter, clock => clk_counter, Q => q_internal(i));
    end generate my_counter;
    t_internal(0) <= enable;
    process(q_internal, t_internal)
        begin
            for i in 1 to 25 loop
                t_internal(i) <= q_internal(i-1) and t_internal(i-1);
            end loop;
    end process;
    count_out <= q_internal;
end Behavioral;
