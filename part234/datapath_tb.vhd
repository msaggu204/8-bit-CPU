

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity datapath_tb is
--  Port ( );
end datapath_tb;

architecture Behavioral of datapath_tb is

SIGNAL clock          : STD_LOGIC;
SIGNAL reset          : STD_LOGIC;
SIGNAL mux_sel        : STD_LOGIC_VECTOR(1 DOWNTO 0);
SIGNAL immediate_data : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL user_input     : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL acc_write      : STD_LOGIC;
SIGNAL rf_address     : STD_LOGIC_VECTOR(2 DOWNTO 0);
SIGNAL rf_write       : STD_LOGIC;
SIGNAL alu_sel        : STD_LOGIC_VECTOR(2 DOWNTO 0);
SIGNAL bits_rotate    : STD_LOGIC_VECTOR(1 DOWNTO 0);
SIGNAL output_enable  : STD_LOGIC;
SIGNAL zero_flag      : STD_LOGIC;
SIGNAL positive_flag  : STD_LOGIC;
SIGNAL datapath_out   : STD_LOGIC_VECTOR(7 DOWNTO 0);

CONSTANT clock_period : TIME := 8 ns;

begin

    UUT : ENTITY WORK.datapath(Structural)
        PORT MAP (
            clock => clock,
            reset => reset,
            mux_sel => mux_sel,
            immediate_data => immediate_data,
            user_input => user_input,
            acc_write => acc_write,
            rf_address => rf_address,
            rf_write => rf_write,
            alu_sel => alu_sel,
            bits_rotate => bits_rotate,
            output_enable => output_enable,
            zero_flag => zero_flag,
            positive_flag => positive_flag,
            datapath_out => datapath_out
        );

   clock_process : PROCESS
   BEGIN
       clock <= '0';
       WAIT FOR clock_period/2;
       clock <= '1';
       WAIT FOR clock_period/2;
   END PROCESS;  
        
   stim_proc : PROCESS
   BEGIN
       reset <= '1';
       WAIT FOR clock_period;
       reset <= '0';
       
       -- Pass immediate data
       user_input <= "00000111";
       immediate_data <= "11111110";
       mux_sel <= "10";
       acc_write <= '1';
       rf_address <= "000";
       rf_write <= '0';
       alu_sel <= "000";
       bits_rotate <= "01";
       output_enable <= '0';
       WAIT for 2*clock_period;
       
       -- Write user input to Acc
       mux_sel <= "11";
       acc_write <= '1';
       rf_address <= "000";
       rf_write <= '0';
       alu_sel <= "000";
       WAIT for 2*clock_period;
       
       -- Write user input to R[0]
       mux_sel <= "00";
       acc_write <= '0';
       rf_address <= "000";
       rf_write <= '1';
       alu_sel <= "000";
       WAIT for 2*clock_period;
       
       -- Rotate user input in Acc
       mux_sel <= "00";
       acc_write <= '1';
       rf_address <= "000";
       rf_write <= '0';
       alu_sel <= "011";
       WAIT for 2*clock_period;
       
       -- Write rotated user input to R[1]
       mux_sel <= "00";
       acc_write <= '0';
       rf_address <= "001";
       rf_write <= '1';
       alu_sel <= "000";
       WAIT for 2*clock_period;
       
       -- Add rotated input with itself (acc + R[1})
       mux_sel <= "00";
       acc_write <= '1';
       rf_address <= "001";
       rf_write <= '0';
       alu_sel <= "100";
       output_enable <= '1';
       WAIT for 2*clock_period;

       WAIT;
   END PROCESS;      

end Behavioral;
