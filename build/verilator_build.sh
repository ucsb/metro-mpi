#!/bin/bash



verilator --trace -cc -exe ../top_mpi_tb.cpp --top-module top_mpi_tb ../metro_mpi_pkg.sv ../sender.sv ../receiver.sv ../top_mpi_tb.sv -Wno-fatal

make -j -C obj_dir -f Vtop_mpi_tb.mk Vtop_mpi_tb CXX=mpic++ LINK=mpic++

obj_dir/Vtop_mpi_tb

gtkwave my_top.vcd metro_mpi.gtkw

