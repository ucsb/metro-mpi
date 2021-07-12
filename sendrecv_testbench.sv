module creditmpi_tb();
    import "DPI-C" function void initialize();
    import "DPI-C" function void finalize();
    import "DPI-C" function int getRank();
    import "DPI-C" function int getSize();
    import "DPI-C" function void barrier();
    import "DPI-C" function longint unsigned metro_receive(int origin);        
    import "DPI-C" function int receive_sig(int origin, int tag);
    import "DPI-C" function void metro_send(longint unsigned message, int dest, int tag);
    import "DPI-C" function void send_sig(int message, int dest, int tag);
    import "DPI-C" function int sig_probe(int source, int tag);

    reg clk = 0;
    initial begin
	forever begin
	clk <= ~clk;
	#10;
	end
	end

    int data_origin;
    int dest;
    int sig_source;

    int rank;
    int size;

    int val_flag;
    int yumi_flag;

    reg rst_n_send = 1;
    reg rst_n_recv = 1;
    reg [63:0] buff;
    int ready_recv, ready_snd;

    reg val_in, yumi_in, val_out, yumi_out;
    wire [63:0] data;
    wire [63:0] recv_data;
    receiver rcv(.clk(clk), .rst_n(rst_n_recv), .valid(val_in), .origin(data_origin), .data_out(recv_data), .yumi(yumi_out), .buff(buff), .ready_recv(ready_recv));
    sender snd(.clk(clk), .rst_n(rst_n_send), .dest(dest), .rnk(rank), .valid(val_out), .yumi(yumi_in), .data_out(data), .ready_snd(ready_snd));

    initial begin
        rst_n_send = 0;
        rst_n_recv = 0;

        initialize();
        rank = getRank();
        size = getSize();
        $display("size: %d", size);
        $display("rank: %d", rank);
        barrier();
        if(rank == 0) begin
            sig_source = 1;
            data_origin = 1;
            #30;
            rst_n_recv = 0;
            $display("receiving reset");
            #20;
            rst_n_recv = 1;
            $display("receiving actual");
            #20;
        end else begin
            sig_source = 0;
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
            $display("rank: %d   ready_snd: %d", rank, ready_snd);
            metro_send(data, dest, rank);
        end

        if(ready_recv)begin
            $display("rank: %d   ready_recv: %d", rank, ready_recv);
            buff = metro_receive(data_origin);
        end
    end

    always @* begin
        if(val_out)begin
            send_sig(1, dest, 0);
        end else begin
            send_sig(0, dest, 0);
        end

        if(yumi_out)begin
            send_sig(1, dest, 1);
        end else begin
            send_sig(0, dest, 1);
        end
    end

    always @* begin
        val_flag = sig_probe(sig_source, 0);
        yumi_flag = sig_probe(sig_source, 1);

        if(val_flag)begin
            val_in = receive_sig(sig_source, 0);
        end
        
        if(yumi_flag)begin
            yumi_in = receive_sig(sig_source, 1);
        end
    end
endmodule

