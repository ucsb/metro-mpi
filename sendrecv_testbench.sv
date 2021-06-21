module creditmpi_tb();
    import "DPI-C" function void initialize();
    import "DPI-C" function void finalize();
    import "DPI-C" function int getRank();
    import "DPI-C" function int getSize();
    reg clk = 0;
    initial begin
	forever begin
	clk <= ~clk;
	#10;
	end
	end

    int data_origin;
    int dest;

    int rank;
    int size;

    reg rst_n_send = 1;
    reg rst_n_recv = 1;
    wire valid, yumi;
    wire [63:0] data;
    wire [63:0] recv_data;
    receiver rcv(.clk(clk), .rst_n(rst_n_recv), .valid(valid), .origin(data_origin), .data_out(recv_data), .yumi(yumi));
    sender snd(.clk(clk), .rst_n(rst_n_send), .dest(dest), .rnk(rank), .valid(valid), .yumi(yumi));

    initial begin
        rst_n_send = 0;
        rst_n_recv = 0;
        initialize();
        rank = getRank();
        size = getSize();
        $display("size: %d", size);
        $display("rank: %d", rank);
        if(rank == 0) begin
            data_origin = 1;
            #30;
            rst_n_recv = 0;
            $display("receiving reset");
            #20;
            rst_n_recv = 1;
            $display("receiving actual");
            #20;
        end else begin
	        dest = 0;
            #10;
            rst_n_send = 0;
            #20;
            rst_n_send = 1;
            #20;
        end
        
        finalize();
        $finish;
    end
endmodule

