library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
---------------------------------------------------------------
entity controller is
    Port ( 
        clk        : in  STD_LOGIC;
        btnl        : in  STD_LOGIC;
        ce         : in  STD_LOGIC;
        mode       : in  STD_LOGIC_VECTOR(2 downto 0);
        bright     : in  STD_LOGIC_VECTOR(7 downto 0);
        speed      : in  STD_LOGIC_VECTOR(7 downto 0);
        target_r   : out STD_LOGIC_VECTOR(7 downto 0);
        target_g   : out STD_LOGIC_VECTOR(7 downto 0);
        target_b   : out STD_LOGIC_VECTOR(7 downto 0)
    );
end controller;

architecture Behavioral of controller is

        signal r_reg : unsigned(7 downto 0);
        signal g_reg : unsigned(7 downto 0);
        signal b_reg : unsigned(7 downto 0);
        signal cnt : unsigned(7 downto 0);
        
        signal bright_reg : unsigned(7 downto 0) := x"FF"; 
        signal speed_reg  : unsigned(7 downto 0) := x"05"; 
begin
process(clk)
    begin
        if rising_edge(clk) then

            if btnl = '1' then
                r_reg <= (others => '0');
                g_reg <= (others => '0');
                b_reg <= (others => '0');
                cnt   <= (others => '0');
                bright_reg <= x"FF";
                speed_reg  <= x"05";

            elsif ce = '1' then
                
                bright_reg <= unsigned(bright);
                speed_reg  <= unsigned(speed);
                
                case mode is

                    -- OFF
                    when "000" =>
                        r_reg <= (others => '0');
                        g_reg <= (others => '0');
                        b_reg <= (others => '0');

                    -- RED
                    when "001" =>
                        r_reg <= bright_reg;
                        g_reg <= (others => '0');
                        b_reg <= (others => '0');

                    -- GREEN
                    when "010" =>
                        r_reg <= (others => '0');
                        g_reg <= bright_reg;
                        b_reg <= (others => '0');

                    -- BLUE
                    when "011" =>
                        r_reg <= (others => '0');
                        g_reg <= (others => '0');
                        b_reg <= bright_reg;

                    -- YELLOW
                    when "100" =>
                        r_reg <= bright_reg;
                        g_reg <= bright_reg;
                        b_reg <= (others => '0');

                    -- CYAN
                    when "101" =>
                        r_reg <= (others => '0');
                        g_reg <= bright_reg;
                        b_reg <= bright_reg;

                    -- MAGENTA
                    when "110" =>
                        r_reg <= bright_reg;
                        g_reg <= (others => '0');
                        b_reg <= bright_reg;

                   -- AUTO FADE
                    when others =>
                    
                        cnt <= cnt + speed_reg;
                    
                        case cnt(7 downto 6) is
                            when "00" =>
                                r_reg <= bright_reg;
                                g_reg <= cnt(5 downto 0) & "00";
                                b_reg <= (others => '0');
                    
                            when "01" =>
                                r_reg <= not (cnt(5 downto 0) & "00");
                                g_reg <= bright_reg;
                                b_reg <= (others => '0');
                    
                            when "10" =>
                                r_reg <= (others => '0');
                                g_reg <= bright_reg;
                                b_reg <= cnt(5 downto 0) & "00";
                    
                            when others =>
                                r_reg <= cnt(5 downto 0) & "00";
                                g_reg <= (others => '0');
                                b_reg <= bright_reg;
                        end case;
                        
                    end case;
                end if;
             end if;
    end process;

    target_r <= std_logic_vector(r_reg);
    target_g <= std_logic_vector(g_reg);
    target_b <= std_logic_vector(b_reg);

end Behavioral;