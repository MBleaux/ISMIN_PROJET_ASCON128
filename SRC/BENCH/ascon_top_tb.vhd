-------------------------------------------------------------------------------
-- Title      : Test Bench of ASCON Top Level
-- Project    : ASCON PCSN
-------------------------------------------------------------------------------
-- File	      : ascon_top_tb.vhd
-- Author     : Mário da Silva ARAÚJO  <mario.dasilvaaraujo@etu.emse.fr>
-- Company    : MINES SAINT ETIENNE
-- Created    : 2022-12-21
-- Last update: 2023-01-01
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: ASCON encryption component consisting of:
-- ascon_top.vhd, compteur_double_init.vhd, compteur_bloc_init.vhd and
-- mde_ascon_moore.vhd.
-------------------------------------------------------------------------------
-- Copyright (c) 2022 
-------------------------------------------------------------------------------

library IEEE;
use IEEE.numeric_std.all;
use IEEE.std_logic_1164.all;
library LIB_RTL;
use LIB_RTL.ascon_pack.all;

entity ascon_top_tb is
end entity ascon_top_tb;

architecture ascon_top_tb_arch of ascon_top_tb is

    -- Calling the ascon_top component
	component ascon_top is
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
    end component ascon_top;

	signal clock_s          : std_logic := '0';
	signal resetb_s         : std_logic;
	signal start_s          : std_logic;
    signal data_valid_s     : std_logic;
    signal data_s           : bit64;
    signal key_s            : bit128;
    signal nonce_s          : bit128;
    signal cipher_valid_o_s : std_logic;
    signal end_s            : std_logic;
    signal cipher_s         : bit64;
    signal tag_s            : bit128;

	begin
        -- Inputs:
        start_s         <= '1';
        data_valid_s    <= '1';
        data_s          <= IV_c;
        key_s           <= x"000102030405060708090a0b0c0d0e0f";
        nonce_s         <= x"000102030405060708090a0b0c0d0e0f";
        -- Period: 20ns
        -- Duty cycle: 50%
        -- Period activate: 10ns
        -- Period inactivate: 10ns
		clock_s     <= not clock_s after 10 ns;
        resetb_s    <= '1';

        DUT : ascon_top
		port map(
			-- Inputs
            clock_i        => clock_s,
            resetb_i       => resetb_s,
            start_i        => start_s,
            data_valid_i   => data_valid_s,
            data_i         => data_s,
            key_i          => key_s,
            nonce_i        => nonce_s,
            -- Outputs
            cipher_valid_o => cipher_valid_o_s,
            end_o          => end_s,
            cipher_o       => cipher_s,
            tag_o          => tag_s
		);

end architecture ascon_top_tb_arch;

configuration ascon_top_tb_conf of ascon_top_tb is
    for ascon_top_tb_arch
        for DUT : ascon_top
            use entity LIB_RTL.ascon_top(ascon_top_arch);
        end for;
    end for;
end configuration ascon_top_tb_conf;