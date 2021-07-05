import metro_mpi_pkg::*;

module sender (
    input  logic            clk_i,
    input  logic            rstn_i,
    input  int              origin_i,
    input  logic            yummy_i,

    output logic [63:0]     data_o,
    output logic            valid_o
);

    //import "DPI-C" function longint unsigned receive(int origin);
    //import "DPI-C" function longint unsigned snd(longint unsigned message, int dest, int cred, int rank);


    logic [CREDIT_WIDTH-1:0] credit_q, credit_d;
    logic [63:0] default_data;

    // Logic credits
    always_ff @(posedge clk_i, negedge rstn_i) begin
        if (~rstn_i) begin
            credit_q <= 1; // Initial assignment
            default_data <= 64'hcafe_cafe_cafe_cafe;
        end
        else begin
            credit_q <= credit_d;
            default_data <= default_data + {61'b0,credit_d}; 
        end
    end

    always_comb begin
        valid_o   = 1'b0;
        data_o    = 64'h0;
        credit_d  = credit_q +{2'b0,yummy_i};

        // Credit management sending
        if ((credit_q != 0) & rstn_i) begin
            valid_o   = 1'b1;
            data_o    = default_data;
            credit_d  = credit_q +{2'b0,yummy_i} - {2'b0,valid_o};
            // /$display("sending from %d to %d", rnk, dest);
            //snd(data_out, dest, 1, rnk);
            $display("sender has %d credits", credit_q);
        end
        // Print logic
        if (yummy_i) begin  //should it be else if??
            $display("incrementing sender cred");
        end
    end

endmodule
