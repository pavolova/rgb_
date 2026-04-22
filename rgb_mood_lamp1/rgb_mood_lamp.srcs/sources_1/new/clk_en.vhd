library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity clk_en is
 generic (
        N_PERIODS : positive := 200000  
  );
    Port ( clk : in STD_LOGIC;
           btnl : in STD_LOGIC;
           en : out STD_LOGIC);
end clk_en;

architecture Behavioral of clk_en is
    signal sig_count : integer range 0 to N_PERIODS - 1;
begin

    p_clk_enable : process (clk) is
    begin

        if (rising_edge(clk)) then     
            if (btnl = '1') then    
                sig_count <= 0;

            elsif (sig_count < (N_PERIODS - 1)) then
                sig_count <= sig_count + 1;   
            else
                sig_count <= 0;
            end if;  
        end if;

    end process p_clk_enable;

    en <= '1' when (sig_count = N_PERIODS - 1) else
             '0';
end Behavioral;
