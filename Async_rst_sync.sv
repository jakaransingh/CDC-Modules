module async_reset_sync
#(
parameter DEPTH = 2;
)
(
	input  wire   clk_i,   // SYSTEM CLOCK
	input  wire   rstn_i,  // SYSTEM ASYNC RESET
	output wire   sync_rstn_o  // SYNCHRONISED DEASSETION OF RST AND ASYNC GEN OF RST
);

  // DEPTH OF RESET SYNCHRONIZER
  reg   [DEPTH - 1 : 0 ]async_d; 

  //PROC BLOCK:1
  //PASSING THE RESET SINAL THROUGH FLOPS
always_ff @(posedge clk or negedge rstn_i) begin
	if(!rstn_i)
		begin
			async_d <= {(DEPTH - 1){1'b0}};
		end
	else
		async_d <= {async_d[ DEPTH - 2 : 0],1'b1};
end
// OUTPUT OF ASYNC RESET GENERATION AND SYNC DEASSERTION OF RESET
assign sync_reset_o = async_d[DEPTH - 1];

endmodule
