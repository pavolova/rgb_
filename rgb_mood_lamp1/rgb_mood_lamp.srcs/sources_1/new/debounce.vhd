library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
-------------------------------------------------------------
entity debounce is
    Port ( 
         clk        : in  STD_LOGIC;
         btnl        : in  STD_LOGIC;
         btnc_in    : in  STD_LOGIC; 
         btnu_in    : in  STD_LOGIC;
         btnd_in    : in  STD_LOGIC;
         btnc_state : out STD_LOGIC; 
         btnu_state : out STD_LOGIC;
         btnd_state : out STD_LOGIC
    );
end debounce;

architecture Behavioral of debounce is
    
    constant C_SHIFT_LEN : positive := 4;
    constant C_MAX       : positive := 10;

    component clk_en is
        generic ( N_PERIODS : positive );
        port (
            clk : in  std_logic;
            btnl : in  std_logic;
            en  : out std_logic
        );
    end component clk_en;

    signal ce_sample : std_logic;

    signal sync0_c, sync1_c   : std_logic;
    signal shift_reg_c         : std_logic_vector(C_SHIFT_LEN-1 downto 0);
    signal debounced_c         : std_logic;

    signal sync0_u, sync1_u   : std_logic;
    signal shift_reg_u         : std_logic_vector(C_SHIFT_LEN-1 downto 0);
    signal debounced_u         : std_logic;

    signal sync0_d, sync1_d   : std_logic;
    signal shift_reg_d         : std_logic_vector(C_SHIFT_LEN-1 downto 0);
    signal debounced_d         : std_logic;

begin

    clock_0 : clk_en
        generic map ( N_PERIODS => C_MAX )
        port map (
            clk => clk,
            btnl => btnl,
            en  => ce_sample
        );

    p_debounce : process(clk)
    begin
        if rising_edge(clk) then
            if btnl = '1' then

                sync0_c <= '0'; sync1_c <= '0'; shift_reg_c <= (others => '0'); debounced_c <= '0';
                sync0_u <= '0'; sync1_u <= '0'; shift_reg_u <= (others => '0'); debounced_u <= '0';
                sync0_d <= '0'; sync1_d <= '0'; shift_reg_d <= (others => '0'); debounced_d <= '0';

            else

                sync1_c <= sync0_c;
                sync0_c <= btnc_in;

                sync1_u <= sync0_u;
                sync0_u <= btnu_in;

                sync1_d <= sync0_d;
                sync0_d <= btnd_in;

                if ce_sample = '1' then

                    shift_reg_c <= shift_reg_c(C_SHIFT_LEN-2 downto 0) & sync1_c;

                    if shift_reg_c = (shift_reg_c'range => '1') then
                        debounced_c <= '1';
                    elsif shift_reg_c = (shift_reg_c'range => '0') then
                        debounced_c <= '0';
                    end if;

                    shift_reg_u <= shift_reg_u(C_SHIFT_LEN-2 downto 0) & sync1_u;
                    if shift_reg_u = (shift_reg_u'range => '1') then
                        debounced_u <= '1';
                    elsif shift_reg_u = (shift_reg_u'range => '0') then
                        debounced_u <= '0';
                    end if;

                    shift_reg_d <= shift_reg_d(C_SHIFT_LEN-2 downto 0) & sync1_d;
                    if shift_reg_d = (shift_reg_d'range => '1') then
                        debounced_d <= '1';
                    elsif shift_reg_d = (shift_reg_d'range => '0') then
                        debounced_d <= '0';
                    end if;

                end if;
            end if;
        end if;
    end process;

    btnc_state <= debounced_c;
    btnu_state <= debounced_u;
    btnd_state <= debounced_d;

end Behavioral;
