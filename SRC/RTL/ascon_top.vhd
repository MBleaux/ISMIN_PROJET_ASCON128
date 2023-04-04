-------------------------------------------------------------------------------
-- Title      : ASCON Top Level
-- Project    : ASCON PCSN
-------------------------------------------------------------------------------
-- File	      : ascon_top.vhd
-- Author     : Mário da Silva ARAÚJO  <mario.dasilvaaraujo@etu.emse.fr>
-- Company    : MINES SAINT ETIENNE
-- Created    : 2022-12-21
-- Last update: 2023-01-01
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: ASCON encryption component consisting of:
-- permutation_finale.vhd, compteur_double_init.vhd, compteur_bloc_init.vhd and
-- mde_ascon_moore.vhd.
-------------------------------------------------------------------------------
-- Copyright (c) 2022 
-------------------------------------------------------------------------------

library IEEE;
use IEEE.numeric_std.all;
use IEEE.std_logic_1164.all;
library LIB_RTL;
use LIB_RTL.ascon_pack.all;

entity ascon_top is
    port(
        -- Inputs
        clock_i        : in std_logic;
        resetb_i       : in std_logic;
        start_i        : in std_logic;
        data_valid_i   : in std_logic;
        data_i         : in bit64;
        key_i          : in bit128;
	    nonce_i        : in bit128;
        -- Outputs
        cipher_valid_o : out std_logic;
        end_o          : out std_logic;
        cipher_o       : out bit64;
        tag_o          : out bit128
	);
end entity ascon_top;

architecture ascon_top_arch of ascon_top is

    -- Calling the final permutation component
    component permutation_finale is
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
            ena_registerT_i   : in  std_logic;
            ena_registerC_i   : in  std_logic;
            tag_o			  : out bit128;
            cipher_o		  : out bit64;
            state_o           : out type_state
        );
    end component permutation_finale;

    -- Calling the state machine component
    component mde_ascon_moore is
        port (  
            -- Inputs:
            start_i			: in std_logic;
            clock_i 		: in std_logic; 
            resetb_i		: in std_logic;
            data_valid_i	: in std_logic;
            round_i 		: in bit4;
            block_i 		: in bit2;
            -- Outputs:
            -- Primary
            data_valid_o 	: out std_logic;
            end_o 			: out std_logic;
            -- to "compteur_rounds"
            init_a_o 		: out std_logic;
            init_b_o 		: out std_logic;
            en_round_o		: out std_logic;
            -- to "compteur_blocs"
            en_block_o		: out std_logic;
            init_block_o 	: out std_logic;	
            -- To "permutation"
            sel_data_o		: out std_logic;
            -- to "xor_begin"
            en_xor_key_b_o	: out std_logic;
            en_xor_data_b_o	: out std_logic;
            -- to "xor_end"
            en_xor_key_e_o	: out std_logic;
            en_xor_lsb_e_o	: out std_logic;
            -- to "reg_state"
            en_reg_state_o	: out std_logic;
            -- to "reg_tag"
            en_tag_o		: out std_logic;
            -- to "reg_cipher"
            en_cipher_o 	: out std_logic
             );
        end component mde_ascon_moore;

    -- Calling the counter component for rounds
    component compteur_double_init is
        port (
          clock_i  : in  std_logic;
          resetb_i : in  std_logic;
          en_i     : in  std_logic;
          init_a_i : in  std_logic;
          init_b_i : in  std_logic;
          cpt_o    : out bit4
          );  
      end component compteur_double_init;
    
    -- Calling the counter component for blocks
    component compteur_bloc_init is
        port (
          clock_i  : in  std_logic;
          resetb_i : in  std_logic;
          en_i     : in  std_logic;
          init_i   : in  std_logic;
          block_o  : out bit2
          );
      end component compteur_bloc_init;
    
    -- Signals
    signal state_s, state_o_s : type_state;
    signal select_s, ena_register_s, clk_s, rstb_s, ena_xor_data_b_s, ena_xor_key_b_s, ena_xor_lsb_e_s, ena_xor_key_e_s, ena_registerT_s, ena_registerC_s : std_logic;
    signal start_s, data_valid_s, data_valid_o_s, end_s, init_a_s, init_b_s, en_round_s, en_block_s, init_block_s : std_logic;
    signal block_s : bit2;
    signal counter_s : bit4;
    signal xor_data_s, cipher_s : bit64;
    signal xor_key_s, tag_s : bit128;

begin
    -- Inputs:
    -- Clock and Reset
    clk_s <= clock_i;
    rstb_s <= resetb_i;
    -- State Machine
    start_s <= start_i;
    data_valid_s <= data_valid_i;
    -- Organizing the data for entry into the exchanger
    state_s(0) <= data_i;
    state_s(1) <= key_i(127 downto 64);
    state_s(2) <= key_i(063 downto 00);
    state_s(3) <= nonce_i(127 downto 64);
    state_s(4) <= nonce_i(063 downto 00);
    -- Constants
    xor_data_s 	 <= x"32303232" & x"80000000";
    xor_key_s 	 <= x"000102030405060708090A0B0C0D0E0F";
    -- Outpus:
    cipher_valid_o <= data_valid_o_s;
    end_o          <= end_s;
    cipher_o       <= cipher_s;
    tag_o          <= tag_s;

    Permutation_And_Xor: permutation_finale
    port map(
        state_i           => state_s,
        select_i          => select_s,
        ena_register_i    => ena_register_s,
        clk_i             => clk_s,
        rstb_i            => rstb_s,
        counter_i         => counter_s,
        xor_data_i        => xor_data_s,
        ena_xor_data_b_i  => ena_xor_data_b_s,
        ena_xor_key_b_i   => ena_xor_key_b_s,
        ena_xor_lsb_e_i   => ena_xor_lsb_e_s,
        ena_xor_key_e_i   => ena_xor_key_e_s,
        xor_key_i         => xor_key_s,
        ena_registerT_i   => ena_registerT_s,
        ena_registerC_i   => ena_registerC_s,
        tag_o			  => tag_s,
        cipher_o		  => cipher_s,
        state_o           => state_o_s
    );

    State_Machine : mde_ascon_moore
    port map(
        start_i			=> start_s,
        clock_i 		=> clk_s,
        resetb_i		=> rstb_s,
        data_valid_i	=> data_valid_s,
        round_i 		=> counter_s,
        block_i 		=> block_s,
        data_valid_o 	=> data_valid_o_s,
        end_o 			=> end_s,
        init_a_o 		=> init_a_s,
        init_b_o 		=> init_b_s,
        en_round_o		=> en_round_s,
        en_block_o		=> en_block_s,
        init_block_o 	=> init_block_s,
        sel_data_o		=> select_s,
        en_xor_key_b_o	=> ena_xor_key_b_s,
        en_xor_data_b_o	=> ena_xor_data_b_s,
        en_xor_key_e_o	=> ena_xor_key_e_s,
        en_xor_lsb_e_o	=> ena_xor_lsb_e_s,
        en_reg_state_o	=> ena_register_s,
        en_tag_o		=> ena_registerT_s,
        en_cipher_o 	=> ena_registerC_s
    );

    Round_Counter : compteur_double_init
    port map(
        clock_i  => clk_s,
        resetb_i => rstb_s,
        en_i     => en_round_s,
        init_a_i => init_a_s,
        init_b_i => init_b_s,
        cpt_o    => counter_s
    );

    Block_Counter : compteur_bloc_init
        port map(
          clock_i  => clk_s,
          resetb_i => rstb_s,
          en_i     => en_block_s,
          init_i   => init_block_s,
          block_o  => block_s
          );

end architecture ascon_top_arch;