Library ieee;

USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;


ENTITY datapath IS 
	Port(
	I_CLOCK, I_RESET_BAR :  in STD_logic;
	Ai,Bi : in STD_logic_vector(7 downto 0);
	LoadRA, LoadRB, LoadRE,  LoadQ, LoadS, LoadN : in STD_logic;
	AshifL, RshiftL : in STD_logic;
	SelxA, SelyA, SelB, SelxRe, SelyRe, Sels, Sels0, SelQ, SelN : in STD_logic;
	SelAddRor1, SelAddAorM, SelAddBor1, SelAddReor1, SelAdd1orQ, SelAddSor1, SelAdd1orN : in STD_logic;
	RAcompl, RBcompl, Scompl, REcompl, Qcompl : in STD_logic;
	ADD_SUB_BAR1, ADD_SUB_BAR2, ADD_SUB_BAR3 : in STD_LOGIC; 
	ReqB, Aeq1, Beq1, Neq0, Seq0 : out STD_logic;
	MSB_A, MSB_B : out STD_logic;
	Q, R, Out_A, Out_B : out STD_logic_vector(7 downto 0)

	
	);
	
END datapath; 

ARCHITECTURE STRUCT OF datapath IS

SIGNAL INT_SELX_A, INT_SELX_B, INT_SELX_RE, INT_SEL_S,INT_SEL_S0, INT_SEL_N, INT_SEL_Q: STD_logic_vector(7 DOWNTO 0);
SIGNAL INT_A, INT_B, INT_RE, INT_Q, INT_S : STD_logic_vector(7 DOWNTO 0);
SIGNAL INT_N : STD_logic_vector(7 DOWNTO 0);
SIGNAL INT_RACOMP, INT_RBCOMP, INT_RECOMP, INT_RSCOMP, INT_QCOMP : STD_logic_vector(7 DOWNTO 0);
SIGNAL INT_SELADD_REOR1, INT_SELADD_QOR1, INT_SELADD_SOR1, INT_SELADD_1ORN, INT_SELADD_ROR1, INT_SELADD_AORM, INT_SELADD_BOR1 : STD_logic_vector(7 DOWNTO 0);
SIGNAL INT_ADDFA1, INT_ADDFA2, INT_ADDFA3 : STD_logic_vector(7 DOWNTO 0); 
SIGNAL INT_RLESSB, INT_RGREATB, INT_REQB, INT_AEQ1, INT_BEQ1, INT_Neq0, INT_Seq0 : STD_logic;






COMPONENT AdderUnit is 

    PORT( 

         X, Y  : IN STD_LOGIC_VECTOR(7 downto 0); 

         control   : IN STD_LOGIC; --controls addition or subtraction 

         carry_out   : OUT STD_LOGIC; 

        sum   : OUT STD_LOGIC_VECTOR(7 downto 0));
		  

END COMPONENT;

COMPONENT mux_4to1 is 

    Port ( 

        A, B, C, D : in std_logic_vector(7 downto 0); -- 8-bit wide inputs 

        sel : in std_logic_vector(1 downto 0);        -- 2-bit select line 

        Y : out std_logic_vector(7 downto 0)          -- 8-bit output 

    ); 

END COMPONENT;

COMPONENT mux_2to1 is 

    Port ( 

        A,B   : in  std_logic_vector(7 downto 0);    -- Input A 

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


COMPONENT eightBitComparator IS
	PORT(
		i_Ai, i_Bi			: IN	STD_LOGIC_VECTOR(7 downto 0);
		o_GT, o_LT, o_EQ		: OUT	STD_LOGIC);
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
INT_RECOMP <= NOT INT_RE;
INT_RSCOMP <= NOT INT_S;
INT_QCOMP <= NOT INT_Q;


selector_a : mux_4to1
PORT MAP( A => Ai, B =>INT_RACOMP, C => INT_ADDFA1, D => "00000000", sel(0) => SelyA, sel(1) => SelxA, y => INT_SELX_A );

selector_b : mux_2to1
PORT MAP( A => Bi, B =>INT_RBCOMP, sel => SelB, Y => INT_SELX_B );

selector_q : mux_2to1
PORT MAP( A => "00000000", B =>INT_ADDFA2, sel => SelQ, Y => INT_SEL_Q ); --CHANGE HERE
--A => INT_Q(7 downto to_integer(unsigned(INT_N)) + 1) & '0' & INT_Q(to_integer(unsigned(INT_N)) - 1 downto 0), B => INT_Q(7 downto to_integer(unsigned(INT_N)) + 1) & '1' & INT_Q(to_integer(unsigned(INT_N)) - 1 downto 0), sel => SelQ, Y => INT_SEL_Q);
selector_s0 : mux_2to1
PORT MAP( A => "00000000", B => INT_RSCOMP, sel => Sels0, Y => INT_SEL_S0 );

selector_s : mux_2to1
PORT MAP( A => INT_SEL_S0, B => INT_ADDFA3, sel => Sels, Y => INT_SEL_S );

selector_n : mux_2to1
PORT MAP( A => Bi, B =>INT_ADDFA3, sel => SelN, Y => INT_SEL_N );

selector_r : mux_4to1
PORT MAP( A => "00000000", B =>INT_ADDFA2, C(0) => INT_A(3), C(1) => INT_RE(1), C(2) => INT_RE(2),  C(3) => INT_RE(3), C(4) => INT_RE(4),  C(5) => INT_RE(5), C(6) => INT_RE(6), C(7) => INT_RE(7) , D => INT_ADDFA1, sel(0) => SelyRe, sel(1) => SelxRe, y => INT_SELX_RE );

reg_A : eightbitshiftregister_l
PORT MAP( i_load => LoadRA , clk => I_ClOCK, i_shift => AshifL, i_value => INT_SELX_A, o_value => INT_A ); 

reg_RE : eightbitshiftregister_l
PORT MAP( i_load => LoadRE , clk => I_ClOCK, i_shift => RshiftL, i_value => INT_SELX_RE, o_value => INT_RE ); 

reg_B : eightbitregister
PORT MAP( i_resetBar => I_RESET_BAR, i_load => LoadRB, i_clock => I_CLOCK, i_value => INT_SELX_B, o_value=> INT_B  ); 

reg_Q : eightbitregister
PORT MAP( i_resetBar => I_RESET_BAR, i_load => LoadQ, i_clock => I_CLOCK, i_value => INT_SEL_Q, o_value=> INT_Q  ); 

reg_N : eightbitregister
PORT MAP( i_resetBar => I_RESET_BAR, i_load => LoadN, i_clock => I_CLOCK, i_value => INT_SEL_N, o_value=> INT_N  ); 

reg_S : eightbitregister
PORT MAP( i_resetBar => I_RESET_BAR, i_load => LoadS, i_clock => I_CLOCK, i_value => INT_SEL_S, o_value=> INT_S  ); 

sel_add_Ror1 : mux_2to1
PORT MAP( A => "00000001" , B => INT_RE, sel => SelAddRor1, Y => INT_SELADD_ROR1 );
 
sel_add_Aorm : mux_2to1
PORT MAP( A => INT_SELADD_ROR1 , B => INT_A, sel => SelAddAorM, Y => INT_SELADD_AORM );

sel_add_Bor1 : mux_2to1
PORT MAP( A => INT_B , B => "00000001", sel => SelAddBor1, Y => INT_SELADD_BOR1 );

sel_add_Sor1 : mux_2to1
PORT MAP( A => "00000001" , B => INT_S, sel => SelAddBor1, Y => INT_SELADD_SOR1 );

sel_add_Nor1 : mux_2to1
PORT MAP( A => INT_N , B => "00000001", sel => SelAdd1orN, Y => INT_SELADD_1ORN );

sel_add_REor1 : mux_2to1
PORT MAP( A => "00000001" , B => INT_RECOMP, sel => SelAddReor1, Y => INT_SELADD_REOR1 );

sel_add_Qor1 : mux_2to1
PORT MAP( A => INT_Q , B => "00000001", sel => SelAdd1orQ, Y => INT_SELADD_QOR1 );

FA_REAB : AdderUnit
PORT MAP( X => INT_SELADD_AORM, Y=> INT_SELADD_BOR1, control => ADD_SUB_BAR1, carry_out => open, sum => INT_ADDFA1 ); 

FA_REQ : AdderUnit
PORT MAP( X => INT_SELADD_REOR1, Y=> INT_SELADD_QOR1, control => ADD_SUB_BAR2, carry_out => open, sum => INT_ADDFA2 ); 

FA_NES : AdderUnit
PORT MAP( X => INT_SELADD_SOR1, Y=> INT_SELADD_1ORN, control => ADD_SUB_BAR3, carry_out => open, sum => INT_ADDFA3 ); 

comp_amsb : oneBitComparator
PORT MAP( i_GTPrevious => '0' , i_LTPrevious => '0', i_Ai => INT_A(3), i_Bi => '1', oEQ => INT_AEQ1) ;

comp_bmsb : oneBitComparator
PORT MAP( i_GTPrevious => '0' , i_LTPrevious => '0', i_Ai => INT_B(3), i_Bi => '1', oEQ => INT_BEQ1) ;

comp_s: eightBitComparator
PORT MAP(  i_Ai => INT_S , i_Bi => "00000000", o_EQ => INT_Seq0);

comp_n : eightBitComparator
PORT MAP(  i_Ai => INT_N , i_Bi => "00000000", o_EQ => INT_Neq0);

comp_rb : eightBitComparator
PORT MAP(  i_Ai => INT_RE, i_Bi => INT_B, o_EQ => INT_REQB);

--display_div : dec_7seg
--PORT MAP(i_hexDigit => , o_segment_a => ,o_segment_b => ,o_segment_c => ,o_segment_d => ,o_segment_e => ,o_segment_f => ,o_segment_g => );


MSB_A <= Ai(3); 
MSB_B <= Bi(3);
ReqB <= INT_REQB;
Aeq1 <= INT_AEQ1;
Beq1 <= INT_BEQ1;
Neq0 <=  INT_Neq0;
Seq0 <=  INT_Seq0;
Q <= INT_Q;
R <= INT_RE;
Out_A <= INT_A; 
Out_B <= INT_B;

END STRUCT;






