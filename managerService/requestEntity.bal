public type RequestEntity record {
    int requestID;
    int userID;
    string reason;
    int requestTypeID;
    int policeCheckstatus;
    int identityCheckstatus;
    int addressCheckstatus;
    string|null character;
    int statusID;
    int gramaID;
};