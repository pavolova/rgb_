library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity rgb_mood_lamp_top is
    Port ( clk : in STD_LOGIC;
           btnl : in STD_LOGIC;
           btnu : in STD_LOGIC;
           btnc : in STD_LOGIC;
           btnd : in STD_LOGIC;
           LED16_r : out STD_LOGIC;
           LED16_g : out STD_LOGIC;
           LED16_b : out STD_LOGIC);
end rgb_mood_lamp_top;

architecture Behavioral of rgb_mood_lamp_top is
        
     
    -- Component declaration for clock enable
    component clk_en is
        generic ( N_PERIODS : integer );
        port (
            clk   : in    std_logic;
            btnl   : in    std_logic;
            en : out   std_logic
        );
    end component;

    -- Component declaration for button debouncer
    component debounce is
        port (
            clk      : in    std_logic;
            btnl      : in    std_logic;
            btnc_in  : in    std_logic;
            btnu_in    : in   std_logic;
            btnd_in : in   std_logic;
            btnc_state : out   std_logic;
            btnu_state : out   std_logic;
            btnd_state : out   std_logic
        );
    end component;

    -- Component declaration for controller
    component controller is
        port (
            clk   : in    std_logic;
            btnl   : in    std_logic;
            ce    : in    std_logic;
            mode : in   std_logic_vector (2 downto 0);
            bright : in   std_logic_vector (7 downto 0);
            speed : in   std_logic_vector (7 downto 0);
            target_r : out std_logic_vector (7 downto 0);
            target_g : out std_logic_vector (7 downto 0);
            target_b : out std_logic_vector (7 downto 0)
        );
    end component;
    
     -- Component declaration for smoothing
    component smoothing is
        port (
            clk   : in    std_logic;
            btnl   : in    std_logic;
            ce    : in    std_logic;
            target_r : in std_logic_vector (7 downto 0);
            target_g : in std_logic_vector (7 downto 0);
            target_b : in std_logic_vector (7 downto 0);
            current_r : out std_logic_vector (7 downto 0);
            current_g : out std_logic_vector (7 downto 0);
            current_b : out std_logic_vector (7 downto 0)
        );
    end component;
    
     -- Component declaration for PWM
    component pwm is
        port (
            clk   : in    std_logic;
            btnl   : in    std_logic;
            duty_cycle : in std_logic_vector (7 downto 0);
            pwm_out : out std_logic
        );
    end component;

    signal sig_en : std_logic;

    signal btnc_db : std_logic;
    signal btnu_db : std_logic;
    signal btnd_db : std_logic;

    signal btnc_prev : std_logic := '0';
    signal btnu_prev : std_logic := '0';
    signal btnd_prev : std_logic := '0';

    signal sig_mode   : std_logic_vector(2 downto 0) := "111";
    signal sig_bright : std_logic_vector(7 downto 0) := x"FF";
    signal sig_speed  : std_logic_vector(7 downto 0) := x"05";

    signal sig_target_r  : std_logic_vector(7 downto 0);
    signal sig_target_g  : std_logic_vector(7 downto 0);
    signal sig_target_b  : std_logic_vector(7 downto 0);

    signal sig_current_r : std_logic_vector(7 downto 0);
    signal sig_current_g : std_logic_vector(7 downto 0);
    signal sig_current_b : std_logic_vector(7 downto 0);
    
begin

    -- Component instantiation of clock enable for 1 ms with 100 MHz clock
    clk_en_ins : clk_en
        generic map ( N_PERIODS => 100000 )
        port map (
            clk   => clk,
            btnl   => btnl,
            en => sig_en
        );

    -- Component instantiation of button debouncer
    debounce_inst : debounce
        port map (
            clk => clk, 
            btnl => btnl,
            btnc_in => btnc, 
            btnu_in => btnu, 
            btnd_in => btnd,
            btnc_state => btnc_db, 
            btnu_state => btnu_db, 
            btnd_state => btnd_db
        );
        
        process(clk)
    begin
        if rising_edge(clk) then
            if btnl = '1' then
                sig_mode   <= "111";
                sig_bright <= x"FF";
                sig_speed  <= x"05";

                btnc_prev <= '0';
                btnu_prev <= '0';
                btnd_prev <= '0';

            else
                btnc_prev <= btnc_db;
                btnu_prev <= btnu_db;
                btnd_prev <= btnd_db;

                -- BTN C: prepína režim 0 až 7
                if btnc_db = '1' and btnc_prev = '0' then
                    sig_mode <= std_logic_vector(unsigned(sig_mode) + 1);
                end if;

                -- BTN U: prepína jas
                if btnu_db = '1' and btnu_prev = '0' then
                    case sig_bright is
                        when x"40" =>
                            sig_bright <= x"80";
                        when x"80" =>
                            sig_bright <= x"C0";
                        when x"C0" =>
                            sig_bright <= x"FF";
                        when others =>
                            sig_bright <= x"40";
                    end case;
                end if;

                -- BTN D: prepína rýchlosť
                if btnd_db = '1' and btnd_prev = '0' then
                    case sig_speed is
                        when x"01" =>
                            sig_speed <= x"03";
                        when x"03" =>
                            sig_speed <= x"05";
                        when x"05" =>
                            sig_speed <= x"0A";
                        when others =>
                            sig_speed <= x"01";
                    end case;
                end if;

            end if;
        end if;
    end process;

    -- Component instantiation of button controller
    controller_inst : controller
        port map (
            clk => clk, 
            btnl => btnl,
            ce => sig_en,
            mode => sig_mode, 
            bright => sig_bright,
            speed => sig_speed,
            target_r => sig_target_r,
            target_g => sig_target_g,
            target_b => sig_target_b
        );
        
    -- Component instantiation of button smoothing
    smoothing_inst : smoothing
        port map (
            clk => clk, 
            btnl => btnl,
            ce => sig_en,
            target_r => sig_target_r,
            target_g => sig_target_g,
            target_b => sig_target_b,
            current_r => sig_current_r,
            current_g => sig_current_g,
            current_b => sig_current_b
        );
        
    -- Component instantiation of LED16_r
    pwm_red : pwm
        port map (
            clk => clk, 
            btnl => btnl,
            duty_cycle => sig_current_r,
            pwm_out => LED16_r
        );
        
    -- Component instantiation of LED16_g
    pwm_green : pwm
        port map (
            clk => clk, 
            btnl => btnl,
            duty_cycle => sig_current_g,
            pwm_out => LED16_g
        );
        
    -- Component instantiation of LED16_b
    pwm_blue : pwm
        port map (
            clk => clk, 
            btnl => btnl,
            duty_cycle => sig_current_b,
            pwm_out => LED16_b
        );
        
end Behavioral;

