LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY eightBitShiftLRegister IS
	PORT(
		i_resetBar, i_load	: IN	STD_LOGIC;
		i_clock				: IN	STD_LOGIC;
		i_Value				: IN	STD_LOGIC_VECTOR(7 downto 0);
		o_Value				: OUT	STD_LOGIC_VECTOR(7 downto 0));
END eightBitShiftLRegister;

ARCHITECTURE rtl OF eightBitShiftLRegister IS
	SIGNAL int_Value, int_notValue : STD_LOGIC_VECTOR(7 downto 0);

	COMPONENT enARdFF_2
		PORT(
			i_resetBar	: IN	STD_LOGIC;
			i_d			: IN	STD_LOGIC;
			i_enable	: IN	STD_LOGIC;
			i_clock		: IN	STD_LOGIC;
			o_q, o_qBar	: OUT	STD_LOGIC);
	END COMPONENT;

BEGIN

-- Connect the first flip-flop (MSB) to take the input from i_Value(7)
msb: enARdFF_2
	PORT MAP (i_resetBar => i_resetBar,
			  i_d => i_Value(7), 
			  i_enable => i_load,
			  i_clock => i_clock,
			  o_q => int_Value(0),
	          o_qBar => int_notValue(0));
				 
-- Shift the output of the previous flip-flop into the next flip-flop for a shift-left operation
six_sb: enARdFF_2
	PORT MAP (i_resetBar => i_resetBar,
			  i_d => int_Value(0),  -- Get input from the previous flip-flop
			  i_enable => i_load, 
			  i_clock => i_clock,
			  o_q => int_Value(1),
	          o_qBar => int_notValue(1));
				 
five_ssb: enARdFF_2
	PORT MAP (i_resetBar => i_resetBar,
			  i_d => int_Value(1),  -- Get input from the previous flip-flop
			  i_enable => i_load, 
			  i_clock => i_clock,
			  o_q => int_Value(2),
	          o_qBar => int_notValue(2));

four_ssb: enARdFF_2
	PORT MAP (i_resetBar => i_resetBar,
			  i_d => int_Value(2),  -- Get input from the previous flip-flop
			  i_enable => i_load, 
			  i_clock => i_clock,
			  o_q => int_Value(3),
	          o_qBar => int_notValue(3));
				 
three_ssb: enARdFF_2
	PORT MAP (i_resetBar => i_resetBar,
			  i_d => int_Value(3),  -- Get input from the previous flip-flop
			  i_enable => i_load, 
			  i_clock => i_clock,
			  o_q => int_Value(4),
	          o_qBar => int_notValue(4));
				 
two_ssb: enARdFF_2
	PORT MAP (i_resetBar => i_resetBar,
			  i_d => int_Value(4),  -- Get input from the previous flip-flop
			  i_enable => i_load, 
			  i_clock => i_clock,
			  o_q => int_Value(5),
	          o_qBar => int_notValue(5));

one_ssb: enARdFF_2
	PORT MAP (i_resetBar => i_resetBar,
			  i_d => int_Value(5),  -- Get input from the previous flip-flop
			  i_enable => i_load, 
			  i_clock => i_clock,
			  o_q => int_Value(6),
	          o_qBar => int_notValue(6));

-- Last flip-flop (LSB) should receive its input from the previous stage's output
lsb: enARdFF_2
	PORT MAP (i_resetBar => i_resetBar,
			  i_d => int_Value(6),  -- Get input from the previous flip-flop
			  i_enable => i_load,
			  i_clock => i_clock,
			  o_q => int_Value(7),
	          o_qBar => int_notValue(7));

-- Output Driver to connect internal signals to the output port
o_Value	<= int_Value;

END rtl;
