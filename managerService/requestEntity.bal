public type RequestEntity record {
    int requestID;
    string userID;
    string reason;
    int requestTypeID;
    int policeCheckstatus;
    int identityCheckstatus;
    int addressCheckstatus;
    string|null characterW;
    int statusID;
    string gramaID;
};