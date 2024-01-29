import ballerina/http;

@http:ServiceConfig {
    cors: {
        allowOrigins: ["*"]
    }
}

service /management on new http:Listener(9090) {
    private Decorder decorder;
    private DatabaseService databaseService;
    function init() returns error? {
        self.decorder = new ();
        self.databaseService = new ();
    }

    public function mapToRequestEntity(User user, GramaRequest gramaRequest, int idcheck, int addresscheck) returns RequestEntity {
        RequestEntity requestEntity = {
            requestID: 0, // Initialize with default value or retrieve from a sequence or other source
            userID: user.userId,
            reason: gramaRequest.reason,
            requestTypeID: 1, // Provide appropriate value
            policeCheckstatus: 2, // Provide appropriate value
            identityCheckstatus: idcheck, // Provide appropriate value
            addressCheckstatus: addresscheck, // Provide appropriate value
            characterW: "", // Provide appropriate value
            statusID: 1, // Provide appropriate value
            gramaID: user.gramaAreaId
        };
        return requestEntity;
    }
    public function mapToRequestEntityCitizen(Citizen citizen, GramaRequest gramaRequest, int idcheck, int addresscheck) returns RequestEntity {
        RequestEntity requestEntity = {
            requestID: 0, // Initialize with default value or retrieve from a sequence or other source
            userID: citizen.UserID,
            reason: gramaRequest.reason,
            requestTypeID: 1, // Provide appropriate value
            policeCheckstatus: 2, // Provide appropriate value
            identityCheckstatus: idcheck, // Provide appropriate value
            addressCheckstatus: addresscheck, // Provide appropriate value
            characterW: "", // Provide appropriate value
            statusID: 1, // Provide appropriate value
            gramaID: citizen.gramaID
        };
        return requestEntity;
    }
    resource function post request(@http:Payload GramaRequest gramaRequest) returns http:Created|error {
        User user = check self.decorder.decode(gramaRequest.accessToken);
        // todo
        RequestEntity entity = self.mapToRequestEntity(user, gramaRequest, 2, 2);
        _ = check self.databaseService.insertRequest(entity);
        return http:CREATED;
    }

    resource function post policeApprove(@http:Payload RequestEntity requestEntity, boolean approve) returns http:Created|error {
        if approve {
            requestEntity.policeCheckstatus = 3;
        } else {
            requestEntity.policeCheckstatus = 1;
        }
        _ = check self.databaseService.updateRequest(requestEntity);
        return http:CREATED;
    }
    resource function post idApprove(@http:Payload RequestEntity requestEntity, boolean approve) returns http:Created|error {
        if approve {
            requestEntity.identityCheckstatus = 3;
        } else {
            requestEntity.identityCheckstatus = 1;
        }
        _ = check self.databaseService.updateRequest(requestEntity);
        return http:CREATED;
    }
    resource function post addressApprove(@http:Payload RequestEntity requestEntity, boolean approve) returns http:Created|error {
        if approve {
            requestEntity.addressCheckstatus = 3;
        } else {
            requestEntity.addressCheckstatus = 1;
        }
        _ = check self.databaseService.updateRequest(requestEntity);
        return http:CREATED;
    }
    resource function post writeCharacter(@http:Payload RequestEntity requestEntity) returns http:Created|error {
        if requestEntity.characterW == "" {
            return error("Character can't be null");
        }
        _ = check self.databaseService.updateRequest(requestEntity);
        return http:CREATED;
    }
    resource function get getRequestsbyGramaID(string gramaID) returns RequestEntity[]|error {
        RequestEntity[] requests = check self.databaseService.getRequestByGramaID(gramaID);
        return requests;
    }
    resource function get getRequestsbyUserID(string userId) returns RequestEntity[]|error {
        RequestEntity[] requests = check self.databaseService.getRequestByUserID(userId);
        return requests;
    }

    // get a request by request id
    resource function get getRequestbyID(int requestId) returns RequestEntity|error {
        RequestEntity request = check self.databaseService.getRequestByID(requestId);
        return request;
    }

}
