#include <iostream>
#include <mpi.h>

using namespace std;

unsigned long long message_async;
MPI_Status status_async;
MPI_Request request_async;

extern "C" void initialize(){
    MPI_Init(NULL, NULL);
    cout << "initializing" << endl;
}


extern "C" unsigned long long receive_async(int origin){
    unsigned long long message;
    int message_len = 1;
    //MPI_Status status;
    cout << "Receive Async from: " << origin << endl;
    MPI_Irecv(&message_async, message_len, MPI_UNSIGNED_LONG_LONG, origin, MPI_ANY_TAG, MPI_COMM_WORLD, &request_async);
    
    //cout << "message: " << std::hex << message << endl;
    return message;
}

extern "C" unsigned long long receive(int origin){
    unsigned long long message;
    int message_len = 1;
    MPI_Status status;
    cout << "Reciving Blockking origin: " << origin << endl;
    MPI_Recv(&message, message_len, MPI_UNSIGNED_LONG_LONG, origin, MPI_ANY_TAG, MPI_COMM_WORLD, &status);
    
    cout << "signal: " << message << endl;
    return message;
}

/*extern "C" unsigned long long receive_async(int origin, int tag){
    unsigned long long message;
    int message_len = 1;
    //MPI_Status status;
    cout << "Receive Async from: " << origin << endl;
    MPI_Irecv(&message_async, message_len, MPI_UNSIGNED_LONG_LONG, origin, MPI_ANY_TAG, MPI_COMM_WORLD, &request_async);
    
    //cout << "message: " << std::hex << message << endl;
    return message;
}*/

extern "C" int getMessageAsync(int origin, int tag){
    int flag;
    cout << "Waiting message " << endl;
    flag = MPI_Wait(&request_async,&status_async);
    return flag;
}


extern "C" int waitMessageAsync(int origin, int tag){
    int flag;
    cout << "Getting message Probe: " << endl;
    flag = MPI_Probe(origin, tag, MPI_COMM_WORLD, &status_async);
    return flag;
}

extern "C" int checkPendingMessages(){
    int flag;
    MPI_Test(&request_async, &flag, &status_async);
    cout << "Checking async message: " << flag << endl;
    return flag;
}

extern "C" void snd(unsigned long long message, int dest, int cred, int rank){
    int message_len = 1;
    cout << "sending " << std::hex << message << " to " << dest << endl;
    MPI_Send(&message, message_len, MPI_UNSIGNED_LONG_LONG, dest, cred, MPI_COMM_WORLD);
}



/*extern "C" unsigned long long receive_async(int origin){
    unsigned long long message;
    int message_len = 1;
    //MPI_Status status;
    cout << "Receive Async from: " << origin << endl;
    MPI_Irecv(&message_async, message_len, MPI_UNSIGNED_LONG_LONG, origin, MPI_ANY_TAG, MPI_COMM_WORLD, &request_async);
    
    //cout << "message: " << std::hex << message << endl;
    return message;
}

extern "C" int checkPendingMessages(){
    int flag;
    MPI_Test(&request_async, &flag, &status_async);
    cout << "Checking async message: " << flag << endl;
    return flag;
}

extern "C" unsigned long long receive_sig(int origin){
    unsigned long long message;
    int message_len = 1;
    MPI_Status status;
    cout << "origin: " << origin << endl;
    MPI_Recv(&message, message_len, MPI_UNSIGNED, origin, MPI_ANY_TAG, MPI_COMM_WORLD, &status);
    
    cout << "signal: " << message << endl;
    return message;
}

extern "C" void send(unsigned long long message, int dest, int cred, int rank){
    int message_len = 1;
    cout << "sending " << std::hex << message << " to " << dest << endl;
    MPI_Send(&message, message_len, MPI_UNSIGNED_LONG_LONG, dest, rank, MPI_COMM_WORLD);
}

extern "C" void snd(unsigned long long message, int dest, int rank){
    int message_len = 1;
    cout << "sending " << std::hex << message << " to " << dest << endl;
    MPI_Send(&message, message_len, MPI_UNSIGNED_LONG_LONG, dest, rank, MPI_COMM_WORLD);
}

extern "C" void snd_sig(int message, int dest, int rank){
    int message_len = 1;
    cout << "sending " << message << " to " << dest << endl;
    MPI_Send(&message, message_len, MPI_UNSIGNED, dest, rank, MPI_COMM_WORLD);
}*/

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

