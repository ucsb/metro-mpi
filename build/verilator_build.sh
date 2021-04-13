#!/bin/sh

verilator -cc -exe ../top_level.cpp ../sendrecv_cpp.cpp --top-module communicator ../sendrecv_sv.sv -Wno-fatal
make -j -C obj_dir -f Vcommunicator.mk Vcommunicator
cd obj_dir/
ar -rcs Vcommunicator__ALL.a Vcommunicator__ALL.o
mpic++    sendrecv_cpp.o top_level.o verilated.o verilated_dpi.o Vcommunicator__ALL.a      -o Vcommunicator
