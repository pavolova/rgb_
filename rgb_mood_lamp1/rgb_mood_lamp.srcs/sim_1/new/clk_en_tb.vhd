-- Testbench automatically generated online
-- at https://vhdl.lapinoo.net
-- Generation date : Sun, 19 Apr 2026 20:50:17 GMT
-- Request id : cfwk-fed377c2-69e54009f0d66

library ieee;
use ieee.std_logic_1164.all;

entity tb_clk_en is
end tb_clk_en;

architecture tb of tb_clk_en is

    component clk_en
        port (clk : in std_logic;
              btnl : in std_logic;
              en  : out std_logic);
    end component;

    signal clk : std_logic;
    signal btnl : std_logic;
    signal en  : std_logic;

    constant TbPeriod : time := 10 ns; 
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : clk_en
    port map (clk => clk,
              btnl => btnl,
              en  => en);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '0' else '0';

    -- ***EDIT*** Check that clk is really your main clock signal
    clk <= TbClock;

    stimuli : process
    begin
        -- ***EDIT*** Adapt initialization as needed

        -- Reset generation
        -- ***EDIT*** Check that rst is really your reset signal
        btnl <= '1';
        wait for 100 ns;
        btnl <= '0';
        wait for 100 ns;
        wait for 5 ms;

        TbSimEnded <= '1';
        wait;

    end process;

end tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

configuration cfg_tb_clk_en of tb_clk_en is
    for tb
    end for;
end cfg_tb_clk_en;