import metro_mpi_pkg::*;

module fake_node_mpi (
    input  logic            clk_i,
    input  logic            rstn_i,
    
    input  int              rank_i,
    input  int              origin_i,
    input  int              dest_i,

    input logic             mpi_work
    // MPI based
    //input  logic            yummy_i,
    //input  logic            valid_i,
    //input  logic [63:0]     data_i,

    //output logic [63:0]     data_o,
    //output logic            valid_o
    
    //output logic            yummy_o
);

    byte unsigned message, valid_argument;

    logic [63:0] buffer_data_in, buffer_data_yummy_out, buffer_data_out;
    
    logic [7:0] buffer_yummy_in, valid_data_int;

    logic valid_yummy_in;
    logic valid_yummy_out;
    logic valid_data_out;
    logic valid_data_in;

    // Instance that receives data and sends yummy
    receiver_mpi rcv(.clk_i(clk_i),
                    .rstn_i(rstn_i),

                    .rank_i(rank_i),

                    .valid_i(valid_data_in),
                    .data_i(buffer_data_in),
                    
                    .data_o(buffer_data_yummy_out),
                    .yummy_o(valid_yummy_out));
    
    sender_mpi  snd(.clk_i(clk_i),
                    .rstn_i(rstn_i),

                    .dest_i(dest_i),
                    .rank_i(rank_i),
                    .yummy_i(valid_yummy_in),
                    .data_o(buffer_data_out),
                    .valid_o(valid_data_out));
    
    //assign valid_data_out  = 0;

    // default values
    //assign data_o = 'h0;
    //assign valid_o = 'h0;
    //assign yummy_o = 'h0;

    initial begin
        valid_data_in   = 'h0;
        buffer_data_in  = 'h0;
        buffer_yummy_in = 'h0;
        valid_data_int  = 'h0;
    end

    /*always_comb begin 
         if (mpi_work) begin
                $display("[SV] Start Cycle Fake Node ");
            
                // first we send data
                $display("[SV] Sending Data&valid");
                $display("valid = %d", valid_data_out);
                valid_data_int = {7'b0, valid_data_out};
                mpi_send_data(buffer_data_out, valid_data_int, origin_i, rank_i);

                // Now we send yummy
                $display("[SV] Handling yummy out");
                message = {7'b0, valid_yummy_out};
                //$display("Yummy valid: %b", message);
                mpi_send_yummy(message, dest_i, rank_i);
                

                // Now we listen for data receive
                $display("[SV] Receiving data");
                buffer_data_in = mpi_receive_data(origin_i, valid_argument);
                valid_data_in = valid_argument[0];
                

                // Now we listen for yummy receive
                $display("[SV] handling yummy in");
                buffer_yummy_in = mpi_receive_yummy(origin_i);
                valid_yummy_in = buffer_yummy_in[0];
            end
    end*/

    always @(posedge clk_i, negedge rstn_i) begin
        if (~rstn_i) begin
            $display("[SV] reset fake node");
            //valid_yummy_in  <= 1'b0;
            valid_data_in   <= 'h0;
            buffer_data_in  <= 'h0;
            buffer_yummy_in <= 'h0;
            valid_data_int  <= 'h0;
        end
        else begin
            if (mpi_work) begin
                $display("[SV] Start Cycle Fake Node ");
            
                // first we send data
                $display("[SV] Sending Data&valid");
                //$display("valid = %d", valid_data_out);
                valid_data_int <= {7'b0, valid_data_out};
                mpi_send_data(buffer_data_out, valid_data_int, origin_i, rank_i);

                // Now we send yummy
                $display("[SV] Handling yummy out");
                message <= {7'b0, valid_yummy_out};
                //$display("Yummy valid: %b", message);
                mpi_send_yummy(message, dest_i, rank_i);
                

                // Now we listen for data receive
                $display("[SV] Receiving data");
                buffer_data_in <= mpi_receive_data(origin_i, valid_argument);
                valid_data_in <= valid_argument[0];
                

                // Now we listen for yummy receive
                $display("[SV] handling yummy in");
                buffer_yummy_in <= mpi_receive_yummy(origin_i);
                valid_yummy_in <= buffer_yummy_in[0];
            end else begin
                buffer_data_in <= buffer_data_in;
                message <= message;
            end
            
        end
    end 
endmodule