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

entity JsonArrayParser_tc is
end JsonArrayParser_tc;

architecture test_case of JsonArrayParser_tc is

  constant EPC                   : integer := 8;
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

  signal rec_ready        : std_logic;
  signal rec_valid        : std_logic;
  signal rec_vec          : std_logic_vector(EPC+EPC*8-1 downto 0);
  signal rec_data         : std_logic_vector(EPC*8-1 downto 0);
  signal rec_tag          : std_logic_vector(EPC-1 downto 0);
  signal rec_empty        : std_logic_vector(EPC-1 downto 0);
  signal rec_stai         : std_logic_vector(log2ceil(EPC)-1 downto 0);
  signal rec_endi         : std_logic_vector(log2ceil(EPC)-1 downto 0);
  signal rec_strb         : std_logic_vector(EPC-1 downto 0);
  signal rec_last         : std_logic_vector(EPC*3-1 downto 0);

  signal out_ready        : std_logic;
  signal out_valid        : std_logic;
  signal out_strb         : std_logic;
  signal out_dvalid       : std_logic;
  signal out_data         : std_logic_vector(INTEGER_WIDTH-1 downto 0);
  signal out_last         : std_logic_vector(1 downto 0);

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
    
    array_parser: JsonArrayParser
    generic map (
      EPC                       => EPC,
      OUTER_NESTING_LEVEL       => 1,
      INNER_NESTING_LEVEL       => 0
    )
    port map (
      clk                       => clk,
      reset                     => reset,
      in_valid                  => in_valid,
      in_ready                  => in_ready,
      in_data                   => in_data,
      in_strb                   => in_strb,
      in_last                   => adv_last,
      out_data                  => rec_data,
      out_last                  => rec_last,
      out_stai                  => rec_stai,
      out_endi                  => rec_endi,
      out_valid                 => rec_valid,
      out_ready                 => rec_ready
    );

    int_parser: IntParser
    generic map (
      EPC     => EPC,
      NESTING_LEVEL             => 2,
      BITWIDTH                  => INTEGER_WIDTH,
      PIPELINE_STAGES           => INT_P_PIPELINE_STAGES
    )
    port map (
      clk                       => clk,
      reset                     => reset,
      in_valid                  => rec_valid,
      in_ready                  => rec_ready,
      in_data                   => rec_data,
      in_last                   => rec_last,
      in_strb                   => rec_strb,
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
      dvalid                    => out_dvalid,
      last                      => out_last(1)
    );

    

  random_tc: process is
    variable a        : streamsource_type;
    variable b        : streamsink_type;

  begin
    tc_open("JsonArrayParser", "test");
    a.initialize("a");
    b.initialize("b");

    a.set_total_cyc(0, 10);
    b.set_valid_cyc(0, 40);
    b.set_total_cyc(0, 40);

    a.push_str("[1, 2]");
    a.transmit;
    b.unblock;

    tc_wait_for(10 us);

    tc_check(b.pq_ready, true);
    tc_check(b.cq_get_d_nat, 1, "1");
    b.cq_next;
    while not b.cq_get_dvalid loop
      b.cq_next;
    end loop;
    tc_check(b.cq_get_d_nat, 2, "2");
    b.cq_next;
    while not b.cq_get_dvalid loop
      b.cq_next;
    end loop;

    tc_pass;
    wait;
  end process;

end test_case;