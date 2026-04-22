-- Testbench automatically generated online
-- at https://vhdl.lapinoo.net
-- Generation date : Tue, 21 Apr 2026 11:57:47 GMT
-- Request id : cfwk-fed377c2-69e7663bb21a5

library ieee;
use ieee.std_logic_1164.all;

entity tb_rgb_mood_lamp_top is
end tb_rgb_mood_lamp_top;

architecture tb of tb_rgb_mood_lamp_top is

    component rgb_mood_lamp_top
        port (clk     : in std_logic;
              btnl     : in std_logic;
              btnu    : in std_logic;
              btnc    : in std_logic;
              btnd    : in std_logic;
              LED16_r : out std_logic;
              LED16_g : out std_logic;
              LED16_b : out std_logic);
    end component;

    signal clk     : std_logic;
    signal btnl     : std_logic;
    signal btnu    : std_logic;
    signal btnc    : std_logic;
    signal btnd    : std_logic;
    signal LED16_r : std_logic;
    signal LED16_g : std_logic;
    signal LED16_b : std_logic;

    constant TbPeriod : time := 10 ns; -- ***EDIT*** Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';
    

begin
    
    dut : rgb_mood_lamp_top
    port map (clk     => clk,
              btnl     => btnl,
              btnu    => btnu,
              btnc    => btnc,
              btnd    => btnd,
              LED16_r => LED16_r,
              LED16_g => LED16_g,
              LED16_b => LED16_b);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- ***EDIT*** Check that clk is really your main clock signal
    clk <= TbClock;

    stimuli : process
begin

    btnu <= '0';
    btnc <= '0';
    btnd <= '0';
    btnl <= '0';
    wait for 100 ns;

    -- RESET
    btnl <= '1';
    wait for 10 us;
    btnl <= '0';
    wait for 1 ms ;

    btnu <= '1'; wait for 5 ms;
    btnu <= '0'; wait for 10 ms;

    btnu <= '1'; wait for 5 ms;
    btnu <= '0'; wait for 10 ms;

    btnu <= '1'; wait for 5 ms;
    btnu <= '0'; wait for 10 ms;

    btnu <= '1'; wait for 5 ms;
    btnu <= '0'; wait for 10 ms;


    -- RED
    btnc <= '1'; wait for 5 ms;
    btnc <= '0'; wait for 10 ms;

    -- GREEN
    btnc <= '1'; wait for 5 ms;
    btnc <= '0'; wait for 10 ms;

    -- BLUE
    btnc <= '1'; wait for 5 ms;
    btnc <= '0'; wait for 10 ms;

    -- YELLOW
    btnc <= '1'; wait for 5 ms;
    btnc <= '0'; wait for 10 ms;

    -- CYAN
    btnc <= '1'; wait for 5 ms;
    btnc <= '0'; wait for 10 ms;

    -- MAGENTA
    btnc <= '1'; wait for 5 ms;
    btnc <= '0'; wait for 10 ms;

    -- AUTO FADE
    btnc <= '1'; wait for 5 ms;
    btnc <= '0'; wait for 10 ms;

    TbSimEnded <= '1';
    wait;
end process;

end tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

configuration cfg_tb_rgb_mood_lamp_top of tb_rgb_mood_lamp_top is
    for tb
    end for;
end cfg_tb_rgb_mood_lamp_top;