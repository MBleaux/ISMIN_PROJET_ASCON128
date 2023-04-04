-------------------------------------------------------------------------------
-- Title      : Substitution
-- Project    : ASCON PCSN
-------------------------------------------------------------------------------
-- File	      : substitution.vhd
-- Author     : Mário da Silva ARAÚJO  <mario.dasilvaaraujo@etu.emse.fr>
-- Company    : MINES SAINT ETIENNE
-- Created    : 2022-11-05
-- Last update: 2022-12-23
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

entity substitution is
    port(
        state_i : in  type_state;
        state_o : out type_state
    );
end entity substitution;

architecture substitution_arch of substitution is
    -- Calling the s_box component
    component s_box is
        port(
            data_i : in  bit5;
            data_o : out bit5
        );
    end component;

begin
    -- Calling the s_box component 64 times to replace each register
    GEN_1 : for i in 0 to 63 generate
        sbox_1 : s_box
        port map (
            data_i(4) => state_i(0)(i),
            data_i(3) => state_i(1)(i),
            data_i(2) => state_i(2)(i),
            data_i(1) => state_i(3)(i),
            data_i(0) => state_i(4)(i),
            data_o(4) => state_o(0)(i),
            data_o(3) => state_o(1)(i),
            data_o(2) => state_o(2)(i),
            data_o(1) => state_o(3)(i),
            data_o(0) => state_o(4)(i)
                );
    end generate GEN_1;
end architecture substitution_arch;
