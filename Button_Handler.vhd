library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
entity Button_Handler is
    Port ( clk : in STD_LOGIC;
           btn1 : in STD_LOGIC;
           btn2 : in STD_LOGIC;
           btns : out STD_LOGIC_VECTOR(1 downto 0));
end Button_Handler;
architecture Behavioral of Button_Handler is
    signal btn_state : STD_LOGIC_VECTOR(1 downto 0) := "00";
--just converts the active low buttons to an active high signal
begin
    process(clk)
    begin
        if rising_edge(clk) then
            -- Button 1 handling
            if btn1 = '0' then
                btn_state(0) <= '1';
            else
                btn_state(0) <= '0';
            end if;
            -- Button 2 handling
            if btn2 = '0' then
                btn_state(1) <= '1';
            else
                btn_state(1) <= '0';
            end if;
            -- Output LEDs with binary value of combined button states
            btns <= btn_state;
        end if;
    end process;
end Behavioral;
