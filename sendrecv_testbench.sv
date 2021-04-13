/* module sendrecv_testbench();
    import "DPI-C" function void
    import "DPI-C" function void finalize();
    int send_rank;
    int recv_rank;
    longint unsigned send_cred;
    longint unsigned recv_cred;
    longint unsigned data;
    longint unsigned recv_data;
    sender send(.credit(send_cred), .data(data), .dest(recv_rank), .rank(send_rank));
    receiver recv(.credit(recv_cred), .origin(send_rank), .data(recv_data), .rank(recv_rank));
    initial begin
        $display("foo");
        data = 2;
        send_cred = 1;
        recv_cred = 1;
    end
    always@(*) begin
        finalize();
    end
endmodule */

module sendrecv_testbench();
    communicator DUT();
endmodule