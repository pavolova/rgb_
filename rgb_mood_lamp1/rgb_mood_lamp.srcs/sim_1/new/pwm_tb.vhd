-- Testbench automatically generated online
-- at https://vhdl.lapinoo.net
-- Generation date : Mon, 20 Apr 2026 08:59:31 GMT
-- Request id : cfwk-fed377c2-69e5eaf395d75

library ieee;
use ieee.std_logic_1164.all;

entity tb_pwm is
end tb_pwm;

architecture tb of tb_pwm is

    component pwm
        port (clk        : in std_logic;
              btnl        : in std_logic;
              duty_cycle : in std_logic_vector (7 downto 0);
              pwm_out    : out std_logic);
    end component;

    signal clk        : std_logic;
    signal btnl        : std_logic;
    signal duty_cycle : std_logic_vector (7 downto 0);
    signal pwm_out    : std_logic;

    constant TbPeriod : time := 10 ns; -- ***EDIT*** Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : pwm
    port map (clk        => clk,
              btnl        => btnl,
              duty_cycle => duty_cycle,
              pwm_out    => pwm_out);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- ***EDIT*** Check that clk is really your main clock signal
    clk <= TbClock;

    stimuli : process
    begin
   
        duty_cycle <= (others => '0');
    
        btnl <= '1';
        wait for 100 ns;
        btnl <= '0';
        wait for 100 ns;
    
        -- 25% duty cycle
        duty_cycle <= x"40";  -- ~64/255
        wait for 10us;
    
        -- 50% duty cycle
        duty_cycle <= x"80";
        wait for 10us;
    
        -- 75% duty cycle
        duty_cycle <= x"C0";
        wait for 10us;
    
        -- 100% duty cycle
        duty_cycle <= x"FF";
        wait for 10us;
    
        TbSimEnded <= '1';
        wait;

end process;


end tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

configuration cfg_tb_pwm of tb_pwm is
    for tb
    end for;
end cfg_tb_pwm;