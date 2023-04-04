-------------------------------------------------------------------------------
-- Title      : Substitution component
-- Project    : ASCON PCSN
-------------------------------------------------------------------------------
-- File	      : s_box.vhd
-- Author     : Mário da Silva ARAÚJO  <mario.dasilvaaraujo@etu.emse.fr>
-- Company    : MINES SAINT ETIENNE
-- Created    : 2022-11-05
-- Last update: 2022-12-23
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: Returns 5 bits as a function of the 5 input bits.
-------------------------------------------------------------------------------
-- Copyright (c) 2022 
-------------------------------------------------------------------------------

library IEEE;
use IEEE.numeric_std.all;
use IEEE.std_logic_1164.all;
library LIB_RTL;
use LIB_RTL.ascon_pack.all;

entity s_box is
    port(
        data_i : in  bit5; 
	    data_o : out bit5
	);
end entity s_box;

architecture s_box_arch of s_box is
    signal data_temp_s, data_compare_s : std_logic_vector(7 downto 0); --bit8;
begin
    -- For add 3 bits to get 8 bits => bit3 & bit5 = bit8
    data_compare_s <= "000"&data_i; 
    -- S-box conditions
    data_temp_s <= x"04" when data_compare_s = x"00" else
              x"0B" when data_compare_s = x"01" else
              x"1F" when data_compare_s = x"02" else
              x"14" when data_compare_s = x"03" else
              x"1A" when data_compare_s = x"04" else
              x"15" when data_compare_s = x"05" else
              x"09" when data_compare_s = x"06" else
              x"02" when data_compare_s = x"07" else
              x"1B" when data_compare_s = x"08" else
              x"05" when data_compare_s = x"09" else
              x"08" when data_compare_s = x"0A" else
              x"12" when data_compare_s = x"0B" else
              x"1D" when data_compare_s = x"0C" else
              x"03" when data_compare_s = x"0D" else
              x"06" when data_compare_s = x"0E" else
              x"1C" when data_compare_s = x"0F" else
              x"1E" when data_compare_s = x"10" else
              x"13" when data_compare_s = x"11" else
              x"07" when data_compare_s = x"12" else
              x"0E" when data_compare_s = x"13" else
              x"00" when data_compare_s = x"14" else
              x"0D" when data_compare_s = x"15" else
              x"11" when data_compare_s = x"16" else
              x"18" when data_compare_s = x"17" else
              x"10" when data_compare_s = x"18" else
              x"0C" when data_compare_s = x"19" else
              x"01" when data_compare_s = x"1A" else
              x"19" when data_compare_s = x"1B" else
              x"16" when data_compare_s = x"1C" else
              x"0A" when data_compare_s = x"1D" else
              x"0F" when data_compare_s = x"1E" else
              x"17";  -- when data_compare_s = x"1F"
    -- Only the 5 weakest bits matter (xxx 000000)
    data_o <= data_temp_s(4 downto 0);
end architecture s_box_arch;
