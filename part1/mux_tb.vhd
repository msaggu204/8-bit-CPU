----------------------------------------------------------------------------------
-- Filename : mux_tb.vhdl
-- Author : Antonio Alejandro Andara Lara
-- Date : 31-Oct-2023
-- Design Name: mux_tb
-- Project Name: ECE 410 lab 3 2023
-- Description : testbench for the multiplexer of the simple CPU design
-- Additional Comments:
-- Copyright : University of Alberta, 2023
-- License : CC0 1.0 Universal
----------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY mux4_tb IS
END mux4_tb;

ARCHITECTURE sim OF mux4_tb IS

    SIGNAL in0     : STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0');
    SIGNAL in1     : STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0');
    SIGNAL in2     : STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0');
    SIGNAL in3     : STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0');
    SIGNAL mux_sel : STD_LOGIC_VECTOR(1 DOWNTO 0) := "00";
    SIGNAL mux_out : STD_LOGIC_VECTOR(7 DOWNTO 0);

BEGIN

    uut : ENTITY WORK.mux4(Dataflow)
        PORT MAP( alu_out => in0
                , rf_out => in1
                , immediate_data => in2
                , user_input => in3
                , mux_sel => mux_sel
                , mux_out => mux_out
                );

    stimulus : PROCESS
    BEGIN
        -- Setup test data
        in0     <= "10101010";
        in1     <= "11001100";
        in2     <= "11110000";
        in3     <= "00001111";

        -- Select in0
        mux_sel <= "00";
        WAIT FOR 20 ns;

        -- Assertion to check if output matches in0
        ASSERT (mux_out = in0)
        REPORT "Mismatch for mux_sel = 00!"
        SEVERITY ERROR;

        -- add cases for the rest of the inputs
        -- Select in1
        mux_sel <= "01";
        WAIT FOR 20 ns;
        ASSERT (mux_out = in1)
        REPORT "Mismatch for mux_sel = 01!"
        SEVERITY ERROR;
        
        -- Select in2
        mux_sel <= "10";
        WAIT FOR 20 ns;
        ASSERT (mux_out = in2)
        REPORT "Mismatch for mux_sel = 10!"
        SEVERITY ERROR;
        
        -- Select in3
        mux_sel <= "11";
        WAIT FOR 20 ns;
        ASSERT (mux_out = in3)
        REPORT "Mismatch for mux_sel = 11!"
        SEVERITY ERROR;
        
        WAIT;
    END PROCESS stimulus;

END sim;
