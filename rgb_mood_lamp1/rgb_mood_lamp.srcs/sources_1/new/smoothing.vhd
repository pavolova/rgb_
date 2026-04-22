library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity smoothing is
    Port ( clk : in STD_LOGIC;
           btnl : in STD_LOGIC;
           ce : in STD_LOGIC;
           target_r : in STD_LOGIC_VECTOR (7 downto 0);
           target_g : in STD_LOGIC_VECTOR (7 downto 0);
           target_b : in STD_LOGIC_VECTOR (7 downto 0);
           current_r : out STD_LOGIC_VECTOR (7 downto 0);
           current_g : out STD_LOGIC_VECTOR (7 downto 0);
           current_b : out STD_LOGIC_VECTOR (7 downto 0));
end smoothing;

architecture Behavioral of smoothing is
    signal r_reg : unsigned(7 downto 0) := (others => '0');
    signal g_reg : unsigned(7 downto 0) := (others => '0');
    signal b_reg : unsigned(7 downto 0) := (others => '0');
begin

    process(clk)
    begin
        if rising_edge(clk) then
            if btnl = '1' then
                r_reg <= (others => '0');
                g_reg <= (others => '0');
                b_reg <= (others => '0');
            elsif ce = '1' then
                -- Red smoothing
                if r_reg < unsigned(target_r) then
                    r_reg <= r_reg + 1;
                elsif r_reg > unsigned(target_r) then
                    r_reg <= r_reg - 1;
                end if;
                -- Green smoothing
                if g_reg < unsigned(target_g) then
                    g_reg <= g_reg + 1;
                elsif g_reg > unsigned(target_g) then
                    g_reg <= g_reg - 1;
                end if;
                -- Blue smoothing
                if b_reg < unsigned(target_b) then
                    b_reg <= b_reg + 1;
                elsif b_reg > unsigned(target_b) then
                    b_reg <= b_reg - 1;
                end if;
            end if;
        end if;
    end process;

    current_r <= std_logic_vector(r_reg);
    current_g <= std_logic_vector(g_reg);
    current_b <= std_logic_vector(b_reg);

end Behavioral;