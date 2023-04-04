-------------------------------------------------------------------------------
-- Title      : Xor Begin
-- Project    : ASCON PCSN
-------------------------------------------------------------------------------
-- File	      : xor_begin.vhd
-- Author     : Mário da Silva ARAÚJO  <mario.dasilvaaraujo@etu.emse.fr>
-- Company    : MINES SAINT ETIENNE
-- Created    : 2022-12-10
-- Last update: 2022-12-24
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: The output data after permutation will be summed with lsb_i and
-- key_i with registered 2 and 3 from the state machine commands.
-------------------------------------------------------------------------------
-- Copyright (c) 2022 
-------------------------------------------------------------------------------

library IEEE;
use IEEE.numeric_std.all;
use IEEE.std_logic_1164.all;
library LIB_RTL;
use LIB_RTL.ascon_pack.all;

entity xor_begin is
    port(  
        data_i         : in  bit64;
        key_i          : in  bit128;
        state_i        : in  type_state;
        ena_xor_data_i : in  std_logic;
        ena_xor_key_i  : in  std_logic;
	    state_o        : out type_state
	);
end entity xor_begin;

architecture xor_begin_arch of xor_begin is
    -- Temporary state
    signal state_tmp_s : bit128;

    begin
        -- Operation XOR for 1st register
        state_o(0) <= state_i(0) xor data_i when ena_xor_data_i = '1' else
                    state_i(0);
        -- Operation XOR for others registers
        state_tmp_s <= key_i xor (state_i(1)(63 downto 0)&state_i(2)(63 downto 0)) when ena_xor_key_i = '1' else
                    (state_i(1)(63 downto 0)&state_i(2)(63 downto 0));
        state_o(1) <= state_tmp_s(127 downto 64);
        state_o(2) <= state_tmp_s(063 downto 00);
        state_o(3) <= state_i(3);
        state_o(4) <= state_i(4);
        
end architecture xor_begin_arch;