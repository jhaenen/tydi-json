library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_misc.all;
use ieee.numeric_std.all;

library work;
use work.UtilInt_pkg.all;


package trip_report_pkg is
    component TripReportParser is
      generic (
        EPC                                              : natural := 8;
        
        -- 
        -- INTEGER FIELDS
        --
        TIMEZONE_INT_WIDTH                               : natural := 16;
        TIMEZONE_INT_P_PIPELINE_STAGES                   : natural := 1;
        TIMEZONE_BUFFER_D                                : natural := 1;

        VIN_INT_WIDTH                                    : natural := 16;
        VIN_INT_P_PIPELINE_STAGES                        : natural := 1;
        VIN_BUFFER_D                                     : natural := 1;

        ODOMETER_INT_WIDTH                               : natural := 16;
        ODOMETER_INT_P_PIPELINE_STAGES                   : natural := 1;
        ODOMETER_BUFFER_D                                : natural := 1;

        AVGSPEED_INT_WIDTH                               : natural := 16;
        AVGSPEED_INT_P_PIPELINE_STAGES                   : natural := 1;
        AVGSPEED_BUFFER_D                                : natural := 1;

        ACCEL_DECEL_INT_WIDTH                            : natural := 16;
        ACCEL_DECEL_INT_P_PIPELINE_STAGES                : natural := 1;
        ACCEL_DECEL_BUFFER_D                             : natural := 1;

        SPEED_CHANGES_INT_WIDTH                          : natural := 16;
        SPEED_CHANGES_INT_P_PIPELINE_STAGES              : natural := 1;
        SPEED_CHANGES_BUFFER_D                           : natural := 1;

        -- 
        -- BOOLEAN FIELDS
        --
        HYPERMILING_BUFFER_D                              : natural := 1;
        ORIENTATION_BUFFER_D                              : natural := 1;

        -- 
        -- INTEGER ARRAY FIELDS
        --
        SEC_IN_BAND_INT_WIDTH                             : natural := 16;
        SEC_IN_BAND_INT_P_PIPELINE_STAGES                 : natural := 1;
        SEC_IN_BAND_BUFFER_D                              : natural := 1;

        MILES_IN_TIME_RANGE_INT_WIDTH                     : natural := 16;
        MILES_IN_TIME_RANGE_INT_P_PIPELINE_STAGES         : natural := 1; 
        MILES_IN_TIME_RANGE_BUFFER_D                      : natural := 1; 


        CONST_SPEED_MILES_IN_BAND_INT_WIDTH               : natural := 16;
        CONST_SPEED_MILES_IN_BAND_INT_P_PIPELINE_STAGES   : natural := 1; 
        CONST_SPEED_MILES_IN_BAND_BUFFER_D                : natural := 1; 


        VARY_SPEED_MILES_IN_BAND_INT_WIDTH                : natural := 16;
        VARY_SPEED_MILES_IN_BAND_INT_P_PIPELINE_STAGES    : natural := 1; 
        VARY_SPEED_MILES_IN_BAND_BUFFER_D                 : natural := 1; 


        SEC_DECEL_INT_WIDTH                               : natural := 16;
        SEC_DECEL_INT_P_PIPELINE_STAGES                   : natural := 1; 
        SEC_DECEL_BUFFER_D                                : natural := 1; 
                  
                  
        SEC_ACCEL_INT_WIDTH                               : natural := 16;
        SEC_ACCEL_INT_P_PIPELINE_STAGES                   : natural := 1; 
        SEC_ACCEL_BUFFER_D                                : natural := 1; 
                  
                  
        BRAKING_INT_WIDTH                                 : natural := 16;
        BRAKING_INT_P_PIPELINE_STAGES                     : natural := 1; 
        BRAKING_BUFFER_D                                  : natural := 1; 


        ACCEL_INT_WIDTH                                   : natural := 16;
        ACCEL_INT_P_PIPELINE_STAGES                       : natural := 1; 
        ACCEL_BUFFER_D                                    : natural := 1; 


        SMALL_SPEED_VAR_INT_WIDTH                         : natural := 16;
        SMALL_SPEED_VAR_INT_P_PIPELINE_STAGES             : natural := 1; 
        SMALL_SPEED_VAR_BUFFER_D                          : natural := 1; 


        LARGE_SPEED_VAR_INT_WIDTH                         : natural := 16;
        LARGE_SPEED_VAR_INT_P_PIPELINE_STAGES             : natural := 1; 
        LARGE_SPEED_VAR_BUFFER_D                          : natural := 1;

        -- 
        -- STRING FIELDS
        --
        TIMESTAMP_BUFFER_D                          : natural := 1;

        END_REQ_EN                                  : boolean := false
      );              
      port (              
        clk                                         : in  std_logic;
        reset                                       : in  std_logic;
    
        in_valid                                    : in  std_logic;
        in_ready                                    : out std_logic;
        in_data                                     : in  std_logic_vector(8*EPC-1 downto 0);
        in_last                                     : in  std_logic_vector(2*EPC-1 downto 0);
        in_stai                                     : in  std_logic_vector(log2ceil(EPC)-1 downto 0) := (others => '0');
        in_endi                                     : in  std_logic_vector(log2ceil(EPC)-1 downto 0) := (others => '1');
        in_strb                                     : in  std_logic_vector(EPC-1 downto 0);
    
        end_req                                     : in  std_logic := '0';
        end_ack                                     : out std_logic;
    
        timezone_valid                              : out std_logic;
        timezone_ready                              : in  std_logic;
        timezone_strb                               : out std_logic;
        timezone_data                               : out std_logic_vector(TIMEZONE_INT_WIDTH-1 downto 0);
        timezone_last                               : out std_logic_vector(1 downto 0);

        --    
        -- INTEGER FIELDS   
        --    
        vin_valid                                   : out std_logic;
        vin_ready                                   : in  std_logic;
        vin_data                                    : out std_logic_vector(VIN_INT_WIDTH-1 downto 0);
        vin_strb                                    : out std_logic;
        vin_last                                    : out std_logic_vector(1 downto 0);
        
        odometer_valid                              : out std_logic;
        odometer_ready                              : in  std_logic;
        odometer_data                               : out std_logic_vector(ODOMETER_INT_WIDTH-1 downto 0);
        odometer_strb                               : out std_logic;
        odometer_last                               : out std_logic_vector(1 downto 0);

        avgspeed_valid                              : out std_logic;
        avgspeed_ready                              : in  std_logic;
        avgspeed_data                               : out std_logic_vector(AVGSPEED_INT_WIDTH-1 downto 0);
        avgspeed_strb                               : out std_logic;
        avgspeed_last                               : out std_logic_vector(1 downto 0);

        accel_decel_valid                           : out std_logic;
        accel_decel_ready                           : in  std_logic;
        accel_decel_data                            : out std_logic_vector(ACCEL_DECEL_INT_WIDTH-1 downto 0);
        accel_decel_strb                            : out std_logic;
        accel_decel_last                            : out std_logic_vector(1 downto 0);

        speed_changes_valid                         : out std_logic;
        speed_changes_ready                         : in  std_logic;
        speed_changes_data                          : out std_logic_vector(SPEED_CHANGES_INT_WIDTH-1 downto 0);
        speed_changes_strb                          : out std_logic;
        speed_changes_last                          : out std_logic_vector(1 downto 0);

        --    
        -- BOOLEAN FIELDS   
        --    
        hypermiling_valid                           : out std_logic;
        hypermiling_ready                           : in  std_logic;
        hypermiling_data                            : out std_logic;
        hypermiling_strb                            : out std_logic;
        hypermiling_last                            : out std_logic_vector(1 downto 0);

        orientation_valid                           : out std_logic;
        orientation_ready                           : in  std_logic;
        orientation_data                            : out std_logic;
        orientation_strb                            : out std_logic;
        orientation_last                            : out std_logic_vector(1 downto 0);

        --    
        -- INTEGER ARRAY FIELDS   
        --    
        sec_in_band_valid                           : out std_logic;
        sec_in_band_ready                           : in  std_logic;
        sec_in_band_data                            : out std_logic_vector(SEC_IN_BAND_INT_WIDTH-1 downto 0);
        sec_in_band_strb                            : out std_logic;
        sec_in_band_last                            : out std_logic_vector(2 downto 0);

        miles_in_time_range_valid                   : out std_logic;
        miles_in_time_range_ready                   : in  std_logic;
        miles_in_time_range_data                    : out std_logic_vector(MILES_IN_TIME_RANGE_INT_WIDTH-1 downto 0);
        miles_in_time_range_strb                    : out std_logic;
        miles_in_time_range_last                    : out std_logic_vector(2 downto 0);


        const_speed_miles_in_band_valid             : out std_logic;
        const_speed_miles_in_band_ready             : in  std_logic;
        const_speed_miles_in_band_data              : out std_logic_vector(CONST_SPEED_MILES_IN_BAND_INT_WIDTH-1 downto 0);
        const_speed_miles_in_band_strb              : out std_logic;
        const_speed_miles_in_band_last              : out std_logic_vector(2 downto 0);


        vary_speed_miles_in_band_valid              : out std_logic;
        vary_speed_miles_in_band_ready              : in  std_logic;
        vary_speed_miles_in_band_data               : out std_logic_vector(VARY_SPEED_MILES_IN_BAND_INT_WIDTH-1 downto 0);
        vary_speed_miles_in_band_strb               : out std_logic;
        vary_speed_miles_in_band_last               : out std_logic_vector(2 downto 0);


        sec_decel_valid                             : out std_logic;
        sec_decel_ready                             : in  std_logic;
        sec_decel_data                              : out std_logic_vector(SEC_DECEL_INT_WIDTH-1 downto 0);
        sec_decel_strb                              : out std_logic;
        sec_decel_last                              : out std_logic_vector(2 downto 0);
      
      
        sec_accel_valid                             : out std_logic;
        sec_accel_ready                             : in  std_logic;
        sec_accel_data                              : out std_logic_vector(SEC_ACCEL_INT_WIDTH-1 downto 0);
        sec_accel_strb                              : out std_logic;
        sec_accel_last                              : out std_logic_vector(2 downto 0);
      
      
        braking_valid                               : out std_logic;
        braking_ready                               : in  std_logic;
        braking_data                                : out std_logic_vector(BRAKING_INT_WIDTH-1 downto 0);
        braking_strb                                : out std_logic;
        braking_last                                : out std_logic_vector(2 downto 0);


        accel_valid                                 : out std_logic;
        accel_ready                                 : in  std_logic;
        accel_data                                  : out std_logic_vector(ACCEL_INT_WIDTH-1 downto 0);
        accel_strb                                  : out std_logic;
        accel_last                                  : out std_logic_vector(2 downto 0);


        small_speed_var_valid                       : out std_logic;
        small_speed_var_ready                       : in  std_logic;
        small_speed_var_data                        : out std_logic_vector(SMALL_SPEED_VAR_INT_WIDTH-1 downto 0);
        small_speed_var_strb                        : out std_logic;
        small_speed_var_last                        : out std_logic_vector(2 downto 0);


        large_speed_var_valid                       : out std_logic;
        large_speed_var_ready                       : in  std_logic;
        large_speed_var_data                        : out std_logic_vector(LARGE_SPEED_VAR_INT_WIDTH-1 downto 0);
        large_speed_var_strb                        : out std_logic;
        large_speed_var_last                        : out std_logic_vector(2 downto 0);

        --    
        -- STRING FIELDS   
        -- 
        timestamp_valid                             : out std_logic;
        timestamp_ready                             : in  std_logic;
        timestamp_data                              : out std_logic_vector(8*EPC-1 downto 0);
        timestamp_last                              : out std_logic_vector(3*EPC-1 downto 0);
        timestamp_stai                              : out std_logic_vector(log2ceil(EPC)-1 downto 0) := (others => '0');
        timestamp_endi                              : out std_logic_vector(log2ceil(EPC)-1 downto 0) := (others => '1');
        timestamp_strb                              : out std_logic_vector(EPC-1 downto 0)
      );
    end component;
end trip_report_pkg;



