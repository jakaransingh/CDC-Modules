module mux_sync
#(
	parameter DEPTH = 2,
	parameter DATA_WIDTH = 32
 )
 (
	input logic clk_i,
	input logic rstn_i,
	input logic [DATA_WIDTH - 1 : 0] data_i,
	input logic sync_ctrl,
	output logic [DATA_WIDTH - 1 : 0]data_o,
 )
 
	reg [ DEPTH -1 : 0 ]sync_r;
	reg [ DATA_WIDTH - 1 : 0 ]data_reg;
	
  ff2_sync sync(clk_i,rstn_i,sync_ctrl,sync_o)
  
  always_ff@(posedge clk or negedge rstn_i)
  begin
	if(!rstn_i)
		data_reg <= 'b0;
	else
		data_reg <= data_o;
  end
  
  assign data_o = (sync_o) ? data_i : data_reg ; 
 
 
 
 endmodule
 
 
 // 2 FF SYNC MODULE
// THIS CAN ALSO BE PARAMETRISED 
// BUT FOR THIS SPECIFIC MODULE I CODED A SIMPLE 2 FLOP SYNCRONIZER 
// YOU CAN REFER ANOTHER MODULE IN THE REPOSITORY FOR THE SAME.
module ff2_sync

    (
    input wire  clk,
    input wire  rstn,
    input wire  valid_i,
    output wire valid_o
    );

    reg [1:0] sync;

    always_ff @ (posedge clk or negedge rstn) 
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
