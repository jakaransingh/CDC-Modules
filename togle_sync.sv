module togle_sync(
  input      clk_i,        //SOURCE CLOCK DOMAIN
  input      clk_o,        //DESTINATION CLOCK DOMAIN
  input      rstn_i,       // SOURCE RESET
  input      puls_i,       //SOURCE PULSE
  output     puls_o        //SYNC PULSE AT DESTINATION DOMAIN
);

reg pulse_tgle;      
reg pulse_tgle_synci;
reg pulse_tgle_synco;
reg pulse_tgle_syncc;

  //PROC BLOCK 1:
  // USED TO SAMPLE A PULSE ON THE INPUT SIGNAL
  // IF NO PULSE THAN USE THE REGISTERED VALUE
  always_ff @ (posedge clk_i or negedge rstn_i)
    begin
      if(!rstn_i)
        begin
	  pulse_tgle <= 1'b0;
        end		
      else if(pulse_i)
        begin
	  pulse_tgle <= ~pulse_tgle;
        end
      else
        begin
	  pulse_tgle <= pulse_tgle;
        end		
    end
  // 2 FLOP SYNC FOR THE SYNCHRONIZATION OF THE PULSE  TO DESTINATION DOMAIN
  ff_2sync sync(clk_o,rstn_i,pulse_tgle,pulse_tgle_synco);


  // PROC BLOCK 2:
  //REGISTER THE SYNC SIGNAL IN DESTINATION DOMAIN
  always_ff @ (posedge clk_o or negedge rstn_i)
    begin
      if(!rstn_i)
        begin
	  pulse_tgle_syncc <= 1'b0;
        end		
      else
        begin
	  pulse_tgle_syncc <= pulse_tgle_synco;
        end		
    end

// RECREATE THE PULSE IN DESTINATION DOMAIN
assign puls_o = pulse_tgle_syncc ^ pulse_tgle_synco;

endmodule


// 2 FF SYNC MODULE
// THIS CAN ALSO BE PARAMETRISED 
// BUT FOR THIS SPECIFIC MODULE I CODED A SIMPLE 2 FLOP SYNCRONIZER 
// YOU CAN REFER ANOTHER MODULE IN THE REPOSITORY FOR THE SAME.
module ff_2sync

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
