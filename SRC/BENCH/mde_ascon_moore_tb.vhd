-------------------------------------------------------------------------------
-- Title      : Machine d'états de ASCON
-- Project    : ASCON PCSN
-------------------------------------------------------------------------------
-- File	      : mde_ascon_moore_tb.vhd
-- Author     : Mário da Silva ARAÚJO  <mario.dasilvaaraujo@etu.emse.fr>
-- Company    : MINES SAINT ETIENNE
-- Created    : 2022-12-19
-- Last update: 2023-01-01
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: state machine responsible for controlling the encryption
-- process.
-------------------------------------------------------------------------------
-- Copyright (c) 2022 
-------------------------------------------------------------------------------

library IEEE;
use IEEE.numeric_std.all;
use IEEE.std_logic_1164.all;
library LIB_RTL;
use LIB_RTL.ascon_pack.all;

entity mde_ascon_moore_tb is
end entity mde_ascon_moore_tb;