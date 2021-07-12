


clean:
	rm -rf obj_dir

fake_node:
	verilator --trace --report-unoptflat -cc --autoflush -exe ../top_mpi_tb.cpp ../sendrecv_cpp.cpp --top-module top_mpi_tb ../metro_mpi_pkg.sv ../sender_mpi.sv ../receiver_mpi.sv ../fake_node_mpi.sv ../top_mpi_tb.sv -Wno-fatal

	make -j -C obj_dir -f Vtop_mpi_tb.mk Vtop_mpi_tb CXX=mpic++ LINK=mpic++

run:
	mpirun -output-filename logfile -np 2 ./obj_dir/Vtop_mpi_tb