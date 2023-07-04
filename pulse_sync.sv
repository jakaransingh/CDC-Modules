module pulse_sync_toggle(
  input      clk_i,        //Sending Clock Domain
  input      clk_o,        //Receiving Clock Domain
  input      rstn_i,       // Reset
  input      puls_i,       //Sending Pulse
  output     puls_o        //Synchronized Pulse 
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


  always_ff @ (posedge clk_o or negedge rstn_i)
    begin
      if(!rstn_i)
        begin
	  pulse_tgle_synci <= 1'b0;
	  pulse_tgle_synco <= 1'b0;
        end		
      else
        begin
	  pulse_tgle_synci <= pulse_tgle;
	  pulse_tgle_synco <= pulse_tgle_synci;
        end		
    end

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
