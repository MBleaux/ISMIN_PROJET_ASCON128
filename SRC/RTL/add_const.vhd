-------------------------------------------------------------------------------
-- Title      : Constant Addition
-- Project    : ASCON PCSN
-------------------------------------------------------------------------------
-- File	      : add_const.vhd
-- Author     : Mário da Silva ARAÚJO  <mario.dasilvaaraujo@etu.emse.fr>
-- Company    : MINES SAINT ETIENNE
-- Created    : 2022-10-29
-- Last update: 2022-12-23
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

entity add_const is
    port(
    state_i  : in  type_state;
	round_i  : in  bit4;
	state_o	 : out type_state
	);
end entity add_const;

architecture add_const_arch of add_const is
begin
	state_o(0)<=state_i(0);
	state_o(1)<=state_i(1);
	state_o(2)<=state_i(2) xor x"00000000000000" &round_constant(to_integer(unsigned(round_i))); -- x_2 = x_2 + constant(round)
	state_o(3)<=state_i(3);
	state_o(4)<=state_i(4);
end architecture add_const_arch;
