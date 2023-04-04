-------------------------------------------------------------------------------
-- Title      : multiplexeur 2 entrée pour le type state
-- Project    : ASCON PCSN
-------------------------------------------------------------------------------
-- File	      : mux_state.vhd
-- Author     : Jean-Baptiste RIGAUD  <rigaud@tallinn.emse.fr>
-- Company    : MINES SAINT ETIENNE
-- Created    : 2022-08-25
-- Last update: 2022-08-26
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description:	 conception du chiffrement leger ASCON
-------------------------------------------------------------------------------
-- Copyright (c) 2022 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date	       Version	Author	Description
-- 2022-08-25  1.0	rigaud	Created
-------------------------------------------------------------------------------

library IEEE;
use IEEE.numeric_std.all;
use IEEE.std_logic_1164.all;
library LIB_RTL;
use LIB_RTL.ascon_pack.all;

entity mux_state is
  
  port (
    sel_i   : in  std_logic;
    data0_i : in  type_state;
    data1_i : in  type_state;
    data_o  : out type_state
    );

end entity mux_state;

architecture mux_state_arch of mux_state is

begin                                         -- architecture mux_state_arch

  data_o <= data0_i when sel_i = '0' else     -- Selector 0
	          data1_i;                          -- Selector 1

end architecture mux_state_arch;

