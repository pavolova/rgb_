-- Testbench automatically generated online
-- at https://vhdl.lapinoo.net
-- Generation date : Mon, 20 Apr 2026 21:19:02 GMT
-- Request id : cfwk-fed377c2-69e69846791c6

library ieee;
use ieee.std_logic_1164.all;

entity tb_debounce is
end tb_debounce;

architecture tb of tb_debounce is

    component debounce
        port (clk        : in std_logic;
              btnl        : in std_logic;
              btnc_in    : in std_logic;
              btnu_in    : in std_logic;
              btnd_in    : in std_logic;
              btnc_state : out std_logic;
              btnu_state : out std_logic;
              btnd_state : out std_logic);
    end component;

    signal clk        : std_logic;
    signal btnl        : std_logic;
    signal btnc_in    : std_logic;
    signal btnu_in    : std_logic;
    signal btnd_in    : std_logic;
    signal btnc_state : std_logic;
    signal btnu_state : std_logic;
    signal btnd_state : std_logic;

    constant TbPeriod : time := 10 ns; -- ***EDIT*** Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : debounce
    port map (clk        => clk,
              btnl        => btnl,
              btnc_in    => btnc_in,
              btnu_in    => btnu_in,
              btnd_in    => btnd_in,
              btnc_state => btnc_state,
              btnu_state => btnu_state,
              btnd_state => btnd_state);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- ***EDIT*** Check that clk is really your main clock signal
    clk <= TbClock;

    stimuli : process
    begin
        -- ***EDIT*** Adapt initialization as needed
        btnc_in <= '0';
        btnu_in <= '0';
        btnd_in <= '0';

        -- Reset generation
        -- ***EDIT*** Check that rst is really your reset signal
        btnl <= '1';
        wait for 100 ns;
        btnl <= '0';
        wait for 100 ns;
        
        btnc_in <= '1';
        wait for 5 us;
        btnc_in <= '0';
        wait for 2 us;
    
        btnu_in <= '1';
        wait for 5 us;
        btnu_in <= '0';
        wait for 2 us;
    
        btnd_in <= '1';
        wait for 5 us;
        btnd_in <= '0';
        wait for 2 us;

        -- ***EDIT*** Add stimuli here
        wait for 200 * TbPeriod;

        -- Stop the clock and hence terminate the simulation
        TbSimEnded <= '1';
        wait;
    end process;

end tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

configuration cfg_tb_debounce of tb_debounce is
    for tb
    end for;
end cfg_tb_debounce;