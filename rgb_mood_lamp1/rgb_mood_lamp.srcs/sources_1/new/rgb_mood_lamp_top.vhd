library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

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
    component PWM is
        port (
            clk   : in    std_logic;
            btnl   : in    std_logic;
            duty_cycle : in std_logic_vector (7 downto 0);
            pwm_out : out std_logic
        );
    end component;

    signal sig_en : std_logic;
    signal sig_mode : std_logic;
    signal sig_bright : std_logic;
    signal sig_speed : std_logic;
    signal sig_target_r   : std_logic_vector(7 downto 0);
    signal sig_target_g   : std_logic_vector(7 downto 0);
    signal sig_target_b   : std_logic_vector(7 downto 0);
    signal sig_current_r  : std_logic_vector(7 downto 0);
    signal sig_current_g  : std_logic_vector(7 downto 0);
    signal sig_current_b  : std_logic_vector(7 downto 0);
    
begin

    -- Component instantiation of clock enable for 2 ms
    clk_en_ins : clk_en
        generic map ( N_PERIODS => 100 )
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
            btnc_state => sig_mode, 
            btnu_state => sig_bright, 
            btnd_state => sig_speed
        );

    -- Component instantiation of button controller
    controller_inst : controller
        port map (
            clk => clk, 
            btnl => btnl,
            ce => sig_en,
            mode => "111", 
            bright => x"FF",
            speed => x"05",
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

