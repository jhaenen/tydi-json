library ieee;
use ieee.std_logic_1164.all;

library work;
use work.test.all;

entity schema_parser_top_com is
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
    output_int_parser_L3_0_inst_valid : out std_logic;
    output_int_parser_L3_0_inst_ready : in std_logic;
    output_int_parser_L3_0_inst_data : out std_logic_vector(63 downto 0);
    output_int_parser_L3_0_inst_last : out std_logic_vector(2 downto 0);
    output_int_parser_L3_0_inst_strb : out std_logic
  );
end schema_parser_top_com;

architecture \schema__parser__top\ of schema_parser_top_com is
  signal \array_parser_L2_0_inst__input_valid\ : std_logic;
  signal \array_parser_L2_0_inst__input_ready\ : std_logic;
  signal \array_parser_L2_0_inst__input_data\ : std_logic_vector(31 downto 0);
  signal \array_parser_L2_0_inst__input_last\ : std_logic_vector(11 downto 0);
  signal \array_parser_L2_0_inst__input_stai\ : std_logic_vector(1 downto 0);
  signal \array_parser_L2_0_inst__input_endi\ : std_logic_vector(1 downto 0);
  signal \array_parser_L2_0_inst__input_strb\ : std_logic_vector(3 downto 0);
  signal \array_parser_L2_0_inst__output_valid\ : std_logic;
  signal \array_parser_L2_0_inst__output_ready\ : std_logic;
  signal \array_parser_L2_0_inst__output_data\ : std_logic_vector(31 downto 0);
  signal \array_parser_L2_0_inst__output_last\ : std_logic_vector(15 downto 0);
  signal \array_parser_L2_0_inst__output_stai\ : std_logic_vector(1 downto 0);
  signal \array_parser_L2_0_inst__output_endi\ : std_logic_vector(1 downto 0);
  signal \array_parser_L2_0_inst__output_strb\ : std_logic_vector(3 downto 0);
  signal \int_parser_L3_0_inst__input_valid\ : std_logic;
  signal \int_parser_L3_0_inst__input_ready\ : std_logic;
  signal \int_parser_L3_0_inst__input_data\ : std_logic_vector(31 downto 0);
  signal \int_parser_L3_0_inst__input_last\ : std_logic_vector(15 downto 0);
  signal \int_parser_L3_0_inst__input_stai\ : std_logic_vector(1 downto 0);
  signal \int_parser_L3_0_inst__input_endi\ : std_logic_vector(1 downto 0);
  signal \int_parser_L3_0_inst__input_strb\ : std_logic_vector(3 downto 0);
  signal \int_parser_L3_0_inst__output_valid\ : std_logic;
  signal \int_parser_L3_0_inst__output_ready\ : std_logic;
  signal \int_parser_L3_0_inst__output_data\ : std_logic_vector(63 downto 0);
  signal \int_parser_L3_0_inst__output_last\ : std_logic_vector(2 downto 0);
  signal \int_parser_L3_0_inst__output_strb\ : std_logic;
  signal \key_parser_L2_0_inst__input_valid\ : std_logic;
  signal \key_parser_L2_0_inst__input_ready\ : std_logic;
  signal \key_parser_L2_0_inst__input_data\ : std_logic_vector(35 downto 0);
  signal \key_parser_L2_0_inst__input_last\ : std_logic_vector(11 downto 0);
  signal \key_parser_L2_0_inst__input_stai\ : std_logic_vector(1 downto 0);
  signal \key_parser_L2_0_inst__input_endi\ : std_logic_vector(1 downto 0);
  signal \key_parser_L2_0_inst__input_strb\ : std_logic_vector(3 downto 0);
  signal \key_parser_L2_0_inst__matcher_match_valid\ : std_logic;
  signal \key_parser_L2_0_inst__matcher_match_ready\ : std_logic;
  signal \key_parser_L2_0_inst__matcher_match_data\ : std_logic_vector(3 downto 0);
  signal \key_parser_L2_0_inst__matcher_match_last\ : std_logic_vector(3 downto 0);
  signal \key_parser_L2_0_inst__matcher_match_stai\ : std_logic_vector(1 downto 0);
  signal \key_parser_L2_0_inst__matcher_match_endi\ : std_logic_vector(1 downto 0);
  signal \key_parser_L2_0_inst__matcher_match_strb\ : std_logic_vector(3 downto 0);
  signal \key_parser_L2_0_inst__matcher_str_valid\ : std_logic;
  signal \key_parser_L2_0_inst__matcher_str_ready\ : std_logic;
  signal \key_parser_L2_0_inst__matcher_str_data\ : std_logic_vector(31 downto 0);
  signal \key_parser_L2_0_inst__matcher_str_last\ : std_logic_vector(3 downto 0);
  signal \key_parser_L2_0_inst__matcher_str_stai\ : std_logic_vector(1 downto 0);
  signal \key_parser_L2_0_inst__matcher_str_endi\ : std_logic_vector(1 downto 0);
  signal \key_parser_L2_0_inst__matcher_str_strb\ : std_logic_vector(3 downto 0);
  signal \key_parser_L2_0_inst__output_valid\ : std_logic;
  signal \key_parser_L2_0_inst__output_ready\ : std_logic;
  signal \key_parser_L2_0_inst__output_data\ : std_logic_vector(31 downto 0);
  signal \key_parser_L2_0_inst__output_last\ : std_logic_vector(11 downto 0);
  signal \key_parser_L2_0_inst__output_stai\ : std_logic_vector(1 downto 0);
  signal \key_parser_L2_0_inst__output_endi\ : std_logic_vector(1 downto 0);
  signal \key_parser_L2_0_inst__output_strb\ : std_logic_vector(3 downto 0);
  signal \record_parser_L1_0_inst__input_valid\ : std_logic;
  signal \record_parser_L1_0_inst__input_ready\ : std_logic;
  signal \record_parser_L1_0_inst__input_data\ : std_logic_vector(31 downto 0);
  signal \record_parser_L1_0_inst__input_last\ : std_logic_vector(7 downto 0);
  signal \record_parser_L1_0_inst__input_stai\ : std_logic_vector(1 downto 0);
  signal \record_parser_L1_0_inst__input_endi\ : std_logic_vector(1 downto 0);
  signal \record_parser_L1_0_inst__input_strb\ : std_logic_vector(3 downto 0);
  signal \record_parser_L1_0_inst__output_valid\ : std_logic;
  signal \record_parser_L1_0_inst__output_ready\ : std_logic;
  signal \record_parser_L1_0_inst__output_data\ : std_logic_vector(35 downto 0);
  signal \record_parser_L1_0_inst__output_last\ : std_logic_vector(11 downto 0);
  signal \record_parser_L1_0_inst__output_stai\ : std_logic_vector(1 downto 0);
  signal \record_parser_L1_0_inst__output_endi\ : std_logic_vector(1 downto 0);
  signal \record_parser_L1_0_inst__output_strb\ : std_logic_vector(3 downto 0);
  signal \voltage_matcher_L2_0_inst__input_valid\ : std_logic;
  signal \voltage_matcher_L2_0_inst__input_ready\ : std_logic;
  signal \voltage_matcher_L2_0_inst__input_data\ : std_logic_vector(31 downto 0);
  signal \voltage_matcher_L2_0_inst__input_last\ : std_logic_vector(3 downto 0);
  signal \voltage_matcher_L2_0_inst__input_stai\ : std_logic_vector(1 downto 0);
  signal \voltage_matcher_L2_0_inst__input_endi\ : std_logic_vector(1 downto 0);
  signal \voltage_matcher_L2_0_inst__input_strb\ : std_logic_vector(3 downto 0);
  signal \voltage_matcher_L2_0_inst__output_valid\ : std_logic;
  signal \voltage_matcher_L2_0_inst__output_ready\ : std_logic;
  signal \voltage_matcher_L2_0_inst__output_data\ : std_logic_vector(3 downto 0);
  signal \voltage_matcher_L2_0_inst__output_last\ : std_logic_vector(3 downto 0);
  signal \voltage_matcher_L2_0_inst__output_stai\ : std_logic_vector(1 downto 0);
  signal \voltage_matcher_L2_0_inst__output_endi\ : std_logic_vector(1 downto 0);
  signal \voltage_matcher_L2_0_inst__output_strb\ : std_logic_vector(3 downto 0);
begin
  array_parser_L2_0_inst: schema_parser_array_parser_L2_0_com port map(
    clk => clk,
    rst => rst,
    input_valid => \array_parser_L2_0_inst__input_valid\,
    input_ready => \array_parser_L2_0_inst__input_ready\,
    input_data => \array_parser_L2_0_inst__input_data\,
    input_last => \array_parser_L2_0_inst__input_last\,
    input_stai => \array_parser_L2_0_inst__input_stai\,
    input_endi => \array_parser_L2_0_inst__input_endi\,
    input_strb => \array_parser_L2_0_inst__input_strb\,
    output_valid => \array_parser_L2_0_inst__output_valid\,
    output_ready => \array_parser_L2_0_inst__output_ready\,
    output_data => \array_parser_L2_0_inst__output_data\,
    output_last => \array_parser_L2_0_inst__output_last\,
    output_stai => \array_parser_L2_0_inst__output_stai\,
    output_endi => \array_parser_L2_0_inst__output_endi\,
    output_strb => \array_parser_L2_0_inst__output_strb\
  );
  int_parser_L3_0_inst: schema_parser_int_parser_L3_0_com port map(
    clk => clk,
    rst => rst,
    input_valid => \int_parser_L3_0_inst__input_valid\,
    input_ready => \int_parser_L3_0_inst__input_ready\,
    input_data => \int_parser_L3_0_inst__input_data\,
    input_last => \int_parser_L3_0_inst__input_last\,
    input_stai => \int_parser_L3_0_inst__input_stai\,
    input_endi => \int_parser_L3_0_inst__input_endi\,
    input_strb => \int_parser_L3_0_inst__input_strb\,
    output_valid => \int_parser_L3_0_inst__output_valid\,
    output_ready => \int_parser_L3_0_inst__output_ready\,
    output_data => \int_parser_L3_0_inst__output_data\,
    output_last => \int_parser_L3_0_inst__output_last\,
    output_strb => \int_parser_L3_0_inst__output_strb\
  );
  key_parser_L2_0_inst: schema_parser_key_parser_L2_0_com port map(
    clk => clk,
    rst => rst,
    input_valid => \key_parser_L2_0_inst__input_valid\,
    input_ready => \key_parser_L2_0_inst__input_ready\,
    input_data => \key_parser_L2_0_inst__input_data\,
    input_last => \key_parser_L2_0_inst__input_last\,
    input_stai => \key_parser_L2_0_inst__input_stai\,
    input_endi => \key_parser_L2_0_inst__input_endi\,
    input_strb => \key_parser_L2_0_inst__input_strb\,
    matcher_match_valid => \key_parser_L2_0_inst__matcher_match_valid\,
    matcher_match_ready => \key_parser_L2_0_inst__matcher_match_ready\,
    matcher_match_data => \key_parser_L2_0_inst__matcher_match_data\,
    matcher_match_last => \key_parser_L2_0_inst__matcher_match_last\,
    matcher_match_stai => \key_parser_L2_0_inst__matcher_match_stai\,
    matcher_match_endi => \key_parser_L2_0_inst__matcher_match_endi\,
    matcher_match_strb => \key_parser_L2_0_inst__matcher_match_strb\,
    matcher_str_valid => \key_parser_L2_0_inst__matcher_str_valid\,
    matcher_str_ready => \key_parser_L2_0_inst__matcher_str_ready\,
    matcher_str_data => \key_parser_L2_0_inst__matcher_str_data\,
    matcher_str_last => \key_parser_L2_0_inst__matcher_str_last\,
    matcher_str_stai => \key_parser_L2_0_inst__matcher_str_stai\,
    matcher_str_endi => \key_parser_L2_0_inst__matcher_str_endi\,
    matcher_str_strb => \key_parser_L2_0_inst__matcher_str_strb\,
    output_valid => \key_parser_L2_0_inst__output_valid\,
    output_ready => \key_parser_L2_0_inst__output_ready\,
    output_data => \key_parser_L2_0_inst__output_data\,
    output_last => \key_parser_L2_0_inst__output_last\,
    output_stai => \key_parser_L2_0_inst__output_stai\,
    output_endi => \key_parser_L2_0_inst__output_endi\,
    output_strb => \key_parser_L2_0_inst__output_strb\
  );
  record_parser_L1_0_inst: schema_parser_record_parser_L1_0_com port map(
    clk => clk,
    rst => rst,
    input_valid => \record_parser_L1_0_inst__input_valid\,
    input_ready => \record_parser_L1_0_inst__input_ready\,
    input_data => \record_parser_L1_0_inst__input_data\,
    input_last => \record_parser_L1_0_inst__input_last\,
    input_stai => \record_parser_L1_0_inst__input_stai\,
    input_endi => \record_parser_L1_0_inst__input_endi\,
    input_strb => \record_parser_L1_0_inst__input_strb\,
    output_valid => \record_parser_L1_0_inst__output_valid\,
    output_ready => \record_parser_L1_0_inst__output_ready\,
    output_data => \record_parser_L1_0_inst__output_data\,
    output_last => \record_parser_L1_0_inst__output_last\,
    output_stai => \record_parser_L1_0_inst__output_stai\,
    output_endi => \record_parser_L1_0_inst__output_endi\,
    output_strb => \record_parser_L1_0_inst__output_strb\
  );
  voltage_matcher_L2_0_inst: schema_parser_voltage_matcher_L2_0_com port map(
    clk => clk,
    rst => rst,
    input_valid => \voltage_matcher_L2_0_inst__input_valid\,
    input_ready => \voltage_matcher_L2_0_inst__input_ready\,
    input_data => \voltage_matcher_L2_0_inst__input_data\,
    input_last => \voltage_matcher_L2_0_inst__input_last\,
    input_stai => \voltage_matcher_L2_0_inst__input_stai\,
    input_endi => \voltage_matcher_L2_0_inst__input_endi\,
    input_strb => \voltage_matcher_L2_0_inst__input_strb\,
    output_valid => \voltage_matcher_L2_0_inst__output_valid\,
    output_ready => \voltage_matcher_L2_0_inst__output_ready\,
    output_data => \voltage_matcher_L2_0_inst__output_data\,
    output_last => \voltage_matcher_L2_0_inst__output_last\,
    output_stai => \voltage_matcher_L2_0_inst__output_stai\,
    output_endi => \voltage_matcher_L2_0_inst__output_endi\,
    output_strb => \voltage_matcher_L2_0_inst__output_strb\
  );
  \record_parser_L1_0_inst__input_valid\ <= input_valid;
  input_ready <= \record_parser_L1_0_inst__input_ready\;
  \record_parser_L1_0_inst__input_data\ <= input_data;
  \record_parser_L1_0_inst__input_last\ <= input_last;
  \record_parser_L1_0_inst__input_stai\ <= input_stai;
  \record_parser_L1_0_inst__input_endi\ <= input_endi;
  \record_parser_L1_0_inst__input_strb\ <= input_strb;
  \key_parser_L2_0_inst__input_valid\ <= \record_parser_L1_0_inst__output_valid\;
  \record_parser_L1_0_inst__output_ready\ <= \key_parser_L2_0_inst__input_ready\;
  \key_parser_L2_0_inst__input_data\ <= \record_parser_L1_0_inst__output_data\;
  \key_parser_L2_0_inst__input_last\ <= \record_parser_L1_0_inst__output_last\;
  \key_parser_L2_0_inst__input_stai\ <= \record_parser_L1_0_inst__output_stai\;
  \key_parser_L2_0_inst__input_endi\ <= \record_parser_L1_0_inst__output_endi\;
  \key_parser_L2_0_inst__input_strb\ <= \record_parser_L1_0_inst__output_strb\;
  \array_parser_L2_0_inst__input_valid\ <= \key_parser_L2_0_inst__output_valid\;
  \key_parser_L2_0_inst__output_ready\ <= \array_parser_L2_0_inst__input_ready\;
  \array_parser_L2_0_inst__input_data\ <= \key_parser_L2_0_inst__output_data\;
  \array_parser_L2_0_inst__input_last\ <= \key_parser_L2_0_inst__output_last\;
  \array_parser_L2_0_inst__input_stai\ <= \key_parser_L2_0_inst__output_stai\;
  \array_parser_L2_0_inst__input_endi\ <= \key_parser_L2_0_inst__output_endi\;
  \array_parser_L2_0_inst__input_strb\ <= \key_parser_L2_0_inst__output_strb\;
  \int_parser_L3_0_inst__input_valid\ <= \array_parser_L2_0_inst__output_valid\;
  \array_parser_L2_0_inst__output_ready\ <= \int_parser_L3_0_inst__input_ready\;
  \int_parser_L3_0_inst__input_data\ <= \array_parser_L2_0_inst__output_data\;
  \int_parser_L3_0_inst__input_last\ <= \array_parser_L2_0_inst__output_last\;
  \int_parser_L3_0_inst__input_stai\ <= \array_parser_L2_0_inst__output_stai\;
  \int_parser_L3_0_inst__input_endi\ <= \array_parser_L2_0_inst__output_endi\;
  \int_parser_L3_0_inst__input_strb\ <= \array_parser_L2_0_inst__output_strb\;
  output_int_parser_L3_0_inst_valid <= \int_parser_L3_0_inst__output_valid\;
  \int_parser_L3_0_inst__output_ready\ <= output_int_parser_L3_0_inst_ready;
  output_int_parser_L3_0_inst_data <= \int_parser_L3_0_inst__output_data\;
  output_int_parser_L3_0_inst_last <= \int_parser_L3_0_inst__output_last\;
  output_int_parser_L3_0_inst_strb <= \int_parser_L3_0_inst__output_strb\;
  \voltage_matcher_L2_0_inst__input_valid\ <= \key_parser_L2_0_inst__matcher_str_valid\;
  \key_parser_L2_0_inst__matcher_str_ready\ <= \voltage_matcher_L2_0_inst__input_ready\;
  \voltage_matcher_L2_0_inst__input_data\ <= \key_parser_L2_0_inst__matcher_str_data\;
  \voltage_matcher_L2_0_inst__input_last\ <= \key_parser_L2_0_inst__matcher_str_last\;
  \voltage_matcher_L2_0_inst__input_stai\ <= \key_parser_L2_0_inst__matcher_str_stai\;
  \voltage_matcher_L2_0_inst__input_endi\ <= \key_parser_L2_0_inst__matcher_str_endi\;
  \voltage_matcher_L2_0_inst__input_strb\ <= \key_parser_L2_0_inst__matcher_str_strb\;
  \key_parser_L2_0_inst__matcher_match_valid\ <= \voltage_matcher_L2_0_inst__output_valid\;
  \voltage_matcher_L2_0_inst__output_ready\ <= \key_parser_L2_0_inst__matcher_match_ready\;
  \key_parser_L2_0_inst__matcher_match_data\ <= \voltage_matcher_L2_0_inst__output_data\;
  \key_parser_L2_0_inst__matcher_match_last\ <= \voltage_matcher_L2_0_inst__output_last\;
  \key_parser_L2_0_inst__matcher_match_stai\ <= \voltage_matcher_L2_0_inst__output_stai\;
  \key_parser_L2_0_inst__matcher_match_endi\ <= \voltage_matcher_L2_0_inst__output_endi\;
  \key_parser_L2_0_inst__matcher_match_strb\ <= \voltage_matcher_L2_0_inst__output_strb\;
end \schema__parser__top\;