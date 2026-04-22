-- Testbench automatically generated online
-- at https://vhdl.lapinoo.net
-- Generation date : Tue, 21 Apr 2026 20:36:08 GMT
-- Request id : cfwk-fed377c2-69e7dfb883d97

library ieee;
use ieee.std_logic_1164.all;

entity tb_controller is
end tb_controller;

architecture tb of tb_controller is

    component controller
        port (clk      : in std_logic;
              btnl      : in std_logic;
              mode     : in std_logic_vector (2 downto 0);
              bright   : in std_logic_vector (7 downto 0);
              speed    : in std_logic_vector (7 downto 0);
              ce       : in std_logic;
              target_r : out std_logic_vector (7 downto 0);
              target_g : out std_logic_vector (7 downto 0);
              target_b : out std_logic_vector (7 downto 0));
    end component;

    signal clk      : std_logic;
    signal btnl      : std_logic;
    signal mode     : std_logic_vector (2 downto 0);
    signal bright   : std_logic_vector (7 downto 0);
    signal speed    : std_logic_vector (7 downto 0);
    signal ce       : std_logic;
    signal target_r : std_logic_vector (7 downto 0);
    signal target_g : std_logic_vector (7 downto 0);
    signal target_b : std_logic_vector (7 downto 0);

    constant TbPeriod : time := 10 ns; -- ***EDIT*** Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : controller
    port map (clk      => clk,
              btnl      => btnl,
              mode     => mode,
              bright   => bright,
              speed    => speed,
              ce       => ce,
              target_r => target_r,
              target_g => target_g,
              target_b => target_b);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- ***EDIT*** Check that clk is really your main clock signal
    clk <= TbClock;

    stimuli : process
    begin
        -- ***EDIT*** Adapt initialization as needed
        mode <= (others => '0');
        bright <= (others => '0');
        speed <= (others => '0');
        ce <= '0';

        -- Reset generation
        -- ***EDIT*** Check that rst is really your reset signal
        btnl <= '1';
        wait for 100 ns;
        btnl <= '0';
        wait for 100 ns;
        
        ce     <= '1';
        bright <= x"FF";  
        speed  <= x"04"; 
        mode   <= "000";
    
        -- 000 OFF
        mode <= "000";
        wait for 500 ns;
    
        -- 001 RED
        mode <= "001";
        wait for 500 ns;

        -- 010 GREEN
        mode <= "010";
        wait for 500 ns;
    
        -- 011 BLUE
        mode <= "011";
        wait for 500 ns;
    
        -- 100 YELLOW
        mode <= "100";
        wait for 500 ns;
    
        -- 101 CYAN
        mode <= "101";
        wait for 500 ns;
    
        -- 110 MAGENTA
        mode <= "110";
        wait for 500 ns;
    
        -- 111 AUTO FADE
        mode <= "111";
        wait for 500 ns; 
    
        -- ***EDIT*** Add stimuli here
        wait for 100 * TbPeriod;

        -- Stop the clock and hence terminate the simulation
        TbSimEnded <= '1';
        wait;
    end process;

end tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

configuration cfg_tb_controller of tb_controller is
    for tb
    end for;
end cfg_tb_controller;