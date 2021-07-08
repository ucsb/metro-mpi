module top_mpi_tb(
    input  logic clk_i,
    input  logic rstn_i,
    input  logic finalize_i,
    output int   rank_o,
    output logic valid_o
);


    import "DPI-C" function void initialize();
    import "DPI-C" function void finalize();
    import "DPI-C" function int getRank();
    import "DPI-C" function int getSize();

    //import "DPI-C" function longint unsigned receive(int origin);
    import "DPI-C" function void mpi_send_yummy(byte unsigned valid, int dest, int rank);
    import "DPI-C" function byte unsigned mpi_receive_yummy(int origin);

    import "DPI-C" function longint unsigned mpi_receive_data(int origin, output byte unsigned valid);
    import "DPI-C" function void mpi_send_data(longint unsigned data, byte unsigned valid, int dest, int rank);
    
    /*reg clk = 0;
    initial begin
        forever begin
            clk = ~clk;
            #10;
        end
	end*/

    byte valid_argument;

    logic yummy_rcv_snd, valid_snd_rcv;
    
    logic [63:0] data_snd_rcv, data_out;

    int dest;

    int rank, rank_receiver;
    int size;

    logic [63:0] buffer_next, mpi_data_in;
    logic [7:0] buffer_next_yummy, mpi_valid_in, mpi_valid_data_in;

    logic fake_valid_data;

    fake_node_mpi node0(.clk_i(clk_i),
                        .rstn_i(rstn_i),

                        .origin_i(dest),
                        .dest_i(dest),
                        .rank_i(rank));
                        
                        //.valid_i(valid_snd_rcv),
                        //.data_i(data_snd_rcv),

                        //.data_o(data_out),
                        //.yummy_o(yummy_rcv_snd));

    assign rank_o = rank;
    assign valid_o = valid_snd_rcv;

    initial begin
        initialize();
        rank = getRank();
        size = getSize();
        $display("size: %d", size);
        $display("rank: %d", rank);
        if(rank == 0) begin
            dest   = 1;
        end else begin
            dest = 0;
            //buffer_next = receive_async(0);

        end
    end

    always_ff @( posedge clk_i, negedge rstn_i) begin
        if (!rstn_i) begin
            // Do nothing
            fake_valid_data <= 'h0;
        end else begin
            if (rank == 1) begin
                if (finalize_i) begin
                    finalize();
                    $finish;
                end else begin
                    $display("[MPI TB] Sending from rank 1 to 0");
                    //mpi_send_yummy(0, dest, rank);
                    mpi_send_data({32'b0,$urandom()}, {7'b0,fake_valid_data}, dest, rank);
                    fake_valid_data <= !fake_valid_data;
                    //$display("[MPI TB] Waiting rank 0 from rank 1");
                    //mpi_data_in <= mpi_receive_data(dest);
                    //mpi_valid_in <= mpi_get_valid();
                    buffer_next_yummy = mpi_receive_yummy(dest);
                    $display("[MPI TB] Cycle rank 1");
                end
            end else if (finalize_i) begin
                finalize();
                $finish;
            end
        end
    end

endmodule

