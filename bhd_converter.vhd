LIBRARY ieee;
USE ieee.std_logic_1164.all;
ENTITY bhd_converter IS
  PORT (
    S : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    hex_display_zero : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
    hex_display_one : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
    hex_display_two : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
    );
END bhd_converter;
ARCHITECTURE converter OF bhd_converter IS
    component display_decoder is
        PORT (
            S : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
            hex_out : OUT STD_LOGIC_Vector(6 DOWNTO 0)
            );
    end component;
    component circuit_a is 
        port(
            S : in STD_LOGIC_VECTOR(3 DOWNTO 0);
            A : out STD_LOGIC_VECTOR(3 DOWNTO 0)
        );
    end component;
    component comparator is
        port(
            S : in std_logic_vector(3 downto 0);
            Z : out std_logic
        );
    end component;
    component circuit_b is
        port(
            Z : in std_logic;
            B : out std_logic_vector(3 downto 0)
        );
    end component;
    component mux_4b_2to1 is
        port(
            S : in std_logic_vector(3 downto 0);
            A : in std_logic_vector(3 downto 0);
            Z : in std_logic;
            mux_out : out std_logic_vector(3 downto 0)
        );
    end component;
    signal A_out : std_logic_vector(3 downto 0);
    signal Z_out : std_logic;
    signal B_out : std_logic_vector(3 downto 0);
    signal MUX_out : std_logic_vector(3 downto 0);
BEGIN
    CIRCA : circuit_a port map(S => S, A => A_out);
    COMP : comparator port map(S => S, Z => Z_out);
    CIRCB : circuit_b port map(Z => Z_out, B => B_out);
    MUX : mux_4b_2to1 port map(S => S, A => A_out, Z => Z_out, mux_out => MUX_out);
    HEX0 : display_decoder port map (S => MUX_out, hex_out => hex_display_zero); --0 to 9
    HEX1 : display_decoder port map (S => B_out, hex_out => hex_display_one);  --0 or 1
    HEX2 : display_decoder port map (S => S, hex_out => hex_display_two); --hex form
END converter;