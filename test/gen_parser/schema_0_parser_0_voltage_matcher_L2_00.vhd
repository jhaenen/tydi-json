library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.schema_parser.all;
use work.UtilInt_pkg.all;

entity schema_0_parser_0_voltage_matcher_L2_00_com is
  generic (
    BPC : positive := 4;
    BIG_ENDIAN                  : boolean := false;
    INPUT_REG_ENABLE            : boolean := false;
    S12_REG_ENABLE              : boolean := true;
    S23_REG_ENABLE              : boolean := true;
    S34_REG_ENABLE              : boolean := true;
    S45_REG_ENABLE              : boolean := true
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
end schema_0_parser_0_voltage_matcher_L2_00_com;

architecture schema_0_parser_0_voltage_matcher_L2_00 of schema_0_parser_0_voltage_matcher_L2_00_com is
-- This constant resolves to 'U' in simulation and '0' in synthesis. It's
  -- used as a value for stuff that's supposed to be invalid.
  constant INVALID              : std_logic := '0'
  -- pragma translate_off
  or 'U'
  -- pragma translate_on
  ;

  -- Number of regular expressions matched by this unit.
  constant NUM_RE               : natural := 1;

  -- NOTE: in the records below, the unusual indentation implies a "validity"
  -- hierarchy; indented signals are valid iff the signal before the indented
  -- block is high and is itself valid.

  ------------------------------------------------------------------------------
  -- Stage 1 input record
  ------------------------------------------------------------------------------
  type si1_type is record

    -- Bytestream. `valid` is an active-high strobe signal indicating the
    -- validity of `data`.
    valid                       : std_logic;
      data                      : std_logic_vector(7 downto 0);

    -- Active-high strobe signal indicating:
    --  - `valid` is high -> the current byte is the last byte in the string.
    --  - `valid` is low -> the previous byte (if any) is the last in the
    --    string.
    last                        : std_logic;

  end record;

  type si1_array is array (natural range <>) of si1_type;

  constant SI1_RESET            : si1_type := (
    valid   => '0',
    data    => (others => INVALID),
    last    => '0'
  );

  ------------------------------------------------------------------------------
  -- Stage 1 to 2 record
  ------------------------------------------------------------------------------
  type s12_type is record

    -- Stream of bytes, decoded into signals that are easier to process by the
    -- next stage. `valid` is an active-high strobe signal indicating its
    -- validity.
    valid                       : std_logic;

      -- Active-high signal indicating that the received byte is a start byte.
      start                     : std_logic;

        -- The amount of continuation bytes expected, valid if `start` is high.
        follow                  : std_logic_vector(1 downto 0);

      -- Indicates that the received byte is reserved/illegal (0xF8..0xFF).
      illegal                   : std_logic;

      -- Copy of bit 6 of the received byte.
      bit6                      : std_logic;

      -- 63-bit thermometer code signal for bit 5..0 of the received byte.
      therm                     : std_logic_vector(62 downto 0);

    -- Copy of s01.last.
    last                        : std_logic;

  end record;

  type s12_array is array (natural range <>) of s12_type;

  constant S12_RESET            : s12_type := (
    valid   => '0',
    start   => INVALID,
    follow  => (others => INVALID),
    illegal => INVALID,
    bit6    => INVALID,
    therm   => (others => INVALID),
    last    => '0'
  );

  ------------------------------------------------------------------------------
  -- Stage 1 computation
  ------------------------------------------------------------------------------
  -- Preprocesses the incoming byte stream for the sequence decoder state
  -- machine. All bits signals generated and registered by this process can be
  -- created using a single level of 6-input LUTs.
  procedure s1_proc(i: in si1_type; o: inout s12_type) is
  begin

    -- Figure out the byte type.
    case i.data(7 downto 4) is

      when X"F" =>
        -- Start of a 4-byte sequence.
        o.start   := '1';
        o.follow  := "11";
        o.illegal := i.data(3);

      when X"E" =>
        -- Start of a 3-byte sequence.
        o.start   := '1';
        o.follow  := "10";
        o.illegal := '0';

      when X"D" | X"C" =>
        -- Start of a 2-byte sequence.
        o.start   := '1';
        o.follow  := "01";
        o.illegal := '0';

      when X"B" | X"A" | X"9" | X"8" =>
        -- Continuation byte.
        o.start   := '0';
        o.follow  := (others => INVALID);
        o.illegal := '0';

      when others =>
        -- Single-byte code point.
        o.start   := '1';
        o.follow  := "00";
        o.illegal := '0';

    end case;

    -- Save bit 6. This is necessary for decoding ASCII-range characters, as
    -- bit 6 is not used in the thermometer code.
    o.bit6 := i.data(6);

    -- Create a thermometer encoder for bits 5..0. Thermometer encoding
    -- allows efficient range checking. For the higher-order bits, the
    -- thermometer code is converted to one-hot. This allows any code point
    -- range that does not cross a 64-CP boundary to be tested for using a
    -- single 6-input LUT later.
    for x in 62 downto 0 loop
      if unsigned(i.data(5 downto 0)) > x then
        o.therm(x) := '1';
      else
        o.therm(x) := '0';
      end if;
    end loop;

    -- Store the `valid` and `last` flags.
    o.valid := i.valid;
    o.last  := i.last;

    -- In simulation, make signals undefined when their value is meaningless.
    -- pragma translate_off
    if to_X01(o.valid) /= '1' then
      o.start   := INVALID;
      o.illegal := INVALID;
      o.bit6    := INVALID;
      o.therm   := (others => INVALID);
    end if;
    if to_X01(o.start) /= '1' then
      o.follow  := (others => INVALID);
    end if;
    -- pragma translate_on

  end procedure;

  ------------------------------------------------------------------------------
  -- Stage 2 state record
  ------------------------------------------------------------------------------
  type s2s_type is record

    -- FSM state. Indicates the amount of continuation bytes still expected.
    state                       : std_logic_vector(1 downto 0);

    -- Error flag. This is set when any kind of error is detected and cleared
    -- by the `last` flag.
    error                       : std_logic;

    -- 5-bit one-hot signal for bit 20..18 of the code point.
    oh3                         : std_logic_vector(4 downto 0);

    -- 64-bit one-hot signal for bit 17..12 of the code point.
    oh2                         : std_logic_vector(63 downto 0);

    -- 64-bit one-hot signal for bit 11..6 of the code point.
    oh1                         : std_logic_vector(63 downto 0);

  end record;

  type s2s_array is array (natural range <>) of s2s_type;

  constant S2S_RESET            : s2s_type := (
    state   => "00",
    error   => '0',
    oh3     => (others => INVALID),
    oh2     => (others => INVALID),
    oh1     => (others => INVALID)
  );

  ------------------------------------------------------------------------------
  -- Stage 2 to 3 record
  ------------------------------------------------------------------------------
  type s23_type is record

    -- Stream of code points, encoded into one-hot and thermometer codes, such
    -- that any range that doesn't cross 64-CP boundaries to be matched against
    -- using a single 5-input LUT (one bit from oh3, one bit from oh2, one bit
    -- from oh1, and two bits from th0). `valid` is an active-high strobe
    -- signal indicating validity.
    valid                       : std_logic;

      -- 5-bit one-hot signal for bit 20..18 of the code point.
      oh3                       : std_logic_vector(4 downto 0);

      -- 64-bit one-hot signal for bit 17..12 of the code point.
      oh2                       : std_logic_vector(63 downto 0);

      -- 64-bit one-hot signal for bit 11..6 of the code point.
      oh1                       : std_logic_vector(63 downto 0);

      -- 63-bit thermometer code signal for bit 5..0 of the code point.
      th0                       : std_logic_vector(62 downto 0);

    -- Active-high strobe signal indicating:
    --  - `valid` is high -> the current code point is the last in the string.
    --  - `valid` is low -> the previous code point (if any) is the last in the
    --    string.
    last                        : std_logic;

      -- Active-high error flag, valid when `last` is asserted. The following
      -- decode errors are detected:
      --  - multi-byte sequence interrupted by last flag or a new sequence
      --    (interrupted sequence is ignored)
      --  - unexpected continuation byte (byte is ignored)
      --  - illegal bytes 0xC0..0xC1, 0xF6..0xF8 (parsed as if they were legal
      --    2-byte/4-byte start markers; for the latter three this means that
      --    oh3 will be "00000", which means the character won't match
      --    anything)
      --  - illegal bytes 0xF8..0xFF (ignored)
      -- Thus, the following decode errors pass silently:
      --  - code points 0x10FFFF to 0x13FFFF (these are out of range, at least
      --    at the time of writing)
      --  - overlong sequences which are not apparent from the first byte
      error                     : std_logic;

  end record;

  type s23_array is array (natural range <>) of s23_type;

  constant S23_RESET            : s23_type := (
    valid   => '0',
    oh3     => (others => INVALID),
    oh2     => (others => INVALID),
    oh1     => (others => INVALID),
    th0     => (others => INVALID),
    last    => '0',
    error   => INVALID
  );

  ------------------------------------------------------------------------------
  -- Stage 2 computation
  ------------------------------------------------------------------------------
  -- Contains the state machine that detects and decodes multi-byte sequences.
  -- The decoded code point is represented as follows:
  --  - oh3: a 5-bit one-hot signal for bit 21..19 of the code point.
  --  - oh2: a 64-bit one-hot signal for bit 18..13 of the code point.
  --  - oh1: a 64-bit one-hot signal for bit 12..7 of the code point.
  --  - th0: a 63-bit thermometer code signal for bit 6..0 of the code point.
  -- Also contains decoding error detection.
  procedure s2_proc(i: in s12_type; s: inout s2s_type; o: inout s23_type) is
    variable oh : std_logic_vector(63 downto 0);
  begin

    -- Don't assert output valid unless otherwise specified by the state
    -- machine. (not all bytes result in a code point)
    o.valid := '0';

    -- Convert thermometer to one-hot.
    oh := (i.therm & "1") and not ("0" & i.therm);

    -- Handle incoming byte, if any.
    if i.valid = '1' then

      -- Handle illegal bytes (0xF8..0xFF).
      if i.illegal = '1' then

        -- Reset the state and set the error flag.
        s.state := "00";
        s.error := '1';

      -- Handle start bytes.
      elsif i.start = '1' then

        -- If we were expecting a continuation byte, set the error flag, and
        -- drop the code point we were decoding in favor of this new start
        -- byte.
        if s.state /= "00" then
          s.error := '1';
        end if;

        -- Different behavior based on the amount of following bytes.
        case i.follow is

          -- Single byte: U+0000 to U+007F (00000000 to 00000177).
          when "00" =>
            s.oh3 := "00001"; -- 00......
            s.oh2 := X"0000000000000001"; -- ..00....
            if i.bit6 = '0' then
              s.oh1 := X"0000000000000001"; -- ....00..
            else
              s.oh1 := X"0000000000000002"; -- ....01..
            end if;

            -- This is the complete sequence already.
            o.valid := '1';
            s.state := "00";

          -- Two bytes: U+0080 to U+07FF (00000200 to 00003777).
          when "01" =>
            s.oh3 := "00001"; -- 00......
            s.oh2 := X"0000000000000001"; -- ..00....
            s.oh1 := X"00000000" & oh(31 downto 0);
            s.state := "01";

            -- The 6 LSBs of the received byte must be between "000010" = 2
            -- and "011111" = 31. Less than 2 is an overlong sequence, more
            -- than 31 should never happen.
            if i.therm(31) = '1' or i.therm(1) = '0' then -- byte > 31 or byte <= 1
              s.error := '1';
            end if;

          -- Three bytes: U+0800 to U+FFFF (00004000 to 00177777).
          when "10" =>
            s.oh3 := "00001"; -- 00......
            s.oh2 := X"000000000000" & oh(47 downto 32);
            -- pragma translate_off
            s.oh1 := (others => 'U');
            -- pragma translate_on
            s.state := "10";

            -- The 6 LSBs of the received byte must be between "100000" = 32
            -- and "101111" = 47. Values out of that range should never
            -- happen.
            if i.therm(47) = '1' or i.therm(32) = '0' then -- byte > 47 or byte <= 32
              s.error := '1';
            end if;

          -- Four bytes: U+10000 to U+10FFFF (00200000 to 04177777).
          when others =>
            s.oh3 := oh(52 downto 48);
            -- pragma translate_off
            s.oh2 := (others => 'U');
            s.oh1 := (others => 'U');
            -- pragma translate_on
            s.state := "11";

            -- The 6 LSBs of the received byte must be between "110000" = 48
            -- and "110100" = 52. Values out of that range should never
            -- happen or are above U+10FFFF (53..55).
            if i.therm(52) = '1' or i.therm(48) = '0' then -- byte > 52 or byte <= 48
              s.error := '1';
            end if;

        end case;

      -- Handle continuation bytes.
      else

        -- Different behavior based on the amount of following bytes.
        case s.state is

          -- Idle state; not expecting any continuation byte.
          when "00" =>
            s.error := '1';

          -- Last byte.
          when "01" =>
            -- Sequence complete, so we don't need to do anything else (the
            -- thermometer code for the last 6 bits are always registered).
            o.valid := '1';
            s.state := "00";

          -- Second to last byte.
          when "10" =>
            s.oh1   := oh;
            s.state := "01";

          -- Third to last byte.
          when others =>
            s.oh2   := oh;
            s.state := "10";

        end case;

      end if;

    end if;

    -- Copy the code point data to the output stream.
    o.oh3   := s.oh3;
    o.oh2   := s.oh2;
    o.oh1   := s.oh1;
    o.th0   := i.therm;

    -- Copy the last/error stream flags to the output stream. If we're not in
    -- state 0 and we receive a `last` flag, the string was cut off in the
    -- middle of a multibyte sequence, which is also an error.
    o.last  := i.last;
    o.error := s.error or s.state(0) or s.state(1);

    -- If the `last` flag is set, always return to the initial state.
    if i.last = '1' then
      s := S2S_RESET;
    end if;

    -- In simulation, make signals undefined when their value is meaningless.
    -- pragma translate_off
    if to_X01(o.valid) /= '1' then
      o.oh3 := (others => INVALID);
      o.oh2 := (others => INVALID);
      o.oh1 := (others => INVALID);
      o.th0 := (others => INVALID);
    end if;
    if to_X01(o.last) /= '1' then
      o.error := INVALID;
    end if;
    -- pragma translate_on

  end procedure;

  ------------------------------------------------------------------------------
  -- Stage 3 to 4 record
  ------------------------------------------------------------------------------
  type s34_type is record

    -- Code point subrange stream. Each flag signal represents one contiguous
    -- range of code points that does not cross a 64-CP boundary.
    valid                       : std_logic;
      b00001f41t41              : std_logic; -- a
      b00001f45t45              : std_logic; -- e
      b00001f47t47              : std_logic; -- g
      b00001f54t54              : std_logic; -- l
      b00001f57t57              : std_logic; -- o
      b00001f64t64              : std_logic; -- t
      b00001f66t66              : std_logic; -- v

    -- Copy of s23.last/error.
    last                        : std_logic;
      error                     : std_logic;

  end record;

  type s34_array is array (natural range <>) of s34_type;

  constant S34_RESET            : s34_type := (
    valid   => '0',
    last    => '0',
    error   => INVALID,
    others  => INVALID
  );

  ------------------------------------------------------------------------------
  -- Stage 3 computation
  ------------------------------------------------------------------------------
  -- Takes the one-hot and thermometer coded signals and converts them into
  -- subrange match signals, which together form the actual subset matchers
  -- used by the matchers.
  procedure s3_proc(i: in s23_type; o: inout s34_type) is
  begin

    -- Pass through control signals and decode range signals.
    o.valid         := i.valid;
    o.b00001f41t41  := i.oh3( 0) and i.oh2( 0) and i.oh1( 1) and i.th0(32) and not i.th0(33); -- a
    o.b00001f45t45  := i.oh3( 0) and i.oh2( 0) and i.oh1( 1) and i.th0(36) and not i.th0(37); -- e
    o.b00001f47t47  := i.oh3( 0) and i.oh2( 0) and i.oh1( 1) and i.th0(38) and not i.th0(39); -- g
    o.b00001f54t54  := i.oh3( 0) and i.oh2( 0) and i.oh1( 1) and i.th0(43) and not i.th0(44); -- l
    o.b00001f57t57  := i.oh3( 0) and i.oh2( 0) and i.oh1( 1) and i.th0(46) and not i.th0(47); -- o
    o.b00001f64t64  := i.oh3( 0) and i.oh2( 0) and i.oh1( 1) and i.th0(51) and not i.th0(52); -- t
    o.b00001f66t66  := i.oh3( 0) and i.oh2( 0) and i.oh1( 1) and i.th0(53) and not i.th0(54); -- v
    o.last          := i.last;
    o.error         := i.error;

    -- In simulation, make signals undefined when their value is meaningless.
    -- pragma translate_off
    if to_X01(o.valid) /= '1' then
      o.b00001f41t41 := 'U';
      o.b00001f45t45 := 'U';
      o.b00001f47t47 := 'U';
      o.b00001f54t54 := 'U';
      o.b00001f57t57 := 'U';
      o.b00001f64t64 := 'U';
      o.b00001f66t66 := 'U';
    end if;
    if to_X01(o.last) /= '1' then
      o.error := INVALID;
    end if;
    -- pragma translate_on

  end procedure;

  ------------------------------------------------------------------------------
  -- Stage 4 to 5 record
  ------------------------------------------------------------------------------
  type s45_type is record

    -- Code point range stream. Each flag signal represents a set of code
    -- points as used by a transition in the NFAEs.
    valid                       : std_logic;
      match                     : std_logic_vector(6 downto 0);

    -- Copy of s23.last/error.
    last                        : std_logic;
      error                     : std_logic;

  end record;

  type s45_array is array (natural range <>) of s45_type;

  constant S45_RESET            : s45_type := (
    valid   => '0',
    match   => (others => INVALID),
    last    => '0',
    error   => INVALID
  );

  ------------------------------------------------------------------------------
  -- Stage 4 computation
  ------------------------------------------------------------------------------
  -- Takes the subranges and maps them to the actual character sets that are
  -- used by the state machine transitions.
  procedure s4_proc(i: in s34_type; o: inout s45_type) is
  begin

    -- Pass through control signals and decode range signals by default.
    o.valid       := i.valid;
    o.match(  0)  := i.b00001f57t57; -- o
    o.match(  1)  := i.b00001f66t66; -- v
    o.match(  2)  := i.b00001f41t41; -- a
    o.match(  3)  := i.b00001f54t54; -- l
    o.match(  4)  := i.b00001f45t45; -- e
    o.match(  5)  := i.b00001f64t64; -- t
    o.match(  6)  := i.b00001f47t47; -- g
    o.last        := i.last;
    o.error       := i.error;

    -- In simulation, make signals undefined when their value is meaningless.
    -- pragma translate_off
    if to_X01(o.valid) /= '1' then
      o.match := (others => INVALID);
    end if;
    if to_X01(o.last) /= '1' then
      o.error := INVALID;
    end if;
    -- pragma translate_on

  end procedure;

  ------------------------------------------------------------------------------
  -- Stage 5 state type
  ------------------------------------------------------------------------------
  -- There is one bit for every NFAE state, which indicates whether the NFAE
  -- can be in that state.
  subtype s5s_type is std_logic_vector(7 downto 0);

  type s5s_array is array (natural range <>) of s5s_type;

  constant S5S_RESET            : s5s_type := "01000000";

  ------------------------------------------------------------------------------
  -- Stage 5 output record
  ------------------------------------------------------------------------------
  type s5o_type is record

    -- String match stream. `valid` is an active-high strobe signal indicating
    -- validity, i.e. that a string has been completely processed.
    valid                       : std_logic;

      -- Active-high flag for each regular expression, indicating whether the
      -- regex matched the received string.
      match                     : std_logic_vector(NUM_RE-1 downto 0);

      -- Active-high UTF-8 decode error. If this is high, an error certainly
      -- occurred, but the following errors are not caught:
      --  - code points 0x10FFFF to 0x13FFFF (these are out of range, at least
      --    at the time of writing)
      --  - overlong sequences which are not apparent from the first byte
      error                     : std_logic;

  end record;

  type s5o_array is array (natural range <>) of s5o_type;

  constant S5O_RESET            : s5o_type := (
    valid   => '0',
    match   => (others => INVALID),
    error   => INVALID
  );

  ------------------------------------------------------------------------------
  -- Stage 5 computation
  ------------------------------------------------------------------------------
  -- Processes the actual NFAEs.
  procedure s5_proc(i: in s45_type; s: inout s5s_type; o: inout s5o_type) is
    variable si : s5s_type;
  begin

    -- Transition to the next state if there is an incoming character.
    if i.valid = '1' then
      si := s;
      s(  0) := (si(  1) and i.match(  0));
      s(  1) := (si(  6) and i.match(  1));
      s(  2) := (si(  5) and i.match(  2));
      s(  3) := (si(  0) and i.match(  3));
      s(  4) := (si(  7) and i.match(  4));
      s(  5) := (si(  3) and i.match(  5));
      s(  6) := '0';
      s(  7) := (si(  2) and i.match(  6));
    end if;

    -- Save whether the next state will be a final state to determine whether
    -- a regex is matching or not. The timing of this corresponds to the last
    -- signal.
    o.match(0) := s(  4);

    -- Reset the state when we're resetting or receiving the last character.
    if rst = '1' or i.last = '1' then
      s := S5S_RESET;
    end if;

    -- Pass through control signals by default.
    o.valid := i.last;
    o.error := i.error;

    -- In simulation, make signals undefined when their value is meaningless.
    -- pragma translate_off
    if to_X01(o.valid) /= '1' then
      o.match := (others => INVALID);
      o.error := INVALID;
    end if;
    -- pragma translate_on

  end procedure;

  ------------------------------------------------------------------------------
  -- Signal declarations
  ------------------------------------------------------------------------------
  -- Internal copy of output_ready.
  signal output_valid_i            : std_logic;

  -- Internal ready signal.
  signal ready                  : std_logic;

  -- Internal clock enable signal. This is just `clken and ready`.
  signal iclken                 : std_logic;

  -- Input stream.
  signal inp                    : si1_array(BPC-1 downto 0);

  -- Interstage register signals.
  signal si1                    : si1_array(BPC-1 downto 0);
  signal s12                    : s12_array(BPC-1 downto 0);
  signal s23                    : s23_array(BPC-1 downto 0);
  signal s34                    : s34_array(BPC-1 downto 0);
  signal s45                    : s45_array(BPC-1 downto 0);

  -- Output stream.
  signal s5o                    : s5o_array(BPC-1 downto 0);

  -- State register signals.
  signal s2s                    : s2s_type;
  signal s5s                    : s5s_type;

begin

  ------------------------------------------------------------------------------
  -- Regex matcher logic
  ------------------------------------------------------------------------------
  match: process (clk) is

    -- Reset procedure.
    procedure reset_all is
    begin
      si1 <= (others => SI1_RESET);
      s12 <= (others => S12_RESET);
      s23 <= (others => S23_RESET);
      s34 <= (others => S34_RESET);
      s45 <= (others => S45_RESET);
      s5o <= (others => S5O_RESET);
      s2s <= S2S_RESET;
      s5s <= S5S_RESET;
    end procedure;

    -- Slot pipeline generator.
    procedure slot_pipeline (
      i     : in natural range 0 to BPC-1;
      s2sv  : inout s2s_type;
      s5sv  : inout s5s_type
    ) is
      variable si1v : si1_type;
      variable s12v : s12_type;
      variable s23v : s23_type;
      variable s34v : s34_type;
      variable s45v : s45_type;
      variable s5ov : s5o_type;
    begin

      -- Load combinatorial input.
      si1v := inp(i);

      -- Input register.
      if INPUT_REG_ENABLE then
        si1(i)  <= si1v;
        si1v    := si1(i);
      end if;

      -- Stage 1.
      s1_proc(si1v, s12v);

      -- Stage 1-2 register.
      if S12_REG_ENABLE then
        s12(i)  <= s12v;
        s12v    := s12(i);
      end if;

      -- Stage 2.
      s2_proc(s12v, s2sv, s23v);

      -- Stage 2-3 register.
      if S23_REG_ENABLE then
        s23(i)  <= s23v;
        s23v    := s23(i);
      end if;

      -- Stage 3.
      s3_proc(s23v, s34v);

      -- Stage 3-4 register.
      if S34_REG_ENABLE then
        s34(i)  <= s34v;
        s34v    := s34(i);
      end if;

      -- Stage 4.
      s4_proc(s34v, s45v);

      -- Stage 4-5 register.
      if S45_REG_ENABLE then
        s45(i)  <= s45v;
        s45v    := s45(i);
      end if;

      -- Stage 5.
      s5_proc(s45v, s5sv, s5ov);

      -- Output register.
      s5o(i) <= s5ov;

    end procedure;

    -- Intermediate state variables.
    variable s2sv  : s2s_type;
    variable s5sv  : s5s_type;

  begin
    if rising_edge(clk) then
      if rst = '1' then

        -- Synchronous reset.
        reset_all;

      elsif iclken = '1' then

        -- Load state from previous cycle.
        s2sv := s2s;
        s5sv := s5s;

        -- Process the slots in order of endianness.
        if BIG_ENDIAN then
          for i in BPC-1 downto 0 loop
            slot_pipeline(i, s2sv, s5sv);
          end loop;
        else
          for i in 0 to BPC-1 loop
            slot_pipeline(i, s2sv, s5sv);
          end loop;
        end if;

        -- Register the state for the next cycle.
        s2s <= s2sv;
        s5s <= s5sv;

      end if;
    end if;
  end process;

  ------------------------------------------------------------------------------
  -- Interface stuff
  ------------------------------------------------------------------------------
  -- Desugar the backpressure signals into a simply clock enable signal. Note:
  -- this is why you probably don't want to use vhdre's backpressure ports if
  -- you want serious throughput. Refer to "Notes on backpressure and timing
  -- closure".
  ready <= output_ready or not output_valid_i;
  iclken <= ready;
  input_ready <= ready;

  -- Put the input stream record signal together.
  inp_proc: process (input_valid, input_strb, input_endi, input_data, input_last) is
  begin

    -- Assign the record signal.
    for i in 0 to BPC-1 loop
      if (i <= unsigned(input_endi)) then
          inp(i).valid <= input_valid and input_strb(i);
      else
        inp(i).valid <= '0';
      end if;
    
      inp(i).data <= input_data(8*i+7 downto 8*i);
      inp(i).last <= input_valid and input_last(i);
    end loop;

  end process;

  -- Unpack the output record.
  outp_proc: process (s5o) is
    variable last_valid : natural range 0 to BPC-1 := 0;
  begin

    -- Output is invalid unless any of the slots are valid.
    output_valid_i <= '0';

    -- Unpack the output record.
    for i in 0 to BPC-1 loop

      -- Make the output valid when any of the slots are valid.
      if s5o(i).valid = '1' then
        output_valid_i <= '1';

        -- Update the last valid slot value for endi signal
        last_valid := i;
      end if;

      -- Unpack into the `out_x*` signals.
      output_strb(i)                                  <= s5o(i).valid;
      output_data(NUM_RE*i+NUM_RE-1 downto NUM_RE*i)  <= s5o(i).match;

    end loop;

    output_endi <= std_logic_vector(to_unsigned(last_valid, output_endi'length));

  end process;

  output_valid <= output_valid_i;
end schema_0_parser_0_voltage_matcher_L2_00;