//Api to handle Identity check
import ballerina/http;

# Description.
#
# + requestid - requestid  
# + Userid - field description  
# + NIC - field description  
# + statusCode - Status Code  
# 0 - Valid  
# 1 - Account Not Active  
# 2 - ID number not on DB  
# 3 - Invalid ID number  
# 4 - other error  
# + description - Description of the statusCode
public type Response record{|
    int requestid;
    string Userid;
    string NIC;
    int statusCode;
    string description;
|};
public type Request record {|
    string Userid;
    string NIC;
    string Name;
    string gramaId;
|};
service /idCheck on new http:Listener(8080) {
    private Validator idValidator;
    private IdCheckService idcheckService;
    function init() returns error? {
        self.idValidator = check new();
        self.idcheckService = self.idValidator.getIdCheckService();
    }

    resource function post getCitizenByGramaID(string grama_id) returns Citizen[]|error {
        return  self.idcheckService.getCitizenByGramaID(grama_id);
    }

    resource function post checkid(Request request) returns Response|error {
        string UserID = request.Userid;
        string NIC = request.NIC;
        string Name =  request.Name;
        string gramaid= request.gramaId;
        int isValidID = check self.idValidator.validateID(NIC,UserID,Name,gramaid);
        Response|error response = {requestid:1,Userid:UserID,NIC:NIC,statusCode:isValidID,description:self.mapper(isValidID)};
        return response;
    }
    resource function post activateAccount(Request request) returns http:Created|error {
        string userID = request.Userid;
        Citizen updatetdCitizen = {
                UserID: userID,
                NIC: "Dummy NIC",
                Name: "Dummy Name",
                genderID: 1,
                accountStatusID: 1,
                gramaID: "111111"
            };
        _ = check self.idcheckService.updateRecord(updatetdCitizen);
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
