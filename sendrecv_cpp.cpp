#include <iostream>
#include <mpi.h>

using namespace std;

extern "C" void initialize(){
    MPI_Init(NULL, NULL);
    cout << "initializing" << endl;
}

extern "C" unsigned long long receive(int origin){
    unsigned long long message;
    int message_len = 1;
    MPI_Status status;
    cout << "origin: " << origin << endl;
    MPI_Recv(&message, message_len, MPI_UNSIGNED_LONG_LONG, origin, MPI_ANY_TAG, MPI_COMM_WORLD, &status);
    
    cout << "message: " << message << endl;
    return message;
}

extern "C" void snd(unsigned long long message, int dest, int cred, int rank){
    int message_len = 1;
    if(cred > 0){
        cout << "sending " << message << " to " << dest << endl;
        MPI_Send(&message, message_len, MPI_UNSIGNED_LONG_LONG, dest, rank, MPI_COMM_WORLD);
    }
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


/* int main(int argc, char* argv[]){
    int rank, size, length, finish;
    char name[80];
    MPI_Init(&argc,&argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
	MPI_Comm_size(MPI_COMM_WORLD, &size);
	MPI_Get_processor_name(name, &length);
} */
