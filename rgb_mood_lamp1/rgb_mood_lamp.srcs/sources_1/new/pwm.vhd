library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity pwm is
    Port ( clk : in STD_LOGIC;
           btnl : in STD_LOGIC;
           duty_cycle : in STD_LOGIC_VECTOR (7 downto 0);
           pwm_out : out STD_LOGIC);
end pwm;

architecture Behavioral of pwm is
    signal counter : unsigned(7 downto 0) := (others => '0');
begin

    process(clk)
    begin
        if rising_edge(clk) then
            if btnl = '1' then
                 counter <= (others => '0');
                 pwm_out <= '0';
            else
                counter <= counter + 1;
                if counter < unsigned(duty_cycle) then
                    pwm_out <= '1';
                else
                    pwm_out <= '0';
                end if;
            end if;
        end if;
    end process;
end Behavioral;
