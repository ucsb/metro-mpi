The /testing/ directory holds all the files for my test cases to make sure that DPI/MPI work properly.

To compile a cpp file into a library for use with SystemVerilog DPI, go into the build subfolder and run
g++ -shared -fPIC ../cpp_filename.cpp -o cpp_filename.so
(with files that include MPI calls replace g++ with mpic++)

Then, in the same subfolder, compile the SystemVerilog file with
vcs -sverilog ../sv_filename.sv

Finally, run the executable and link the newly created cpp library using
./simv -sv_lib cpp_filename
(note that there is no .so after cpp_filename)

For mpi_communicate.cpp and mpi_hello.cpp, compile mpi with mpic++ instead of g++
