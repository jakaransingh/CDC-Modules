//Created BY : JASKARAN SINGH
module ff_sync
#(
  parameter DEPTH = 2
  )
 (
    input wire  clk,
    input wire  rstn,
    input wire  valid_i,
    output wire valid_o
    );

    reg [DEPTH - 1:0] sync;

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

    assign valid_o = sync[DEPTH - 1];


endmodule
