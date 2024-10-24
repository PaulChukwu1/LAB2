--Parallel Eight bit Shift Right Register

LIBRARY ieee;  

USE ieee.std_logic_1164.ALL;  

ENTITY eightbitshiftregister_r IS  

PORT(  

i_shift, i_load, clk : IN STD_LOGIC; 

 i_value : IN STD_LOGIC_VECTOR(7 downto 0); 

 o_value : OUT STD_LOGIC_VECTOR(7 downto 0) ); 

 END eightbitshiftregister_r; 

 

 ARCHITECTURE rtl OF eightbitshiftregister_r IS  

SIGNAL int_value : STD_LOGIC_VECTOR(7 downto 0);  

 

COMPONENT enARdFF_2  

PORT( 

 i_resetBar : IN STD_LOGIC; 

 i_d : IN STD_LOGIC; 

 i_enable : IN STD_LOGIC; 

 i_clock : IN STD_LOGIC; 

 o_q, o_qBar: OUT STD_LOGIC ); 

 END COMPONENT;  

 

BEGIN bitseven : enARdFF_2  

PORT MAP( 

 i_resetBar => '1', 

 i_d => (int_value(0) AND i_shift) OR (i_value(7) AND i_load), 	i_enable => i_shift OR i_load, 

 i_clock => clk,  

o_q => int_value(6),  

o_qBar => OPEN ); 

 

 bitsix : enARdFF_2  

PORT MAP( 

 i_resetBar => '1', 

 i_d => (int_value(7) AND i_shift) OR (i_value(6) AND i_load),  

i_enable => i_shift OR i_load,  

i_clock => clk,  

o_q => int_value(5),  

o_qBar => OPEN );  

 

bitfive : enARdFF_2  

PORT MAP(  

i_resetBar => '1',  

i_d => (int_value(6) AND i_shift) OR (i_value(5) AND i_load), 	i_enable => i_shift OR i_load, 

 i_clock => clk,  

o_q => int_value(4),  

o_qBar => OPEN );  

 

bitfour : enARdFF_2  

PORT MAP(  

i_resetBar => '1', 

 i_d => (int_value(5) AND i_shift) OR (i_value(4) AND i_load), 	i_enable => i_shift OR i_load,  

i_clock => clk, 

 o_q => int_value(3), 

 o_qBar => OPEN ); 



bitthree : enARdFF_2  

PORT MAP( 

 i_resetBar => '1',  

i_d => (int_value(4) AND i_shift) OR (i_value(3) AND i_load), 	i_enable => i_shift OR i_load, 

 i_clock => clk,  

o_q => int_value(2),  

o_qBar => OPEN );  

 

bittwo : enARdFF_2 

 PORT MAP(  

i_resetBar => '1', 

 i_d => (int_value(3) AND i_shift) OR (i_value(2) AND i_load), 	i_enable => i_shift OR i_load,  

i_clock => clk,  

o_q => int_value(1),  

o_qBar => OPEN ); 

 

 bitone : enARdFF_2  

PORT MAP(  

i_resetBar => '1',  

i_d => (int_value(2) AND i_shift) OR (i_value(1) AND i_load), 	i_enable => i_shift OR i_load,  

i_clock => clk, 

 o_q => int_value(0), 

 o_qBar => OPEN ); 

 


 

 o_value <= int_value; END rtl; 