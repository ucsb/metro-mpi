module receiver(clk, credit, origin, data);
    input clk;
    input longint unsigned credit;
    input int origin;
    output longint unsigned data;
    longint unsigned buffer;
    import "DPI-C" function longint unsigned receive(int origin);
    initial begin
        $display("initialized receiver");
    end

    always @(posedge clk) begin
        $display("credit: %b", credit);
        if(credit > 0) begin
            buffer = receive(origin);
            data = buffer;
            $display("received %d from %d", data, origin);
        end
    end 
endmodule

module sender(clk, credit, data, dest, rnk);
    input clk;
    input longint unsigned credit;
    input longint unsigned data;
    input int dest;
    input int rnk;
    import "DPI-C" function longint unsigned snd(longint unsigned message, int dest, int cred, int rank);
    initial begin
        $display("initialized sender");
    end

    always @(credit) begin
        $display("dest: %d", dest);
        if(credit > 0)
        begin
            snd(data, dest, 1, rnk);
            $display("sent");
        end
    end 
endmodule

module communicator(
`ifdef VERILATOR
input clk
`endif
);
    import "DPI-C" function void initialize();
    import "DPI-C" function void finalize();
    import "DPI-C" function int getRank();
    import "DPI-C" function int getSize();
    int rank;
    int data_origin;
    int dest;
    int i;
    int size;

    `ifndef VERILATOR
    reg clk;
    always #100 clk = ~clk;
    `endif

    reg stop;

    longint unsigned send_cred = 0;
    longint unsigned recv_cred = 0;

    longint unsigned data = 5;
    longint unsigned recv_data;

    sender sndr(.clk(clk), .credit(send_cred), .data(data), .dest(dest), .rnk(rank));
    receiver rcvr(.clk(clk), .credit(recv_cred), .origin(data_origin), .data(recv_data));

    initial begin
        `ifndef VERILATOR
	clk = 0;
        `endif
        initialize();
        rank = getRank();
        size = getSize();
        $display("size: %d", size);
        $display("rank: %d", rank);
        if(rank == 0) begin
            #200;
            recv_cred = 1;
            data_origin = 1;
        end else begin
            #100;
	        dest = 0;
            send_cred = 1;
            $display("sending from %d", rank);
        end
        #200;
        recv_cred = 0;
        finalize();
        $finish;
    end

    /* always@(*) begin
        if(rank == 1) begin
            recv_cred = 1;
            data_origin = 0;
            $display("received: %d", recv_data);
        end else begin
	        dest = 1;
            send_cred = 1;
            data = 5;
            $display("sending from %d", rank);
        end
        stop = 1;
        //finalize();
    end */

    /* always@(stop) begin
        if(stop == 1) begin
            finalize();
            stop <= 0;
        end
    end */
endmodule 

