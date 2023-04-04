-------------------------------------------------------------------------------
-- Title      : registre simple pour le type state
-- Project    : ASCON PCSN
-------------------------------------------------------------------------------
-- File	      : state_register.vhd
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

entity state_register is
  
  port(
    clock_i  : in  std_logic;
    resetb_i : in  std_logic;
    data_i   : in  type_state;
    data_o   : out type_state
    );

end entity state_register;

architecture state_register_arch of state_register is

  signal state_s : type_state;
  
begin                                             -- architecture state_register_arch

  seq_0 : process (clock_i, resetb_i) is
  begin	                                          -- process seq_0
    if (resetb_i = '0') then		                  -- asynchronous reset (active low)
      state_s <= (others => (others => '0'));
    elsif (clock_i'event and clock_i = '1') then  -- rising clock edge
      state_s <= data_i;
                                                  -- else
                                                  -- state_s <= state_s;
    end if;
  end process seq_0;

  data_o <= state_s;
end architecture state_register_arch;
