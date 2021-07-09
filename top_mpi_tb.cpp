/*
Copyright (c) 2018 Princeton University
All rights reserved.
Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:
    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * Neither the name of Princeton University nor the
      names of its contributors may be used to endorse or promote products
      derived from this software without specific prior written permission.
THIS SOFTWARE IS PROVIDED BY PRINCETON UNIVERSITY "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL PRINCETON UNIVERSITY BE LIABLE FOR ANY
DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/
#include "Vtop_mpi_tb.h"
#include "verilated.h"
#include <iostream>
#include "verilated_vcd_c.h"

uint64_t main_time = 0; // Current simulation time
uint64_t clk = 0;
Vtop_mpi_tb* top;
VerilatedVcdC* tfp;
// This is a 64-bit integer to reduce wrap over issues and
double sc_time_stamp () { // Called by $time in Verilog
    return main_time; // converts to double, to match
// what SystemC does
}

void tick() {
    // MPI work
    
    top->eval();
    top->mpi_work = 1;
    top->eval();
    top->clk_i = !top->clk_i;
    
    top->eval();
    // Regular clock
    top->mpi_work = 0;
    main_time += 1;
    top->eval();
    tfp->dump(main_time);
    
    top->clk_i = !top->clk_i;
    main_time += 1;
    top->eval();
    tfp->dump(main_time);
}

void reset_and_init() {
    
    //std::cout << "Reset" << std::endl;
    top->rstn_i = 0;
    top->finalize_i = 0;
    for (int i = 0; i < 5;i++) {
        tick();
    }
    top->rstn_i = 1;
    //std::cout << "Reset finish" << std::endl;

}

int main(int argc, char **argv, char **env) {
    //std::cout << "Started" << std::endl << std::flush;
    Verilated::commandArgs(argc, argv);
    
    top = new Vtop_mpi_tb;
    
    //std::cout << "Vtop_mpi_tb created" << std::endl << std::flush;
    
    Verilated::traceEverOn(true);
    
    tfp = new VerilatedVcdC;

    top->rstn_i = 0;
    top->eval();

    std::cout << "RANK: " << top->rank_o << std::endl << std::flush;
    
    top->trace (tfp, 99);
    std::string rank = std::to_string(top->rank_o);
    std::string tracename ("my_top"+rank+".vcd");
    const char *cstr = tracename.c_str();
    tfp->open(cstr);
    //tfp->open ("my_top.vcd");
    
    //Verilated::debug(1);
    //#endif
    reset_and_init();

//    while (!Verilated::gotFinish()) { tick(); }
    for (int i = 0; i < 20; i++) {
        std::cout << "Cycle: " << std::dec << main_time << std::endl;
        tick();
    }
    top->finalize_i = 1;
    top->eval();

    //std::cout << "Trace done" << std::endl;
    tfp->close();

    delete top;
    exit(0);
}
