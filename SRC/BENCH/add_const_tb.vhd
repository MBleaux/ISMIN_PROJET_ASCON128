-------------------------------------------------------------------------------
-- Title      : Test Bench of Constant Addition
-- Project    : ASCON PCSN
-------------------------------------------------------------------------------
-- File	      : add_const_tb.vhd
-- Author     : Mário da Silva ARAÚJO  <mario.dasilvaaraujo@etu.emse.fr>
-- Company    : MINES SAINT ETIENNE
-- Created    : 2022-10-29
-- Last update: 2022-12-26
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: Add a constant to the third input data register as a function  
-- of the round.
-------------------------------------------------------------------------------
-- Copyright (c) 2022 
-------------------------------------------------------------------------------

library IEEE;
use IEEE.numeric_std.all;
use IEEE.std_logic_1164.all;
library LIB_RTL;
use LIB_RTL.ascon_pack.all;

entity add_const_tb is

end entity add_const_tb;

architecture add_const_tb_arch of add_const_tb is
    
    -- Calling the add_const component
    component add_const
        port (
            state_i : in type_state;
            round_i : in bit4;
            state_o : out type_state
            );
    end component add_const;

    signal state_i_s : type_state;
    signal round_s   : bit4;
    signal state_o_s : type_state;

    begin 
        DUT : add_const
        port map (
            state_i => state_i_s,
            round_i => round_s,
            state_o => state_o_s
        );

        -- Input data for state_i
        state_i_s(0) <= x"80400c0600000000";
        state_i_s(1) <= x"0001020304050607";
        state_i_s(2) <= x"08090a0b0c0d0e0f";
        state_i_s(3) <= x"0001020304050607";
        state_i_s(4) <= x"08090a0b0c0d0e0f";    

        -- Input data for round_i
        round_s <= x"0", x"1" after 20ns, x"2" after 40 ns;

end architecture add_const_tb_arch;

configuration add_const_tb_conf of add_const_tb is
    for add_const_tb_arch
        for DUT : add_const
            use entity LIB_RTL.add_const(add_const_arch);
        end for;
    end for;
end configuration add_const_tb_conf;
