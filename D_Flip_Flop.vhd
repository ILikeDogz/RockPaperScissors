library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity D_Flip_Flop is
    Port (
        D : in STD_LOGIC;
        reset : in STD_LOGIC;
        clk : in STD_LOGIC;
        Q : out STD_LOGIC
    );
end D_Flip_Flop;

architecture Behavioral of D_Flip_Flop is
begin
    process(reset, clk)
        begin
            if(reset = '0') then --async active low reset
                Q <= '0';
            elsif(rising_edge(clk)) then
                Q <= D; 
        end if;
    end process;
end Behavioral;