-------------------------------------------------------------------------------
-- Title      : Test Bench of Diffusion
-- Project    : ASCON PCSN
-------------------------------------------------------------------------------
-- File	      : diffusion_tb.vhd
-- Author     : Mário da Silva ARAÚJO  <mario.dasilvaaraujo@etu.emse.fr>
-- Company    : MINES SAINT ETIENNE
-- Created    : 2022-11-12
-- Last update: 2022-12-26
-- Platform   : 
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

entity diffusion_tb is

end entity diffusion_tb;

architecture diffusion_tb_arch of diffusion_tb is

    -- Calling the diffusion component
    component diffusion is
        port (
            data_i  : in  type_state;
            data_o	 : out type_state
            );
    end component diffusion;

    signal data_i_s : type_state;
    signal data_o_s : type_state;

  begin 
      DUT : diffusion
        port map (
            data_i => data_i_s,
            data_o => data_o_s
        );

        -- Input data for state_i
        data_i_s(0) <= x"8849060f0c0d0eff";
        data_i_s(1) <= x"80410e05040506f7";
        data_i_s(2) <= x"ffffffffffffff0f";
        data_i_s(3) <= x"80400406000000f0";
        data_i_s(4) <= x"0808080a08080808";

end architecture diffusion_tb_arch;

configuration diffusion_tb_conf of diffusion_tb is
  for diffusion_tb_arch
    for DUT : diffusion
      use entity LIB_RTL.diffusion(diffusion_arch);
    end for;
  end for;
end configuration diffusion_tb_conf;
