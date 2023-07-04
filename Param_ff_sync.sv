//Created BY : JASKARAN SINGH
module ff_sync
#(
  parameter DEPTH = 2      // PARAMETER TO PASS THE DEPTH VALUE OF THE SYNCHRONIZER
  )
 (
    input wire  clk,       // GENERALLY DEST CLOCK IS USED
    input wire  rstn,      // DEST RESET(ACTIVE LOW)
    input wire  valid_i,   // SIGNAL TO BE SYNCED
    output wire valid_o    // SYNC SIGNAL
    );

    // DECLARES THE THE NUMBER OF REGS REQUIRED FOR SYNC
    reg [DEPTH - 1:0] sync;
    // PROC BLOCK:
    // THIS IS IS USED TO SAMPLE THE SIGNAL TO SYNCED
    always_ff @ (posedge clk or negedge rstn) 
    begin

        if (rstn == 1'b0) begin
            sync <= DEPTH{'b0};
        end
        else 
        begin
            sync <= {sync[DEPTH - 2 : 0], valid_i};
        end
    end
    // ASSSIGN STATMENT TO PASS THE SYNCED SIGNAL
    assign valid_o = sync[DEPTH - 1];


endmodule
