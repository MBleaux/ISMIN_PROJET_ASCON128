-------------------------------------------------------------------------------
-- Title      : Test Bench of Inter Permutation
-- Project    : ASCON PCSN
-------------------------------------------------------------------------------
-- File	      : permutation_inter_tb.vhd
-- Author     : Mário da Silva ARAÚJO  <mario.dasilvaaraujo@etu.emse.fr>
-- Company    : MINES SAINT ETIENNE
-- Created    : 2022-12-03
-- Last update: 2022-12-26
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: Connects the components: mux_state.vhd, add_const.vhd,
-- substitution.vhd, diffusion.vhd, state_register_w_en.vhd xor_begin.vhd and  
-- xor_end.vhd to form a inter permutation.
-------------------------------------------------------------------------------
-- Copyright (c) 2022 
-------------------------------------------------------------------------------

library IEEE;
use IEEE.numeric_std.all;
use IEEE.std_logic_1164.all;
library LIB_RTL;
use LIB_RTL.ascon_pack.all;

entity permutation_inter_tb is
end entity permutation_inter_tb;

architecture permutation_inter_tb_arch of permutation_inter_tb is

    -- Calling the permutation_inter component
	component permutation_inter is 
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
end component permutation_inter;
	
	signal state_i_s        : type_state;
	signal select_i_s       : std_logic;
	signal ena_register_i_s : std_logic;
	signal clk_i_s          : std_logic := '0';
	signal rstb_i_s         : std_logic;
	signal counter_i_s      : bit4;
    signal xor_data_s 		: bit64;
    signal ena_xor_data_b_s : std_logic;
    signal ena_xor_key_b_s  : std_logic;
    signal ena_xor_lsb_e_s  : std_logic;
    signal ena_xor_key_e_s  : std_logic;
    signal xor_key_s 		: bit128;
	signal state_o_s        : type_state;

	begin 
		DUT : permutation_inter
		port map(
			state_i           => state_i_s,
			select_i          => select_i_s,
			ena_register_i	  => ena_register_i_s,
			clk_i             => clk_i_s,
			rstb_i            => rstb_i_s,
			counter_i         => counter_i_s,
            xor_data_i 			=> xor_data_s,
			ena_xor_data_b_i  	=> ena_xor_data_b_s,
			ena_xor_key_b_i   	=> ena_xor_key_b_s,
			ena_xor_lsb_e_i   	=> ena_xor_lsb_e_s,
			ena_xor_key_e_i 	=> ena_xor_key_e_s,
			xor_key_i 			=> xor_key_s,
			state_o           => state_o_s
		);
		
        -- Period: 20ns
        -- Duty cycle: 50%
        -- Period activate: 10ns
        -- Period inactivate: 10ns
		clk_i_s <= not clk_i_s after 10 ns;
		
        -- Input data for state_i
		state_i_s(0) <= IV_c;
		state_i_s(1) <= x"0001020304050607"; 
		state_i_s(2) <= x"08090a0b0c0d0e0f"; 
		state_i_s(3) <= x"0001020304050607";
		state_i_s(4) <= x"08090a0b0c0d0e0f";
        xor_key_s 	 <= x"000102030405060708090A0B0C0D0E0F";
	    xor_data_s 	 <= x"32303232" & x"80000000";

		process 
			begin
                counter_i_s <= x"0";
                ena_register_i_s <= '1';
                rstb_i_s <= '0';
                select_i_s <= '1';    
                ena_xor_data_b_s <= '0';
                ena_xor_key_b_s <= '0';
                ena_xor_lsb_e_s <= '0';
                ena_xor_key_e_s <= '0'; 
                
                wait for 20 ns;

                rstb_i_s <= '1';

                wait for 20 ns;

                select_i_s <='0';
                counter_i_s <= x"1";

                wait for 20 ns;

                counter_i_s <= x"2";

                wait for 20 ns;

                counter_i_s <= x"3";
                
                wait for 20 ns;

                counter_i_s <= x"4";
                
                wait for 20 ns;

                counter_i_s <= x"5";
                
                wait for 20 ns;

                counter_i_s <= x"6";
                
                wait for 20 ns;

                counter_i_s <= x"7";
                
                wait for 20 ns;

                counter_i_s <= x"8";
                
                wait for 20 ns;

                counter_i_s <= x"9";
                
                wait for 20 ns;

                counter_i_s <= x"A";

                wait for 20 ns;

                counter_i_s <= x"B";
                ena_xor_key_e_s <= '1';

                wait for 20 ns;
                
                counter_i_s <= x"6";
                ena_xor_data_b_s <= '1';
                ena_xor_key_e_s <= '0';
                
                wait for 20 ns;
                
                counter_i_s <= x"7";
                ena_xor_data_b_s <= '0';
                
                wait for 20 ns;
                
                counter_i_s <= x"8";
                
                wait for 20 ns;
                
                counter_i_s <= x"9";
                
                wait for 20 ns;
                
                counter_i_s <= x"A";
                
                wait for 20 ns;
                
                counter_i_s <= x"B";
                ena_xor_lsb_e_s <= '1';
                
                wait for 20 ns; 

                end process;
end architecture permutation_inter_tb_arch;

configuration permutation_inter_tb_conf of permutation_inter_tb is
    for permutation_inter_tb_arch
        for DUT : permutation_inter
            use entity LIB_RTL.permutation_inter(permutation_inter_arch);
        end for;
    end for;
end configuration permutation_inter_tb_conf;