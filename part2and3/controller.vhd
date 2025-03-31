----------------------------------------------------------------------------------
-- Company: Department of Electrical and Computer Engineering, University of Alberta
-- Engineer: Shyama Gandhi and Bruce Cockburn
-- Create Date: 10/29/2020 07:18:24 PM
-- Updated Date: 01/11/2021
-- Design Name: CONTROLLER FOR THE CPU
-- Module Name: cpu - behavioral(controller)
-- Description: CPU_LAB 3 - ECE 410 (2021)
-- Revision:
-- Revision 0.01 - File Created
-- Revision 1.01 - File Modified by Raju Machupalli (October 31, 2021)
-- Revision 2.01 - File Modified by Shyama Gandhi (November 2, 2021)
-- Revision 3.01 - File Modified by Antonio Andara (October 31, 2023)
-- Additional Comments:
--*********************************************************************************
-- The controller implements the states for each instructions and asserts appropriate control signals for the datapath during every state.
-- For detailed information on the opcodes and instructions to be executed, refer the lab manual.
-----------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY controller IS
    PORT( clock          : IN STD_LOGIC
        ; reset          : IN STD_LOGIC
        ; enter          : IN STD_LOGIC
        ; mux_sel        : OUT STD_LOGIC_VECTOR(1 DOWNTO 0)
        ; immediate_data : BUFFER STD_LOGIC_VECTOR(7 DOWNTO 0)
        ; acc_write      : OUT STD_LOGIC
        ; rf_address     : OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
        ; rf_write       : OUT STD_LOGIC
        ; alu_sel        : OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
        ; output_enable  : OUT STD_LOGIC
        ; zero_flag      : IN STD_LOGIC
        ; positive_flag  : IN STD_LOGIC
        ; PC_out         : OUT STD_LOGIC_VECTOR(4 DOWNTO 0)
        ; OPCODE_output  : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
        ; bits_rotate    : OUT STD_LOGIC_VECTOR(1 DOWNTO 0)
        ; done           : OUT STD_LOGIC
        );
END controller;

ARCHITECTURE Behavioral OF controller IS

    TYPE state_type IS ( STATE_FETCH
                       , STATE_DECODE
                       , STATE_INA
                       , STATE_LDI
                       , STATE_LDA
                       , STATE_STA
                       , STATE_ADD
                       , STATE_SUB
                       , STATE_ROTR
                       , STATE_INC
                       , STATE_DEC
                       , STATE_AND
                       , STATE_OUTA
                       , STATE_JMPZ
                       , STATE_HALT
                       , STATE_NOT
                       , STATE_NOT1
                       , STATE_NOT2
                       , STATE_NOT3
                       , STATE_SHL
                       );

    SIGNAL state     : state_type;
    SIGNAL IR        : STD_LOGIC_VECTOR(7 DOWNTO 0); -- instruction register
    SIGNAL PC        : INTEGER RANGE 0 TO 31        := 0; -- program counter

-- Instructions and their opcodes (pre-decided)
    CONSTANT OPCODE_INA  : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0001";
    CONSTANT OPCODE_LDI  : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0010";
    CONSTANT OPCODE_LDA  : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0011";    
    CONSTANT OPCODE_STA  : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0100";
    CONSTANT OPCODE_ADD  : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0101";
    CONSTANT OPCODE_SUB  : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0110";
    CONSTANT OPCODE_NOT : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0111"; -- Custom instruction 1
    CONSTANT OPCODE_ROTR : STD_LOGIC_VECTOR(3 DOWNTO 0) := "1000";
    CONSTANT OPCODE_INC  : STD_LOGIC_VECTOR(3 DOWNTO 0) := "1001";
    CONSTANT OPCODE_DEC  : STD_LOGIC_VECTOR(3 DOWNTO 0) := "1010";
    CONSTANT OPCODE_AND : STD_LOGIC_VECTOR(3 DOWNTO 0) := "1011";
    CONSTANT OPCODE_SHL : STD_LOGIC_VECTOR(3 DOWNTO 0) := "1100"; -- Custom instruction 2
    CONSTANT OPCODE_JMPZ : STD_LOGIC_VECTOR(3 DOWNTO 0) := "1101";
    CONSTANT OPCODE_OUTA : STD_LOGIC_VECTOR(3 DOWNTO 0) := "1110";
    CONSTANT OPCODE_HALT : STD_LOGIC_VECTOR(3 DOWNTO 0) := "1111";


    -- program memory that will store the instructions sequentially
    TYPE PM_BLOCK IS ARRAY(0 TO 31) OF STD_LOGIC_VECTOR(7 DOWNTO 0);
    
BEGIN

    --opcode is kept up-to-date
    OPCODE_output <= IR(7 DOWNTO 4);
    
    PROCESS (clock) -- add sensitity list

        -- "PM" is the program memory that holds the instructions
        -- to be executed by the CPU 
        VARIABLE PM     : PM_BLOCK;

        -- To STATE_DECODE the 4 MSBs from the PC content
        VARIABLE OPCODE : STD_LOGIC_VECTOR(3 DOWNTO 0);
        
        

    BEGIN
-- RESET initializes all the control signals to 0.
        IF (reset = '1') THEN
            PC             <= 0;
            IR             <= (OTHERS => '0');
            PC_out         <= std_logic_vector(to_unsigned(PC, PC_out'length));
            mux_sel        <= "00";
            immediate_data <= (OTHERS => '0');
            acc_write      <= '0';
            rf_address     <= "000";
            rf_write       <= '0';
            alu_sel        <= "000";
            output_enable  <= '0';
            done           <= '0';
            bits_rotate    <= "00";
            state          <= STATE_FETCH;

------------------------------------------------
            -- assembly code for program goes here
            PM(0) := "00010000"; 
            PM(1) := "00100000"; 
            PM(2) := "10101010"; 
            PM(3) := "01000111"; 
            PM(4) := "00010000"; 
            PM(5) := "00100000"; 
            PM(6) := "01101001";
            PM(7) := "01000101";
            -- add more instructions as needed
--------------------------------------------------

        ELSIF RISING_EDGE(clock) THEN
            CASE state IS

                WHEN STATE_FETCH => -- FETCH instruction
                    PC_out         <= std_logic_vector(to_unsigned(PC, PC_out'length));
                    -- ****************************************
                    -- write the 8-bit instruction into the Instruction Register here:
                    IR <= PM(PC);
				    -- ****************************************
                    mux_sel        <= "00";
                    immediate_data <= (OTHERS => '0');
                    acc_write      <= '0';
                    rf_address     <= "000";
                    rf_write       <= '0';
                    alu_sel        <= "000";
                    done           <= '0';
                                    
                    IF (enter = '1') THEN
                    -- ****************************************
                    -- increment the program counter here:
                        PC <= PC + 1;
				    -- ****************************************
                        output_enable  <= '0';
                        state  <= STATE_DECODE;
                    ELSE
                        state  <= STATE_FETCH;
                    END IF;

                WHEN STATE_DECODE => -- DECODE instruction

                    OPCODE := IR(7 DOWNTO 4);

                    CASE OPCODE IS
                        -- every instruction must have an execute state
                        WHEN OPCODE_INA  => state <= STATE_INA;
                        WHEN OPCODE_LDI  => state <= STATE_LDI;
                        WHEN OPCODE_LDA  => state <= STATE_LDA;
                        WHEN OPCODE_STA  => state <= STATE_STA;
                        WHEN OPCODE_ADD  => state <= STATE_ADD;
                        WHEN OPCODE_SUB  => state <= STATE_SUB;
                        WHEN OPCODE_ROTR => state <= STATE_ROTR;
                        WHEN OPCODE_INC  => state <= STATE_INC;
                        WHEN OPCODE_DEC  => state <= STATE_DEC;
                        WHEN OPCODE_AND  => state <= STATE_AND;
                        WHEN OPCODE_JMPZ => state <= STATE_JMPZ;
                        WHEN OPCODE_OUTA => state <= STATE_OUTA;
                        WHEN OPCODE_HALT => state <= STATE_HALT;
                        WHEN OTHERS      => state <= STATE_HALT;
                    END CASE;

                    mux_sel        <= "00";

                    -- ****************************************
                    -- Pre-fetching immediate data relaxes the
                    -- requirement for PM to be very fast
                    -- for LDI to work properly.
                    -- pre-fetch immediate data value here:
                    immediate_data <= PM(PC + 1);
                    -- ****************************************

                    acc_write      <= '0';
                    
                    -- ****************************************
                    -- set up the register file address here to
                    -- reduce the delay for waiting one more cycle
                    rf_address <= IR(2 downto 0);
                    -- ****************************************
                    
                    rf_write       <= '0';
                    alu_sel        <= "000";
                    output_enable  <= '0';
                    done           <= '0';

                    -- ****************************************
                    -- set up the bit rotate value here:
                    bits_rotate <= IR(1 downto 0);
                    -- ****************************************

                WHEN STATE_INA => -- INA exceute
                    mux_sel        <= "11";
                    immediate_data <= (OTHERS => '0');
                    acc_write      <= '1';
                    rf_address     <= "000";
                    rf_write       <= '0';
                    alu_sel        <= "000";
                    output_enable  <= '0';
                    done           <= '0';
                    state          <= STATE_FETCH;
                
                WHEN STATE_LDI => -- LDI exceute
                    mux_sel        <= "10";
                    -- immediate data has already been pre-fetched
                    acc_write      <= '1';
                    rf_address     <= "000";
                    rf_write       <= '0';
                    alu_sel        <= "000";
                    output_enable  <= '0';
                    done           <= '0';
                    PC             <= PC + 1;
                    state          <= STATE_FETCH;

                WHEN STATE_LDA => -- LDA exceute
                    -- *********************************
                    -- write the entire state for STATE_LDA
                    mux_sel <= "01";
                    immediate_data <= (OTHERS => '0');
                    acc_write <= '1';
                    --rf_address <= rf_address; -- Already pre-fetched
                    rf_write <= '0';
                    alu_sel <= "000";
                    output_enable <= '0';
                    done <= '0';
                    state <= STATE_FETCH;
                    -- *********************************

                WHEN STATE_STA => -- STA exceute
                    mux_sel        <= "00";
                    immediate_data <= (OTHERS => '0');
                    acc_write      <= '0';
                    rf_address     <= IR(2 DOWNTO 0);
                    -- is the previous line necessary? why?
                    -- no, it was already pre-fetched
                    rf_write       <= '1';
                    alu_sel        <= "000";
                    output_enable  <= '0';
                    done           <= '0';
                    state          <= STATE_FETCH;
            
                WHEN STATE_ADD => -- ADD exceute
                    -- *********************************
                    -- write the entire state for STATE_ADD
                    mux_sel <= "00";
                    immediate_data <= (OTHERS => '0');
                    acc_write <= '1';
                    -- rf_address <= rf_address;
                    rf_write <= '0';
                    alu_sel <= "100";
                    output_enable <= '0';
                    done <= '0';
                    state <= STATE_FETCH;
                    -- *********************************

                WHEN STATE_SUB => -- SUB exceute
                    -- *********************************
                    -- write the entire state for STATE_SUB
                    mux_sel <= "00";
                    immediate_data <= (OTHERS => '0');
                    acc_write <= '1';
                    -- rf_address <= rf_address;
                    rf_write <= '0';
                    alu_sel <= "101";
                    output_enable <= '0';
                    done <= '0';
                    state <= STATE_FETCH;
                    -- *********************************
                
                -- *********************************
                -- write the entire case handling for custom
                -- Bitwise NOT instruction
                -- *********************************
                
                WHEN STATE_NOT =>
                    -- Store current accumulator in register One(STA code)
                    mux_sel        <= "00";
                    immediate_data <= (OTHERS => '0');
                    acc_write      <= '0';
                    rf_address     <= "001";
                    rf_write       <= '1';
                    alu_sel        <= "000";
                    output_enable  <= '0';
                    done           <= '0';
                    state <= STATE_NOT1;
                    
                WHEN STATE_NOT1 =>
                    -- Load register Zero with all 1's
                    mux_sel <= "10";
                    immediate_data <= (OTHERS => '1');
                    acc_write <= '1';
                    rf_address <= "000";
                    rf_write <= '1';
                    alu_sel <= "000";
                    output_enable <= '0';
                    done <= '0';
                    state <= STATE_NOT2;
                    
                WHEN STATE_NOT2 =>
                    -- Load accumulator with current accumulator value again
                    mux_sel <= "01";
                    immediate_data <= (OTHERS => '0');
                    acc_write <= '1';
                    rf_address <= "000";
                    rf_write <= '0';
                    alu_sel <= "000";
                    output_enable <= '0';
                    done <= '0';
                    state <= STATE_NOT3;
                    
                WHEN STATE_NOT3 =>
                    -- Do subtraction and load accumulator with result (flipped bits)
                    mux_sel <= "00";
                    immediate_data <= (OTHERS => '0');
                    acc_write <= '1';
                    rf_address <= "000";
                    rf_write <= '0';
                    alu_sel <= "101";
                    output_enable <= '0';
                    done <= '0';
                    state <= STATE_FETCH;
                
                
                WHEN STATE_ROTR => -- ROTR exceute
                    -- *********************************
                    -- write the entire state for STATE_ROTR
                    mux_sel <= "00";
                    immediate_data <= (OTHERS => '0');
                    rf_address     <= "000";
                    acc_write <= '0';
                    -- bits_rotate <= bits_rotate
                    rf_write <= '0';
                    alu_sel <= "011";
                    output_enable <= '0';
                    done <= '0';
                    state <= STATE_FETCH;
                    -- *********************************

                WHEN STATE_INC =>
                    -- *********************************
                    -- write the entire state for STATE_INC
                    mux_sel <= "00";
                    immediate_data <= (OTHERS => '0');
                    acc_write <= '0';
                    rf_write <= '0';
                    alu_sel <= "110";
                    output_enable <= '0';
                    done <= '0';
                    state <= STATE_FETCH;
                    -- *********************************
                
                WHEN STATE_DEC =>
                    -- *********************************
                    -- write the entire state for STATE_DEC
                    mux_sel <= "00";
                    immediate_data <= (OTHERS => '0');
                    acc_write <= '0';
                    rf_write <= '0';
                    alu_sel <= "111";
                    output_enable <= '0';
                    done <= '0';
                    state <= STATE_FETCH;
                    -- *********************************

                WHEN STATE_AND =>
                    -- *********************************
                    -- write the entire state for STATE_AND
                    mux_sel <= "00";
                    immediate_data <= (OTHERS => '0');
                    acc_write <= '0';
                    rf_write <= '0';
                    alu_sel <= "001";
                    output_enable <= '0';
                    done <= '0';
                    state <= STATE_FETCH;
                    -- *********************************
                
                -- *********************************
                -- write the entire case handling for custom
                -- Shift left (SHL) instruction
                -- *********************************
                
                WHEN STATE_SHL =>
                    NULL;
--                    mux_sel <= "00";
--                    immediate_data <= (OTHERS => '0');
--                    acc_write <= '0';
--                    rf_write <= '0';
--                    alu_sel <= "001";
--                    output_enable <= '0';
--                    done <= '0';
--                    state <= STATE_FETCH;
                
                WHEN STATE_JMPZ => -- JMPZ exceute
                    -- *********************************
                    -- write the entire state for STATE_JMPZ
                    mux_sel <= "00";
                    immediate_data <= (OTHERS => '0');
                    rf_address     <= "000";
                    acc_write <= '0';
                    rf_write <= '0';
                    alu_sel <= "000";
                    output_enable <= '0';
                    done <= '0';
                    if zero_flag = '1' then
                        PC <= to_integer(unsigned(PM(PC + 1)));
                    end if;
                    state <= STATE_FETCH;
                    
                    -- *********************************

                WHEN STATE_OUTA => -- OUTA exceute
                    -- *********************************
                    -- write the entire state for STATE_OUTA
                    mux_sel <= "00";
                    immediate_data <= (OTHERS => '0');
                    rf_address <= "000";
                    acc_write <= '0';
                    rf_write <= '0';
                    alu_sel <= "000";
                    output_enable <= '1';
                    done <= '0';
                    state <= STATE_FETCH;
                    -- *********************************

                WHEN STATE_HALT => -- HALT execute
                    -- *********************************
                    -- write the entire state for STATE_HALT
                    mux_sel <= "00";
                    immediate_data <= (OTHERS => '0');
                    rf_address <= "000";
                    acc_write <= '0';
                    rf_write <= '0';
                    alu_sel <= "000";
                    output_enable <= '1';
                    done <= '1';
                    -- *********************************

                WHEN OTHERS =>
                    mux_sel        <= "00";
                    immediate_data <= (OTHERS => '0');
                    acc_write      <= '0';
                    rf_address     <= "000";
                    rf_write       <= '0';
                    alu_sel        <= "000";
                    output_enable  <= '1';
                    done           <= '1';
                    state          <= STATE_HALT;

            END CASE;
        END IF;
    END PROCESS;
    
END Behavioral;
