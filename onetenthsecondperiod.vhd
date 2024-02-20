library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
entity onetenthsecondperiod is
    Port (
        clk_50Mhz : in STD_LOGIC;
        enable : in STD_LOGIC;
        clock_out : out std_logic
    );
end onetenthsecondperiod;
architecture Behavioral of onetenthsecondperiod is
    component twenty_six_bit_counter is
        Port (
            clk_counter : in STD_LOGIC;
            enable : in std_logic;
            reset_counter : in STD_LOGIC;
            count_out : out STD_LOGIC_VECTOR(25 downto 0)
        );
    end component;
    signal fast_count : STD_LOGIC_VECTOR(25 downto 0);
    signal internal : STD_LOGIC := '1';
begin
    fast_counter : twenty_six_bit_counter port map(clk_counter => clk_50Mhz, enable => enable, reset_counter => internal, count_out => fast_count);
    ToggleEnable : process(fast_count)
    begin
        if fast_count = "00010011000100101101000000" then --this is the number that control the period, in this case should be 1/10th seconds
            clock_out <= '1';
        elsif (fast_count = "00010011000100101101000001") then 
        --I need clock_out to remain 1 for atleast 1 cycle so it can be used, otherwise it returns to 0 quicker than the input clock
            internal <= '0';
        else
            clock_out <= '0';
            internal <= '1';
        end if;
    end process ToggleEnable;
end Behavioral;