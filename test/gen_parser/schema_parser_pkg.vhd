library ieee;
use ieee.std_logic_1164.all;

package schema_parser is

  component schema_0_parser_0_array_parser_L2_00_com is
    generic (
      EPC : positive := 4;
      DIM : positive := 3;
      OUTER_NESTING_LEVEL : natural := 2;
      INNER_NESTING_LEVEL : natural := 0
    );
    port (
      clk : in std_logic;
      rst : in std_logic;
      input_valid : in std_logic;
      input_ready : out std_logic;
      input_data : in std_logic_vector(31 downto 0);
      input_last : in std_logic_vector((DIM * 4) - 1 downto 0);
      input_stai : in std_logic_vector(1 downto 0);
      input_endi : in std_logic_vector(1 downto 0);
      input_strb : in std_logic_vector(3 downto 0);
      output_valid : out std_logic;
      output_ready : in std_logic;
      output_data : out std_logic_vector(31 downto 0);
      output_last : out std_logic_vector(((DIM + 1) * 4) - 1 downto 0);
      output_stai : out std_logic_vector(1 downto 0);
      output_endi : out std_logic_vector(1 downto 0);
      output_strb : out std_logic_vector(3 downto 0)
    );
  end component schema_0_parser_0_array_parser_L2_00_com;

  component schema_0_parser_0_int_parser_L3_00_com is
    generic (
      EPC : positive := 4;
      DIM : positive := 4;
      NESTING_LEVEL : positive := 3;
      BITWIDTH : positive := 64
    );
    port (
      clk : in std_logic;
      rst : in std_logic;
      input_valid : in std_logic;
      input_ready : out std_logic;
      input_data : in std_logic_vector(31 downto 0);
      input_last : in std_logic_vector((DIM * 4) - 1 downto 0);
      input_stai : in std_logic_vector(1 downto 0);
      input_endi : in std_logic_vector(1 downto 0);
      input_strb : in std_logic_vector(3 downto 0);
      output_valid : out std_logic;
      output_ready : in std_logic;
      output_data : out std_logic_vector(63 downto 0);
      output_last : out std_logic_vector((DIM - 1) - 1 downto 0);
      output_strb : out std_logic
    );
  end component schema_0_parser_0_int_parser_L3_00_com;

  component schema_0_parser_0_key_parser_L2_00_com is
    generic (
      EPC : positive := 4;
      DIM : positive := 3;
      OUTER_NESTING_LEVEL : positive := 2
    );
    port (
      clk : in std_logic;
      rst : in std_logic;
      input_valid : in std_logic;
      input_ready : out std_logic;
      input_data : in std_logic_vector(35 downto 0);
      input_last : in std_logic_vector((DIM * 4) - 1 downto 0);
      input_stai : in std_logic_vector(1 downto 0);
      input_endi : in std_logic_vector(1 downto 0);
      input_strb : in std_logic_vector(3 downto 0);
      matcher_str_valid : out std_logic;
      matcher_str_ready : in std_logic;
      matcher_str_data : out std_logic_vector(31 downto 0);
      matcher_str_last : out std_logic_vector(3 downto 0);
      matcher_str_stai : out std_logic_vector(1 downto 0);
      matcher_str_endi : out std_logic_vector(1 downto 0);
      matcher_str_strb : out std_logic_vector(3 downto 0);
      matcher_match_valid : in std_logic;
      matcher_match_ready : out std_logic;
      matcher_match_data : in std_logic_vector(3 downto 0);
      matcher_match_last : in std_logic_vector(3 downto 0);
      matcher_match_stai : in std_logic_vector(1 downto 0);
      matcher_match_endi : in std_logic_vector(1 downto 0);
      matcher_match_strb : in std_logic_vector(3 downto 0);
      output_valid : out std_logic;
      output_ready : in std_logic;
      output_data : out std_logic_vector(31 downto 0);
      output_last : out std_logic_vector((DIM * 4) - 1 downto 0);
      output_stai : out std_logic_vector(1 downto 0);
      output_endi : out std_logic_vector(1 downto 0);
      output_strb : out std_logic_vector(3 downto 0)
    );
  end component schema_0_parser_0_key_parser_L2_00_com;

  component schema_0_parser_0_record_parser_L1_00_com is
    generic (
      EPC : positive := 4;
      DIM : positive := 2;
      OUTER_NESTING_LEVEL : positive := 1;
      INNER_NESTING_LEVEL : natural := 1
    );
    port (
      clk : in std_logic;
      rst : in std_logic;
      input_valid : in std_logic;
      input_ready : out std_logic;
      input_data : in std_logic_vector(31 downto 0);
      input_last : in std_logic_vector((DIM * 4) - 1 downto 0);
      input_stai : in std_logic_vector(1 downto 0);
      input_endi : in std_logic_vector(1 downto 0);
      input_strb : in std_logic_vector(3 downto 0);
      output_valid : out std_logic;
      output_ready : in std_logic;
      output_data : out std_logic_vector(35 downto 0);
      output_last : out std_logic_vector(((DIM + 1) * 4) - 1 downto 0);
      output_stai : out std_logic_vector(1 downto 0);
      output_endi : out std_logic_vector(1 downto 0);
      output_strb : out std_logic_vector(3 downto 0)
    );
  end component schema_0_parser_0_record_parser_L1_00_com;

  component schema_0_parser_0_top_com is
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
  end component schema_0_parser_0_top_com;

  component schema_0_parser_0_voltage_matcher_L2_00_com is
    generic (
      BPC : positive := 4
    );
    port (
      clk : in std_logic;
      rst : in std_logic;
      input_valid : in std_logic;
      input_ready : out std_logic;
      input_data : in std_logic_vector(31 downto 0);
      input_last : in std_logic_vector(3 downto 0);
      input_stai : in std_logic_vector(1 downto 0);
      input_endi : in std_logic_vector(1 downto 0);
      input_strb : in std_logic_vector(3 downto 0);
      output_valid : out std_logic;
      output_ready : in std_logic;
      output_data : out std_logic_vector(3 downto 0);
      output_last : out std_logic_vector(3 downto 0);
      output_stai : out std_logic_vector(1 downto 0);
      output_endi : out std_logic_vector(1 downto 0);
      output_strb : out std_logic_vector(3 downto 0)
    );
  end component schema_0_parser_0_voltage_matcher_L2_00_com;

end schema_parser;