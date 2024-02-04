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

public type SuperRequestEntity record {
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
    string NIC;
    string name;
};
public function mapToSuperRequest(RequestEntity request,string name, string nic) returns SuperRequestEntity {
    SuperRequestEntity superRequest = {
        requestID: request.requestID,
        userID: request.userID,
        reason: request.reason,
        requestTypeID: request.requestTypeID,
        NIC: nic, // Set the appropriate value for NIC
        name: name,  // Set the appropriate value for name
        gramaID: request.gramaID, 
        policeCheckstatus: request.policeCheckstatus, 
        statusID: request.statusID, 
        characterW: request.characterW, 
        identityCheckstatus: request.identityCheckstatus, 
        addressCheckstatus: request.addressCheckstatus
    };

    // Additional logic to map other fields if needed

    return superRequest;
}