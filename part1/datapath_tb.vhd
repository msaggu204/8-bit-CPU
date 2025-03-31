----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/06/2023 04:59:34 PM
-- Design Name: 
-- Module Name: datapath_tb - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

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

begin

UUT : entity work.datapath(Structural)
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

end Behavioral;
