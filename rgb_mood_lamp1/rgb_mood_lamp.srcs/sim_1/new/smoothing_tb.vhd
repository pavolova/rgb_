-- Testbench automatically generated online
-- at https://vhdl.lapinoo.net
-- Generation date : Sun, 19 Apr 2026 20:50:17 GMT
-- Request id : cfwk-fed377c2-69e54009f0d66

library ieee;
use ieee.std_logic_1164.all;

entity tb_smoothing is
end tb_smoothing;

architecture tb of tb_smoothing is

    component smoothing
        port (clk       : in std_logic;
              btnl       : in std_logic;
              ce        : in std_logic;
              target_r  : in std_logic_vector (7 downto 0);
              target_g  : in std_logic_vector (7 downto 0);
              target_b  : in std_logic_vector (7 downto 0);
              current_r : out std_logic_vector (7 downto 0);
              current_g : out std_logic_vector (7 downto 0);
              current_b : out std_logic_vector (7 downto 0));
    end component;

    signal clk       : std_logic;
    signal btnl       : std_logic;
    signal ce        : std_logic;
    signal target_r  : std_logic_vector (7 downto 0);
    signal target_g  : std_logic_vector (7 downto 0);
    signal target_b  : std_logic_vector (7 downto 0);
    signal current_r : std_logic_vector (7 downto 0);
    signal current_g : std_logic_vector (7 downto 0);
    signal current_b : std_logic_vector (7 downto 0);

    constant TbPeriod : time := 10 ns; -- ***EDIT*** Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : smoothing
    port map (clk       => clk,
              btnl       => btnl,
              ce        => ce,
              target_r  => target_r,
              target_g  => target_g,
              target_b  => target_b,
              current_r => current_r,
              current_g => current_g,
              current_b => current_b);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- ***EDIT*** Check that clk is really your main clock signal
    clk <= TbClock;

    stimuli : process
    begin
        -- ***EDIT*** Adapt initialization as needed
        ce <= '0';
        target_r <= (others => '0');
        target_g <= (others => '0');
        target_b <= (others => '0');

        -- Reset generation
        -- ***EDIT*** Check that rst is really your reset signal
        btnl <= '1';
        wait for 100 ns;
        btnl <= '0';
        ce <= '1';
        wait for 100 ns;

        -- ***EDIT*** Add stimuli here
        wait for 100 ns;
        
        -- RED
        target_r <= x"FF";
        target_g <= x"00";
        target_b <= x"00";
        wait for 2 us;
        
        -- GREEN
        target_r <= x"00";
        target_g <= x"FF";
        target_b <= x"00";
        wait for 2 us;
        
        -- BLUE
        target_r <= x"00";
        target_g <= x"00";
        target_b <= x"FF";
        wait for 2 us;
        
        -- mix
        target_r <= x"80";
        target_g <= x"40";
        target_b <= x"20";
        wait for 2 us;
        
        -- Stop the clock and hence terminate the simulation
        TbSimEnded <= '1';
        wait;
    end process;

end tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

configuration cfg_tb_smoothing of tb_smoothing is
    for tb
    end for;
end cfg_tb_smoothing;