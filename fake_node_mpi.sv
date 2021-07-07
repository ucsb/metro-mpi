import metro_mpi_pkg::*;

module fake_node_mpi (
    input  logic            clk_i,
    input  logic            rstn_i,
    
    input  int              rank_i,
    input  int              origin_i,
    input  int              dest_i

    // MPI based
    //input  logic            yummy_i,
    //input  logic            valid_i,
    //input  logic [63:0]     data_i,

    //output logic [63:0]     data_o,
    //output logic            valid_o
    
    //output logic            yummy_o
);
    //import "DPI-C" function longint unsigned receive(int origin);
    //import "DPI-C" function longint unsigned mpi_send_data(longint unsigned message, int valid, int dest, int cred, int rank);
    //import "DPI-C" function longint unsigned mpi_receive_data(longint unsigned message, int valid, int dest, int cred, int rank);

    import "DPI-C" function void mpi_send_yummy(byte unsigned valid, int dest, int rank);
    import "DPI-C" function byte unsigned mpi_receive_yummy(int origin);

    import "DPI-C" function longint unsigned mpi_receive_data(int origin);
    import "DPI-C" function byte unsigned mpi_get_valid();
    import "DPI-C" function void mpi_send_data(longint unsigned data, byte unsigned valid, int dest, int rank);

    byte unsigned message;

    logic [63:0] buffer_data_in, buffer_data_yummy_out;
    
    logic [7:0] buffer_yummy_in, valid_data_int, valid_data_in;

    //logic valid_yummy_in;
    logic valid_yummy_out;
    //logic valid_data_out;
    //logic valid_data_in;

    // Instance that receives data and sends yummy
    receiver_mpi rcv(.clk_i(clk_i),
                    .rstn_i(rstn_i),

                    .rank_i(rank_i),

                    .valid_i(valid_data_in[0]),
                    .data_i(buffer_data_in),
                    
                    .data_o(buffer_data_yummy_out),
                    .yummy_o(valid_yummy_out));
    
    //assign valid_data_out  = 0;

    // default values
    //assign data_o = 'h0;
    //assign valid_o = 'h0;
    //assign yummy_o = 'h0;

    always_ff @(posedge clk_i, negedge rstn_i) begin
        if (~rstn_i) begin
            $display("[SV] reset fake node");
            //valid_yummy_in  <= 1'b0;
            valid_data_in   <= 'h0;
            buffer_data_in  <= 'h0;
            buffer_yummy_in <= 'h0;
            valid_data_int  <= 'h0;
        end
        else begin
            if (rank_i==0) begin
                $display("[SV] Start Cycle Fake Node ");
            
                // first we send data
                //if (valid_data_out) begin
                //$display("[SV] Sending");
                //valid_data_int <= {7'b0, 1'b1};
                //mpi_send_data(1, 1, origin_i, rank_i);
                //end else begin
                //    mpi_send_data(1, 1, origin_i, 0, rank_i);
                //end

                // Now we send yummy
                $display("[SV] Handling yummy out");
                message <= {7'b0, valid_yummy_out};
                //$display("Yummy valid: %b", message);
                mpi_send_yummy(message, dest_i, rank_i);
                

                // Now we listen for data receive
                $display("[SV] Receiving data");
                buffer_data_in <= mpi_receive_data(origin_i);
                valid_data_in  <= mpi_get_valid();
                

                // Now we listen for yummy receive
                /*$display("handling yummy in");
                buffer_yummy_in <= mpi_receive_yummy(origin_i);
                valid_yummy_in <= buffer_yummy_in[0];*/
            end
            
        end
    end 
endmodule