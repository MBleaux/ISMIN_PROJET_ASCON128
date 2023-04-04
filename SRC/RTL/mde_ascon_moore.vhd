-------------------------------------------------------------------------------
-- Title      : Machine d'états de ASCON
-- Project    : ASCON PCSN
-------------------------------------------------------------------------------
-- File	      : mde_ascon_moore.vhd
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

entity mde_ascon_moore is
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
end entity mde_ascon_moore;

architecture mde_ascon_moore_arch of mde_ascon_moore is
	-- definition of the states present in the machine
	type state_t is (idle, conf_init, end_conf_init, init, end_init, idle_da, conf_da, end_conf_da, da, end_da, idle_cipher, conf_cipher, end_conf_cipher, cipher, end_cipher, idle_finale, conf_finale, end_conf_finale, finale, end_finale);
	-- type state
	signal etat_present, etat_futur : state_t;

begin
	-- sequential process for modeling the state register
	seq_0 : process (clock_i, resetb_i)
		begin 
			if resetb_i='0' then 
				etat_present <= idle;
			elsif (clock_i'event and clock_i='1') then 
				etat_present <= etat_futur;
			end if;
		end process seq_0;
	-- transition modelling
	comb_0 : process (etat_present, start_i, data_valid_i, round_i, block_i)
	begin
		case etat_present is 
			when idle =>
				if start_i = '1' then
					etat_futur <= conf_init;
				else
					etat_futur <= idle;
				end if;

			when conf_init =>
			-- without requirements
				etat_futur <= end_conf_init;

			when end_conf_init =>
			-- without requirements
				etat_futur <= init;

			when init =>
				if round_i = x"A" then
					etat_futur <= end_init;
				else
					etat_futur <= init;
				end if;

			when end_init =>
			-- without requirements
				etat_futur <= idle_da;

			when idle_da =>
				if data_valid_i = '1' then
					etat_futur <= conf_da;
				else
					etat_futur <= idle_da;
				end if;

			when conf_da =>
			-- without requirements
				etat_futur <= end_conf_da;

			when end_conf_da =>
			-- without requirements
				etat_futur <= da;

			when da =>
				if round_i = x"A" then
					etat_futur <= end_da;
				else
					etat_futur <= da;
				end if;

			when end_da =>
			-- without requirements
				etat_futur <= idle_cipher;

			when idle_cipher =>
				if data_valid_i = '1' then
					etat_futur <= conf_cipher;
				else
					etat_futur <= idle_cipher;
				end if;

			when conf_cipher =>
			-- without requirements
				etat_futur <= end_conf_cipher;

			when end_conf_cipher =>
			-- without requirements
				etat_futur <= cipher;

			when cipher =>
				if round_i = x"A" then
					etat_futur <= end_cipher;
				else
					etat_futur <= cipher;
				end if;

			when end_cipher => 
				if block_i < x"3" then
					etat_futur <= idle_cipher;
				else
					etat_futur <= idle_finale;
				end if;

			when idle_finale =>
			-- without requirements
				etat_futur <= conf_finale;

			when conf_finale =>
			-- without requirements
				etat_futur <= end_conf_finale;

			when end_conf_finale =>
			-- without requirements
				etat_futur <= finale;

			when finale =>
				if round_i = x"A" then
					etat_futur <= end_finale;
				else
					etat_futur <= finale;
				end if;

			when end_finale =>
				if start_i = '1' then
					etat_futur <= idle;
				else
					etat_futur <= end_finale;
				end if;
				
		end case;
	end process comb_0;

comb_1 : process (etat_present)
begin
	-- default value for all outputs
	end_o				<= '0';
	data_valid_o		<= '0';
	sel_data_o 			<= '0';
	en_xor_key_b_o		<= '0';
	en_xor_data_b_o		<= '0';
	en_xor_key_e_o		<= '0';
	en_xor_lsb_e_o		<= '0';
	en_reg_state_o		<= '0';
	en_cipher_o			<= '0';
	en_tag_o			<= '0';
	en_round_o			<= '0';
	init_a_o			<= '0';
	init_b_o			<= '0';
	en_block_o			<= '0';
	init_block_o		<= '0';

	case etat_present is 
		when idle =>
		end_o			<= '0';
		data_valid_o	<= '0';
		sel_data_o 		<= '0';
		en_xor_key_b_o	<= '0';
		en_xor_data_b_o	<= '0';
		en_xor_key_e_o	<= '0';
		en_xor_lsb_e_o	<= '0';
		en_reg_state_o	<= '0';
		en_cipher_o		<= '0';
		en_tag_o		<= '0';
		en_round_o		<= '0';
		init_a_o		<= '0';
		init_b_o		<= '0';
		en_block_o		<= '0';
		init_block_o	<= '0';	

		when conf_init =>
		end_o			<= '0';
		data_valid_o	<= '0';
		sel_data_o 		<= '0';
		en_xor_key_b_o	<= '0';
		en_xor_data_b_o	<= '0';
		en_xor_key_e_o	<= '0';
		en_xor_lsb_e_o	<= '0';
		en_reg_state_o	<= '0';
		en_cipher_o		<= '0';
		en_tag_o		<= '0';
		en_round_o		<= '1';
		init_a_o		<= '1';
		init_b_o		<= '0';
		en_block_o		<= '0';
		init_block_o	<= '0';	

		when end_conf_init =>
		end_o			<= '0';
		data_valid_o	<= '0';
		sel_data_o 		<= '0';
		en_xor_key_b_o	<= '0';
		en_xor_data_b_o	<= '0';
		en_xor_key_e_o	<= '0';
		en_xor_lsb_e_o	<= '0';
		en_reg_state_o	<= '1';
		en_cipher_o		<= '0';
		en_tag_o		<= '0';
		en_round_o		<= '1';
		init_a_o		<= '0';
		init_b_o		<= '0';
		en_block_o		<= '0';
		init_block_o	<= '0';	

		when init =>
		end_o			<= '0';
		data_valid_o	<= '0';
		sel_data_o 		<= '1';
		en_xor_key_b_o	<= '0';
		en_xor_data_b_o	<= '0';
		en_xor_key_e_o	<= '0';
		en_xor_lsb_e_o	<= '0';
		en_reg_state_o	<= '1';
		en_cipher_o		<= '0';
		en_tag_o		<= '0';
		en_round_o		<= '1';
		init_a_o		<= '0';
		init_b_o		<= '0';
		en_block_o		<= '0';
		init_block_o	<= '0';

		when end_init =>
		end_o			<= '0';
		data_valid_o	<= '0';
		sel_data_o 		<= '1';
		en_xor_key_b_o	<= '0';
		en_xor_data_b_o	<= '0';
		en_xor_key_e_o	<= '1';
		en_xor_lsb_e_o	<= '0';
		en_reg_state_o	<= '1';
		en_cipher_o		<= '0';
		en_tag_o		<= '0';
		en_round_o		<= '0';
		init_a_o		<= '0';
		init_b_o		<= '0';
		en_block_o		<= '0';
		init_block_o	<= '0';

		when idle_da =>
		end_o			<= '0';
		data_valid_o	<= '0';
		sel_data_o 		<= '1';
		en_xor_key_b_o	<= '0';
		en_xor_data_b_o	<= '0';
		en_xor_key_e_o	<= '0';
		en_xor_lsb_e_o	<= '0';
		en_reg_state_o	<= '0';
		en_cipher_o		<= '0';
		en_tag_o		<= '0';
		en_round_o		<= '0';
		init_a_o		<= '0';
		init_b_o		<= '0';
		en_block_o		<= '0';
		init_block_o	<= '0';

		when conf_da =>
		end_o			<= '0';
		data_valid_o	<= '1';
		sel_data_o 		<= '1';
		en_xor_key_b_o	<= '0';
		en_xor_data_b_o	<= '0';
		en_xor_key_e_o	<= '0';
		en_xor_lsb_e_o	<= '0';
		en_reg_state_o	<= '0';
		en_cipher_o		<= '0';
		en_tag_o		<= '0';
		en_round_o		<= '1';
		init_a_o		<= '0';
		init_b_o		<= '1';
		en_block_o		<= '0';
		init_block_o	<= '0';

		when end_conf_da =>
		end_o			<= '0';
		data_valid_o	<= '1';
		sel_data_o 		<= '1';
		en_xor_key_b_o	<= '0';
		en_xor_data_b_o	<= '1';
		en_xor_key_e_o	<= '0';
		en_xor_lsb_e_o	<= '0';
		en_reg_state_o	<= '1';
		en_cipher_o		<= '0';
		en_tag_o		<= '0';
		en_round_o		<= '1';
		init_a_o		<= '0';
		init_b_o		<= '0';
		en_block_o		<= '0';
		init_block_o	<= '0';

		when da =>
		end_o			<= '0';
		data_valid_o	<= '0';
		sel_data_o 		<= '1';
		en_xor_key_b_o	<= '0';
		en_xor_data_b_o	<= '0';
		en_xor_key_e_o	<= '0';
		en_xor_lsb_e_o	<= '0';
		en_reg_state_o	<= '1';
		en_cipher_o		<= '0';
		en_tag_o		<= '0';
		en_round_o		<= '1';
		init_a_o		<= '0';
		init_b_o		<= '0';
		en_block_o		<= '0';
		init_block_o	<= '0';

		when end_da =>
		end_o			<= '0';
		data_valid_o	<= '0';
		sel_data_o 		<= '1';
		en_xor_key_b_o	<= '0';
		en_xor_data_b_o	<= '0';
		en_xor_key_e_o	<= '0';
		en_xor_lsb_e_o	<= '1';
		en_reg_state_o	<= '1';
		en_cipher_o		<= '0';
		en_tag_o		<= '0';
		en_round_o		<= '0';
		init_a_o		<= '0';
		init_b_o		<= '0';
		en_block_o		<= '0';
		init_block_o	<= '0';

		when idle_cipher =>
		end_o			<= '0';
		data_valid_o	<= '0';
		sel_data_o 		<= '1';
		en_xor_key_b_o	<= '0';
		en_xor_data_b_o	<= '0';
		en_xor_key_e_o	<= '0';
		en_xor_lsb_e_o	<= '0';
		en_reg_state_o	<= '0';
		en_cipher_o		<= '0';
		en_tag_o		<= '0';
		en_round_o		<= '0';
		init_a_o		<= '0';
		init_b_o		<= '0';
		en_block_o		<= '0';
		init_block_o	<= '0';

		when conf_cipher =>
		end_o			<= '0';
		data_valid_o	<= '1';
		sel_data_o 		<= '1';
		en_xor_key_b_o	<= '0';
		en_xor_data_b_o	<= '0';
		en_xor_key_e_o	<= '0';
		en_xor_lsb_e_o	<= '0';
		en_reg_state_o	<= '0';
		en_cipher_o		<= '0';
		en_tag_o		<= '0';
		en_round_o		<= '1';
		init_a_o		<= '0';
		init_b_o		<= '1';
		en_block_o		<= '1';
		init_block_o	<= '1';

		when end_conf_cipher =>
		end_o			<= '0';
		data_valid_o	<= '1';
		sel_data_o 		<= '1';
		en_xor_key_b_o	<= '0';
		en_xor_data_b_o	<= '1';
		en_xor_key_e_o	<= '0';
		en_xor_lsb_e_o	<= '0';
		en_reg_state_o	<= '1';
		en_cipher_o		<= '1';
		en_tag_o		<= '0';
		en_round_o		<= '1';
		init_a_o		<= '0';
		init_b_o		<= '0';
		en_block_o		<= '1';
		init_block_o	<= '0';

		when cipher =>
		end_o			<= '0';
		data_valid_o	<= '0';
		sel_data_o 		<= '1';
		en_xor_key_b_o	<= '0';
		en_xor_data_b_o	<= '0';
		en_xor_key_e_o	<= '0';
		en_xor_lsb_e_o	<= '0';
		en_reg_state_o	<= '1';
		en_cipher_o		<= '1';
		en_tag_o		<= '0';
		en_round_o		<= '1';
		init_a_o		<= '0';
		init_b_o		<= '0';
		en_block_o		<= '1';
		init_block_o	<= '0';

		when end_cipher =>
		end_o			<= '0';
		data_valid_o	<= '0';
		sel_data_o 		<= '1';
		en_xor_key_b_o	<= '0';
		en_xor_data_b_o	<= '0';
		en_xor_key_e_o	<= '0';
		en_xor_lsb_e_o	<= '0';
		en_reg_state_o	<= '1';
		en_cipher_o		<= '1';
		en_tag_o		<= '0';
		en_round_o		<= '0';
		init_a_o		<= '0';
		init_b_o		<= '0';
		en_block_o		<= '0';
		init_block_o	<= '0';

		when idle_finale =>
		end_o			<= '0';
		data_valid_o	<= '0';
		sel_data_o 		<= '1';
		en_xor_key_b_o	<= '0';
		en_xor_data_b_o	<= '0';
		en_xor_key_e_o	<= '0';
		en_xor_lsb_e_o	<= '0';
		en_reg_state_o	<= '0';
		en_cipher_o		<= '0';
		en_tag_o		<= '0';
		en_round_o		<= '0';
		init_a_o		<= '0';
		init_b_o		<= '0';
		en_block_o		<= '0';
		init_block_o	<= '0';

		when conf_finale =>
		end_o			<= '0';
		data_valid_o	<= '0';
		sel_data_o 		<= '1';
		en_xor_key_b_o	<= '0';
		en_xor_data_b_o	<= '0';
		en_xor_key_e_o	<= '0';
		en_xor_lsb_e_o	<= '0';
		en_reg_state_o	<= '0';
		en_cipher_o		<= '0';
		en_tag_o		<= '0';
		en_round_o		<= '1';
		init_a_o		<= '1';
		init_b_o		<= '0';
		en_block_o		<= '0';
		init_block_o	<= '0';

		when end_conf_finale =>
		end_o			<= '0';
		data_valid_o	<= '0';
		sel_data_o 		<= '0';
		en_xor_key_b_o	<= '1';
		en_xor_data_b_o	<= '0';
		en_xor_key_e_o	<= '0';
		en_xor_lsb_e_o	<= '0';
		en_reg_state_o	<= '1';
		en_cipher_o		<= '0';
		en_tag_o		<= '0';
		en_round_o		<= '1';
		init_a_o		<= '0';
		init_b_o		<= '0';
		en_block_o		<= '0';
		init_block_o	<= '0';

		when finale =>
		end_o			<= '0';
		data_valid_o	<= '0';
		sel_data_o 		<= '1';
		en_xor_key_b_o	<= '0';
		en_xor_data_b_o	<= '0';
		en_xor_key_e_o	<= '0';
		en_xor_lsb_e_o	<= '0';
		en_reg_state_o	<= '1';
		en_cipher_o		<= '0';
		en_tag_o		<= '0';
		en_round_o		<= '1';
		init_a_o		<= '0';
		init_b_o		<= '0';
		en_block_o		<= '0';
		init_block_o	<= '0';

		when end_finale =>
		end_o			<= '1';
		data_valid_o	<= '0';
		sel_data_o 		<= '1';
		en_xor_key_b_o	<= '0';
		en_xor_data_b_o	<= '0';
		en_xor_key_e_o	<= '1';
		en_xor_lsb_e_o	<= '0';
		en_reg_state_o	<= '1';
		en_cipher_o		<= '0';
		en_tag_o		<= '1';
		en_round_o		<= '0';
		init_a_o		<= '0';
		init_b_o		<= '0';
		en_block_o		<= '0';
		init_block_o	<= '0';

	end case;
end process;

end architecture mde_ascon_moore_arch;