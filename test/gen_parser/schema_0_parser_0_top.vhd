library ieee;
use ieee.std_logic_1164.all;

library work;
use work.schema_parser.all;

entity schema_0_parser_0_top_com is
  port (
    clk : in std_logic;
    rst : in std_logic;
    input_valid : in std_logic;
    input_ready : out std_logic;
    input_data : in std_logic_vector(31 downto 0);
    input_last : in std_logic_vector(7 downto 0);
    input_stai : in std_logic_vector(1 downto 0);
    input_endi : in std_logic_vector(1 downto 0);
    input_strb : in std_logic_vector(3 downto 0);
    output_int_parser_L3_00_inst_valid : out std_logic;
    output_int_parser_L3_00_inst_ready : in std_logic;
    output_int_parser_L3_00_inst_data : out std_logic_vector(63 downto 0);
    output_int_parser_L3_00_inst_last : out std_logic_vector(2 downto 0);
    output_int_parser_L3_00_inst_strb : out std_logic
  );
end schema_0_parser_0_top_com;

architecture schema_0_parser_0_top of schema_0_parser_0_top_com is
  signal array_parser_L2_00_inst_0_input_valid : std_logic;
  signal array_parser_L2_00_inst_0_input_ready : std_logic;
  signal array_parser_L2_00_inst_0_input_data : std_logic_vector(31 downto 0);
  signal array_parser_L2_00_inst_0_input_last : std_logic_vector(11 downto 0);
  signal array_parser_L2_00_inst_0_input_stai : std_logic_vector(1 downto 0);
  signal array_parser_L2_00_inst_0_input_endi : std_logic_vector(1 downto 0);
  signal array_parser_L2_00_inst_0_input_strb : std_logic_vector(3 downto 0);
  signal array_parser_L2_00_inst_0_output_valid : std_logic;
  signal array_parser_L2_00_inst_0_output_ready : std_logic;
  signal array_parser_L2_00_inst_0_output_data : std_logic_vector(31 downto 0);
  signal array_parser_L2_00_inst_0_output_last : std_logic_vector(15 downto 0);
  signal array_parser_L2_00_inst_0_output_stai : std_logic_vector(1 downto 0);
  signal array_parser_L2_00_inst_0_output_endi : std_logic_vector(1 downto 0);
  signal array_parser_L2_00_inst_0_output_strb : std_logic_vector(3 downto 0);
  signal int_parser_L3_00_inst_0_input_valid : std_logic;
  signal int_parser_L3_00_inst_0_input_ready : std_logic;
  signal int_parser_L3_00_inst_0_input_data : std_logic_vector(31 downto 0);
  signal int_parser_L3_00_inst_0_input_last : std_logic_vector(15 downto 0);
  signal int_parser_L3_00_inst_0_input_stai : std_logic_vector(1 downto 0);
  signal int_parser_L3_00_inst_0_input_endi : std_logic_vector(1 downto 0);
  signal int_parser_L3_00_inst_0_input_strb : std_logic_vector(3 downto 0);
  signal int_parser_L3_00_inst_0_output_valid : std_logic;
  signal int_parser_L3_00_inst_0_output_ready : std_logic;
  signal int_parser_L3_00_inst_0_output_data : std_logic_vector(63 downto 0);
  signal int_parser_L3_00_inst_0_output_last : std_logic_vector(2 downto 0);
  signal int_parser_L3_00_inst_0_output_strb : std_logic;
  signal key_parser_L2_00_inst_0_input_valid : std_logic;
  signal key_parser_L2_00_inst_0_input_ready : std_logic;
  signal key_parser_L2_00_inst_0_input_data : std_logic_vector(35 downto 0);
  signal key_parser_L2_00_inst_0_input_last : std_logic_vector(11 downto 0);
  signal key_parser_L2_00_inst_0_input_stai : std_logic_vector(1 downto 0);
  signal key_parser_L2_00_inst_0_input_endi : std_logic_vector(1 downto 0);
  signal key_parser_L2_00_inst_0_input_strb : std_logic_vector(3 downto 0);
  signal key_parser_L2_00_inst_0_matcher_str_valid : std_logic;
  signal key_parser_L2_00_inst_0_matcher_str_ready : std_logic;
  signal key_parser_L2_00_inst_0_matcher_str_data : std_logic_vector(31 downto 0);
  signal key_parser_L2_00_inst_0_matcher_str_last : std_logic_vector(3 downto 0);
  signal key_parser_L2_00_inst_0_matcher_str_stai : std_logic_vector(1 downto 0);
  signal key_parser_L2_00_inst_0_matcher_str_endi : std_logic_vector(1 downto 0);
  signal key_parser_L2_00_inst_0_matcher_str_strb : std_logic_vector(3 downto 0);
  signal key_parser_L2_00_inst_0_matcher_match_valid : std_logic;
  signal key_parser_L2_00_inst_0_matcher_match_ready : std_logic;
  signal key_parser_L2_00_inst_0_matcher_match_data : std_logic_vector(3 downto 0);
  signal key_parser_L2_00_inst_0_matcher_match_last : std_logic_vector(3 downto 0);
  signal key_parser_L2_00_inst_0_matcher_match_stai : std_logic_vector(1 downto 0);
  signal key_parser_L2_00_inst_0_matcher_match_endi : std_logic_vector(1 downto 0);
  signal key_parser_L2_00_inst_0_matcher_match_strb : std_logic_vector(3 downto 0);
  signal key_parser_L2_00_inst_0_output_valid : std_logic;
  signal key_parser_L2_00_inst_0_output_ready : std_logic;
  signal key_parser_L2_00_inst_0_output_data : std_logic_vector(31 downto 0);
  signal key_parser_L2_00_inst_0_output_last : std_logic_vector(11 downto 0);
  signal key_parser_L2_00_inst_0_output_stai : std_logic_vector(1 downto 0);
  signal key_parser_L2_00_inst_0_output_endi : std_logic_vector(1 downto 0);
  signal key_parser_L2_00_inst_0_output_strb : std_logic_vector(3 downto 0);
  signal record_parser_L1_00_inst_0_input_valid : std_logic;
  signal record_parser_L1_00_inst_0_input_ready : std_logic;
  signal record_parser_L1_00_inst_0_input_data : std_logic_vector(31 downto 0);
  signal record_parser_L1_00_inst_0_input_last : std_logic_vector(7 downto 0);
  signal record_parser_L1_00_inst_0_input_stai : std_logic_vector(1 downto 0);
  signal record_parser_L1_00_inst_0_input_endi : std_logic_vector(1 downto 0);
  signal record_parser_L1_00_inst_0_input_strb : std_logic_vector(3 downto 0);
  signal record_parser_L1_00_inst_0_output_valid : std_logic;
  signal record_parser_L1_00_inst_0_output_ready : std_logic;
  signal record_parser_L1_00_inst_0_output_data : std_logic_vector(35 downto 0);
  signal record_parser_L1_00_inst_0_output_last : std_logic_vector(11 downto 0);
  signal record_parser_L1_00_inst_0_output_stai : std_logic_vector(1 downto 0);
  signal record_parser_L1_00_inst_0_output_endi : std_logic_vector(1 downto 0);
  signal record_parser_L1_00_inst_0_output_strb : std_logic_vector(3 downto 0);
  signal voltage_matcher_L2_00_inst_0_input_valid : std_logic;
  signal voltage_matcher_L2_00_inst_0_input_ready : std_logic;
  signal voltage_matcher_L2_00_inst_0_input_data : std_logic_vector(31 downto 0);
  signal voltage_matcher_L2_00_inst_0_input_last : std_logic_vector(3 downto 0);
  signal voltage_matcher_L2_00_inst_0_input_stai : std_logic_vector(1 downto 0);
  signal voltage_matcher_L2_00_inst_0_input_endi : std_logic_vector(1 downto 0);
  signal voltage_matcher_L2_00_inst_0_input_strb : std_logic_vector(3 downto 0);
  signal voltage_matcher_L2_00_inst_0_output_valid : std_logic;
  signal voltage_matcher_L2_00_inst_0_output_ready : std_logic;
  signal voltage_matcher_L2_00_inst_0_output_data : std_logic_vector(3 downto 0);
  signal voltage_matcher_L2_00_inst_0_output_last : std_logic_vector(3 downto 0);
  signal voltage_matcher_L2_00_inst_0_output_stai : std_logic_vector(1 downto 0);
  signal voltage_matcher_L2_00_inst_0_output_endi : std_logic_vector(1 downto 0);
  signal voltage_matcher_L2_00_inst_0_output_strb : std_logic_vector(3 downto 0);
begin
  array_parser_L2_00_inst: schema_0_parser_0_array_parser_L2_00_com port map(
    clk => clk,
    rst => rst,
    input_valid => array_parser_L2_00_inst_0_input_valid,
    input_ready => array_parser_L2_00_inst_0_input_ready,
    input_data => array_parser_L2_00_inst_0_input_data,
    input_last => array_parser_L2_00_inst_0_input_last,
    input_stai => array_parser_L2_00_inst_0_input_stai,
    input_endi => array_parser_L2_00_inst_0_input_endi,
    input_strb => array_parser_L2_00_inst_0_input_strb,
    output_valid => array_parser_L2_00_inst_0_output_valid,
    output_ready => array_parser_L2_00_inst_0_output_ready,
    output_data => array_parser_L2_00_inst_0_output_data,
    output_last => array_parser_L2_00_inst_0_output_last,
    output_stai => array_parser_L2_00_inst_0_output_stai,
    output_endi => array_parser_L2_00_inst_0_output_endi,
    output_strb => array_parser_L2_00_inst_0_output_strb
  );
  int_parser_L3_00_inst: schema_0_parser_0_int_parser_L3_00_com port map(
    clk => clk,
    rst => rst,
    input_valid => int_parser_L3_00_inst_0_input_valid,
    input_ready => int_parser_L3_00_inst_0_input_ready,
    input_data => int_parser_L3_00_inst_0_input_data,
    input_last => int_parser_L3_00_inst_0_input_last,
    input_stai => int_parser_L3_00_inst_0_input_stai,
    input_endi => int_parser_L3_00_inst_0_input_endi,
    input_strb => int_parser_L3_00_inst_0_input_strb,
    output_valid => int_parser_L3_00_inst_0_output_valid,
    output_ready => int_parser_L3_00_inst_0_output_ready,
    output_data => int_parser_L3_00_inst_0_output_data,
    output_last => int_parser_L3_00_inst_0_output_last,
    output_strb => int_parser_L3_00_inst_0_output_strb
  );
  key_parser_L2_00_inst: schema_0_parser_0_key_parser_L2_00_com port map(
    clk => clk,
    rst => rst,
    input_valid => key_parser_L2_00_inst_0_input_valid,
    input_ready => key_parser_L2_00_inst_0_input_ready,
    input_data => key_parser_L2_00_inst_0_input_data,
    input_last => key_parser_L2_00_inst_0_input_last,
    input_stai => key_parser_L2_00_inst_0_input_stai,
    input_endi => key_parser_L2_00_inst_0_input_endi,
    input_strb => key_parser_L2_00_inst_0_input_strb,
    matcher_str_valid => key_parser_L2_00_inst_0_matcher_str_valid,
    matcher_str_ready => key_parser_L2_00_inst_0_matcher_str_ready,
    matcher_str_data => key_parser_L2_00_inst_0_matcher_str_data,
    matcher_str_last => key_parser_L2_00_inst_0_matcher_str_last,
    matcher_str_stai => key_parser_L2_00_inst_0_matcher_str_stai,
    matcher_str_endi => key_parser_L2_00_inst_0_matcher_str_endi,
    matcher_str_strb => key_parser_L2_00_inst_0_matcher_str_strb,
    matcher_match_valid => key_parser_L2_00_inst_0_matcher_match_valid,
    matcher_match_ready => key_parser_L2_00_inst_0_matcher_match_ready,
    matcher_match_data => key_parser_L2_00_inst_0_matcher_match_data,
    matcher_match_last => key_parser_L2_00_inst_0_matcher_match_last,
    matcher_match_stai => key_parser_L2_00_inst_0_matcher_match_stai,
    matcher_match_endi => key_parser_L2_00_inst_0_matcher_match_endi,
    matcher_match_strb => key_parser_L2_00_inst_0_matcher_match_strb,
    output_valid => key_parser_L2_00_inst_0_output_valid,
    output_ready => key_parser_L2_00_inst_0_output_ready,
    output_data => key_parser_L2_00_inst_0_output_data,
    output_last => key_parser_L2_00_inst_0_output_last,
    output_stai => key_parser_L2_00_inst_0_output_stai,
    output_endi => key_parser_L2_00_inst_0_output_endi,
    output_strb => key_parser_L2_00_inst_0_output_strb
  );
  record_parser_L1_00_inst: schema_0_parser_0_record_parser_L1_00_com port map(
    clk => clk,
    rst => rst,
    input_valid => record_parser_L1_00_inst_0_input_valid,
    input_ready => record_parser_L1_00_inst_0_input_ready,
    input_data => record_parser_L1_00_inst_0_input_data,
    input_last => record_parser_L1_00_inst_0_input_last,
    input_stai => record_parser_L1_00_inst_0_input_stai,
    input_endi => record_parser_L1_00_inst_0_input_endi,
    input_strb => record_parser_L1_00_inst_0_input_strb,
    output_valid => record_parser_L1_00_inst_0_output_valid,
    output_ready => record_parser_L1_00_inst_0_output_ready,
    output_data => record_parser_L1_00_inst_0_output_data,
    output_last => record_parser_L1_00_inst_0_output_last,
    output_stai => record_parser_L1_00_inst_0_output_stai,
    output_endi => record_parser_L1_00_inst_0_output_endi,
    output_strb => record_parser_L1_00_inst_0_output_strb
  );
  voltage_matcher_L2_00_inst: schema_0_parser_0_voltage_matcher_L2_00_com port map(
    clk => clk,
    rst => rst,
    input_valid => voltage_matcher_L2_00_inst_0_input_valid,
    input_ready => voltage_matcher_L2_00_inst_0_input_ready,
    input_data => voltage_matcher_L2_00_inst_0_input_data,
    input_last => voltage_matcher_L2_00_inst_0_input_last,
    input_stai => voltage_matcher_L2_00_inst_0_input_stai,
    input_endi => voltage_matcher_L2_00_inst_0_input_endi,
    input_strb => voltage_matcher_L2_00_inst_0_input_strb,
    output_valid => voltage_matcher_L2_00_inst_0_output_valid,
    output_ready => voltage_matcher_L2_00_inst_0_output_ready,
    output_data => voltage_matcher_L2_00_inst_0_output_data,
    output_last => voltage_matcher_L2_00_inst_0_output_last,
    output_stai => voltage_matcher_L2_00_inst_0_output_stai,
    output_endi => voltage_matcher_L2_00_inst_0_output_endi,
    output_strb => voltage_matcher_L2_00_inst_0_output_strb
  );
  record_parser_L1_00_inst_0_input_valid <= input_valid;
  input_ready <= record_parser_L1_00_inst_0_input_ready;
  record_parser_L1_00_inst_0_input_data <= input_data;
  record_parser_L1_00_inst_0_input_last <= input_last;
  record_parser_L1_00_inst_0_input_stai <= input_stai;
  record_parser_L1_00_inst_0_input_endi <= input_endi;
  record_parser_L1_00_inst_0_input_strb <= input_strb;
  key_parser_L2_00_inst_0_input_valid <= record_parser_L1_00_inst_0_output_valid;
  record_parser_L1_00_inst_0_output_ready <= key_parser_L2_00_inst_0_input_ready;
  key_parser_L2_00_inst_0_input_data <= record_parser_L1_00_inst_0_output_data;
  key_parser_L2_00_inst_0_input_last <= record_parser_L1_00_inst_0_output_last;
  key_parser_L2_00_inst_0_input_stai <= record_parser_L1_00_inst_0_output_stai;
  key_parser_L2_00_inst_0_input_endi <= record_parser_L1_00_inst_0_output_endi;
  key_parser_L2_00_inst_0_input_strb <= record_parser_L1_00_inst_0_output_strb;
  array_parser_L2_00_inst_0_input_valid <= key_parser_L2_00_inst_0_output_valid;
  key_parser_L2_00_inst_0_output_ready <= array_parser_L2_00_inst_0_input_ready;
  array_parser_L2_00_inst_0_input_data <= key_parser_L2_00_inst_0_output_data;
  array_parser_L2_00_inst_0_input_last <= key_parser_L2_00_inst_0_output_last;
  array_parser_L2_00_inst_0_input_stai <= key_parser_L2_00_inst_0_output_stai;
  array_parser_L2_00_inst_0_input_endi <= key_parser_L2_00_inst_0_output_endi;
  array_parser_L2_00_inst_0_input_strb <= key_parser_L2_00_inst_0_output_strb;
  int_parser_L3_00_inst_0_input_valid <= array_parser_L2_00_inst_0_output_valid;
  array_parser_L2_00_inst_0_output_ready <= int_parser_L3_00_inst_0_input_ready;
  int_parser_L3_00_inst_0_input_data <= array_parser_L2_00_inst_0_output_data;
  int_parser_L3_00_inst_0_input_last <= array_parser_L2_00_inst_0_output_last;
  int_parser_L3_00_inst_0_input_stai <= array_parser_L2_00_inst_0_output_stai;
  int_parser_L3_00_inst_0_input_endi <= array_parser_L2_00_inst_0_output_endi;
  int_parser_L3_00_inst_0_input_strb <= array_parser_L2_00_inst_0_output_strb;
  output_int_parser_L3_00_inst_valid <= int_parser_L3_00_inst_0_output_valid;
  int_parser_L3_00_inst_0_output_ready <= output_int_parser_L3_00_inst_ready;
  output_int_parser_L3_00_inst_data <= int_parser_L3_00_inst_0_output_data;
  output_int_parser_L3_00_inst_last <= int_parser_L3_00_inst_0_output_last;
  output_int_parser_L3_00_inst_strb <= int_parser_L3_00_inst_0_output_strb;
  voltage_matcher_L2_00_inst_0_input_valid <= key_parser_L2_00_inst_0_matcher_str_valid;
  key_parser_L2_00_inst_0_matcher_str_ready <= voltage_matcher_L2_00_inst_0_input_ready;
  voltage_matcher_L2_00_inst_0_input_data <= key_parser_L2_00_inst_0_matcher_str_data;
  voltage_matcher_L2_00_inst_0_input_last <= key_parser_L2_00_inst_0_matcher_str_last;
  voltage_matcher_L2_00_inst_0_input_stai <= key_parser_L2_00_inst_0_matcher_str_stai;
  voltage_matcher_L2_00_inst_0_input_endi <= key_parser_L2_00_inst_0_matcher_str_endi;
  voltage_matcher_L2_00_inst_0_input_strb <= key_parser_L2_00_inst_0_matcher_str_strb;
  key_parser_L2_00_inst_0_matcher_match_valid <= voltage_matcher_L2_00_inst_0_output_valid;
  voltage_matcher_L2_00_inst_0_output_ready <= key_parser_L2_00_inst_0_matcher_match_ready;
  key_parser_L2_00_inst_0_matcher_match_data <= voltage_matcher_L2_00_inst_0_output_data;
  key_parser_L2_00_inst_0_matcher_match_last <= voltage_matcher_L2_00_inst_0_output_last;
  key_parser_L2_00_inst_0_matcher_match_stai <= voltage_matcher_L2_00_inst_0_output_stai;
  key_parser_L2_00_inst_0_matcher_match_endi <= voltage_matcher_L2_00_inst_0_output_endi;
  key_parser_L2_00_inst_0_matcher_match_strb <= voltage_matcher_L2_00_inst_0_output_strb;
end schema_0_parser_0_top;