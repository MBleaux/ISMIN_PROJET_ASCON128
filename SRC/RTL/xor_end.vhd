-------------------------------------------------------------------------------
-- Title      : Xor End
-- Project    : ASCON PCSN
-------------------------------------------------------------------------------
-- File	      : xor_end.vhd
-- Author     : Mário da Silva ARAÚJO  <mario.dasilvaaraujo@etu.emse.fr>
-- Company    : MINES SAINT ETIENNE
-- Created    : 2022-12-10
-- Last update: 2022-12-24
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: The output data after permutation will be summed with lsb_i and
-- key_i with registered 4 and 5 from the state machine commands.
-------------------------------------------------------------------------------
-- Copyright (c) 2022 
-------------------------------------------------------------------------------

library IEEE;
use IEEE.numeric_std.all;
use IEEE.std_logic_1164.all;
library LIB_RTL;
use LIB_RTL.ascon_pack.all;

entity xor_end is
    port(  
        key_i          : in  bit128;
        state_i        : in  type_state;
        ena_xor_lsb_i  : in  std_logic;
        ena_xor_key_i  : in  std_logic;
	    state_o        : out type_state
	);
end entity xor_end;

architecture xor_end_arch of xor_end is
    -- Temporary state
    signal x3_s, x4_s : bit64;

    begin
        -- Signal x3_s (64 bits)
        x3_s <= state_i(3);
        
        -- Signal x4_s (64 bits)
        x4_s(0) <= state_i(4)(0) xor ena_xor_lsb_i;
        x4_s(63 downto 1) <= state_i(4)(63 downto 1);

        -- State out
        state_o(0) <= state_i(0);
        state_o(1) <= state_i(1);
        state_o(2) <= state_i(2);
        state_o(3) <= x3_s xor key_i(127 downto 64) when ena_xor_key_i = '1' else
                      x3_s;
        state_o(4) <= x4_s xor key_i(063 downto 00) when ena_xor_key_i = '1' else
                      x4_s;
end architecture xor_end_arch;