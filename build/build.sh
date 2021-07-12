#!/bin/bash

mpic++ -shared -fPIC ../sendrecv_cpp.cpp -o sendrecv_cpp.so
vcs -sverilog -cpp mpic++ -f flist
