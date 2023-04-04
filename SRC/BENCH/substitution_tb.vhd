-------------------------------------------------------------------------------
-- Title      : Test Bench of Substitution
-- Project    : ASCON PCSN
-------------------------------------------------------------------------------
-- File	      : substitution_tb.vhd
-- Author     : Mário da Silva ARAÚJO  <mario.dasilvaaraujo@etu.emse.fr>
-- Company    : MINES SAINT ETIENNE
-- Created    : 2022-11-05
-- Last update: 2022-12-26
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: The data of type "type_state" will be treated as 64 registers
-- of 5 bits. Therefore, with the help of the s_box component, the substitution
-- will be performed according to the substitution table present in the s_box
-- component.
-------------------------------------------------------------------------------
-- Copyright (c) 2022 
-------------------------------------------------------------------------------

library IEEE;
use IEEE.numeric_std.all;
use IEEE.std_logic_1164.all;
library LIB_RTL;
use LIB_RTL.ascon_pack.all;

entity substitution_tb is
end entity substitution_tb;

architecture substitution_tb_arch of substitution_tb is
    
    -- Calling the substitution component
    component substitution
    port (
        state_i : in type_state;
        state_o : out type_state
        );
    end component substitution;

    signal state_i_s : type_state;
    signal state_o_s : type_state;

    begin 
        DUT : substitution
        port map (
            state_i => state_i_s,
            state_o => state_o_s
        );

        -- Inout data for state_i
        state_i_s(0) <= x"80400c0600000000";
        state_i_s(1) <= x"0001020304050607";
        state_i_s(2) <= x"08090a0b0c0d0eff";
        state_i_s(3) <= x"0001020304050607";
        state_i_s(4) <= x"08090a0b0c0d0e0f";    

end architecture substitution_tb_arch;

configuration substitution_tb_conf of substitution_tb is
    for substitution_tb_arch
        for DUT : substitution
            use entity LIB_RTL.substitution(substitution_arch);
        end for;
    end for;
end configuration substitution_tb_conf;
