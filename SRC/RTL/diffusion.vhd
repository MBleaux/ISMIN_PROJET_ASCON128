-------------------------------------------------------------------------------
-- Title      : Diffusion
-- Project    : ASCON PCSN
-------------------------------------------------------------------------------
-- File	      : diffusion.vhd
-- Author     : Mário da Silva ARAÚJO  <mario.dasilvaaraujo@etu.emse.fr>
-- Company    : MINES SAINT ETIENNE
-- Created    : 2022-11-12
-- Last update: 2022-12-23
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: Sum the input register with itself, but with its data shifted
-- following the rules:
-- x_0 ← Σ0(x_0) = x_0 ⊕ (x_0 ≫ 19) ⊕ (x_0 ≫ 28)
-- x_1 ← Σ1(x_1) = x_1 ⊕ (x_1 ≫ 61) ⊕ (x_1 ≫ 39)
-- x_2 ← Σ2(x_2) = x_2 ⊕ (x_2 ≫ 01) ⊕ (x_2 ≫ 06)
-- x_3 ← Σ3(x_3) = x_3 ⊕ (x_3 ≫ 10) ⊕ (x_3 ≫ 17)
-- x_4 ← Σ4(x_4) = x_4 ⊕ (x_4 ≫ 07) ⊕ (x_4 ≫ 41)
-- Where "n" of "x_n" represents the register numbering and ">> j" the number
-- of rightward j-shifts.
-------------------------------------------------------------------------------
-- Copyright (c) 2022 
-------------------------------------------------------------------------------

library IEEE;
use IEEE.numeric_std.all;
use IEEE.std_logic_1164.all;
library LIB_RTL;
use LIB_RTL.ascon_pack.all;

entity diffusion is
    port(
        data_i  : in  type_state;
	    data_o	: out type_state
	);
end entity diffusion;

architecture diffusion_arch of diffusion is
begin
		data_o(0) <= data_i(0) xor (data_i(0)(18 downto 0)&data_i(0)(63 downto 19)) xor (data_i(0)(27 downto 0)&data_i(0)(63 downto 28));
		data_o(1) <= data_i(1) xor (data_i(1)(60 downto 0)&data_i(1)(63 downto 61)) xor (data_i(1)(38 downto 0)&data_i(1)(63 downto 39));
		data_o(2) <= data_i(2) xor (data_i(2)(00 downto 0)&data_i(2)(63 downto 01)) xor (data_i(2)(05 downto 0)&data_i(2)(63 downto 06));
		data_o(3) <= data_i(3) xor (data_i(3)(09 downto 0)&data_i(3)(63 downto 10)) xor (data_i(3)(16 downto 0)&data_i(3)(63 downto 17));
		data_o(4) <= data_i(4) xor (data_i(4)(06 downto 0)&data_i(4)(63 downto 07)) xor (data_i(4)(40 downto 0)&data_i(4)(63 downto 41));
end architecture diffusion_arch;
