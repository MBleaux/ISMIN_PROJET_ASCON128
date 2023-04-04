-------------------------------------------------------------------------------
-- Title      : Compteur bloc init
-- Project    : ASCON PCSN
-------------------------------------------------------------------------------
-- File	      : compteur_bloc_init.vhd
-- Author     : Mário da Silva Araújo  <mario.dasilvaaraujo@etu.emse.fr>
-- Company    : MINES SAINT ETIENNE
-- Created    : 2022-12-29
-- Last update: 2022-12-31
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description:	block counter 0 to 4
-------------------------------------------------------------------------------
-- Copyright (c) 2022 

library IEEE;
use IEEE.numeric_std.all;
use IEEE.std_logic_1164.all;
library LIB_RTL;
use LIB_RTL.ascon_pack.all;

entity compteur_bloc_init is
  
  port (
    clock_i  : in  std_logic;
    resetb_i : in  std_logic;
    en_i     : in  std_logic;
    init_i   : in  std_logic;
    block_o  : out bit2
    );

end entity compteur_bloc_init;

architecture compteur_bloc_init_arch of compteur_bloc_init is

    signal block_s : integer range 0 to 3;
  
begin  -- architecture compteur_bloc_init_arch

  seq_0 : process (clock_i, resetb_i, en_i, init_i) is
  begin	 -- process seq_0
    if (resetb_i = '0') then -- asynchronous reset (active low)
        block_s <= 0;
    elsif (clock_i'event and clock_i = '1') then -- rising clock edge
        if (en_i = '1') then
	        if (init_i = '1') then
	            block_s <= 0;
            else
                block_s <= block_s + 1;
            end if;
        else
            block_s <= block_s;
        end if;
    end if;
    end process seq_0;

    block_o <= std_logic_vector(to_unsigned(block_s, 2));

end architecture compteur_bloc_init_arch;
