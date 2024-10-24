Library ieee; 

  

USE ieee.std_logic_1164.ALL; 
USE ieee.numeric_std.ALL;

  

ENTITY datapath_mul IS  

	Port( 

	I_CLOCK, I_RESET_BAR :  in STD_logic; 

	Ai,Bi : in STD_logic_vector(7 downto 0); 

	LoadRA, LoadRB, LoadRP,  LoadRC, LoadRS: in STD_logic; 

	AshifL : in STD_logic; 

	SelxRA, SelyRA, SelxRB, SelyRB, SelRC, SelxRP, SelyRP: in STD_logic; 

	SelAddP1, SelAddA1: in STD_logic; 

	B3eq1, A3eq1, Bceq1, Ceq4, Seq0 : out STD_logic; 

	Pi: out STD_logic_vector(7 downto 0)

	); 

	 

END datapath_mul; 

 

ARCHITECTURE STRUCT of datapath_mul is

	SIGNAL INT_SELX_RA, INT_SELY_RA, INT_SELX_RB, INT_SELY_RB, INT_SEL_RP,  INT_SEL_ADDP1, INT_SEL_ADDA1, INT_SEL_RC: STD_logic_vector(7 DOWNTO 0); 

	SIGNAL INT_A, INT_B, INT_P, INT_C: STD_logic_vector(7 DOWNTO 0); 

	SIGNAL INT_S: STD_logic_vector(7 DOWNTO 0); 

	SIGNAL INT_RACOMP, INT_RBCOMP, INT_RPCOMP: STD_logic_vector(7 DOWNTO 0); 

	SIGNAL INT_RSCOMP: STD_logic_vector(7 DOWNTO 0); 

	SIGNAL INT_ADDAP, INT_ADDB, INT_ADDC : STD_logic_vector(7 DOWNTO 0);  

	SIGNAL INT_A3EQ1, INT_B3EQ1, INT_BCeq1, INT_SEQ0, INT_CEQ4: STD_logic; 

	 

	COMPONENT AdderUnit is  

	  

		 PORT (  

				X, Y : IN STD_LOGIC_VECTOR (7 downto 0);  

				control   : IN STD_LOGIC; --controls addition or subtraction  

				carry_out   : OUT STD_LOGIC;  

			  sum   : OUT STD_LOGIC_VECTOR(7 downto 0)); 

	END COMPONENT; 

	  

	COMPONENT mux_4to1 is  

		 Port (  

			  A, B, C, D: in std_logic_vector(7 downto 0); -- 8-bit wide inputs  

			  sel : in std_logic_vector(1 downto 0);       -- 2-bit select line  

			  Y: out std_logic_vector(7 downto 0)          -- 8-bit output  

		 );  

	END COMPONENT; 

	  

	COMPONENT mux_2to1 is  

		 Port (  

			  A, B: in  std_logic_vector(7 downto 0); -- Input A  

			  sel : in  std_logic;    -- Select signal  

			  Y   : out std_logic_vector(7 downto 0)     -- Output Y  

	 );   

	END COMPONENT; 

	COMPONENT oneBitComparator IS 

		PORT( 

			i_GTPrevious, i_LTPrevious	: IN	STD_LOGIC; 

			i_Ai, i_Bi			: IN	STD_LOGIC; 

			o_GT, o_LT, oEQ			: OUT	STD_LOGIC); 

	END COMPONENT; 

	COMPONENT threeBitComparator IS 

		PORT( 

			i_Ai, i_Bi			: IN	STD_LOGIC_VECTOR(2 downto 0); 

			o_GT, o_LT, o_EQ		: OUT	STD_LOGIC); 

	END COMPONENT; 

	 

	COMPONENT eightBitComparator IS 

		PORT( 

			i_Ai, i_Bi			: IN	STD_LOGIC_VECTOR(7 downto 0); 

			o_GT, o_LT, o_EQ		: OUT	STD_LOGIC); 

	END COMPONENT; 

	  

	COMPONENT onebitregister IS 

		PORT( 

			i_resetBar, i_load	: IN	STD_LOGIC; 

			i_clock			: IN	STD_LOGIC; 

			i_Value			: IN	STD_LOGIC; 

			o_Value			: OUT	STD_LOGIC); 

	END COMPONENT; 

	 

	COMPONENT eightbitshiftregister_l IS   

	PORT(   

	i_shift, i_load, clk : IN STD_LOGIC;  

	i_value : IN STD_LOGIC_VECTOR(7 downto 0);  

	o_value : OUT STD_LOGIC_VECTOR(7 downto 0) );  

	END COMPONENT; 

	  

	COMPONENT eightbitregister IS 

		PORT( 

			i_resetBar, i_load	: IN	STD_LOGIC; 

			i_clock			: IN	STD_LOGIC; 

			i_Value			: IN	STD_LOGIC_VECTOR(7 downto 0); 

			o_Value			: OUT	STD_LOGIC_VECTOR(7 downto 0)); 

	END COMPONENT; 

	 

	BEGIN 

	  

	INT_RACOMP <= NOT INT_A; 

	INT_RBCOMP <= NOT INT_B; 

	INT_RPCOMP <= NOT INT_P; 

	INT_RSCOMP <= NOT INT_S; 

	 

	selector_a1 : mux_2to1 

	PORT MAP( A => INT_RACOMP, B => INT_ADDAP, sel => SelxRA, Y => INT_SELX_RA); 

	  

	selector_a2: mux_2to1 

	PORT MAP( A => INT_A, B =>INT_SELX_RA, sel => SelyRA, Y => INT_SELY_RA); 

	 

	selector_b1: mux_2to1 

	PORT MAP( A => INT_ADDB, B => INT_RBCOMP, sel => SelxRB, Y => INT_SELX_RB); 

	 

	selector_b2: mux_2to1 

	PORT MAP( A => INT_B, B =>INT_SELX_RB, sel => SelyRB, Y => INT_SELY_RB); 

	 

	selector_p : mux_4to1 

	PORT MAP( A => "00000000", B =>INT_RPCOMP, C => INT_ADDAP, D => INT_ADDAP, sel(0) => SelxRP, sel(1) => SelyRP, Y => INT_SEL_RP ); 
	 
	 

	selector_addp: mux_2to1 

	PORT MAP( A => INT_P, B =>"00000001", sel => SelAddP1, Y => INT_SEL_ADDP1); 

	 

	selector_adda: mux_2to1 

	PORT MAP( A => INT_A, B =>"00000001", sel => SelAddA1, Y => INT_SEL_ADDA1); 

	 

	selector_c: mux_2to1 

	PORT MAP( A => INT_C, B => INT_ADDC, sel => SelRC, Y => INT_SEL_RC); 

	 

	FA_B : AdderUnit 

	PORT MAP( X => INT_B, Y=> "00000001", control => '0', carry_out => OPEN, sum => INT_ADDB );  

	  

	FA_AP : AdderUnit 

	PORT MAP( X => INT_SEL_ADDP1, Y=> INT_SEL_ADDA1, control => '0', carry_out => OPEN, sum => INT_ADDAP);  

	  

	FA_C : AdderUnit 

	PORT MAP( X => INT_C, Y=> "00000001", control => '0', carry_out => OPEN, sum => INT_ADDC); 

	 

	reg_A : eightbitshiftregister_l 

	PORT MAP( i_load => LoadRA , clk => I_ClOCK, i_shift => AshifL, i_value => INT_SELY_RA, o_value => INT_A); 

	 

	reg_B : eightbitregister 

	PORT MAP( i_resetBar => I_RESET_BAR, i_load => LoadRB, i_clock => I_CLOCK, i_value => INT_SELY_RB, o_value=> INT_B);  

	  

	reg_P: eightbitregister 

	PORT MAP( i_resetBar => I_RESET_BAR, i_load => LoadRP, i_clock => I_CLOCK, i_value => INT_SEL_RP, o_value=> INT_P );  

	  

	reg_C: eightbitregister 

	PORT MAP( i_resetBar => I_RESET_BAR, i_load => LoadRC, i_clock => I_CLOCK, i_value => INT_SEL_RC, o_value=> INT_C );  

	  

	reg_S : eightbitregister 

	PORT MAP( i_resetBar => I_RESET_BAR, i_load => LoadRS, i_clock => I_CLOCK, i_value => INT_RSCOMP, o_value=> INT_S  ); 

	 

	comp_a3: oneBitComparator 

	PORT MAP( i_GTPrevious => '0' , i_LTPrevious => '0', i_Ai => INT_A(3), i_Bi => '1', oEQ => INT_A3EQ1) ; 

	  

	comp_b3 : oneBitComparator 

	PORT MAP( i_GTPrevious => '0' , i_LTPrevious => '0', i_Ai => INT_B(3), i_Bi => '1', oEQ => INT_B3EQ1) ; 

	 

	comp_bc : oneBitComparator 

	PORT MAP( i_GTPrevious => '0' , i_LTPrevious => '0', i_Ai => INT_B(to_integer(unsigned(INT_C))), i_Bi => '1', oEQ => INT_BCEQ1) ; 

	  

	comp_s : eightBitComparator 

	PORT MAP( i_Ai => INT_S, i_Bi => "00000000", o_EQ => INT_SEQ0) ; 

	  

	comp_c: eightBitComparator 

	PORT MAP(  i_Ai => INT_C, i_Bi => "00000100", o_EQ => INT_CEQ4); 

	 

	A3eq1 <= INT_A3EQ1; 

	B3eq1 <= INT_B3EQ1; 

	Bceq1 <= INT_BCEQ1; 

	Ceq4 <= INT_CEQ4; 

	Seq0 <= INT_SEQ0; 

	Pi <= INT_P;  

	 

	END STRUCT; 