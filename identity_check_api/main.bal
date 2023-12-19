//Api to handle Identity check
import ballerina/http;

# Description.
#
# + requestid - requestid
# + id - id number of the request
# + statusCode - Status Code
#   0 - Valid
#   1 - Account Not Active
#   2 - ID number not on DB
#   3 - Invalid ID number
#   4 - other error
# + description - Description of the statusCode
public type Response record{|
    int requestid;
    string id;
    int statusCode;
    string description;
|};
public type Request record {|
    string id;
|};
service /idCheck on new http:Listener(8080) {
    private Validator idValidator;
    private IdCheckService idcheckService;
    function init() returns error? {
        self.idValidator = check new();
        self.idcheckService = self.idValidator.getIdCheckService();
    }

    resource function post checkid(Request request) returns Response|error {
        string id = request.id;
        int isValidID = check self.idValidator.validateID(id);
        Response|error response = {requestid:1,id:request.id,statusCode:isValidID,description:self.mapper(isValidID)};
        return response;
    }
    resource function post activateAccount(Request request) returns http:Created|error {
        string id = request.id;
        Citizen updatetdCitizen = {
                id: id,
                Name: "Dummy Name",
                genderID: 1,
                accountStatusID: 1
            };
        _ = check self.idcheckService.insertRecord(updatetdCitizen);
        return http:CREATED;
    }

    function mapper(int statusID) returns string {
        match statusID{
           0 =>{return "Valid and Active";}
           1 =>{return "Valid and Not Active";}
           2 =>{return "ID number not found on Database";}
           3 =>{return "Invalid ID Number";}
           4 =>{return "Other Error check Backend console or log for more details";}
           _ =>{return "Impossible return";}
        }   
    }
}
