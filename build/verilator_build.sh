#!/bin/sh

verilator -cc -exe ../top_level.cpp ../sendrecv_cpp.cpp --top-module communicator ../sendrecv_sv.sv -Wno-fatal
make -j -C obj_dir -f Vcommunicator.mk Vcommunicator CXX=mpic++ LINK=mpic++
