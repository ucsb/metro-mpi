module creditmpi_tb();
    import "DPI-C" function void initialize();
    import "DPI-C" function void finalize();
    import "DPI-C" function int getRank();
    import "DPI-C" function int getSize();
    import "DPI-C" function longint unsigned receive(int origin);        
    import "DPI-C" function int receive_sig(int origin);
    import "DPI-C" function void snd(longint unsigned message, int dest, int cred, int rank);
    import "DPI-C" function void snd_sig(int message, int dest, int rank);

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
    reg [63:0] buff;
    reg ready_recv, ready_snd;

    wire val_in, yumi_in, val_out, yumi_out;
    wire [63:0] data;
    wire [63:0] recv_data;
    receiver rcv(.clk(clk), .rst_n(rst_n_recv), .valid(val_in), .origin(data_origin), .data_out(recv_data), .yumi(yumi_out), .buff(buff), .ready_recv(ready_recv));
    sender snd(.clk(clk), .rst_n(rst_n_send), .dest(dest), .rnk(rank), .valid(val_out), .yumi(yumi_in), .data_out(data), .ready_snd(ready_snd));

    initial begin
        rst_n_send = 0;
        rst_n_recv = 0;
        ready_recv = 0;
        ready_snd = 0;

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

    always @* begin
        if(ready_snd)begin
            snd(data, dest, 1, rank);
        end

        if(ready_recv)begin
            buff = receive(data_origin);
        end
    end

    always @* begin
        if(val_out)begin
            snd_sig(1, dest, 0, rank);
        end else begin
            snd_sig(0, dest, 0, rank);
        end

        if(yumi_out)begin
            snd_sig(1, dest, 1, rank);
        end else begin
            snd_sig(0, dest, 1, rank);
        end
    end

    always @* begin
        //receive val and yumi signals, nonblocking??
    end
endmodule

