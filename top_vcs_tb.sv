module top_vcs_tb();
    reg rstn_i, finalize_i, mpi_work, valid_o;

    int rank_o, i; 

    reg clk = 0;
    initial begin
        forever begin
            clk = ~clk;
            #10;
        end
	end

    top_mpi_tb MUT(
            .clk_i(clk)
        ,   .rstn_i(rstn_i)
        ,   .finalize_i(finalize_i)
        ,   .rank_o(rank_o)
        ,   .valid_o(valid_o)
        ,   .mpi_work(mpi_work)
    );

    initial begin
        //mimics reset_and_init
        $display("Resetting");
        rstn_i = 0;
        finalize_i = 0;
        for(i = 0; i < 5; i = i + 1) begin
            mpi_work = 1;
            #10;
            mpi_work = 0;
            #10;
        end
        #5;
        rstn_i = 1;
        #15;
        //mimics 20 ticks
        for(i = 0; i < 20; i = i + 1) begin
            $display("Cycle %d:", i);
            mpi_work = 1;
            #10;
            mpi_work = 0;
            #10;
        end

        finalize_i = 1;
        #10;
        $finish;
    end

endmodule

