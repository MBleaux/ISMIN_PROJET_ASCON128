-------------------------------------------------------------------------------
-- Title      : Intermediate Permutation
-- Project    : ASCON PCSN
-------------------------------------------------------------------------------
-- File	      : permutation_inter.vhd
-- Author     : Mário da Silva ARAÚJO  <mario.dasilvaaraujo@etu.emse.fr>
-- Company    : MINES SAINT ETIENNE
-- Created    : 2022-12-10
-- Last update: 2022-12-23
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: Connects the components: mux_state.vhd, add_const.vhd,
-- substitution.vhd, diffusion.vhd, state_register_w_en.vhd, xor_begin.vhd and
-- xor_end.vhd to form a intermediate permutation.
-------------------------------------------------------------------------------
-- Copyright (c) 2022 
-------------------------------------------------------------------------------

library IEEE;
use IEEE.numeric_std.all;
use IEEE.std_logic_1164.all;
library LIB_RTL;
use LIB_RTL.ascon_pack.all;

entity permutation_inter is
    port(
        state_i           : in  type_state;
        select_i          : in  std_logic;
		ena_register_i    : in  std_logic;
		clk_i             : in  std_logic;
		rstb_i            : in  std_logic;
		counter_i         : in  bit4;
		xor_data_i        : in  bit64;
        ena_xor_data_b_i  : in  std_logic;
		ena_xor_key_b_i   : in  std_logic;
		ena_xor_lsb_e_i   : in  std_logic;
        ena_xor_key_e_i   : in  std_logic;
		xor_key_i         : in  bit128;
        state_o           : out type_state
	);
end entity permutation_inter;

architecture permutation_inter_arch of permutation_inter is

    -- Calling the multiplexer component
    component mux_state is
    port(
        sel_i   : in  std_logic;
        data0_i : in  type_state;
        data1_i : in  type_state;
        data_o  : out type_state
        );
    end component mux_state;

    -- Calling the state_register_w_en component
    component state_register_w_en is
        port(
          clock_i  : in  std_logic;
          resetb_i : in  std_logic;
          en_i     : in  std_logic;
          data_i   : in  type_state;
          data_o   : out type_state
          );
      end component state_register_w_en;

    -- Calling the add_const component
    component add_const is
        port(
            state_i  : in  type_state;
            round_i  : in  bit4; 
            state_o	 : out type_state
        );
    end component add_const;

    -- Calling the substitution component
    component substitution is
        port(
            state_i : in  type_state;
            state_o : out type_state
        );
    end component substitution;

    -- Calling the diffusion component
    component diffusion is
        port(
            data_i  : in  type_state;
            data_o	: out type_state
        );
    end component diffusion;

    -- Calling the xor_begin component
    component xor_begin is
        port(  
            data_i         : in  bit64;
            key_i          : in  bit128;
            state_i        : in  type_state;
            ena_xor_data_i : in  std_logic;
            ena_xor_key_i  : in  std_logic;
            state_o        : out type_state
        );
    end component xor_begin;
    
    -- Calling the xor_end component
    component xor_end is
        port(  
            key_i          : in  bit128;
            state_i        : in  type_state;
            ena_xor_lsb_i  : in  std_logic;
            ena_xor_key_i  : in  std_logic;
            state_o        : out type_state
        );
    end component xor_end;
    
    -- Internal signals defined as: state_X_s
    -- Where "X" represents the output signal of a component
    -- M: mux_state
    -- A: add_const
    -- S: substitution
    -- D: diffusion
    -- R: register
    -- M_xor: xor after M (xor begin)
    -- D_xor: xor after D (xor end)
    signal state_R_s, state_M_s, state_A_s, state_S_s, state_D_s : type_state;
    signal state_M_xor_s, state_D_xor_s                          : type_state;

begin

    Mux: mux_state
    port map(
        sel_i   => select_i,
        data0_i => state_R_s, -- state_R_s <= state_o
        data1_i => state_i,
        data_o  => state_M_s
    );

    Xor_b: xor_begin
    port map(
        data_i         => xor_data_i,
        key_i          => xor_key_i,
        state_i        => state_M_s,
        ena_xor_data_i => ena_xor_data_b_i, 
        ena_xor_key_i  => ena_xor_key_b_i,
        state_o        => state_M_xor_s
    );

    Pc: add_const
    port map(
        state_i => state_M_xor_s,
        round_i => counter_i,
        state_o => state_A_s
    );

    Ps: substitution
    port map(
        state_i => state_A_s,
        state_o => state_S_s
    );

    Pl: diffusion
    port map(
        data_i => state_S_s,
        data_o => state_D_s
    );

    Xor_e: xor_end
    port map(  
            key_i          => xor_key_i,
            state_i        => state_D_s, 
            ena_xor_lsb_i  => ena_xor_lsb_e_i,
            ena_xor_key_i  => ena_xor_key_e_i,
            state_o        => state_D_xor_s
    );

    Reg: state_register_w_en
    port map(
        clock_i  => clk_i,
        resetb_i => rstb_i,
        en_i     => ena_register_i,
        data_i   => state_D_xor_s,
        data_o   => state_R_s
    );

    state_o <= state_R_s;

end architecture permutation_inter_arch;