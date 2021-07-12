import metro_mpi_pkg::*;

module receiver (
    input  logic            clk_i,
    input  logic            rstn_i,
    input  logic            valid_i,
    input  logic [63:0]     data_i,
    input  int              origin_i,
    
    output logic [63:0]     data_o,
    output logic            yummy_o
);
    //import "DPI-C" function longint unsigned receive(int origin);
    //import "DPI-C" function longint unsigned snd_sig(longint unsigned message, int dest, int cred, int rank);

    logic [CREDIT_WIDTH-1:0][63:0] buffer;

    logic [63:0] data_to_store, data_out_int;
    
    logic [CREDIT_WIDTH-1:0] credit_q, credit_d, num_q, num_d, cnt_q, cnt_d;

    logic yummy_int, write_enable;

    assign yummy_o  = yummy_int;
    assign data_o   = data_out_int;
        
    always_comb begin
        yummy_int     = 1'b0;
        data_out_int  = 64'b0;
        data_to_store = 64'b0;
        write_enable  = 1'b0;
        
        if (valid_i && (credit_q != 0)) begin
            //buffer_next = receive(origin);
            data_to_store = data_i;
            write_enable = 1'b1;
            cnt_d = 5;
            $display("credit_next: %h", credit_d);
        end
        else if (valid_i && (credit_q == 0)) begin
            $display("ERROR: credits 0 and valid anyways");
        end

       /* if (cnt_q != 0) begin
            cnt_d = cnt_q -1;
        end else begin
            cnt_d = cnt_q;
        end*/

        if (num_q > 0 ) begin
            data_out_int = buffer[0];
            yummy_int = 1'b1;
            $display("data_out: %h", data_out_int);
        end

        //snd_sig()
    end

    always_comb begin 
        num_d = num_q +{2'b0,valid_i} - {2'b0,yummy_int};
        credit_d = credit_q -{2'b0,valid_i} + {2'b0,yummy_int};
    end

    always_ff @(posedge clk_i, negedge rstn_i) begin
        if (~rstn_i) begin
            $display("reset receiver");
            credit_q <= 1;
            num_q <= 0;
            for (int i = 0; i <= CREDIT_WIDTH-1; i++) begin
                buffer[i] <= 64'b0; 
            end
        end
        else begin
            credit_q <= credit_d;
            num_q    <= num_d;
            cnt_q    <= cnt_d;
            if (write_enable) begin
                buffer[0] <= data_to_store;
            end
            
        end
    end 
endmodule