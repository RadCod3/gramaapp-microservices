import ballerina/http;
import ballerina/io;
public class Validator{
    private IdCheckService idCheckService;
    public function init() returns error? {
        self.idCheckService = check new();
    }
    public function validateID(string id) returns int {
        if (string:length(id) == 10) {
            if !self.digits10(id){
                return 3;
            }else{
                return self.validateDB(id);
            }
        }
        else if (string:length(id) == 12)  {
            if !self.digits12(id){
                return 3;
            }else{
                return self.validateDB(id);
            }
        }
        else{
            return 3;
        }
    } 

    public function validateDB(string id) returns int{
        Citizen|http:NotFound|error citizen = self.idCheckService.getRecord(id);
        if citizen is http:NotFound{
            return 2;
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