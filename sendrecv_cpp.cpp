#include <iostream>
#include <mpi.h>

using namespace std;

unsigned long long message_async;
MPI_Status status_async;
MPI_Request request_async;

const int nitems=2;
int          blocklengths[2] = {1,1};
MPI_Datatype types[2] = {MPI_UNSIGNED_CHAR, MPI_UNSIGNED_LONG_LONG};
MPI_Datatype mpi_data_type;
MPI_Aint     offsets[2];



typedef struct {
    unsigned char valid;
    unsigned long long data;
} mpi_data_t;

extern "C" void initialize(){
    MPI_Init(NULL, NULL);
    cout << "initializing" << endl;
    
    // Initialize the struct data&valid
    offsets[0] = offsetof(mpi_data_t, valid);
    offsets[1] = offsetof(mpi_data_t, data);

    MPI_Type_create_struct(nitems, blocklengths, offsets, types, &mpi_data_type);
    MPI_Type_commit(&mpi_data_type);

}

// MPI Yummy functions
extern "C" unsigned char mpi_receive_yummy(int origin){
    unsigned char message;
    int message_len = 1;
    MPI_Status status;
    cout << "[DPI CPP] Block Receive YUMMY from rank: " << origin << endl << std::flush;
    MPI_Recv(&message, message_len, MPI_UNSIGNED_CHAR, origin, 1, MPI_COMM_WORLD, &status);
    
    cout << "[DPI CPP] Yummy received: " << std::hex << (int)message << endl << std::flush;
    return message;
}

extern "C" void mpi_send_yummy(unsigned char message, int dest, int rank){
    int message_len = 1;
    cout << "[DPI CPP] Sending YUMMY " << std::hex << (int)message << " to " << dest << endl << std::flush;
    MPI_Send(&message, message_len, MPI_UNSIGNED_CHAR, dest, 1, MPI_COMM_WORLD);
}

// MPI data&Valid functions
extern "C" void mpi_send_data(unsigned long long data, unsigned char valid, int dest, int rank){
    int message_len = 1;
    mpi_data_t message;
    //cout << "valid: " << std::hex << valid << std::endl;
    message.valid = valid;
    message.data  = data;
    cout << "[DPI CPP] Sending DATA valid: " << std::hex << (int)message.valid << " data: " << message.data << " to " << dest << endl;
    MPI_Send(&message, message_len, mpi_data_type, dest, 0, MPI_COMM_WORLD);
}

extern "C" unsigned long long mpi_receive_data(int origin, unsigned char* valid){
    int message_len = 1;
    MPI_Status status;
    mpi_data_t message;
    cout << "[DPI CPP] Blocking Receive data rank: " << origin << endl << std::flush;
    MPI_Recv(&message, message_len, mpi_data_type, origin, 0, MPI_COMM_WORLD, &status);
    
    cout << "[DPI CPP] Data Message received: " << (int) message.valid << " " << message.data << endl << std::flush;
    *valid = message.valid;
    return message.data;
}

extern "C" int getRank(){
    int rank;
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    return rank;
}

extern "C" int getSize(){
    int size;
    MPI_Comm_rank(MPI_COMM_WORLD, &size);
    return size;
}

extern "C" void finalize(){
    cout << "[DPI CPP] Finalizing" << endl;
    MPI_Finalize();
}

