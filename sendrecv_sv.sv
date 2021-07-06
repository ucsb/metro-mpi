module receiver (
    input clk
,   input rst_n
,   input valid
,   input int origin
,   output reg [63:0] data_out
,   output reg yumi
);
    import "DPI-C" function longint unsigned receive(int origin);
    import "DPI-C" function longint unsigned snd_sig(longint unsigned message, int dest, int cred, int rank);

    localparam CREDIT_WIDTH = 3;
    // localparam BUFFER_DEPTH_LOG2 = 1;
    // reg [63:0] buffer [BUFFER_DEPTH_LOG2-1:0];
    reg [63:0] buffer;
    reg [63:0] buffer_next;
    reg [CREDIT_WIDTH-1:0] credit;
    reg [CREDIT_WIDTH-1:0] credit_next;
    
    always @* begin
        yumi = 1'b0;
        data_out = 64'b0;
        credit_next = credit;
        if (valid && (credit != 0)) begin
            buffer_next = receive(origin);
            credit_next = credit - 1;
            $display("credit_next: %h", credit_next);
        end
        else if (credit == 0) begin
            credit_next = credit + 1;
            data_out = buffer;
            yumi = 1'b1;
            $display("data_out: %h", data_out);
        end
        //snd_sig()
    end

    always @(posedge clk) begin
        if (~rst_n) begin
            $display("reset receiver");
            credit <= 1;
            buffer <= 64'b0;
        end
        else begin
            credit <= credit_next;
            buffer <= buffer_next;
        end
    end 
endmodule

module sender (
    input clk
,   input rst_n
//,   input longint unsigned data_in
,   input int dest
,   input int rnk
,   output reg valid
,   input yumi
);

    import "DPI-C" function longint unsigned receive(int origin);
    import "DPI-C" function longint unsigned snd(longint unsigned message, int dest, int cred, int rank);
    localparam CREDIT_WIDTH = 3;
    reg [CREDIT_WIDTH-1:0] credit;
    reg [CREDIT_WIDTH-1:0] credit_next;
    reg [63:0] data_out;

    always @(posedge clk) begin
        if (~rst_n) begin
            credit <= 1;
        end
        else begin
            credit <= credit_next;
        end
    end

    always @* begin
        valid = 1'b0;
        data_out = 64'h0;
        credit_next = credit;
        if (credit != 0) begin
            valid = 1'b1;
            data_out = 64'hdeedabba_cafeface;
            $display("sending from %d to %d", rnk, dest);
            snd(data_out, dest, 1, rnk);
            credit_next = yumi ? credit : credit - 1;
            $display("sender has %d credits", credit_next);
            // do some other stuff, maybe change data_out
        end
        else if (yumi) begin  //should it be else if??
            credit_next = credit + 1;
            $display("incrementing sender cred");
        end
    end

endmodule

//move mpi functions out of the modules into tb