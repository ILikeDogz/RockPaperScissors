--based code off of lecture 
library IEEE;
use IEEE.std_logic_1164.all;

entity T_Flip_Flop is
	port (T : in std_logic;
			clear : in std_logic;
			clock : in std_logic;
			Q : out std_logic);
end T_Flip_Flop;

architecture My_T_Flip_Flop of T_Flip_Flop is

signal NewQ : std_logic;

begin
	tff: process (clear,clock)
	begin
		if (clear = '0') then	--Is 0 in order to represent the active low
			NewQ <= '0';
		elsif (rising_edge(clock)) then			
			if (T = '0') then
			NewQ <= NewQ;
			elsif (T = '1') then
			NewQ <= NOT(NewQ);
		end if;
		end if;
		Q <= NewQ;
	end process tff;
end My_T_Flip_Flop;