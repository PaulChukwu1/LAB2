library IEEE; 

use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL; 
 
 
entity displayController is
	Port(
		Left, Right : in STD_LOGIC;
		GClock, GReset : in STD_lOGIC;
		DisplayOut   : out STD_LOGIC_VECTOR(7 downto 0)
	
	);
end displayController;

architecture structural of datapath is 
    -- Internal signals to connect components 

    signal LMASK, RMASK, DISPLAY, mux_out : std_logic_vector(7 downto 0); 
	 signal control_signal : std_logic; -- Example control signal for mux 

 

    -- Declare components 

    COMPONENT dFF_1 

       PORT(
		i_d			: IN	STD_LOGIC;
		i_clock			: IN	STD_LOGIC;
		o_q, o_qBar		: OUT	STD_LOGIC);
    end component; 

 

    component mux_4to1 

        Port ( 

        A : in std_logic; -- Input A 

        B : in std_logic; -- Input B 

        C : in std_logic; -- Input C 

        D : in std_logic; -- Input D 

        sel : in std_logic_vector(1 downto 0); -- 2-bit select line 

        Y : out std_logic  -- Output 

    ); 

    end component; 

 

begin 

    -- Instantiate registers 

    reg_LMASK: 

	 PORT MAP(clk => clk, reset => reset, D => mux_out, Q => LMASK); 

    reg_RMASK:

	 PORT MAP(clk => clk, reset => reset, D => mux_out, Q => RMASK); 

    reg_DISPLAY:  PORT MAP(clk => clk, reset => reset, D => mux_out, Q => DISPLAY); 

 

    -- Instantiate a multiplexer 

    mux_inst: mux_2to1 port map(A => LMASK, B => RMASK, sel => control_signal, Y => mux_out); 

 

    -- Output assignment 

    display <= DISPLAY; 

 

end structural; 