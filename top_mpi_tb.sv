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
    import "DPI-C" function int getMessageAsync(int origin, int tag);
    import "DPI-C" function int checkPendingMessages();
    import "DPI-C" function longint unsigned receive_async(int origin);
    import "DPI-C" function void snd(longint unsigned message, int dest, int cred, int rank);
    
    /*reg clk = 0;
    initial begin
        forever begin
            clk = ~clk;
            #10;
        end
	end*/

    logic yummy_rcv_snd, valid_snd_rcv;
    
    logic [63:0] data_snd_rcv, data_out;

    int dest;

    int rank, rank_receiver;
    int size;

    logic [63:0] buffer_next;

    /*receiver_mpi rcv(.clk_i(clk_i),
                 .rstn_i(rstn_i),
                 .origin_i(0),
                 .rank_i(rank),
                 .valid_i(valid_snd_rcv),
                 .data_i(data_snd_rcv),

                 .data_o(data_out),
                 .yummy_o(yummy_rcv_snd));*/

    sender_mpi   snder(.clk_i(clk_i),
                 .rstn_i(rstn_i),
                 
                 .dest_i(dest),
                 .rank_i(rank),
                 
                 //.yummy_i(yummy_rcv_snd),
                 .yummy_i(0),
                 .valid_o(valid_snd_rcv),
                 .data_o(data_snd_rcv));

    assign rank_o = rank;
    assign valid_o = valid_snd_rcv;

    initial begin
        initialize();
        rank = getRank();
        size = getSize();
        $display("size: %d", size);
        $display("rank: %d", rank);
        if(rank == 0) begin
            dest = 1;
        end else begin
            dest = 0;
            buffer_next = receive_async(0);

        end
    end

    always_ff @( posedge clk_i ) begin
        if (finalize_i) begin
            finalize();
        end
        else if (rank == 1) begin
            if (checkPendingMessages() == 1) begin
                $display("Message received");
                //$display("%d ", getMessageAsync(1, 0));
                $display("message obtained");
                snd(1,dest,1,rank);
                //finalize();
                buffer_next = receive_async(0);
            end
        end
    end

endmodule

