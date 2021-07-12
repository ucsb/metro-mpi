
package metro_mpi_pkg;

parameter CREDIT_WIDTH = 3;

//typedef logic [63:0]  reg64_t;


/*typedef enum logic [1:0] {
    ENUM1  = 2'b00,
    ENUM2  = 2'b01,
    ENUM3  = 2'b10,
    ENUM3  = 2'b11
} enum_name;    // Enum*/

import "DPI-C" function void initialize();
import "DPI-C" function void finalize();
import "DPI-C" function int getRank();
import "DPI-C" function int getSize();

import "DPI-C" function void mpi_send_yummy(byte unsigned valid, int dest, int rank);
import "DPI-C" function byte unsigned mpi_receive_yummy(int origin);

import "DPI-C" function longint unsigned mpi_receive_data(int origin, output byte unsigned valid);
import "DPI-C" function void mpi_send_data(longint unsigned data, byte unsigned valid, int dest, int rank);



endpackage
