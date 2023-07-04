// Created BY: JASKARAN SINGH
module pulse_sync

    (
    input  wire clk_i,  //SOURCE CLOCK DOMAIN
    input  wire rstn_i, //SOURCE RESET DOMAIN
    input  wire clk_o,   // DESTINATION CLOCK DOMAIN
    input  wire rstn_o,  // DESTINATION RESET DOMAIN
    input  wire valid_i,  // AN SIMPLE INPUT CONSIDERED IT CAN BE COMBINATION OF TWO MUX's EXPLAINED BELOW
    output wire ready_i,  //READY TO ACCEPT ANOTHER PULSE OR NOT
    output reg  valid_o   // FEEDBACK PULSE FROM THE DESTINATION
    );

/*

THE BELOW IS THE SIMPLE VALID_I GENERATING LOGIC THAT CAN BE USED IN YOUR SYSTEM
          |---------|
pulse_mux-|         |              |------------|
          |  MUX 1  |--------------|            |
  'b0-----|         |              |            |------------------valid_i
          |---------|              |    MUX 2   |
              |          'b1-------|            |
              |                    |____________|      
              |                            |
              |                            |
          pulse_back                       |
                                           |
                                PULSE GENERATING SIGNAL/
                                        LOGIC

*/

    reg  pulse_mux;
    wire pulse_mux_sync;
    wire pulse_back;
    wire pulse_passed_in_dest;
    reg  pulse_mux_sync_ffd;
  
    //PROC. BLOCK 1:
    // THIS IS USED TO SAMPLE THE INCOMING PULSE
    // AS SOON AS PULSE COMES FROM THE DEST. DOMAIN DRIVES THE MUX OUT OF PULSE TO 0.
    // OTHERWISE KEEPS GENERATING THE PULSE CONSTAINTLY.
    always_ff @ (posedge clk_i or negedge rstn_i) 
    begin

        if (rstn_i == 1'b0) begin
            pulse_mux <= 1'b0;
        end
        else 
        begin
            if (valid_i == 1'b1)
                pulse_mux <= 1'b1;
            else 
            begin
                if (pulse_back == 1'b1)
                    pulse_mux <= 1'b0;
                else
                    pulse_mux <= pulse_mux;
            end
        end
    end

    // ASSIGN STATMENT1:
    // THIS STATMENT IS USED TO GENERATE A COMBO READY SIGNAL FOR PASSSING ANOTHER PULSE THROUGH CDC
    assign ready_i = ~(pulse_back | pulse_mux);

    // 2 FF SYNC Module TO SYNCH THE PULSE SOURCE --> DESTINATION
    2ffd_sync pulse_resync(clk_o, rstn_o, pulse_mux, pulse_mux_sync);

   // 2 FF SYNC Module TO SYNC THE FEEDBACK BACK PULSE DESTINATION --> SOURCE
    2ffd_sync pulse_bck2src(clk_i, rstn_i, pulse_mux_sync, pulse_back);

   // ASSIGN STAMENT @:
   // USED TO RE-CREATE THE PULSE AT DESTINATION DOMAIN 
   // USING REGISTERED VERSION OF SYNC PULSE and SYNC PULSE SIGNAL
    assign pulse_passed_in_dest = pulse_mux_sync & ~pulse_mux_sync_ffd;

   // PROC. BLOCK 2:
   // REGISTERS THE SYNC PULSE SIGNAL
    // DRIVES THE VALID OUTPUT TO SIGNIFY THE SYNC PULSE FOR SAMPLING and USING IT IN SYSTEM
  always_ff @ (posedge clk_o or negedge rstn_o) begin: destination

        if (rstn_o == 1'b0) begin
            pulse_mux_sync_ffd <= 1'b0;
            valid_o <= 1'b0;
        end
        else 
        begin
            pulse_mux_sync_ffd <= pulse_mux_sync;
            valid_o <= pulse_passed_in_dest;
        end

    end

endmodule

// 2 FF SYNC MODULE
// THIS CAN ALSO BE PARAMETRISED 
// BUT FOR THIS SPECIFIC MODULE I CODED A SIMPLE 2 FLOP SYNCRONIZER 
// YOU CAN REFER ANOTHER MODULE IN THE REPOSITORY FOR THE SAME.
module 2ff_sync

    (
    input wire  clk,
    input wire  rstn,
    input wire  valid_i,
    output wire valid_o
    );

    reg [1:0] sync;

    always_ff @ (posedge aclk or negedge arstn) 
    begin

        if (rstn == 1'b0) begin
            sync <= 2'b0;
        end
        else 
        begin
            sync <= {sync[0], valid_i};
        end
    end

    assign valid_o = sync[1];


endmodule
