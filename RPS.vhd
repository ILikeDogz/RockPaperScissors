LIBRARY ieee;
USE ieee.std_logic_1164.all;
ENTITY RPS IS
  PORT (
  A : IN STD_LOGIC_VECTOR(1 DOWNTO 0); --player 1
  B : IN STD_LOGIC_VECTOR(1 DOWNTO 0); --player 2
  WA : OUT STD_LOGIC; --A wins
  WB : OUT STD_LOGIC; --B wins
  E : OUT STD_LOGIC --Error
  );
END RPS;
ARCHITECTURE comb OF RPS IS
BEGIN
  WA   <= (A(1) xor B(0)) or (((A(0) xor B(1)) and B(0)) xor B(0)); --handles player 1 win conditions
  WB   <= (A(0) xor B(1)) or (((A(1) xor B(0)) and B(1)) xor B(1)); --handles player 2 win conditions
  E    <= (A(1) nor A(0)) or (B(1) nor B(0)); --handles error cases
END comb;