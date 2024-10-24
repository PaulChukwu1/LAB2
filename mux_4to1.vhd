library IEEE; 

use IEEE.STD_LOGIC_1164.ALL; 

 

-- Entity for 4-to-1 MUX with 8-bit inputs 

entity mux_4to1 is 

    Port ( 

        A, B, C, D : in std_logic_vector(7 downto 0); -- 8-bit wide inputs 

        sel : in std_logic_vector(1 downto 0);        -- 2-bit select line 

        Y : out std_logic_vector(7 downto 0)          -- 8-bit output 

    ); 

end mux_4to1; 

 

architecture structural of mux_4to1 is 

    -- Internal signals for NOT gates 

    signal sel_not_0, sel_not_1 : std_logic; 

 

    -- Internal signals for AND gates (8-bit vectors) 

    signal and_A, and_B, and_C, and_D : std_logic_vector(7 downto 0); 

 

begin 

    -- NOT gates for select lines 

    sel_not_0 <= not sel(0); 

    sel_not_1 <= not sel(1); 

 

    -- AND gates for each input (bitwise AND applied to 8-bit signals) 

    and_A <= A when (sel_not_1 = '1' and sel_not_0 = '1') else (others => '0'); -- Select "00" 

    and_B <= B when (sel_not_1 = '1' and sel(0) = '1') else (others => '0');    -- Select "01" 

    and_C <= C when (sel(1) = '1' and sel_not_0 = '1') else (others => '0');    -- Select "10" 

    and_D <= D when (sel(1) = '1' and sel(0) = '1') else (others => '0');       -- Select "11" 

 

    -- OR gate to combine the 8-bit outputs 

    Y <= and_A or and_B or and_C or and_D; 

 

end structural; 