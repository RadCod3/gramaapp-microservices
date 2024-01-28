import ballerina/http;
import ballerina/io;
public class Validator{
    private IdCheckService idCheckService;
    public function init() returns error? {
        self.idCheckService = check new();
    }
    public function getIdCheckService() returns IdCheckService{
        return self.idCheckService;
    }
    public function validateID(string id,string userID,string name,string grama_id) returns int|error {
        if (string:length(id) == 10) {
            if !self.digits10(id){
                return 3;
            }else{
                return self.validateDB(id,userID,name,grama_id);
            }
        }
        else if (string:length(id) == 12)  {
            if !self.digits12(id){
                return 3;
            }else{
                return self.validateDB(id,userID,name,grama_id);
            }
        }
        else{
            return 3;
        }
    } 

    public function validateDB(string id,string UserID,string Name,string grama_id) returns int|error{
        Citizen|http:NotFound|error citizen = self.idCheckService.getRecord(id);
        if citizen is http:NotFound{
            Citizen newCitizen = {
                UserID:UserID,
                NIC: id,
                Name: Name,
                genderID: 1,
                accountStatusID: 2,
                grama_id:grama_id
            };
            _ = check self.idCheckService.insertRecord(newCitizen);
            return 1;
        }else if citizen is Citizen{
            return citizen.accountStatusID-1;
        }else{
            io:println(citizen);
            return 4;
        }
    }

    private function digits12(string id) returns boolean{
        string strYear = id.substring(0, 4);

        int|error idint = int:fromString(id);
        if idint is error{
            return false;
        }

        int|error year = int:fromString(strYear);
        if year is error{
            return false;
        }
        if (year<2000){
            return false;
        }
        return true;
    }
    private function digits10(string id) returns boolean{
        string strYear = id.substring(0, 9);
        int | error year = int:fromString((strYear));
        if year is error{
            return false;
        }
        string lastletter = id[9];
        if (lastletter == "V") || (lastletter == "X"){
            return true;
        }else{
            return false;
        }
        
    }
}