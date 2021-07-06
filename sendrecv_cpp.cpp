#include <iostream>
#include <mpi.h>

using namespace std;

extern "C" void initialize(){
    MPI_Init(NULL, NULL);
    cout << "initializing" << endl;
}

extern "C" void barrier(){
    MPI_Barrier(MPI_COMM_WORLD);
    cout << "barrier" << endl;
}

extern "C" unsigned long long metro_receive(int origin){
    unsigned long long message;
    int message_len = 1;
    MPI_Status status;
    cout << "origin: " << origin << endl;
    MPI_Recv(&message, message_len, MPI_UNSIGNED_LONG_LONG, origin, MPI_ANY_TAG, MPI_COMM_WORLD, &status);
    
    cout << "message: " << message << endl;
    return message;
}

extern "C" int receive_sig(int origin, int tag){
    int signal;
    int message_len = 1;
    MPI_Status status;
    cout << "origin: " << origin << endl;
    MPI_Recv(&signal, message_len, MPI_INT, origin, tag, MPI_COMM_WORLD, &status);
    
    cout << "signal: " << signal << endl;
    return signal;
}

extern "C" void metro_send(unsigned long long message, int dest, int tag){
    int message_len = 1;
    cout << "sending " << message << " to " << dest << endl;
    MPI_Send(&message, message_len, MPI_UNSIGNED_LONG_LONG, dest, tag, MPI_COMM_WORLD);
}

extern "C" void send_sig(int message, int dest, int tag){
    int message_len = 1;
    cout << "sending " << message << " to " << dest << endl;
    MPI_Send(&message, message_len, MPI_INT, dest, tag, MPI_COMM_WORLD);
}

extern "C" int sig_probe(int source, int tag){
    int flag;
    MPI_Status status;
    MPI_Iprobe(source, tag, MPI_COMM_WORLD, &flag, &status);
    cout << "source: " << source << endl;
    cout << "tag: " << tag << " flag: " << flag << endl;
    return flag;
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
    cout << "finalizing" << endl;
    MPI_Finalize();
}

