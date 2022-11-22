library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.UtilInt_pkg.all;
use work.TestCase_pkg.all;
use work.Stream_pkg.all;
use work.ClockGen_pkg.all;
use work.StreamSource_pkg.all;
use work.StreamSink_pkg.all;
use work.Json_pkg.all;
use work.TestCase_pkg.all;

entity NestedArray_tc is
end NestedArray_tc;

architecture test_case of NestedArray_tc is

  constant EPC                   : integer := 2;
  constant INTEGER_WIDTH         : integer := 64;
  constant INT_P_PIPELINE_STAGES : integer := 1;

  signal clk              : std_logic;
  signal reset            : std_logic;

  signal in_valid         : std_logic;
  signal in_ready         : std_logic;
  signal in_dvalid        : std_logic;
  signal in_last          : std_logic;
  signal in_data          : std_logic_vector(EPC*8-1 downto 0);
  signal in_count         : std_logic_vector(log2ceil(EPC+1)-1 downto 0);
  signal in_strb          : std_logic_vector(EPC-1 downto 0);
  signal in_endi          : std_logic_vector(log2ceil(EPC+1)-1 downto 0);

  signal adv_last         : std_logic_vector(EPC*2-1 downto 0) := (others => '0');

  signal fl_ready        : std_logic;
  signal fl_valid        : std_logic;
  signal fl_vec          : std_logic_vector(EPC+EPC*8-1 downto 0);
  signal fl_data         : std_logic_vector(EPC*8-1 downto 0);
  signal fl_tag          : std_logic_vector(EPC-1 downto 0);
  signal fl_empty        : std_logic_vector(EPC-1 downto 0);
  signal fl_stai         : std_logic_vector(log2ceil(EPC)-1 downto 0);
  signal fl_endi         : std_logic_vector(log2ceil(EPC)-1 downto 0);
  signal fl_strb         : std_logic_vector(EPC-1 downto 0);
  signal fl_last         : std_logic_vector(EPC*3-1 downto 0);

  signal sl_ready        : std_logic;
  signal sl_valid        : std_logic;
  signal sl_vec          : std_logic_vector(EPC+EPC*8-1 downto 0);
  signal sl_data         : std_logic_vector(EPC*8-1 downto 0);
  signal sl_tag          : std_logic_vector(EPC-1 downto 0);
  signal sl_empty        : std_logic_vector(EPC-1 downto 0);
  signal sl_stai         : std_logic_vector(log2ceil(EPC)-1 downto 0);
  signal sl_endi         : std_logic_vector(log2ceil(EPC)-1 downto 0);
  signal sl_strb         : std_logic_vector(EPC-1 downto 0);
  signal sl_last         : std_logic_vector(EPC*4-1 downto 0);

  signal out_ready        : std_logic;
  signal out_valid        : std_logic;
  signal out_strb         : std_logic;
  signal out_dvalid       : std_logic;
  signal out_data         : std_logic_vector(INTEGER_WIDTH-1 downto 0);
  signal out_last         : std_logic_vector(2 downto 0);

begin

  clkgen: ClockGen_mdl
    port map (
      clk                       => clk,
      reset                     => reset
    );

  in_source: StreamSource_mdl
    generic map (
      NAME                      => "a",
      ELEMENT_WIDTH             => 8,
      COUNT_MAX                 => EPC,
      COUNT_WIDTH               => log2ceil(EPC+1)
    )
    port map (
      clk                       => clk,
      reset                     => reset,
      valid                     => in_valid,
      ready                     => in_ready,
      dvalid                    => in_dvalid,
      last                      => in_last,
      data                      => in_data,
      count                     => in_count
    );

  in_strb <= element_mask(in_count, in_dvalid, EPC); 
  in_endi <= std_logic_vector(unsigned(in_count) - 1);

  -- TODO: Is there a cleaner solutiuon? It's getting late :(
  adv_last(EPC*2-1 downto 0) <=  std_logic_vector(shift_left(resize(unsigned'("0" & in_last), 
            EPC*2), to_integer((unsigned(in_endi))*2+1)));
    
  fl_array_parser: JsonArrayParser
    generic map (
      EPC                       => EPC,
      OUTER_NESTING_LEVEL       => 1,
      INNER_NESTING_LEVEL       => 1
    )
    port map (
      clk                       => clk,
      reset                     => reset,
      in_valid                  => in_valid,
      in_ready                  => in_ready,
      in_data                   => in_data,
      in_strb                   => in_strb,
      in_last                   => adv_last,
      out_data                  => fl_data,
      out_valid                 => fl_valid,
      out_ready                 => fl_ready,
      out_last                  => fl_last,
      out_stai                  => fl_stai,
      out_endi                  => fl_endi,
      out_strb                  => fl_strb
    );

  sl_array_parser: JsonArrayParser
    generic map (
      EPC                       => EPC,
      OUTER_NESTING_LEVEL       => 2,
      INNER_NESTING_LEVEL       => 0
    )
    port map (
      clk                       => clk,
      reset                     => reset,
      in_valid                  => fl_valid,
      in_ready                  => fl_ready,
      in_data                   => fl_data,
      in_strb                   => fl_strb,
      in_last                   => fl_last,
      out_data                  => sl_data,
      out_valid                 => sl_valid,
      out_ready                 => sl_ready,
      out_last                  => sl_last,
      out_stai                  => sl_stai,
      out_endi                  => sl_endi,
      out_strb                  => sl_strb
    );

  int_parser: IntParser
    generic map (
      EPC                       => EPC,
      NESTING_LEVEL             => 3,
      BITWIDTH                  => INTEGER_WIDTH,
      PIPELINE_STAGES           => INT_P_PIPELINE_STAGES
    )
    port map (
      clk                       => clk,
      reset                     => reset,
      in_valid                  => sl_valid,
      in_ready                  => sl_ready,
      in_data                   => sl_data,
      in_last                   => sl_last,
      in_strb                   => sl_strb,
      out_data                  => out_data,
      out_valid                 => out_valid,
      out_ready                 => out_ready,
      out_last                  => out_last,
      out_strb                  => out_strb
    );

    out_dvalid <= out_strb;

  out_sink: StreamSink_mdl
    generic map (
      NAME                      => "b",
      ELEMENT_WIDTH             => INTEGER_WIDTH,
      COUNT_MAX                 => 1,
      COUNT_WIDTH               => 1
    )
    port map (
      clk                       => clk,
      reset                     => reset,
      valid                     => out_valid,
      ready                     => out_ready,
      data                      => out_data,
      dvalid                    => out_dvalid
    );

    

  random_tc: process is
    variable a        : streamsource_type;
    variable b        : streamsink_type;

  begin
    tc_open("JsonArrayParser", "test");
    a.initialize("a");
    b.initialize("b");

    a.push_str("[ [ 1, 10, 6, 2], [ 3, 4 ], [ 5 ] ]");
    
    a.set_total_cyc(0, 40);
    b.set_valid_cyc(0, 40);
    b.set_total_cyc(0, 40);

    a.transmit;
    b.unblock;

    tc_wait_for(60 us);

    tc_check(b.pq_ready, true);
    tc_check(b.cq_get_d_nat, 1, "1");
    b.cq_next;
    while not b.cq_get_dvalid loop
      b.cq_next;
    end loop;
    tc_check(b.cq_get_d_nat, 10, "10");
    b.cq_next;
    while not b.cq_get_dvalid loop
      b.cq_next;
    end loop;
    tc_check(b.cq_get_d_nat, 6, "6");
    -- b.cq_next;
    -- while not b.cq_get_dvalid loop
    --   b.cq_next;
    -- end loop;
    -- tc_check(b.cq_get_d_nat, 2, "2");
    -- b.cq_next;
    -- while not b.cq_get_dvalid loop
    --   b.cq_next;
    -- end loop;

    -- tc_check(b.cq_get_d_nat, 3, "3");
    -- b.cq_next;
    -- while not b.cq_get_dvalid loop
    --   b.cq_next;
    -- end loop;
    -- tc_check(b.cq_get_d_nat, 4, "4");
    -- b.cq_next;
    -- while not b.cq_get_dvalid loop
    --   b.cq_next;
    -- end loop;

    -- tc_check(b.cq_get_d_nat, 5, "5");

    tc_pass;
    wait;
  end process;

end test_case;