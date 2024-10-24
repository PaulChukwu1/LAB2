Library ieee;

USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;


ENTITY controlpath IS 
	Port(
	I_CLOCK, I_RESET_BAR :  in STD_logic;
	MSB_A, MSB_B : in STD_logic;
	SELADD_BOR1, SELADD_ROR1, SELADD_REOR1, SELADD_AORM, SELADD_ZERORS, SELADD_1ORN, SELADD_QOR1: out STD_logic;
	RSHIFTL, ASHIFTL : out STD_logic;
	NLESS0, RLESSB, SEQ0 : in STD_logic;
	SELX_RE, SELY_RE, SEL_Q, SELY_A, SEL_S,SEL_S0, SELY_B, SELX_B, SELX_A : out STD_logic;
	QCOMP, RACOMP, RBOMP, RECOMP, SCOMP: out STD_logic;
	LOAD_Q, LOAD_RE, LOAD_S, LOAD_RA, LOAD_RB, LOAD_RN, LOAD_D : out STD_logic;
	ADD1, ADD2, ADD3 : out STD_logic
	);
	END controlpath;
	
	ARCHITECTURE STRUCT OF controlpath IS
	SIGNAL S0, S1, S2, S3, S4, S5, S6, S7, S8, S9, S10 : STD_logic;
	
	COMPONENT enARdFF_2 IS
	PORT(
		i_resetBar	: IN	STD_LOGIC;
		i_d		: IN	STD_LOGIC;
		i_enable	: IN	STD_LOGIC;
		i_clock		: IN	STD_LOGIC;
		o_q, o_qBar	: OUT	STD_LOGIC);

	END COMPONENT;
	
	BEGIN
	
	D_FF_0 : enARdFF_2
	PORT MAP (i_resetBar => I_RESET_BAR , i_d => '1', i_enable => '1', i_clock => I_CLOCK, o_q => S0 );
	
	D_FF_1 : enARdFF_2
	PORT MAP (i_resetBar => I_RESET_BAR , i_d => S0 AND MSB_A, i_enable => '1', i_clock => I_CLOCK, o_q => S1 );
	
	D_FF_2 : enARdFF_2
	PORT MAP (i_resetBar => I_RESET_BAR , i_d => S1, i_enable => '1', i_clock => I_CLOCK, o_q => S2 );
	
	D_FF_3 : enARdFF_2
	PORT MAP (i_resetBar => I_RESET_BAR , i_d => ((S0 AND (NOT(MSB_A))AND MSB_B) OR (S2 AND MSB_B)), i_enable => '1', i_clock => I_CLOCK, o_q => S3 );
	
	D_FF_4 : enARdFF_2
	PORT MAP (i_resetBar => I_RESET_BAR , i_d => (S3), i_enable => '1', i_clock => I_CLOCK, o_q => S4 );
	
	D_FF_5 : enARdFF_2
	PORT MAP (i_resetBar => I_RESET_BAR , i_d => ((S7 AND NLESS0) OR (S0 AND (NOT(MSB_A)) AND (NOT(MSB_B)) AND NLESS0) OR (S2 AND (NOT(MSB_B))) OR (S6 AND NLESS0) OR (S4 AND NLESS0)  ), i_enable => '1', i_clock => I_CLOCK, o_q => S5 );
	
	D_FF_6 : enARdFF_2
	PORT MAP (i_resetBar => I_RESET_BAR , i_d => (S5 AND RLESSB), i_enable => '1', i_clock => I_CLOCK, o_q => S6 );
	
	D_FF_7 : enARdFF_2
	PORT MAP (i_resetBar => I_RESET_BAR , i_d => (S5 AND (NOT(RLESSB))), i_enable => '1', i_clock => I_CLOCK, o_q => S7 );
	
	D_FF_8 : enARdFF_2
	PORT MAP (i_resetBar => I_RESET_BAR , i_d => ((S7 AND SEQ0 AND (NOT(NLESS0))) OR (S6 AND SEQ0 AND (NOT(NLESS0))) OR (S2 AND SEQ0 AND (NOT(MSB_B))) OR (S4 AND SEQ0 AND NLESS0) OR (S0 AND (NOT(MSB_B)) AND (NOT(MSB_A)) AND NLESS0 AND SEQ0 )), i_enable => '1', i_clock => I_CLOCK, o_q => S8 );
	
	D_FF_9 : enARdFF_2
	PORT MAP (i_resetBar => I_RESET_BAR , i_d => S8, i_enable => '1', i_clock => I_CLOCK, o_q => S9 );
	
	D_FF_10 : enARdFF_2
	PORT MAP (i_resetBar => I_RESET_BAR , i_d => ((S7 AND (NOT(SEQ0)) AND (NOT(NLESS0))) OR (S6 AND (NOT(SEQ0)) AND (NOT(NLESS0))) OR (S2 AND (NOT(SEQ0)) AND (NOT(MSB_B))) OR (S4 AND (NOT(SEQ0)) AND NLESS0) OR (S0 AND (NOT(MSB_B)) AND (NOT(MSB_A)) AND NLESS0 AND (NOT(SEQ0))) ), i_enable => '1', i_clock => I_CLOCK, o_q => S10 );
	
	LOAD_Q <= S0 OR S5 OR S7 OR S8;
	load_RE <= S0 OR S1 OR S2 OR S5 OR S6;
	load_S <= S0 OR S1 OR S3;
	load_RA <= S0 OR S3 OR S4;
	load_RB <= S0 OR S5 OR S6;
	load_RN <= S0 OR S5 OR S6;
	load_D <= S0 OR S5 OR S6;
	SELADD_BOR1 <= S4 OR S7; 
	SELADD_ROR1 <= S7; 
	SELADD_REOR1 <= S9; 
	SELADD_AORM <= S2; 
	SELADD_ZERORS <= S2 OR S4; 
	SELADD_1ORN <= S2 OR S4;
	SELADD_QOR1 <= S9;
	RSHIFTL <= S5;
	ASHIFTL <= S5;
	SELX_RE <= S5; 
	SELY_RE <= S5 OR S9; 
	SEL_Q <= S0 OR S6; 
	SELY_A <= S1; 
	SEL_S <= S2 OR S4;
	SEL_S0 <= S4; 
	
	SELY_B <= S3; 
	SELX_B <= S4; 
	SELX_A <= S2;
	QCOMP <= S8 ; 
	RACOMP <= S1;  
	RBOMP   <= S3;
	RECOMP <= S9;
	SCOMP <= S3;
	ADD1 <= S2 OR S4;
	ADD2 <= S8 OR S9;
	ADD3 <= S2 OR S4 OR S6 OR S7;
	
	
	END STRUCT;
	

