## Metro-MPI is a library designed to parallelize Verilog HDL simulations using OpenMPI libraries through SystemVerilog's Direct Programming Interface.


Running the examples require the OpenMPI library and Synopsys VCS to be installed.

To run a working example of the Metro-MPI library in use, head into the /build/ directory and run the `build.sh` script to compile the necessary files.

Run the executable and link the newly created cpp library using
`mpirun -np 2 ./simv -sv_lib sendrecv_cpp`
(note that there is no .so after sendrecv_cpp)



In case of the script not running, the functionality of the `build.sh` script is detailed below.

To compile a cpp file into a library for use with SystemVerilog DPI, head into the build subfolder and run
`mpic++ -shared -fPIC ../sendrecv_cpp.cpp -o sendrecv_cpp.so`
(since the code includes MPI calls, we replace g++ with mpic++)

Then, in the same build subfolder, compile the SystemVerilog file with
`vcs -sverilog -cpp mpic++ -f flist`
(-cpp option allows mpic++ to be used as the c++ compiler, and the flist contains the names of the required files)

