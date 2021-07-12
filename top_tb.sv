module top_tb(
    input logic clk_i,
    input logic rstn_i
);
    logic yummy_rcv_snd, valid_snd_rcv;
    
    logic [63:0] data_snd_rcv, data_out;

    receiver rcv(.clk_i(clk_i),
                 .rstn_i(rstn_i),
                 .origin_i(0),
                 .valid_i(valid_snd_rcv),
                 .data_i(data_snd_rcv),

                 .data_o(data_out),
                 .yummy_o(yummy_rcv_snd));

    sender   snd(.clk_i(clk_i),
                 .rstn_i(rstn_i),
                 .origin_i(0),
                 .yummy_i(yummy_rcv_snd),
                 //.yummy_i(yummy_i_fake),
                 .valid_o(valid_snd_rcv),
                 .data_o(data_snd_rcv));

endmodule

