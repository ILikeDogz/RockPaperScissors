library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.math_real.all;
entity one_player_rps is
    Port (
        A : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        reset : in STD_LOGIC;
        enable : in STD_LOGIC;
        clock : in STD_LOGIC;
        B : out std_logic_vector(3 downto 0);
        WA : OUT STD_LOGIC;
        WB : OUT STD_LOGIC;
        E : OUT STD_LOGIC;
        count_hex_zero : out STD_LOGIC_VECTOR(6 downto 0);
        count_hex_one : out STD_LOGIC_VECTOR(6 downto 0)
    );
end one_player_rps;

architecture Behavioral of one_player_rps is
    component RPS IS
        PORT (
        A : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        B : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        WA : OUT STD_LOGIC;
        WB : OUT STD_LOGIC;
        E : OUT STD_LOGIC
        );
    end component;
    component ten_to_zero is
        Port ( 
            clock : in STD_LOGIC;
            reset : in STD_LOGIC;
            finished : out std_logic;
            count : out STD_LOGIC_VECTOR(3 downto 0)
            );
    end component;
    component clock_speed_slower is
        Port (
            clk_50Mhz : in STD_LOGIC;
            enable : in STD_LOGIC;
            clock_out : out std_logic
        );
    end component;
    component random_number_generator is
        Port (
            release : in std_logic;
            clock : in std_logic;
            reset : in std_logic;
            number : out std_logic_vector(1 downto 0)
        );
    end component;
    component bhd_converter IS
    PORT (
        S : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        hex_display_zero : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
        hex_display_one : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
        hex_display_two : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
        );
    END component;
    component D_Flip_Flop is
        Port (
            D : in STD_LOGIC;
            reset : in STD_LOGIC;
            clk : in STD_LOGIC;
            Q : out STD_LOGIC
        );
    end component;
    component debounce is
        Port (
            clk : in STD_LOGIC;
            button : in STD_LOGIC;
            result : out STD_LOGIC
        );
    end component;
    component onetenthsecondperiod is
        Port (
            clk_50Mhz : in STD_LOGIC;
            enable : in STD_LOGIC;
            clock_out : out std_logic
        );
    end component;
    component Button_Handler is
        Port ( clk : in STD_LOGIC;
               btn1 : in STD_LOGIC;
               btn2 : in STD_LOGIC;
               btns : out STD_LOGIC_VECTOR(1 downto 0));
    end component;
    
    signal internal_clock : std_logic; --clock for countdown
    signal user_input : STD_LOGIC_VECTOR(1 DOWNTO 0); --player 1 signal
    signal random_input : STD_LOGIC_VECTOR(1 DOWNTO 0) := "00"; --player 2 signal
    signal start_game : std_logic; --signals when to start game
    signal release : std_logic := '0'; --activates random number
    signal p1, p2, err : std_logic; --temp signals that hold results from rps
    signal count : std_logic_vector(3 downto 0); --handles the count
    signal D_sig : std_logic_vector(6 downto 0) := "0000000"; --flip flop signal
    signal Q_sig : std_logic_vector(6 downto 0) := "0000000"; --flip flop signal
    signal internal_enable : std_logic := '1'; --activates button processing clock, active by default
    signal enabled_clock : std_logic; --activates flip flops
    signal button_internal : std_logic_vector (1 downto 0); --signal to handle debounced buttons
    signal trash : std_logic_vector(6 downto 0); -- won't be used, easier to just discard than rewrite the bhd converter
    begin
    slow_period : clock_speed_slower port map(clk_50Mhz => clock, enable => enable, clock_out => internal_clock); --handles countdown clock
    button_clock: onetenthsecondperiod port map(clk_50Mhz => clock, enable => internal_enable, clock_out => enabled_clock); --handles clock that processes inputs
    rng : random_number_generator port map(release => release, clock => clock, reset => reset, number => random_input); --handles rng
    rock_paper_scissors : RPS port map (A => user_input, B => random_input, WA => p1, WB => p2, E => err); --handles the actual rock paper scissor game
    count_down : ten_to_zero port map (clock => internal_clock, reset => reset, finished => start_game, count => count); --is the count down from 10 to 0
    btn1_debounce : debounce Port map (clk => clock, button => A(0), result => button_internal(0)); --debounce inputs
    btn2_debounce : debounce Port map (clk => clock, button => A(1), result => button_internal(1)); --debounce inputs
    HEXES : bhd_converter port map(S => count, hex_display_zero => count_hex_zero, hex_display_one => count_hex_one, hex_display_two => trash); --decodes binary to a hex output
    buttons : Button_Handler Port map( clk => clock, btn1 => button_internal(0), btn2 => button_internal(1), btns => user_input); --inverts active low inputs to active high, for the rps component
    DFF0: D_Flip_Flop port map(D => D_sig(0), reset => reset, clk => enabled_clock, Q => Q_sig(0)); --winner a
    DFF1: D_Flip_Flop port map(D => D_sig(1), reset => reset, clk => enabled_clock, Q => Q_sig(1)); --winner b
    DFF2: D_Flip_Flop port map(D => D_sig(2), reset => reset, clk => enabled_clock, Q => Q_sig(2)); --error, with how it is designed should never occur
    DFF3: D_Flip_Flop port map(D => D_sig(3), reset => reset, clk => enabled_clock, Q => Q_sig(3)); --player 1's inputs
    DFF4: D_Flip_Flop port map(D => D_sig(4), reset => reset, clk => enabled_clock, Q => Q_sig(4)); --player 1's inputs
    DFF5: D_Flip_Flop port map(D => D_sig(5), reset => reset, clk => enabled_clock, Q => Q_sig(5)); --player 2's inputs
    DFF6: D_Flip_Flop port map(D => D_sig(6), reset => reset, clk => enabled_clock, Q => Q_sig(6)); --player 2's inputs
    process(reset, A, start_game, p1, p2, err)
    begin
        if reset = '0' then --async reset active low
            --variables below handle resetting what the reset doesn't already reset
            release <= '0';
            D_sig <= "0000000";
            internal_enable <= '1'; 
        elsif start_game = '0' then --when game hasn't began, coundown isn't equal to 0 
            release <= '0';
            D_sig <= "0000000";
            internal_enable <= '1';
        elsif start_game = '1' and (user_input = "11" or user_input = "10" or user_input = "01") then --game has began once start = 1, the and is to allow the game to wait for user input
            release <= '1'; --releases the random number
            D_sig(0) <= p1;
            D_sig(1) <= p2;
            D_sig(2) <= err;
            D_sig(3) <= user_input(0);
            D_sig(4) <= user_input(1);
            D_sig(5) <= random_input(0);
            D_sig(6) <= random_input(1);
        elsif Q_sig(3) = '1' or Q_sig(4) = '1' then --there is about 1/10th of a second of noise, till this should activate, allowing for multiple button inputs to be processed at once
            internal_enable <= '0'; --disables the flip flops, so they only hold after the user input
        else  --default case
            release <= '0'; 
            D_sig <= (others => '0');
        end if;
    end process; 
    --final outputs to the fpga
    WA <= Q_sig(0);
    WB <= Q_sig(1);
    E <= Q_sig(2);
    B(3) <= Q_sig(6);
    B(2) <= Q_sig(5);
    B(1) <= Q_sig(4);
    B(0) <= Q_sig(3);
end Behavioral;
